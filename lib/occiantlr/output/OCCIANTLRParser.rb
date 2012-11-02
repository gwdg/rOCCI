#!/usr/bin/env ruby
#
# /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g
# --
# Generated using ANTLR version: 3.4
# Ruby runtime library version: 
# Input grammar file: /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g
# Generated at: 2012-06-12 16:26:16
#

# ~~~> start load path setup
this_directory = File.expand_path( File.dirname( __FILE__ ) )
$LOAD_PATH.unshift( this_directory ) unless $LOAD_PATH.include?( this_directory )

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join( $/ )
  raise LoadError, <<-END.strip!

Failed to load the ANTLR3 runtime library (version ):

Ensure the library has been installed on your system and is available
on the load path. If rubygems is available on your system, this can
be done with the command:

  gem install antlr3

Current load path:
#{ load_path }

  END
end

defined?( ANTLR3 ) or begin

  # 1: try to load the ruby antlr3 runtime library from the system path
  require 'antlr3'

rescue LoadError

  # 2: try to load rubygems if it isn't already loaded
  defined?( Gem ) or begin
    require 'rubygems'
  rescue LoadError
    antlr_load_failed.call
  end

  # 3: try to activate the antlr3 gem
  begin
    Gem.activate( 'antlr3', '~> ' )
  rescue Gem::LoadError
    antlr_load_failed.call
  end

  require 'antlr3'

end
# <~~~ end load path setup


module OCCIANTLR
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all
  # ANTLR-generated recognizers.
  const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens( :EOF => -1, :ACTION => 4, :ACTIONS => 5, :AMPERSAND => 6, 
                   :AT => 7, :ATTRIBUTES => 8, :BACKSLASH => 9, :CATEGORY => 10, 
                   :CATEGORY_KEY => 11, :CLASS => 12, :COLON => 13, :DASH => 14, 
                   :DIGIT => 15, :DOT => 16, :EQUALS => 17, :ESC => 18, 
                   :GT => 19, :HASH => 20, :KIND => 21, :LINK => 22, :LINK_KEY => 23, 
                   :LOALPHA => 24, :LOCATION => 25, :LT => 26, :MIXIN => 27, 
                   :PERCENT => 28, :PLUS => 29, :QUESTION => 30, :QUOTE => 31, 
                   :REL => 32, :SCHEME => 33, :SELF => 34, :SEMICOLON => 35, 
                   :SLASH => 36, :SQUOTE => 37, :TERM => 38, :TILDE => 39, 
                   :TITLE => 40, :UNDERSCORE => 41, :UPALPHA => 42, :WS => 43, 
                   :X_Occi_ATTRIBUTE_KEY => 44, :X_Occi_LOCATION_KEY => 45 )


    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names( "ACTION", "ACTIONS", "AMPERSAND", "AT", "ATTRIBUTES", 
                    "BACKSLASH", "CATEGORY", "CATEGORY_KEY", "CLASS", "COLON", 
                    "DASH", "DIGIT", "DOT", "EQUALS", "ESC", "GT", "HASH", 
                    "KIND", "LINK", "LINK_KEY", "LOALPHA", "LOCATION", "LT", 
                    "MIXIN", "PERCENT", "PLUS", "QUESTION", "QUOTE", "REL", 
                    "SCHEME", "SELF", "SEMICOLON", "SLASH", "SQUOTE", "TERM", 
                    "TILDE", "TITLE", "UNDERSCORE", "UPALPHA", "WS", "X_Occi_ATTRIBUTE_KEY",
                    "X_Occi_LOCATION_KEY" )


  end


  class Parser < ANTLR3::Parser
  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0

end

