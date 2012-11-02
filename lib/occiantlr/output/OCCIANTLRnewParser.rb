#!/usr/bin/env ruby
#
# /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g
# --
# Generated using ANTLR version: 3.4
# Ruby runtime library version: 
# Input grammar file: /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g
# Generated at: 2012-09-04 23:59:56
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


module OCCIANTLRnew
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all
  # ANTLR-generated recognizers.
  const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens( :EOF => -1, :T__8 => 8, :T__9 => 9, :T__10 => 10, :T__11 => 11, 
                   :T__12 => 12, :T__13 => 13, :T__14 => 14, :T__15 => 15, 
                   :T__16 => 16, :T__17 => 17, :T__18 => 18, :T__19 => 19, 
                   :T__20 => 20, :T__21 => 21, :T__22 => 22, :T__23 => 23, 
                   :T__24 => 24, :T__25 => 25, :T__26 => 26, :T__27 => 27, 
                   :T__28 => 28, :T__29 => 29, :T__30 => 30, :T__31 => 31, 
                   :T__32 => 32, :T__33 => 33, :T__34 => 34, :T__35 => 35, 
                   :T__36 => 36, :T__37 => 37, :T__38 => 38, :T__39 => 39, 
                   :T__40 => 40, :T__41 => 41, :T__42 => 42, :T__43 => 43, 
                   :T__44 => 44, :T__45 => 45, :T__46 => 46, :DIGIT => 4, 
                   :LOALPHA => 5, :UPALPHA => 6, :WS => 7 )


    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names( "DIGIT", "LOALPHA", "UPALPHA", "WS", "'\"'", "'#'", 
                    "'%'", "'&'", "'+'", "'-'", "'.'", "'/'", "':'", "';'", 
                    "'<'", "'='", "'>'", "'?'", "'@'", "'Category'", "'Link:'", 
                    "'X-Occi-Attribute:'", "'X-Occi-Location:'", "'\\\\'",
                    "'_'", "'action'", "'actions=\"'", "'attributes=\"'", 
                    "'category='", "'class='", "'immutable'", "'kind'", 
                    "'location='", "'mixin'", "'mutable'", "'rel='", "'required'", 
                    "'scheme='", "'self='", "'title='", "'{'", "'}'", "'~'" )


  end


  class Parser < ANTLR3::Parser
  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0

end

