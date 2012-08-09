require 'rubygems'
require 'json'
require 'nokogiri'
require 'hashie/mash'
require 'rubygems/package'
require 'zlib'
require 'tempfile'
require 'occi/collection'
require 'occi/log'
require 'occiantlr/OCCIANTLRParser'

module OCCI
  class Parser

    # Declaring Class constants for OVF XML namespaces (defined in OVF specification ver.1.1)
    OVF   ="http://schemas.dmtf.org/ovf/envelope/1"
    RASD  ="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData"
    VSSD  ="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData"
    OVFENV="http://schemas.dmtf.org/ovf/environment/1"
    CIM   ="http://schemas.dmtf.org/wbem/wscim/1/common"

    # Parses an OCCI message and extracts OCCI relevant information
    # @param [String] media_type the media type of the OCCI message
    # @param [String] body the body of the OCCI message
    # @param [true, false] category for text/plain and text/occi media types information e.g. from the HTTP request location is needed to determine if the OCCI message includes a category or an entity
    # @param [OCCI::Core::Resource,OCCI::Core::Link] entity_type entity type to use for parsing of text plain entities
    # @param [Hash] header optional header of the OCCI message
    # @return [Array<Array, OCCI::Collection>] list consisting of an array of locations and the OCCI object collection
    def self.parse(media_type, body, category=false, entity_type=OCCI::Core::Resource, header={ })
      OCCI::Log.debug '### Parsing request data to OCCI data structure ###'
      collection = OCCI::Collection.new

      locations = self.header_locations(header)
      category ? collection = self.header_categories(header) : collection = self.header_entity(header, entity_type) if locations.empty?

      case media_type
        when 'text/uri-list'
          body.each_line { |line| locations << URI.parse(line) }
        when 'text/occi'
          nil
        when 'text/plain', nil
          locations.concat self.text_locations(body)
          category ? collection = self.text_categories(body) : collection = self.text_entity(body, entity_type) if locations.empty? && collection.empty?
        when 'application/occi+json', 'application/json'
          collection = self.json(body)
        when 'application/occi+xml', 'application/xml'
          collection = self.xml(body)
        when 'application/ovf', 'application/ovf+xml'
          collection = self.ovf(body)
        when 'application/ova'
          collection = self.ova(body)
        else
          raise "Content Type not supported"
      end
      return locations, collection
    end

    private

    # @param [Hash] header
    # @return [Array] list of URIs
    def self.header_locations(header)
      x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
      x_occi_location_strings.collect { |loc| OCCIANTLR::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }
    end

    # @param [Hash] header
    # @return [OCCI::Collection]
    def self.header_categories(header)
      collection       = OCCI::Collection.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      category_strings.each do |cat|
        category = OCCIANTLR::Parser.new('Category: ' + cat).category
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action.scheme, action.term, action.title, action.attributes) }
      end
      collection
    end

    # @param [Hash] header
    # @param [Class] entity_type
    # @return [OCCI::Collection]
    def self.header_entity(header, entity_type)
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
      if entity_type == OCCI::Core::Link
        entity.target = link.attributes!.occi!.core!.target
        entity.source = link.attributes!.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity.kind, entity.mixins, entity.attributes)
      elsif entity_type == OCCI::Core::Resource
        link_strings = header['HTTP_LINK'].to_s.split(',')
        link_strings.each do |link_string|
          link = OCCIANTLR::Parser.new('Link: ' + link_string).link
          entity.links << OCCI::Core::Link.new(link.kind, link.mixins, link.attributes, link.actions, link.rel)
        end
        collection.resources << OCCI::Core::Resource.new(entity.kind, entity.mixins, entity.attributes, entity.links)
      end
      collection
    end

    # @param [String] text
    # @return [Array] list of URIs
    def self.text_locations(text)
      text.lines.collect { |line| OCCIANTLR::Parser.new(line).x_occi_location if line.include? 'X-OCCI-Location' }.compact
    end

    # @param [String] text
    # @return [OCCI::Collection]
    def self.text_categories(text)
      collection = OCCI::Collection.new
      text.each_line do |line|
        category = OCCIANTLR::Parser.new(line).category
        next if category.nil?
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action.scheme, action.term, action.title, action.attributes) }
      end
      collection
    end

    # @param [String] text
    # @param [Class] entity_type
    # @return [OCCI::Collection]
    def self.text_entity(text, entity_type)
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
      if entity_type == OCCI::Core::Link
        entity.target = links.first.attributes!.occi!.core!.target
        entity.source = links.first.attributes!.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity.kind, entity.mixins, entity.attributes)
      elsif entity_type == OCCI::Core::Resource
        entity.links = links.collect { |link| OCCI::Core::Link.new(link.kind, link.mixins, link.attributes, link.actions, link.rel) }
        collection.resources << OCCI::Core::Resource.new(entity.kind, entity.mixins, entity.attributes, entity.links)
      end unless entity.kind.nil?
      collection
    end

    # @param [String] json
    # @return [OCCI::Collection]
    def self.json(json)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(JSON.parse(json))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.links) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link.kind, link.mixins, link.attributes) } if hash.links
      collection
    end

    # @param [String] xml
    # @return [OCCI::Collection]
    def self.xml(xml)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(Hash.from_xml(Nokogiri::XML(xml)))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.links) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link.kind, link.mixins, link.attributes) } if hash.links
      collection
    end


    ####################Helper method for calculation of storage size based on allocation units configured###########

    def self.calculate_capacity_bytes(capacity, alloc_units_bytes)
      total_capacity_bytes = alloc_units_bytes * capacity.to_i
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
      alloc_vars        = units[1].split('^')
      alloc_units_bytes = (alloc_vars[0].to_i**alloc_vars[1].to_i)
      alloc_units_bytes
    end

    ###############End of Helper methods for OVF Parsing ##################################################################

    # @param [String] ova
    # @return [OCCI::Collection]
    def self.ova(ova)
      tar   = Gem::Package::TarReader.new(StringIO.new(ova))
      ovf   = mf = cert = nil
      files = { }
      tar.each do |entry|
        tempfile = Tempfile.new(entry.full_name)
        tempfile.write(entry.read)
        tempfile.close
        files[entry.full_name] = tempfile.path
        ovf = tempfile.path if entry.full_name.end_with? '.ovf'
        mf = tempfile.path if entry.full_name.end_with? '.mf'
        cert = tempfile.path if entry.full_name.end_with? '.cert'
      end

      File.read(mf).each_line do |line|
        name = line.scan(/SHA1\(([^\)]*)\)= (.*)/).flatten.first
        sha1 = line.scan(/SHA1\(([^\)]*)\)= (.*)/).flatten.last
        puts Digest::SHA1.hexdigest(files[name])
        raise "SHA1 mismatch for file #{name}" if Digest::SHA1.hexdigest(File.read(files[name])) != sha1
      end if mf

      raise 'no ovf file found' if ovf.nil?

      self.ovf(File.read(ovf), files)
    end

    # @param [String] ovf
    # @param [Hash] files key value pairs of file names and paths to the file
    def self.ovf(ovf, files={ })
      collection = OCCI::Collection.new
      doc        = Nokogiri::XML(ovf)
      references = { }

      doc.xpath('envelope:Envelope/envelope:References/envelope:File', 'envelope' => "#{Parser::OVF}").each do |file|
        href = URI.parse(file.attributes['href'].to_s)
        if href.relative?
          references[file.attributes['id'].to_s] = 'file://' + files[href.to_s] if files[href.to_s]
        else
          references[file.attributes['id'].to_s] = href.to_s
        end
      end

      doc.xpath('envelope:Envelope/envelope:DiskSection/envelope:Disk', 'envelope' => "#{Parser::OVF}").each do |disk|
        storage = OCCI::Core::Resource.new('http://schemas.ogf.org/occi/infrastructure#storage')
        if disk.attributes['fileRef']
          storagelink                               = OCCI::Core::Link.new("http://schemas.ogf.org/occi/infrastructure#storagelink")
          storagelink.attributes.occi!.core!.title  = disk.attributes['fileRef'].to_s
          storagelink.attributes.occi!.core!.target = references[disk.attributes['fileRef'].to_s]
          storage.attributes.occi!.core!.title      = disk.attributes['diskId'].to_s
          storage.links << storagelink
        else
          #OCCI accepts storage size in GB
          #OVF ver 1.1: The capacity of a virtual disk shall be specified by the ovf:capacity attribute with an xs:long integer
          #value. The default unit odf allocation shall be bytes. The optional string attribute
          #ovf:capacityAllocationUnits may be used to specify a particular unit of allocation.
          alloc_units = disk.attributes['capacityAllocationUnits'].to_s
          if alloc_units.empty?
            # The capacity is defined in bytes , convert to GB and pass it to OCCI
            capacity = disk.attributes['capacity'].to_s
            capacity =capacity.to_i
          else
            alloc_unit_bytes = self.alloc_units_bytes(alloc_units)
            capacity         = self.calculate_capacity_bytes(disk.attributes['capacity'].to_s, alloc_unit_bytes)
          end
          capacity_gb = self.calculate_capacity_gb(capacity)
          OCCI::Log.debug('capacity in gb ' + capacity_gb.to_s)
          storage.attributes.occi!.storage!.size = capacity_gb.to_s if capacity_gb
          storage.attributes.occi!.core!.title = disk.attributes['diskId'].to_s if disk.attributes['diskId']
        end
        collection.resources << storage
      end

      doc.xpath('envelope:Envelope/envelope:NetworkSection/envelope:Network', 'envelope' => "#{Parser::OVF}").each do |nw|
        network                              = OCCI::Core::Resource.new('http://schemas.ogf.org/occi/infrastructure#network')
        network.attributes.occi!.core!.title = nw.attributes['name'].to_s
        collection.resources << network
      end

      # Iteration through all the virtual hardware sections,and a sub-iteration on each Item defined in the Virtual Hardware section
      doc.xpath('envelope:Envelope/envelope:VirtualSystem', 'envelope' => "#{Parser::OVF}").each do |virtsys|
        compute = OCCI::Core::Resource.new('http://schemas.ogf.org/occi/infrastructure#compute')

        doc.xpath('envelope:Envelope/envelope:VirtualSystem/envelope:VirtualHardwareSection', 'envelope' => "#{Parser::OVF}").each do |virthwsec|
          compute.attributes.occi!.core!.summary = virthwsec.xpath("item:Info/text()", 'item' => "#{Parser::RASD}").to_s

          virthwsec.xpath('envelope:Item', 'envelope' => "#{Parser::OVF}").each do |resource_alloc|
            resType = resource_alloc.xpath("item:ResourceType/text()", 'item' => "#{Parser::RASD}")
            case resType.to_s
              # 4 is the ResourceType for memory in the CIM_ResourceAllocationSettingData
              when "4" then
                compute.attributes.occi!.compute!.memory = resource_alloc.xpath("item:VirtualQuantity/text()", 'item' => "#{Parser::RASD}").to_s.to_i
              # 3 is the ResourceType for processor in the CIM_ResourceAllocationSettingData
              when "3" then
                compute.attributes.occi!.compute!.cores = resource_alloc.xpath("item:VirtualQuantity/text()", 'item' => "#{Parser::RASD}").to_s.to_i
              when "10" then
                networkinterface                              = OCCI::Core::Link.new('http://schemas.ogf.org/occi/infrastructure#networkinterface')
                networkinterface.attributes.occi!.core!.title = resource_alloc.xpath("item:ElementName/text()", 'item' => "#{Parser::RASD}").to_s
                id                                            = resource_alloc.xpath("item:Connection/text()", 'item' => "#{Parser::RASD}").to_s
                network                                       = collection.resources.select { |resource| resource.attributes.occi!.core!.title == id }.first
                raise "Network with id #{id} not found" unless network
                networkinterface.attributes.occi!.core!.target = network.location
              when "17" then
                storagelink                              = OCCI::Core::Link.new("http://schemas.ogf.org/occi/infrastructure#storagelink")
                storagelink.attributes.occi!.core!.title = resource_alloc.xpath("item:ElementName/text()", 'item' => "#{Parser::RASD}").to_s
                # extract the mountpoint
                host_resource                            = resource_alloc.xpath("item:HostResource/text()", 'item' => "#{Parser::RASD}").to_s
                if host_resource.start_with? 'ovf:/disk/'
                  id      = host_resource.gsub('ovf:/disk/', '')
                  storage = collection.resources.select { |resource| resource.attributes.occi!.core!.title == id }.first
                  raise "Disk with id #{id} not found" unless storage
                  storagelink.attributes.occi!.core!.target = storage.location
                elsif host_resource.start_with? 'ovf:/file/'
                  id                                        = host_resource.gsub('ovf:/file/', '')
                  storagelink.attributes.occi!.core!.target = references[id]
                end
                compute.links << storagelink
            end
            ##Add the cpu architecture
            #system_sec                                      = virthwsec.xpath('envelope:System', 'envelope' => "#{Parser::OVF}")
            #virtsys_type                                    = system_sec.xpath('vssd_:VirtualSystemType/text()', 'vssd_' => "#{Parser::VSSD}")
            #compute.attributes.occi!.compute!.architecture = virtsys_type
          end
        end
        collection.resources << compute
      end
      collection
    end
  end

end