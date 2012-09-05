#!/usr/bin/env ruby
#
# OCCIANTLR.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: OCCIANTLR.g
# Generated at: 2012-09-05 21:22:49
# 

# ~~~> start load path setup
this_directory = File.expand_path( File.dirname( __FILE__ ) )
$LOAD_PATH.unshift( this_directory ) unless $LOAD_PATH.include?( this_directory )

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join( $/ )
  raise LoadError, <<-END.strip!
  
Failed to load the ANTLR3 runtime library (version 1.8.11):

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
    Gem.activate( 'antlr3', '~> 1.8.11' )
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
    define_tokens( :TERM => 45, :CLASS => 11, :LT => 18, :ATTRIBUTES => 15, 
                   :ESC => 42, :EQUALS => 9, :EOF => -1, :ACTION => 41, 
                   :ACTIONS => 16, :AT => 27, :LBRACKET => 46, :QUOTE => 10, 
                   :SLASH => 37, :T__51 => 51, :T__52 => 52, :TILDE => 33, 
                   :PLUS => 31, :DIGIT => 26, :RBRACKET => 47, :LOALPHA => 24, 
                   :DOT => 32, :T__50 => 50, :X_OCCI_ATTRIBUTE_KEY => 22, 
                   :PERCENT => 28, :DASH => 38, :T__48 => 48, :T__49 => 49, 
                   :HASH => 34, :AMPERSAND => 36, :CATEGORY => 21, :UNDERSCORE => 29, 
                   :REL => 13, :SEMICOLON => 6, :CATEGORY_KEY => 4, :LINK => 44, 
                   :SQUOTE => 43, :KIND => 39, :SCHEME => 8, :COLON => 5, 
                   :MIXIN => 40, :WS => 7, :QUESTION => 35, :UPALPHA => 25, 
                   :LINK_KEY => 17, :LOCATION => 14, :GT => 19, :X_OCCI_LOCATION_KEY => 23, 
                   :SELF => 20, :BACKSLASH => 30, :TITLE => 12 )
    
  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = OCCIANTLR
    include TokenData

    
    begin
      generated_using( "OCCIANTLR.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end
    
    RULE_NAMES   = [ "T__48", "T__49", "T__50", "T__51", "T__52", "CATEGORY_KEY", 
                     "LINK_KEY", "X_OCCI_ATTRIBUTE_KEY", "X_OCCI_LOCATION_KEY", 
                     "ACTION", "ACTIONS", "AMPERSAND", "AT", "ATTRIBUTES", 
                     "BACKSLASH", "CATEGORY", "CLASS", "COLON", "DASH", 
                     "DOT", "EQUALS", "GT", "HASH", "KIND", "LINK", "LOCATION", 
                     "LT", "MIXIN", "PERCENT", "PLUS", "QUESTION", "QUOTE", 
                     "REL", "SCHEME", "SELF", "SEMICOLON", "SLASH", "SQUOTE", 
                     "TERM", "TILDE", "TITLE", "UNDERSCORE", "LBRACKET", 
                     "RBRACKET", "LOALPHA", "UPALPHA", "DIGIT", "WS", "ESC" ].freeze
    RULE_METHODS = [ :t__48!, :t__49!, :t__50!, :t__51!, :t__52!, :category_key!, 
                     :link_key!, :x_occi_attribute_key!, :x_occi_location_key!, 
                     :action!, :actions!, :ampersand!, :at!, :attributes!, 
                     :backslash!, :category!, :class!, :colon!, :dash!, 
                     :dot!, :equals!, :gt!, :hash!, :kind!, :link!, :location!, 
                     :lt!, :mixin!, :percent!, :plus!, :question!, :quote!, 
                     :rel!, :scheme!, :self!, :semicolon!, :slash!, :squote!, 
                     :term!, :tilde!, :title!, :underscore!, :lbracket!, 
                     :rbracket!, :loalpha!, :upalpha!, :digit!, :ws!, :esc! ].freeze

    
    def initialize( input=nil, options = {} )
      super( input, options )

    end
    
    
    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule t__48! (T__48)
    # (in OCCIANTLR.g)
    def t__48!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = T__48
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 7:9: '{'
      match( 0x7b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )

    end

    # lexer rule t__49! (T__49)
    # (in OCCIANTLR.g)
    def t__49!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = T__49
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 8:9: 'mutable'
      match( "mutable" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )

    end

    # lexer rule t__50! (T__50)
    # (in OCCIANTLR.g)
    def t__50!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = T__50
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 9:9: 'immutable'
      match( "immutable" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )

    end

    # lexer rule t__51! (T__51)
    # (in OCCIANTLR.g)
    def t__51!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = T__51
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 10:9: 'required'
      match( "required" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )

    end

    # lexer rule t__52! (T__52)
    # (in OCCIANTLR.g)
    def t__52!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      type = T__52
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 11:9: '}'
      match( 0x7d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )

    end

    # lexer rule category_key! (CATEGORY_KEY)
    # (in OCCIANTLR.g)
    def category_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      type = CATEGORY_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 131:4: 'Category'
      match( "Category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )

    end

    # lexer rule link_key! (LINK_KEY)
    # (in OCCIANTLR.g)
    def link_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      type = LINK_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 133:4: 'Link'
      match( "Link" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )

    end

    # lexer rule x_occi_attribute_key! (X_OCCI_ATTRIBUTE_KEY)
    # (in OCCIANTLR.g)
    def x_occi_attribute_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      type = X_OCCI_ATTRIBUTE_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 135:4: 'X-OCCI-Attribute'
      match( "X-OCCI-Attribute" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )

    end

    # lexer rule x_occi_location_key! (X_OCCI_LOCATION_KEY)
    # (in OCCIANTLR.g)
    def x_occi_location_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      type = X_OCCI_LOCATION_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 137:4: 'X-OCCI-Location'
      match( "X-OCCI-Location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )

    end

    # lexer rule action! (ACTION)
    # (in OCCIANTLR.g)
    def action!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      type = ACTION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 141:10: 'action'
      match( "action" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )

    end

    # lexer rule actions! (ACTIONS)
    # (in OCCIANTLR.g)
    def actions!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      type = ACTIONS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 142:11: 'actions'
      match( "actions" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )

    end

    # lexer rule ampersand! (AMPERSAND)
    # (in OCCIANTLR.g)
    def ampersand!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      type = AMPERSAND
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 144:4: '&'
      match( 0x26 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )

    end

    # lexer rule at! (AT)
    # (in OCCIANTLR.g)
    def at!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      type = AT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 145:6: '@'
      match( 0x40 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )

    end

    # lexer rule attributes! (ATTRIBUTES)
    # (in OCCIANTLR.g)
    def attributes!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      type = ATTRIBUTES
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 147:4: 'attributes'
      match( "attributes" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )

    end

    # lexer rule backslash! (BACKSLASH)
    # (in OCCIANTLR.g)
    def backslash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      type = BACKSLASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 149:4: '\\\\'
      match( 0x5c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )

    end

    # lexer rule category! (CATEGORY)
    # (in OCCIANTLR.g)
    def category!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )

      type = CATEGORY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 150:11: 'category'
      match( "category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 16 )

    end

    # lexer rule class! (CLASS)
    # (in OCCIANTLR.g)
    def class!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )

      type = CLASS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 151:9: 'class'
      match( "class" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 17 )

    end

    # lexer rule colon! (COLON)
    # (in OCCIANTLR.g)
    def colon!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )

      type = COLON
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 152:9: ':'
      match( 0x3a )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 18 )

    end

    # lexer rule dash! (DASH)
    # (in OCCIANTLR.g)
    def dash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )

      type = DASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 153:8: '-'
      match( 0x2d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 19 )

    end

    # lexer rule dot! (DOT)
    # (in OCCIANTLR.g)
    def dot!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      type = DOT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 154:7: '.'
      match( 0x2e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 20 )

    end

    # lexer rule equals! (EQUALS)
    # (in OCCIANTLR.g)
    def equals!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )

      type = EQUALS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 155:10: '='
      match( 0x3d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 21 )

    end

    # lexer rule gt! (GT)
    # (in OCCIANTLR.g)
    def gt!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )

      type = GT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 156:6: '>'
      match( 0x3e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 22 )

    end

    # lexer rule hash! (HASH)
    # (in OCCIANTLR.g)
    def hash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )

      type = HASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 157:8: '#'
      match( 0x23 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 23 )

    end

    # lexer rule kind! (KIND)
    # (in OCCIANTLR.g)
    def kind!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      type = KIND
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 158:8: 'kind'
      match( "kind" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 24 )

    end

    # lexer rule link! (LINK)
    # (in OCCIANTLR.g)
    def link!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      type = LINK
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 159:8: 'link'
      match( "link" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )

    end

    # lexer rule location! (LOCATION)
    # (in OCCIANTLR.g)
    def location!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      type = LOCATION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 160:11: 'location'
      match( "location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 26 )

    end

    # lexer rule lt! (LT)
    # (in OCCIANTLR.g)
    def lt!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      type = LT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 161:6: '<'
      match( 0x3c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )

    end

    # lexer rule mixin! (MIXIN)
    # (in OCCIANTLR.g)
    def mixin!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )

      type = MIXIN
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 162:9: 'mixin'
      match( "mixin" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 28 )

    end

    # lexer rule percent! (PERCENT)
    # (in OCCIANTLR.g)
    def percent!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )

      type = PERCENT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 163:11: '%'
      match( 0x25 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 29 )

    end

    # lexer rule plus! (PLUS)
    # (in OCCIANTLR.g)
    def plus!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )

      type = PLUS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 164:8: '+'
      match( 0x2b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 30 )

    end

    # lexer rule question! (QUESTION)
    # (in OCCIANTLR.g)
    def question!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )

      type = QUESTION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 165:11: '?'
      match( 0x3f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 31 )

    end

    # lexer rule quote! (QUOTE)
    # (in OCCIANTLR.g)
    def quote!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )

      type = QUOTE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 166:9: '\"'
      match( 0x22 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 32 )

    end

    # lexer rule rel! (REL)
    # (in OCCIANTLR.g)
    def rel!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )

      type = REL
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 167:7: 'rel'
      match( "rel" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 33 )

    end

    # lexer rule scheme! (SCHEME)
    # (in OCCIANTLR.g)
    def scheme!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 34 )

      type = SCHEME
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 168:10: 'scheme'
      match( "scheme" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 34 )

    end

    # lexer rule self! (SELF)
    # (in OCCIANTLR.g)
    def self!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 35 )

      type = SELF
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 169:8: 'self'
      match( "self" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 35 )

    end

    # lexer rule semicolon! (SEMICOLON)
    # (in OCCIANTLR.g)
    def semicolon!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 36 )

      type = SEMICOLON
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 171:4: ';'
      match( 0x3b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 36 )

    end

    # lexer rule slash! (SLASH)
    # (in OCCIANTLR.g)
    def slash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 37 )

      type = SLASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 172:9: '/'
      match( 0x2f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 37 )

    end

    # lexer rule squote! (SQUOTE)
    # (in OCCIANTLR.g)
    def squote!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 38 )

      type = SQUOTE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 173:10: '\\''
      match( 0x27 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 38 )

    end

    # lexer rule term! (TERM)
    # (in OCCIANTLR.g)
    def term!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 39 )

      type = TERM
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 174:8: 'term'
      match( "term" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 39 )

    end

    # lexer rule tilde! (TILDE)
    # (in OCCIANTLR.g)
    def tilde!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 40 )

      type = TILDE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 175:9: '~'
      match( 0x7e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 40 )

    end

    # lexer rule title! (TITLE)
    # (in OCCIANTLR.g)
    def title!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 41 )

      type = TITLE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 176:9: 'title'
      match( "title" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 41 )

    end

    # lexer rule underscore! (UNDERSCORE)
    # (in OCCIANTLR.g)
    def underscore!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 42 )

      type = UNDERSCORE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 178:4: '_'
      match( 0x5f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 42 )

    end

    # lexer rule lbracket! (LBRACKET)
    # (in OCCIANTLR.g)
    def lbracket!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 43 )

      type = LBRACKET
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 179:12: '('
      match( 0x28 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 43 )

    end

    # lexer rule rbracket! (RBRACKET)
    # (in OCCIANTLR.g)
    def rbracket!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 44 )

      type = RBRACKET
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 180:12: ')'
      match( 0x29 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 44 )

    end

    # lexer rule loalpha! (LOALPHA)
    # (in OCCIANTLR.g)
    def loalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 45 )

      type = LOALPHA
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 182:12: ( 'a' .. 'z' )+
      # at file 182:12: ( 'a' .. 'z' )+
      match_count_1 = 0
      while true
        alt_1 = 2
        look_1_0 = @input.peek( 1 )

        if ( look_1_0.between?( 0x61, 0x7a ) )
          alt_1 = 1

        end
        case alt_1
        when 1
          # at line 182:13: 'a' .. 'z'
          match_range( 0x61, 0x7a )

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
      # trace_out( __method__, 45 )

    end

    # lexer rule upalpha! (UPALPHA)
    # (in OCCIANTLR.g)
    def upalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 46 )

      type = UPALPHA
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 183:12: ( 'A' .. 'Z' )+
      # at file 183:12: ( 'A' .. 'Z' )+
      match_count_2 = 0
      while true
        alt_2 = 2
        look_2_0 = @input.peek( 1 )

        if ( look_2_0.between?( 0x41, 0x5a ) )
          alt_2 = 1

        end
        case alt_2
        when 1
          # at line 183:13: 'A' .. 'Z'
          match_range( 0x41, 0x5a )

        else
          match_count_2 > 0 and break
          eee = EarlyExit(2)


          raise eee
        end
        match_count_2 += 1
      end


      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 46 )

    end

    # lexer rule digit! (DIGIT)
    # (in OCCIANTLR.g)
    def digit!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 47 )

      type = DIGIT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 184:12: ( '0' .. '9' )+
      # at file 184:12: ( '0' .. '9' )+
      match_count_3 = 0
      while true
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0.between?( 0x30, 0x39 ) )
          alt_3 = 1

        end
        case alt_3
        when 1
          # at line 184:13: '0' .. '9'
          match_range( 0x30, 0x39 )

        else
          match_count_3 > 0 and break
          eee = EarlyExit(3)


          raise eee
        end
        match_count_3 += 1
      end


      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 47 )

    end

    # lexer rule ws! (WS)
    # (in OCCIANTLR.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 48 )

      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 185:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      # at file 185:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      match_count_4 = 0
      while true
        alt_4 = 2
        look_4_0 = @input.peek( 1 )

        if ( look_4_0.between?( 0x9, 0xa ) || look_4_0.between?( 0xc, 0xd ) || look_4_0 == 0x20 )
          alt_4 = 1

        end
        case alt_4
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
          match_count_4 > 0 and break
          eee = EarlyExit(4)


          raise eee
        end
        match_count_4 += 1
      end


      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 48 )

    end

    # lexer rule esc! (ESC)
    # (in OCCIANTLR.g)
    def esc!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 49 )

      type = ESC
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 186:12: '\\\\' ( QUOTE | '\\'' )
      match( 0x5c )
      if @input.peek(1) == 0x22 || @input.peek(1) == 0x27
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
      # trace_out( __method__, 49 )

    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    # 
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( T__48 | T__49 | T__50 | T__51 | T__52 | CATEGORY_KEY | LINK_KEY | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | ACTION | ACTIONS | AMPERSAND | AT | ATTRIBUTES | BACKSLASH | CATEGORY | CLASS | COLON | DASH | DOT | EQUALS | GT | HASH | KIND | LINK | LOCATION | LT | MIXIN | PERCENT | PLUS | QUESTION | QUOTE | REL | SCHEME | SELF | SEMICOLON | SLASH | SQUOTE | TERM | TILDE | TITLE | UNDERSCORE | LBRACKET | RBRACKET | LOALPHA | UPALPHA | DIGIT | WS | ESC )
      alt_5 = 49
      alt_5 = @dfa5.predict( @input )
      case alt_5
      when 1
        # at line 1:10: T__48
        t__48!

      when 2
        # at line 1:16: T__49
        t__49!

      when 3
        # at line 1:22: T__50
        t__50!

      when 4
        # at line 1:28: T__51
        t__51!

      when 5
        # at line 1:34: T__52
        t__52!

      when 6
        # at line 1:40: CATEGORY_KEY
        category_key!

      when 7
        # at line 1:53: LINK_KEY
        link_key!

      when 8
        # at line 1:62: X_OCCI_ATTRIBUTE_KEY
        x_occi_attribute_key!

      when 9
        # at line 1:83: X_OCCI_LOCATION_KEY
        x_occi_location_key!

      when 10
        # at line 1:103: ACTION
        action!

      when 11
        # at line 1:110: ACTIONS
        actions!

      when 12
        # at line 1:118: AMPERSAND
        ampersand!

      when 13
        # at line 1:128: AT
        at!

      when 14
        # at line 1:131: ATTRIBUTES
        attributes!

      when 15
        # at line 1:142: BACKSLASH
        backslash!

      when 16
        # at line 1:152: CATEGORY
        category!

      when 17
        # at line 1:161: CLASS
        class!

      when 18
        # at line 1:167: COLON
        colon!

      when 19
        # at line 1:173: DASH
        dash!

      when 20
        # at line 1:178: DOT
        dot!

      when 21
        # at line 1:182: EQUALS
        equals!

      when 22
        # at line 1:189: GT
        gt!

      when 23
        # at line 1:192: HASH
        hash!

      when 24
        # at line 1:197: KIND
        kind!

      when 25
        # at line 1:202: LINK
        link!

      when 26
        # at line 1:207: LOCATION
        location!

      when 27
        # at line 1:216: LT
        lt!

      when 28
        # at line 1:219: MIXIN
        mixin!

      when 29
        # at line 1:225: PERCENT
        percent!

      when 30
        # at line 1:233: PLUS
        plus!

      when 31
        # at line 1:238: QUESTION
        question!

      when 32
        # at line 1:247: QUOTE
        quote!

      when 33
        # at line 1:253: REL
        rel!

      when 34
        # at line 1:257: SCHEME
        scheme!

      when 35
        # at line 1:264: SELF
        self!

      when 36
        # at line 1:269: SEMICOLON
        semicolon!

      when 37
        # at line 1:279: SLASH
        slash!

      when 38
        # at line 1:285: SQUOTE
        squote!

      when 39
        # at line 1:292: TERM
        term!

      when 40
        # at line 1:297: TILDE
        tilde!

      when 41
        # at line 1:303: TITLE
        title!

      when 42
        # at line 1:309: UNDERSCORE
        underscore!

      when 43
        # at line 1:320: LBRACKET
        lbracket!

      when 44
        # at line 1:329: RBRACKET
        rbracket!

      when 45
        # at line 1:338: LOALPHA
        loalpha!

      when 46
        # at line 1:346: UPALPHA
        upalpha!

      when 47
        # at line 1:354: DIGIT
        digit!

      when 48
        # at line 1:360: WS
        ws!

      when 49
        # at line 1:363: ESC
        esc!

      end
    end

    
    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA5 < ANTLR3::DFA
      EOT = unpack( 2, -1, 3, 36, 1, -1, 3, 37, 1, 36, 2, -1, 1, 50, 1, 
                    36, 6, -1, 2, 36, 5, -1, 1, 36, 3, -1, 1, 36, 8, -1, 
                    4, 36, 3, -1, 2, 36, 2, -1, 13, 36, 1, 81, 1, -1, 15, 
                    36, 2, -1, 4, 36, 1, 103, 1, 104, 2, 36, 1, 107, 1, 
                    108, 2, 36, 1, 111, 2, 36, 1, -1, 3, 36, 1, 118, 2, 
                    -1, 2, 36, 2, -1, 1, 121, 1, 36, 1, -1, 2, 36, 1, -1, 
                    1, 127, 2, 36, 1, -1, 1, 36, 1, 131, 1, -1, 1, 132, 
                    2, 36, 1, -1, 1, 137, 1, -1, 3, 36, 2, -1, 1, 36, 1, 
                    142, 3, -1, 1, 36, 1, 144, 1, 145, 1, 146, 1, -1, 1, 
                    36, 3, -1, 1, 148, 1, -1 )
      EOF = unpack( 149, -1 )
      MIN = unpack( 1, 9, 1, -1, 1, 105, 1, 109, 1, 101, 1, -1, 1, 97, 1, 
                    105, 1, 45, 1, 99, 2, -1, 1, 34, 1, 97, 6, -1, 2, 105, 
                    5, -1, 1, 99, 3, -1, 1, 101, 8, -1, 1, 116, 1, 120, 
                    1, 109, 1, 108, 2, -1, 1, 79, 2, 116, 2, -1, 1, 116, 
                    1, 97, 2, 110, 1, 99, 1, 104, 1, 108, 1, 114, 1, 116, 
                    1, 97, 1, 105, 2, 117, 1, 97, 1, 67, 1, 105, 1, 114, 
                    1, 101, 1, 115, 1, 100, 1, 107, 1, 97, 1, 101, 1, 102, 
                    1, 109, 1, 108, 1, 98, 1, 110, 1, 116, 1, 105, 1, -1, 
                    1, 67, 1, 111, 1, 105, 1, 103, 1, 115, 2, 97, 1, 116, 
                    1, 109, 2, 97, 1, 101, 1, 108, 2, 97, 1, 114, 1, 73, 
                    1, 110, 1, 98, 1, 111, 1, 97, 2, -1, 1, 105, 1, 101, 
                    2, -1, 1, 97, 1, 101, 1, -1, 1, 98, 1, 101, 1, 45, 1, 
                    97, 1, 117, 1, 114, 1, -1, 1, 111, 1, 97, 1, -1, 1, 
                    97, 1, 108, 1, 100, 1, 65, 1, 97, 1, -1, 1, 116, 1, 
                    121, 1, 110, 2, -1, 1, 101, 1, 97, 3, -1, 1, 101, 3, 
                    97, 1, -1, 1, 115, 3, -1, 1, 97, 1, -1 )
      MAX = unpack( 1, 126, 1, -1, 1, 117, 1, 109, 1, 101, 1, -1, 1, 97, 
                    1, 105, 1, 45, 1, 116, 2, -1, 1, 39, 1, 108, 6, -1, 
                    1, 105, 1, 111, 5, -1, 1, 101, 3, -1, 1, 105, 8, -1, 
                    1, 116, 1, 120, 1, 109, 1, 113, 2, -1, 1, 79, 2, 116, 
                    2, -1, 1, 116, 1, 97, 2, 110, 1, 99, 1, 104, 1, 108, 
                    1, 114, 1, 116, 1, 97, 1, 105, 2, 117, 1, 122, 1, 67, 
                    1, 105, 1, 114, 1, 101, 1, 115, 1, 100, 1, 107, 1, 97, 
                    1, 101, 1, 102, 1, 109, 1, 108, 1, 98, 1, 110, 1, 116, 
                    1, 105, 1, -1, 1, 67, 1, 111, 1, 105, 1, 103, 1, 115, 
                    2, 122, 1, 116, 1, 109, 2, 122, 1, 101, 1, 108, 1, 122, 
                    1, 97, 1, 114, 1, 73, 1, 110, 1, 98, 1, 111, 1, 122, 
                    2, -1, 1, 105, 1, 101, 2, -1, 1, 122, 1, 101, 1, -1, 
                    1, 98, 1, 101, 1, 45, 1, 122, 1, 117, 1, 114, 1, -1, 
                    1, 111, 1, 122, 1, -1, 1, 122, 1, 108, 1, 100, 1, 76, 
                    1, 122, 1, -1, 1, 116, 1, 121, 1, 110, 2, -1, 1, 101, 
                    1, 122, 3, -1, 1, 101, 3, 122, 1, -1, 1, 115, 3, -1, 
                    1, 122, 1, -1 )
      ACCEPT = unpack( 1, -1, 1, 1, 3, -1, 1, 5, 4, -1, 1, 12, 1, 13, 2, 
                       -1, 1, 18, 1, 19, 1, 20, 1, 21, 1, 22, 1, 23, 2, 
                       -1, 1, 27, 1, 29, 1, 30, 1, 31, 1, 32, 1, -1, 1, 
                       36, 1, 37, 1, 38, 1, -1, 1, 40, 1, 42, 1, 43, 1, 
                       44, 1, 45, 1, 46, 1, 47, 1, 48, 4, -1, 1, 6, 1, 7, 
                       3, -1, 1, 49, 1, 15, 30, -1, 1, 33, 21, -1, 1, 24, 
                       1, 25, 2, -1, 1, 35, 1, 39, 2, -1, 1, 28, 6, -1, 
                       1, 17, 2, -1, 1, 41, 5, -1, 1, 10, 3, -1, 1, 34, 
                       1, 2, 2, -1, 1, 8, 1, 9, 1, 11, 4, -1, 1, 4, 1, -1, 
                       1, 16, 1, 26, 1, 3, 1, -1, 1, 14 )
      SPECIAL = unpack( 149, -1 )
      TRANSITION = [
        unpack( 2, 39, 1, -1, 2, 39, 18, -1, 1, 39, 1, -1, 1, 26, 1, 19, 
                1, -1, 1, 23, 1, 10, 1, 30, 1, 34, 1, 35, 1, -1, 1, 24, 
                1, -1, 1, 15, 1, 16, 1, 29, 10, 38, 1, 14, 1, 28, 1, 22, 
                1, 17, 1, 18, 1, 25, 1, 11, 2, 37, 1, 6, 8, 37, 1, 7, 11, 
                37, 1, 8, 2, 37, 1, -1, 1, 12, 2, -1, 1, 33, 1, -1, 1, 9, 
                1, 36, 1, 13, 5, 36, 1, 3, 1, 36, 1, 20, 1, 21, 1, 2, 4, 
                36, 1, 4, 1, 27, 1, 31, 6, 36, 1, 1, 1, -1, 1, 5, 1, 32 ),
        unpack(  ),
        unpack( 1, 41, 11, -1, 1, 40 ),
        unpack( 1, 42 ),
        unpack( 1, 43 ),
        unpack(  ),
        unpack( 1, 44 ),
        unpack( 1, 45 ),
        unpack( 1, 46 ),
        unpack( 1, 47, 16, -1, 1, 48 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 49, 4, -1, 1, 49 ),
        unpack( 1, 51, 10, -1, 1, 52 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 53 ),
        unpack( 1, 54, 5, -1, 1, 55 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 56, 1, -1, 1, 57 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 58, 3, -1, 1, 59 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 60 ),
        unpack( 1, 61 ),
        unpack( 1, 62 ),
        unpack( 1, 64, 4, -1, 1, 63 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 65 ),
        unpack( 1, 66 ),
        unpack( 1, 67 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 68 ),
        unpack( 1, 69 ),
        unpack( 1, 70 ),
        unpack( 1, 71 ),
        unpack( 1, 72 ),
        unpack( 1, 73 ),
        unpack( 1, 74 ),
        unpack( 1, 75 ),
        unpack( 1, 76 ),
        unpack( 1, 77 ),
        unpack( 1, 78 ),
        unpack( 1, 79 ),
        unpack( 1, 80 ),
        unpack( 26, 36 ),
        unpack( 1, 82 ),
        unpack( 1, 83 ),
        unpack( 1, 84 ),
        unpack( 1, 85 ),
        unpack( 1, 86 ),
        unpack( 1, 87 ),
        unpack( 1, 88 ),
        unpack( 1, 89 ),
        unpack( 1, 90 ),
        unpack( 1, 91 ),
        unpack( 1, 92 ),
        unpack( 1, 93 ),
        unpack( 1, 94 ),
        unpack( 1, 95 ),
        unpack( 1, 96 ),
        unpack( 1, 97 ),
        unpack(  ),
        unpack( 1, 98 ),
        unpack( 1, 99 ),
        unpack( 1, 100 ),
        unpack( 1, 101 ),
        unpack( 1, 102 ),
        unpack( 26, 36 ),
        unpack( 26, 36 ),
        unpack( 1, 105 ),
        unpack( 1, 106 ),
        unpack( 26, 36 ),
        unpack( 26, 36 ),
        unpack( 1, 109 ),
        unpack( 1, 110 ),
        unpack( 26, 36 ),
        unpack( 1, 112 ),
        unpack( 1, 113 ),
        unpack( 1, 114 ),
        unpack( 1, 115 ),
        unpack( 1, 116 ),
        unpack( 1, 117 ),
        unpack( 26, 36 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 119 ),
        unpack( 1, 120 ),
        unpack(  ),
        unpack(  ),
        unpack( 26, 36 ),
        unpack( 1, 122 ),
        unpack(  ),
        unpack( 1, 123 ),
        unpack( 1, 124 ),
        unpack( 1, 125 ),
        unpack( 18, 36, 1, 126, 7, 36 ),
        unpack( 1, 128 ),
        unpack( 1, 129 ),
        unpack(  ),
        unpack( 1, 130 ),
        unpack( 26, 36 ),
        unpack(  ),
        unpack( 26, 36 ),
        unpack( 1, 133 ),
        unpack( 1, 134 ),
        unpack( 1, 135, 10, -1, 1, 136 ),
        unpack( 26, 36 ),
        unpack(  ),
        unpack( 1, 138 ),
        unpack( 1, 139 ),
        unpack( 1, 140 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 141 ),
        unpack( 26, 36 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 143 ),
        unpack( 26, 36 ),
        unpack( 26, 36 ),
        unpack( 26, 36 ),
        unpack(  ),
        unpack( 1, 147 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 26, 36 ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 5
      

      def description
        <<-'__dfa_description__'.strip!
          1:1: Tokens : ( T__48 | T__49 | T__50 | T__51 | T__52 | CATEGORY_KEY | LINK_KEY | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | ACTION | ACTIONS | AMPERSAND | AT | ATTRIBUTES | BACKSLASH | CATEGORY | CLASS | COLON | DASH | DOT | EQUALS | GT | HASH | KIND | LINK | LOCATION | LT | MIXIN | PERCENT | PLUS | QUESTION | QUOTE | REL | SCHEME | SELF | SEMICOLON | SLASH | SQUOTE | TERM | TILDE | TITLE | UNDERSCORE | LBRACKET | RBRACKET | LOALPHA | UPALPHA | DIGIT | WS | ESC );
        __dfa_description__
      end
    end

    
    private
    
    def initialize_dfas
      super rescue nil
      @dfa5 = DFA5.new( self, 5 )

    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main( ARGV ) } if __FILE__ == $0
end

