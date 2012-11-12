require 'rubygems'

require 'set'
require 'hashie/mash'

require 'active_support/json'
require 'active_support/inflector'
require 'active_support/notifications'

require 'logger'

require 'uuidtools'

require 'httparty'

require 'nokogiri'

require 'rubygems/package'

require 'zlib'

require 'tempfile'

require 'occi/version'
require 'occi/collection'
require 'occi/parser'
require 'occi/model'
require 'occi/log'
require 'occi/core'
require 'occi/infrastructure'

require 'occiantlr/OCCIANTLRLexer'
require 'occiantlr/OCCIANTLRParser'

require 'occi/api/dsl'
require 'occi/api/client'

module Occi

  def kinds
    Occi::Core::Kinds.new
  end

  def mixins
    Occi::Core::Mixins.new
  end

  def actions
    Occi::Core::Actions.new
  end

  # @return [Array] list of Occi::Core::Categories
  def categories
    self.kinds + self.mixins + self.actions
  end
end