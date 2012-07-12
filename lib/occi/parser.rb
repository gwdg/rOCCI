require 'rubygems'
require 'json'
require 'nokogiri'
require 'hashie/mash'
require 'occi/collection'
require 'occi/log'
require 'occiantlr/OCCIANTLRParser'

module OCCI
  class Parser
# Declaring Class constants for OVF XML namespaces (defined in OVF specification ver.1.1)
OVF="http://schemas.dmtf.org/ovf/envelope/1"
RASD="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData"
VSSD="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData"
OVFENV="http://schemas.dmtf.org/ovf/environment/1"
CIM="http://schemas.dmtf.org/wbem/wscim/1/common"

=begin
          if content_type.includes?('multipart')
            # TODO: implement multipart handling
            # handle file upload
            if params['file'] != nil
              OCCI::Log.debug("Location of Image #{params['file'][:tempfile].path}")
              $image_path = OCCI::Server.config[:one_image_tmp_dir] + '/' + params['file'][:filename]
              FileUtils.cp(params['file'][:tempfile].path, $image_path)
            end

            # handle file upload in multipart requests
            request.POST.values.each do |body|
              if body.kind_of?(String)
                parse_text(body)
              elsif body.kind_of?(Hash)
                if body['type'].include?('application/json')
                  # try to parse body as JSON object
                  parse_json(body.read)
                elsif body['type'].include?('text/plain') # text/plain
                  parse_text(body.read)
                end unless body['type'].nil?
              end
            end
          end
=end

    # Parses an OCCI message and extracts OCCI relevant information
    # @param [String] media_type the media type of the OCCI message
    # @param [String] body the body of the OCCI message
    # @param [true, false] category for text/plain and text/occi media types information e.g. from the HTTP request location is needed to determine if the OCCI message includes a category or an entity
    # @param [Hash] header optional header of the OCCI message
    # @return [Array<Array, OCCI::Collection>] list consisting of an array of locations and the OCCI object collection
    def self.parse(media_type, body, category=false, header={ })
      OCCI::Log.debug('### Parsing request data to OCCI data structure ###')
      collection = OCCI::Collection.new

      case media_type
        when 'text/occi'
          locations  = self.header_locations(header)
          category ? collection = self.header_categories(header) : collection = self.header_entity(header) if locations.empty?
        when 'text/uri-list'
          body.each_line { |line| locations << URI.parse(line) }
        when 'text/plain', nil
          locations = self.text_locations(body)
          category ? collection = self.text_categories(body) : collection = self.text_entity(body) if locations.empty?
        when 'application/occi+json', 'application/json'
          collection = self.json(body)
        when 'application/occi+xml', 'application/xml'
          collection = self.xml(body)
        when 'application/ovf+xml'
          collection = self.ovf(body)
        else
          raise "Content Type not supported"
      end
      return locations, collection
    end

    private

    def self.header_locations(header)
      x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
      x_occi_location_strings.collect { |loc| OCCIANTLR::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }
    end

    def self.header_categories(header)
      collection       = OCCI::Collection.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      category_strings.each do |cat|
        category = OCCIANTLR::Parser.new('Category: ' + cat).category
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.header_entity(header)
      collection       = OCCI::Collection.new
      entity           = Hashie::Mash.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      return collection if category_strings.empty?
      attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
      categories        = Hashie::Mash.new({ :kinds => [], :mixins => [], :actions => [] })
      category_strings.each { |cat| categories.merge!(OCCIANTLR::Parser.new('Category: ' + cat).category) }
      return collection if categories.kinds.empty?
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if categories.mixins.any?
      attribute_strings.each { |attr| entity.attributes!.merge!(OCCIANTLR::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute) }
      kind = OCCI::Model.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if kind.entity_type == OCCI::Core::Link.name
        entity.target = link.attributes.occi!.core!.target
        entity.source = link.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif kind.entity_type == OCCI::Core::Resource.name
        link_strings = header['HTTP_LINK'].to_s.split(',')
        link_strings.each { |link| entity.links << OCCIANTLR::Parser.new('Link: ' + link).link }
        collection.resources << OCCI::Core::Resource.new(entity)
      end
      collection
    end

    def self.text_locations(text)
      text.lines.collect { |line| OCCIANTLR::Parser.new(line).x_occi_location if line.include? 'X-OCCI-Location' }.compact
    end

    def self.text_categories(text)
      collection = OCCI::Collection.new
      text.each_line do |line|
        category = OCCIANTLR::Parser.new(line).category
        next if category.nil?
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.text_entity(text)
      collection = OCCI::Collection.new
      entity     = Hashie::Mash.new
      links      = []
      categories = Hashie::Mash.new({ :kinds => [], :mixins => [], :actions => [] })
      text.each_line do |line|
        categories.merge!(OCCIANTLR::Parser.new(line).category) if line.include? 'Category'
        entity.attributes!.merge!(OCCIANTLR::Parser.new(line).x_occi_attribute) if line.include? 'X-OCCI-Attribute'
        links << OCCIANTLR::Parser.new(line).link if line.include? 'Link'
      end
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term if categories.kinds.first
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if entity.mixins
      kind = OCCI::Model.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if OCCI::Model.get_by_id(entity.kind).entity_type == OCCI::Core::Link.name
        entity.target = links.first.attributes.occi!.core!.target
        entity.source = links.first.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif OCCI::Model.get_by_id(entity.kind).entity_type == OCCI::Core::Resource.name
        entity.links = links
        collection.resources << OCCI::Core::Resource.new(entity)
      end unless entity.kind.nil?
      collection
    end

    def self.json(json)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(JSON.parse(json))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
      collection
    end

    def self.xml(xml)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(Hash.from_xml(Nokogiri::XML(xml)))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
      collection
    end
    
    
    ####################Helper method for calculation of storage size based on allocation units configured###########
    def self.calculate_capacity_bytes(capacity, alloc_units_bytes)
    total_capacity_bytes =  alloc_units_bytes * capacity.to_i
    total_capacity_bytes
    end
    
    
    def self.calculate_capacity_gb(capacity)
       capacity_gb = capacity/(2**30)
       capacity_gb
       end
       
       
    def self.alloc_units_bytes(alloc_units)
             units = alloc_units.split('*')
             #check units[1] is nil??
             units[1].strip!
             alloc_vars =  units[1].split('^')
             alloc_units_bytes = (alloc_vars[0].to_i**alloc_vars[1].to_i)
             alloc_units_bytes
        end
             
             
     def self.getmountpoint(host_resource)
     host_resource.slice! "ovf:/disk/"
           # Implementation to extract the mount point from the HostResource element
           # Force a convention in OVF file to provide only the following values for <disk id> : home, swap, fs etc.,
           # 
     host_resource  
     end
   ###############End of Helper methods for OVF Parsing ##################################################################
   
    def self.ovf(ovf)
     collection = OCCI::Collection.new
        doc = Nokogiri::XML(ovf)
        doc.xpath('envelope:Envelope/envelope:DiskSection/envelope:Disk','envelope'=>"#{Parser::OVF}").each do |disk|
          storage = OCCI::Core::Resource.new
          storage.kind = 'http://schemas.ogf.org/occi/infrastructure#storage'
          #storage.attributes!.occi!.storage!.id = disk.attributes['diskId']
          #OCCI accepts storage size in GB
          #OVF ver 1.1: The capacity of a virtual disk shall be specified by the ovf:capacity attribute with an xs:long integer
          #value. The default unit of allocation shall be bytes. The optional string attribute
          #ovf:capacityAllocationUnits may be used to specify a particular unit of allocation.
          alloc_units = disk.attributes['capacityAllocationUnits'].to_s
          if alloc_units.empty?
          # The capacity is defined in bytes , convert to GB and pass it to OCCI
          capacity =  disk.attributes['capacity'].to_s
               capacity=capacity.to_i
          else
               alloc_unit_bytes =  self.alloc_units_bytes(alloc_units)
               capacity = self.calculate_capacity_bytes(disk.attributes['capacity'].to_s,alloc_unit_bytes)
          end
          capacity_gb = self.calculate_capacity_gb(capacity)
          OCCI::Log.debug('capacity in gb ' + capacity_gb.to_s)
          storage.attributes!.occi!.storage!.size = capacity_gb.to_s
          collection.resources << storage
        end
   
        
        doc.xpath('envelope:Envelope/envelope:NetworkSection/envelope:Network', 'envelope'=>"#{Parser::OVF}").each do |nw|
          network = OCCI::Core::Resource.new
          network.kind = 'http://schemas.ogf.org/occi/infrastructure#network'
          # Not sure if its label or vlan
          network.attributes!.occi!.network!.label = nw.attributes['name']
          collection.resources << network
        end
        # Iteration through all the virtual hardware sections,and a sub-iteration on each Item defined in the Virtual Hardware section 
        doc.xpath('envelope:Envelope/envelope:VirtualSystem/envelope:VirtualHardwareSection','envelope'=>"#{Parser::OVF}").each do |virthwsec|
             compute = OCCI::Core::Resource.new
             
             compute.kind = 'http://schemas.ogf.org/occi/infrastructure#compute'
             virthwsec.xpath('envelope:Item','envelope'=>"#{Parser::OVF}").each do |resource_alloc|
               resType = resource_alloc.xpath("item:ResourceType/text()",'item'=>"#{Parser::RASD}")
               case resType.to_s
               # 4 is the ResourceType for memory in the CIM_ResourceAllocationSettingData
                 when "4" then 
                  memory_value = resource_alloc.xpath("item:VirtualQuantity/text()",'item'=>"#{Parser::RASD}")
                  compute.attributes!.occi!.compute!.memory =  memory_value
                  OCCI::Log.info("Retrieving memory attribute from OVF. Value is #{memory_value}")
               # 3 is the ResourceType for processor in the CIM_ResourceAllocationSettingData
                 when "3" then
                 cpu_core_value = resource_alloc.xpath("item:VirtualQuantity/text()",'item'=>"#{Parser::RASD}")
                 compute.attributes!.occi!.compute!.cores =  cpu_core_value
                 OCCI::Log.info("Retrieving cpu cores attribute from OVF. Value is #{cpu_core_value}")
                 when "17" then
                 storagelink = OCCI::Core::Link.new
                 storagelink.kind = "http://schemas.ogf.org/occi/infrastructure#storagelink"
              # extract the mountpoint
                 host_resource = resource_alloc.xpath("item:HostResource/text()",'item'=>"#{Parser::RASD}")
                 mount_point = self.getmountpoint(host_resource.to_s)
                 compute.attributes!.occi!.storagelink!.mountpoint = mount_point
                 OCCI::Log.info("Retrieving mountpoint attribute from OVF. Value is #{mount_point}")
                 collection.links << storagelink       
                else
                    OCCI::Log.info("Retrieving cpu cores attribute from OVF. Value is #{resType.to_s}")   
               end
               #Add the cpu architecture
                system_sec = virthwsec.xpath('envelope:System','envelope'=>"#{Parser::OVF}")
                virtsys_type = system_sec.xpath('vssd_:VirtualSystemType/text()','vssd_'=>"#{Parser::VSSD}")
                compute.attributes!.occi!.compute!.architecture = virtsys_type
              end
           # get the hostname from the ProductSection
           doc.xpath('//envelope:ProductSection/envelope:Property', 'envelope'=>"#{Parser::OVF}").each do |prod_prop|
              key = prod_prop.attributes['key']
              if  key.to_s == "hostname" then
                  compute.attributes!.occi!.compute!.hostname = prod_prop.attributes['value']
              end
           end
           collection.resources << compute
        end
        collection.resources.each {|resource| OCCI::Log.debug("#{resource.attributes}") }
        collection
    end
  end

end