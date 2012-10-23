# a bunch of OCCI client helpers for bin/occi

def helper_list(options)
  found = []

  if resource_types.include? options.resource
    Occi::Log.debug "#{options.resource} is a resource type."
    found = list options.resource
  elsif mixin_types.include? options.resource
    Occi::Log.debug "#{options.resource} is a mixin type."
    found = mixins options.resource
  else
    Occi::Log.debug "I have no idea what #{options.resource} is ..."
    puts "Unknown resource #{options.resource}, there is nothing to list here!"
  end

  found
end

def helper_describe(options)
  found = []

  if resource_types.include? options.resource or options.resource.start_with? options.endpoint
    Occi::Log.debug "#{options.resource} is a resource type or an actual resource."

    found = describe(options.resource)
  elsif mixin_types.include? options.resource
    Occi::Log.debug "#{options.resourcre} is a mixin type."

    mixins(options.resource).each do |mxn|
      mxn = mxn.split("#").last
      found << mixin(mxn, options.resource, true)
    end
  elsif mixin_types.include? options.resource.split('#').first
    Occi::Log.debug "#{options.resource} is a specific mixin type."

    mxn_type,mxn = options.resource.split('#')
    found << mixin(mxn, mxn_type, true)
  else
    Occi::Log.debug "I have no idea what #{options.resource} is ..."

    puts "Unknown resource #{options.resource}, there is nothing to describe here!"
  end

  found
end

def helper_create(options)
  location = nil

  if resource_types.include? options.resource
    Occi::Log.debug "#{options.resource} is a resource type."
    raise "Not yet implemented!" unless options.resource.include? "compute"

    res = resource options.resource

    Occi::Log.debug "Creating #{options.resource}:\n#{res.inspect}"
    Occi::Log.debug "with mixins:#{options.mixin}"

    options.mixin.keys.each do |type|
      Occi::Log.debug "Adding mixins of type #{type} to #{options.resource}"
      options.mixin[type].each do |name|
        mxn = mixin name, type

        raise "Unknown mixin #{type}##{name}, stopping here!" if mxn.nil?
        Occi::Log.debug "Adding mixin #{mxn} to #{options.resource}"
        res.mixins << mxn
      end
    end

    #TODO: set other attributes
    res.title = options.resource_title

    Occi::Log.debug "Creating #{options.resource}:\n#{res.inspect}"

    location = create res
  else
    Occi::Log.debug "I have no idea what #{options.resource} is ..."
    puts "Unknown resource #{options.resource}, there is nothing to create here!"
  end

  location
end

def helper_delete(options)
  delete options.resource
end

def helper_trigger(options)
  raise "Not yet implemented!"
end