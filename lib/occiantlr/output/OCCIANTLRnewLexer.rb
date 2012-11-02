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

  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = OCCIANTLRnew
    include TokenData

    begin
      generated_using( "/Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g", "3.4", "" )
    rescue NoMethodError => error
      # ignore
    end

    RULE_NAMES   = [ "T__8", "T__9", "T__10", "T__11", "T__12", "T__13", 
                     "T__14", "T__15", "T__16", "T__17", "T__18", "T__19", 
                     "T__20", "T__21", "T__22", "T__23", "T__24", "T__25", 
                     "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", 
                     "T__32", "T__33", "T__34", "T__35", "T__36", "T__37", 
                     "T__38", "T__39", "T__40", "T__41", "T__42", "T__43", 
                     "T__44", "T__45", "T__46", "LOALPHA", "UPALPHA", "DIGIT", 
                     "WS" ].freeze
    RULE_METHODS = [ :t__8!, :t__9!, :t__10!, :t__11!, :t__12!, :t__13!, 
                     :t__14!, :t__15!, :t__16!, :t__17!, :t__18!, :t__19!, 
                     :t__20!, :t__21!, :t__22!, :t__23!, :t__24!, :t__25!, 
                     :t__26!, :t__27!, :t__28!, :t__29!, :t__30!, :t__31!, 
                     :t__32!, :t__33!, :t__34!, :t__35!, :t__36!, :t__37!, 
                     :t__38!, :t__39!, :t__40!, :t__41!, :t__42!, :t__43!, 
                     :t__44!, :t__45!, :t__46!, :loalpha!, :upalpha!, :digit!, 
                     :ws! ].freeze

    def initialize( input=nil, options = {} )
      super( input, options )
    end


    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule t__8! (T__8)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__8!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )



      type = T__8
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 7:8: '\"'
      match( 0x22 )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )


    end

    # lexer rule t__9! (T__9)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__9!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )



      type = T__9
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 8:8: '#'
      match( 0x23 )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )


    end

    # lexer rule t__10! (T__10)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__10!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )



      type = T__10
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 9:9: '%'
      match( 0x25 )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )


    end

    # lexer rule t__11! (T__11)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__11!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )



      type = T__11
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 10:9: '&'
      match( 0x26 )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )


    end

    # lexer rule t__12! (T__12)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__12!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )



      type = T__12
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 11:9: '+'
      match( 0x2b )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )


    end

    # lexer rule t__13! (T__13)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__13!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )



      type = T__13
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 12:9: '-'
      match( 0x2d )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )


    end

    # lexer rule t__14! (T__14)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__14!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )



      type = T__14
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 13:9: '.'
      match( 0x2e )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )


    end

    # lexer rule t__15! (T__15)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__15!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )



      type = T__15
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 14:9: '/'
      match( 0x2f )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )


    end

    # lexer rule t__16! (T__16)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__16!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )



      type = T__16
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 15:9: ':'
      match( 0x3a )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )


    end

    # lexer rule t__17! (T__17)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__17!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )



      type = T__17
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 16:9: ';'
      match( 0x3b )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )


    end

    # lexer rule t__18! (T__18)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__18!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )



      type = T__18
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 17:9: '<'
      match( 0x3c )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )


    end

    # lexer rule t__19! (T__19)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__19!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )



      type = T__19
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 18:9: '='
      match( 0x3d )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )


    end

    # lexer rule t__20! (T__20)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__20!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )



      type = T__20
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 19:9: '>'
      match( 0x3e )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )


    end

    # lexer rule t__21! (T__21)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__21!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )



      type = T__21
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 20:9: '?'
      match( 0x3f )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )


    end

    # lexer rule t__22! (T__22)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__22!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )



      type = T__22
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 21:9: '@'
      match( 0x40 )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )


    end

    # lexer rule t__23! (T__23)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__23!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )



      type = T__23
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 22:9: 'Category'
      match( "Category" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 16 )


    end

    # lexer rule t__24! (T__24)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__24!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )



      type = T__24
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 23:9: 'Link:'
      match( "Link:" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 17 )


    end

    # lexer rule t__25! (T__25)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__25!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )



      type = T__25
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 24:9: 'X-Occi-Attribute:'
      match( "X-Occi-Attribute:" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 18 )


    end

    # lexer rule t__26! (T__26)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__26!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )



      type = T__26
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 25:9: 'X-Occi-Location:'
      match( "X-Occi-Location:" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 19 )


    end

    # lexer rule t__27! (T__27)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__27!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )



      type = T__27
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 26:9: '\\\\'
      match( 0x5c )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 20 )


    end

    # lexer rule t__28! (T__28)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__28!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )



      type = T__28
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 27:9: '_'
      match( 0x5f )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 21 )


    end

    # lexer rule t__29! (T__29)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__29!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )



      type = T__29
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 28:9: 'action'
      match( "action" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 22 )


    end

    # lexer rule t__30! (T__30)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__30!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )



      type = T__30
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 29:9: 'actions=\"'
      match( "actions=\"" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 23 )


    end

    # lexer rule t__31! (T__31)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__31!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )



      type = T__31
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 30:9: 'attributes=\"'
      match( "attributes=\"" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 24 )


    end

    # lexer rule t__32! (T__32)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__32!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )



      type = T__32
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 31:9: 'category='
      match( "category=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )


    end

    # lexer rule t__33! (T__33)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__33!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )



      type = T__33
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 32:9: 'class='
      match( "class=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 26 )


    end

    # lexer rule t__34! (T__34)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__34!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )



      type = T__34
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 33:9: 'immutable'
      match( "immutable" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )


    end

    # lexer rule t__35! (T__35)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__35!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )



      type = T__35
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 34:9: 'kind'
      match( "kind" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 28 )


    end

    # lexer rule t__36! (T__36)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__36!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )



      type = T__36
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 35:9: 'location='
      match( "location=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 29 )


    end

    # lexer rule t__37! (T__37)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__37!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )



      type = T__37
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 36:9: 'mixin'
      match( "mixin" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 30 )


    end

    # lexer rule t__38! (T__38)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__38!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )



      type = T__38
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 37:9: 'mutable'
      match( "mutable" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 31 )


    end

    # lexer rule t__39! (T__39)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__39!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )



      type = T__39
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 38:9: 'rel='
      match( "rel=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 32 )


    end

    # lexer rule t__40! (T__40)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__40!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )



      type = T__40
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 39:9: 'required'
      match( "required" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 33 )


    end

    # lexer rule t__41! (T__41)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__41!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 34 )



      type = T__41
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 40:9: 'scheme='
      match( "scheme=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 34 )


    end

    # lexer rule t__42! (T__42)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__42!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 35 )



      type = T__42
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 41:9: 'self='
      match( "self=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 35 )


    end

    # lexer rule t__43! (T__43)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__43!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 36 )



      type = T__43
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 42:9: 'title='
      match( "title=" )



      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 36 )


    end

    # lexer rule t__44! (T__44)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__44!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 37 )



      type = T__44
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 43:9: '{'
      match( 0x7b )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 37 )


    end

    # lexer rule t__45! (T__45)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__45!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 38 )



      type = T__45
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 44:9: '}'
      match( 0x7d )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 38 )


    end

    # lexer rule t__46! (T__46)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def t__46!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 39 )



      type = T__46
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 45:9: '~'
      match( 0x7e )


      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 39 )


    end

    # lexer rule loalpha! (LOALPHA)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def loalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 40 )



      type = LOALPHA
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 
      if @input.peek( 1 ).between?( 0x61, 0x7a )
        @input.consume
      else
        mse = MismatchedSet( nil )
        recover mse
        raise mse

      end




      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 40 )


    end

    # lexer rule upalpha! (UPALPHA)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def upalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 41 )



      type = UPALPHA
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 
      if @input.peek( 1 ).between?( 0x41, 0x5a )
        @input.consume
      else
        mse = MismatchedSet( nil )
        recover mse
        raise mse

      end




      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 41 )


    end

    # lexer rule digit! (DIGIT)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def digit!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 42 )



      type = DIGIT
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 
      if @input.peek( 1 ).between?( 0x30, 0x39 )
        @input.consume
      else
        mse = MismatchedSet( nil )
        recover mse
        raise mse

      end




      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 42 )


    end

    # lexer rule ws! (WS)
    # (in /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLRnew.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 43 )



      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL
    # - - - - label initialization - - - -


      # - - - - main rule block - - - -
      # at line 132:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      # at file 132:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      match_count_1 = 0
      while true
        alt_1 = 2
        look_1_0 = @input.peek( 1 )

        if ( look_1_0.between?( 0x9, 0xa ) || look_1_0.between?( 0xc, 0xd ) || look_1_0 == 0x20 )
          alt_1 = 1

        end
        case alt_1
        when 1
          # at line 
          if @input.peek( 1 ).between?( 0x9, 0xa ) || @input.peek( 1 ).between?( 0xc, 0xd ) || @input.peek(1) == 0x20
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse

          end



        else
          match_count_1 > 0 and break
          eee = EarlyExit(1)


          raise eee
        end
        match_count_1 += 1
      end




      @state.type = type
      @state.channel = channel
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 43 )


    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    #
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( T__8 | T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | T__37 | T__38 | T__39 | T__40 | T__41 | T__42 | T__43 | T__44 | T__45 | T__46 | LOALPHA | UPALPHA | DIGIT | WS )
      alt_2 = 43
      alt_2 = @dfa2.predict( @input )
      case alt_2
      when 1
        # at line 1:10: T__8
        t__8!


      when 2
        # at line 1:15: T__9
        t__9!


      when 3
        # at line 1:20: T__10
        t__10!


      when 4
        # at line 1:26: T__11
        t__11!


      when 5
        # at line 1:32: T__12
        t__12!


      when 6
        # at line 1:38: T__13
        t__13!


      when 7
        # at line 1:44: T__14
        t__14!


      when 8
        # at line 1:50: T__15
        t__15!


      when 9
        # at line 1:56: T__16
        t__16!


      when 10
        # at line 1:62: T__17
        t__17!


      when 11
        # at line 1:68: T__18
        t__18!


      when 12
        # at line 1:74: T__19
        t__19!


      when 13
        # at line 1:80: T__20
        t__20!


      when 14
        # at line 1:86: T__21
        t__21!


      when 15
        # at line 1:92: T__22
        t__22!


      when 16
        # at line 1:98: T__23
        t__23!


      when 17
        # at line 1:104: T__24
        t__24!


      when 18
        # at line 1:110: T__25
        t__25!


      when 19
        # at line 1:116: T__26
        t__26!


      when 20
        # at line 1:122: T__27
        t__27!


      when 21
        # at line 1:128: T__28
        t__28!


      when 22
        # at line 1:134: T__29
        t__29!


      when 23
        # at line 1:140: T__30
        t__30!


      when 24
        # at line 1:146: T__31
        t__31!


      when 25
        # at line 1:152: T__32
        t__32!


      when 26
        # at line 1:158: T__33
        t__33!


      when 27
        # at line 1:164: T__34
        t__34!


      when 28
        # at line 1:170: T__35
        t__35!


      when 29
        # at line 1:176: T__36
        t__36!


      when 30
        # at line 1:182: T__37
        t__37!


      when 31
        # at line 1:188: T__38
        t__38!


      when 32
        # at line 1:194: T__39
        t__39!


      when 33
        # at line 1:200: T__40
        t__40!


      when 34
        # at line 1:206: T__41
        t__41!


      when 35
        # at line 1:212: T__42
        t__42!


      when 36
        # at line 1:218: T__43
        t__43!


      when 37
        # at line 1:224: T__44
        t__44!


      when 38
        # at line 1:230: T__45
        t__45!


      when 39
        # at line 1:236: T__46
        t__46!


      when 40
        # at line 1:242: LOALPHA
        loalpha!


      when 41
        # at line 1:250: UPALPHA
        upalpha!


      when 42
        # at line 1:258: DIGIT
        digit!


      when 43
        # at line 1:264: WS
        ws!


      end
    end


    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA2 < ANTLR3::DFA
      EOT = unpack( 16, -1, 3, 34, 2, -1, 9, 33, 32, -1, 1, 65, 5, -1 )
      EOF = unpack( 68, -1 )
      MIN = unpack( 1, 9, 15, -1, 1, 97, 1, 105, 1, 45, 2, -1, 1, 99, 1, 
                    97, 1, 109, 1, 105, 1, 111, 1, 105, 1, 101, 1, 99, 1, 
                    105, 9, -1, 1, 79, 1, 116, 8, -1, 1, 108, 3, -1, 1, 
                    67, 1, 105, 2, -1, 1, 67, 1, 111, 1, 73, 1, 110, 1, 
                    45, 1, 115, 1, 65, 4, -1 )
      MAX = unpack( 1, 126, 15, -1, 1, 97, 1, 105, 1, 45, 2, -1, 1, 116, 
                    1, 108, 1, 109, 1, 105, 1, 111, 1, 117, 2, 101, 1, 105, 
                    9, -1, 1, 79, 1, 116, 8, -1, 1, 113, 3, -1, 1, 67, 1, 
                    105, 2, -1, 1, 67, 1, 111, 1, 73, 1, 110, 1, 45, 1, 
                    115, 1, 76, 4, -1 )
      ACCEPT = unpack( 1, -1, 1, 1, 1, 2, 1, 3, 1, 4, 1, 5, 1, 6, 1, 7, 
                       1, 8, 1, 9, 1, 10, 1, 11, 1, 12, 1, 13, 1, 14, 1, 
                       15, 3, -1, 1, 20, 1, 21, 9, -1, 1, 37, 1, 38, 1, 
                       39, 1, 40, 1, 41, 1, 42, 1, 43, 1, 16, 1, 17, 2, 
                       -1, 1, 24, 1, 25, 1, 26, 1, 27, 1, 28, 1, 29, 1, 
                       30, 1, 31, 1, -1, 1, 34, 1, 35, 1, 36, 2, -1, 1, 
                       32, 1, 33, 7, -1, 1, 23, 1, 22, 1, 18, 1, 19 )
      SPECIAL = unpack( 68, -1 )
      TRANSITION = [
        unpack( 2, 36, 1, -1, 2, 36, 18, -1, 1, 36, 1, -1, 1, 1, 1, 2, 1, 
                -1, 1, 3, 1, 4, 4, -1, 1, 5, 1, -1, 1, 6, 1, 7, 1, 8, 10, 
                35, 1, 9, 1, 10, 1, 11, 1, 12, 1, 13, 1, 14, 1, 15, 2, 34, 
                1, 16, 8, 34, 1, 17, 11, 34, 1, 18, 2, 34, 1, -1, 1, 19, 
                2, -1, 1, 20, 1, -1, 1, 21, 1, 33, 1, 22, 5, 33, 1, 23, 
                1, 33, 1, 24, 1, 25, 1, 26, 4, 33, 1, 27, 1, 28, 1, 29, 
                6, 33, 1, 30, 1, -1, 1, 31, 1, 32 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 37 ),
        unpack( 1, 38 ),
        unpack( 1, 39 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 40, 16, -1, 1, 41 ),
        unpack( 1, 42, 10, -1, 1, 43 ),
        unpack( 1, 44 ),
        unpack( 1, 45 ),
        unpack( 1, 46 ),
        unpack( 1, 47, 11, -1, 1, 48 ),
        unpack( 1, 49 ),
        unpack( 1, 50, 1, -1, 1, 51 ),
        unpack( 1, 52 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 53 ),
        unpack( 1, 54 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 55, 4, -1, 1, 56 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 57 ),
        unpack( 1, 58 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 59 ),
        unpack( 1, 60 ),
        unpack( 1, 61 ),
        unpack( 1, 62 ),
        unpack( 1, 63 ),
        unpack( 1, 64 ),
        unpack( 1, 66, 10, -1, 1, 67 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  )
      ].freeze

      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end

      @decision = 2


      def description
        <<-'__dfa_description__'.strip!
          1:1: Tokens : ( T__8 | T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | T__37 | T__38 | T__39 | T__40 | T__41 | T__42 | T__43 | T__44 | T__45 | T__46 | LOALPHA | UPALPHA | DIGIT | WS );
        __dfa_description__
      end

    end


    private

    def initialize_dfas
      super rescue nil
      @dfa2 = DFA2.new( self, 2 )


    end

  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main( ARGV ) } if __FILE__ == $0

end

