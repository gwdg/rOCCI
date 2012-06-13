#!/usr/bin/env ruby
#
# OCCIANTLR.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: OCCIANTLR.g
# Generated at: 2012-06-12 16:37:00
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
    define_tokens( :TERM => 45, :LT => 18, :CLASS => 11, :ATTRIBUTES => 15, 
                   :ESC => 42, :EQUALS => 9, :EOF => -1, :ACTION => 41, 
                   :ACTIONS => 16, :AT => 27, :QUOTE => 10, :SLASH => 37, 
                   :TILDE => 33, :PLUS => 31, :DIGIT => 26, :DOT => 32, 
                   :LOALPHA => 24, :X_OCCI_ATTRIBUTE_KEY => 22, :PERCENT => 28, 
                   :DASH => 38, :HASH => 34, :AMPERSAND => 36, :CATEGORY => 21, 
                   :UNDERSCORE => 29, :REL => 13, :CATEGORY_KEY => 4, :SEMICOLON => 6, 
                   :LINK => 44, :SQUOTE => 43, :KIND => 39, :SCHEME => 8, 
                   :COLON => 5, :MIXIN => 40, :WS => 7, :QUESTION => 35, 
                   :UPALPHA => 25, :LINK_KEY => 17, :LOCATION => 14, :GT => 19, 
                   :X_OCCI_LOCATION_KEY => 23, :SELF => 20, :BACKSLASH => 30, 
                   :TITLE => 12 )
    
  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = OCCIANTLR
    include TokenData

    
    begin
      generated_using( "OCCIANTLR.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end
    
    RULE_NAMES   = [ "CATEGORY_KEY", "LINK_KEY", "X_OCCI_ATTRIBUTE_KEY", 
                     "X_OCCI_LOCATION_KEY", "ACTION", "ACTIONS", "AMPERSAND", 
                     "AT", "ATTRIBUTES", "BACKSLASH", "CATEGORY", "CLASS", 
                     "COLON", "DASH", "DOT", "EQUALS", "GT", "HASH", "KIND", 
                     "LINK", "LOCATION", "LT", "MIXIN", "PERCENT", "PLUS", 
                     "QUESTION", "QUOTE", "REL", "SCHEME", "SELF", "SEMICOLON", 
                     "SLASH", "SQUOTE", "TERM", "TILDE", "TITLE", "UNDERSCORE", 
                     "LOALPHA", "UPALPHA", "DIGIT", "WS", "ESC" ].freeze
    RULE_METHODS = [ :category_key!, :link_key!, :x_occi_attribute_key!, 
                     :x_occi_location_key!, :action!, :actions!, :ampersand!, 
                     :at!, :attributes!, :backslash!, :category!, :class!, 
                     :colon!, :dash!, :dot!, :equals!, :gt!, :hash!, :kind!, 
                     :link!, :location!, :lt!, :mixin!, :percent!, :plus!, 
                     :question!, :quote!, :rel!, :scheme!, :self!, :semicolon!, 
                     :slash!, :squote!, :term!, :tilde!, :title!, :underscore!, 
                     :loalpha!, :upalpha!, :digit!, :ws!, :esc! ].freeze

    
    def initialize( input=nil, options = {} )
      super( input, options )

    end
    
    
    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule category_key! (CATEGORY_KEY)
    # (in OCCIANTLR.g)
    def category_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = CATEGORY_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 130:4: 'Category'
      match( "Category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )

    end

    # lexer rule link_key! (LINK_KEY)
    # (in OCCIANTLR.g)
    def link_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = LINK_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 132:4: 'Link'
      match( "Link" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )

    end

    # lexer rule x_occi_attribute_key! (X_OCCI_ATTRIBUTE_KEY)
    # (in OCCIANTLR.g)
    def x_occi_attribute_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = X_OCCI_ATTRIBUTE_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 134:4: 'X-OCCI-Attribute'
      match( "X-OCCI-Attribute" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )

    end

    # lexer rule x_occi_location_key! (X_OCCI_LOCATION_KEY)
    # (in OCCIANTLR.g)
    def x_occi_location_key!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = X_OCCI_LOCATION_KEY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 136:4: 'X-OCCI-Location'
      match( "X-OCCI-Location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )

    end

    # lexer rule action! (ACTION)
    # (in OCCIANTLR.g)
    def action!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      type = ACTION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 140:10: 'action'
      match( "action" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )

    end

    # lexer rule actions! (ACTIONS)
    # (in OCCIANTLR.g)
    def actions!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      type = ACTIONS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 141:11: 'actions'
      match( "actions" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )

    end

    # lexer rule ampersand! (AMPERSAND)
    # (in OCCIANTLR.g)
    def ampersand!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      type = AMPERSAND
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 143:4: '&'
      match( 0x26 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )

    end

    # lexer rule at! (AT)
    # (in OCCIANTLR.g)
    def at!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      type = AT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 144:6: '@'
      match( 0x40 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )

    end

    # lexer rule attributes! (ATTRIBUTES)
    # (in OCCIANTLR.g)
    def attributes!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      type = ATTRIBUTES
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 146:4: 'attributes'
      match( "attributes" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )

    end

    # lexer rule backslash! (BACKSLASH)
    # (in OCCIANTLR.g)
    def backslash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      type = BACKSLASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 148:4: '\\\\'
      match( 0x5c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )

    end

    # lexer rule category! (CATEGORY)
    # (in OCCIANTLR.g)
    def category!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      type = CATEGORY
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 149:11: 'category'
      match( "category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )

    end

    # lexer rule class! (CLASS)
    # (in OCCIANTLR.g)
    def class!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      type = CLASS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 150:9: 'class'
      match( "class" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )

    end

    # lexer rule colon! (COLON)
    # (in OCCIANTLR.g)
    def colon!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      type = COLON
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 151:9: ':'
      match( 0x3a )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )

    end

    # lexer rule dash! (DASH)
    # (in OCCIANTLR.g)
    def dash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      type = DASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 152:8: '-'
      match( 0x2d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )

    end

    # lexer rule dot! (DOT)
    # (in OCCIANTLR.g)
    def dot!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      type = DOT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 153:7: '.'
      match( 0x2e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )

    end

    # lexer rule equals! (EQUALS)
    # (in OCCIANTLR.g)
    def equals!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )

      type = EQUALS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 154:10: '='
      match( 0x3d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 16 )

    end

    # lexer rule gt! (GT)
    # (in OCCIANTLR.g)
    def gt!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )

      type = GT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 155:6: '>'
      match( 0x3e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 17 )

    end

    # lexer rule hash! (HASH)
    # (in OCCIANTLR.g)
    def hash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )

      type = HASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 156:8: '#'
      match( 0x23 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 18 )

    end

    # lexer rule kind! (KIND)
    # (in OCCIANTLR.g)
    def kind!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )

      type = KIND
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 157:8: 'kind'
      match( "kind" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 19 )

    end

    # lexer rule link! (LINK)
    # (in OCCIANTLR.g)
    def link!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      type = LINK
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 158:8: 'link'
      match( "link" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 20 )

    end

    # lexer rule location! (LOCATION)
    # (in OCCIANTLR.g)
    def location!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )

      type = LOCATION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 159:11: 'location'
      match( "location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 21 )

    end

    # lexer rule lt! (LT)
    # (in OCCIANTLR.g)
    def lt!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )

      type = LT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 160:6: '<'
      match( 0x3c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 22 )

    end

    # lexer rule mixin! (MIXIN)
    # (in OCCIANTLR.g)
    def mixin!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )

      type = MIXIN
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 161:9: 'mixin'
      match( "mixin" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 23 )

    end

    # lexer rule percent! (PERCENT)
    # (in OCCIANTLR.g)
    def percent!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      type = PERCENT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 162:11: '%'
      match( 0x25 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 24 )

    end

    # lexer rule plus! (PLUS)
    # (in OCCIANTLR.g)
    def plus!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      type = PLUS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 163:8: '+'
      match( 0x2b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )

    end

    # lexer rule question! (QUESTION)
    # (in OCCIANTLR.g)
    def question!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      type = QUESTION
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 164:11: '?'
      match( 0x3f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 26 )

    end

    # lexer rule quote! (QUOTE)
    # (in OCCIANTLR.g)
    def quote!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      type = QUOTE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 165:9: '\"'
      match( 0x22 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )

    end

    # lexer rule rel! (REL)
    # (in OCCIANTLR.g)
    def rel!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )

      type = REL
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 166:7: 'rel'
      match( "rel" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 28 )

    end

    # lexer rule scheme! (SCHEME)
    # (in OCCIANTLR.g)
    def scheme!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )

      type = SCHEME
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 167:10: 'scheme'
      match( "scheme" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 29 )

    end

    # lexer rule self! (SELF)
    # (in OCCIANTLR.g)
    def self!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )

      type = SELF
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 168:8: 'self'
      match( "self" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 30 )

    end

    # lexer rule semicolon! (SEMICOLON)
    # (in OCCIANTLR.g)
    def semicolon!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )

      type = SEMICOLON
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 170:4: ';'
      match( 0x3b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 31 )

    end

    # lexer rule slash! (SLASH)
    # (in OCCIANTLR.g)
    def slash!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )

      type = SLASH
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 171:9: '/'
      match( 0x2f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 32 )

    end

    # lexer rule squote! (SQUOTE)
    # (in OCCIANTLR.g)
    def squote!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )

      type = SQUOTE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 172:10: '\\''
      match( 0x27 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 33 )

    end

    # lexer rule term! (TERM)
    # (in OCCIANTLR.g)
    def term!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 34 )

      type = TERM
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 173:8: 'term'
      match( "term" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 34 )

    end

    # lexer rule tilde! (TILDE)
    # (in OCCIANTLR.g)
    def tilde!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 35 )

      type = TILDE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 174:9: '~'
      match( 0x7e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 35 )

    end

    # lexer rule title! (TITLE)
    # (in OCCIANTLR.g)
    def title!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 36 )

      type = TITLE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 175:9: 'title'
      match( "title" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 36 )

    end

    # lexer rule underscore! (UNDERSCORE)
    # (in OCCIANTLR.g)
    def underscore!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 37 )

      type = UNDERSCORE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 177:4: '_'
      match( 0x5f )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 37 )

    end

    # lexer rule loalpha! (LOALPHA)
    # (in OCCIANTLR.g)
    def loalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 38 )

      type = LOALPHA
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 179:12: ( 'a' .. 'z' )+
      # at file 179:12: ( 'a' .. 'z' )+
      match_count_1 = 0
      while true
        alt_1 = 2
        look_1_0 = @input.peek( 1 )

        if ( look_1_0.between?( 0x61, 0x7a ) )
          alt_1 = 1

        end
        case alt_1
        when 1
          # at line 179:13: 'a' .. 'z'
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
      # trace_out( __method__, 38 )

    end

    # lexer rule upalpha! (UPALPHA)
    # (in OCCIANTLR.g)
    def upalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 39 )

      type = UPALPHA
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 180:12: ( 'A' .. 'Z' )+
      # at file 180:12: ( 'A' .. 'Z' )+
      match_count_2 = 0
      while true
        alt_2 = 2
        look_2_0 = @input.peek( 1 )

        if ( look_2_0.between?( 0x41, 0x5a ) )
          alt_2 = 1

        end
        case alt_2
        when 1
          # at line 180:13: 'A' .. 'Z'
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
      # trace_out( __method__, 39 )

    end

    # lexer rule digit! (DIGIT)
    # (in OCCIANTLR.g)
    def digit!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 40 )

      type = DIGIT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 181:12: ( '0' .. '9' )+
      # at file 181:12: ( '0' .. '9' )+
      match_count_3 = 0
      while true
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0.between?( 0x30, 0x39 ) )
          alt_3 = 1

        end
        case alt_3
        when 1
          # at line 181:13: '0' .. '9'
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
      # trace_out( __method__, 40 )

    end

    # lexer rule ws! (WS)
    # (in OCCIANTLR.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 41 )

      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 182:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      # at file 182:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
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
      # trace_out( __method__, 41 )

    end

    # lexer rule esc! (ESC)
    # (in OCCIANTLR.g)
    def esc!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 42 )

      type = ESC
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 183:12: '\\\\' ( QUOTE | '\\'' )
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
      # trace_out( __method__, 42 )

    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    # 
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( CATEGORY_KEY | LINK_KEY | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | ACTION | ACTIONS | AMPERSAND | AT | ATTRIBUTES | BACKSLASH | CATEGORY | CLASS | COLON | DASH | DOT | EQUALS | GT | HASH | KIND | LINK | LOCATION | LT | MIXIN | PERCENT | PLUS | QUESTION | QUOTE | REL | SCHEME | SELF | SEMICOLON | SLASH | SQUOTE | TERM | TILDE | TITLE | UNDERSCORE | LOALPHA | UPALPHA | DIGIT | WS | ESC )
      alt_5 = 42
      alt_5 = @dfa5.predict( @input )
      case alt_5
      when 1
        # at line 1:10: CATEGORY_KEY
        category_key!

      when 2
        # at line 1:23: LINK_KEY
        link_key!

      when 3
        # at line 1:32: X_OCCI_ATTRIBUTE_KEY
        x_occi_attribute_key!

      when 4
        # at line 1:53: X_OCCI_LOCATION_KEY
        x_occi_location_key!

      when 5
        # at line 1:73: ACTION
        action!

      when 6
        # at line 1:80: ACTIONS
        actions!

      when 7
        # at line 1:88: AMPERSAND
        ampersand!

      when 8
        # at line 1:98: AT
        at!

      when 9
        # at line 1:101: ATTRIBUTES
        attributes!

      when 10
        # at line 1:112: BACKSLASH
        backslash!

      when 11
        # at line 1:122: CATEGORY
        category!

      when 12
        # at line 1:131: CLASS
        class!

      when 13
        # at line 1:137: COLON
        colon!

      when 14
        # at line 1:143: DASH
        dash!

      when 15
        # at line 1:148: DOT
        dot!

      when 16
        # at line 1:152: EQUALS
        equals!

      when 17
        # at line 1:159: GT
        gt!

      when 18
        # at line 1:162: HASH
        hash!

      when 19
        # at line 1:167: KIND
        kind!

      when 20
        # at line 1:172: LINK
        link!

      when 21
        # at line 1:177: LOCATION
        location!

      when 22
        # at line 1:186: LT
        lt!

      when 23
        # at line 1:189: MIXIN
        mixin!

      when 24
        # at line 1:195: PERCENT
        percent!

      when 25
        # at line 1:203: PLUS
        plus!

      when 26
        # at line 1:208: QUESTION
        question!

      when 27
        # at line 1:217: QUOTE
        quote!

      when 28
        # at line 1:223: REL
        rel!

      when 29
        # at line 1:227: SCHEME
        scheme!

      when 30
        # at line 1:234: SELF
        self!

      when 31
        # at line 1:239: SEMICOLON
        semicolon!

      when 32
        # at line 1:249: SLASH
        slash!

      when 33
        # at line 1:255: SQUOTE
        squote!

      when 34
        # at line 1:262: TERM
        term!

      when 35
        # at line 1:267: TILDE
        tilde!

      when 36
        # at line 1:273: TITLE
        title!

      when 37
        # at line 1:279: UNDERSCORE
        underscore!

      when 38
        # at line 1:290: LOALPHA
        loalpha!

      when 39
        # at line 1:298: UPALPHA
        upalpha!

      when 40
        # at line 1:306: DIGIT
        digit!

      when 41
        # at line 1:312: WS
        ws!

      when 42
        # at line 1:315: ESC
        esc!

      end
    end

    
    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA5 < ANTLR3::DFA
      EOT = unpack( 1, -1, 3, 32, 1, 31, 2, -1, 1, 41, 1, 31, 6, -1, 2, 
                    31, 1, -1, 1, 31, 4, -1, 2, 31, 3, -1, 1, 31, 9, -1, 
                    2, 31, 2, -1, 11, 31, 1, -1, 8, 31, 1, 76, 4, 31, 1, 
                    -1, 4, 31, 1, 86, 1, 87, 2, 31, 1, -1, 1, 31, 1, 91, 
                    1, 92, 1, 31, 1, -1, 3, 31, 1, 98, 2, -1, 1, 31, 1, 
                    100, 1, 31, 2, -1, 1, 102, 1, -1, 1, 105, 2, 31, 1, 
                    -1, 1, 31, 1, -1, 1, 109, 2, -1, 1, 112, 1, -1, 3, 31, 
                    4, -1, 1, 31, 1, 117, 1, 118, 1, 31, 2, -1, 1, 120, 
                    1, -1 )
      EOF = unpack( 121, -1 )
      MIN = unpack( 1, 9, 1, 97, 1, 105, 1, 45, 1, 99, 2, -1, 1, 34, 1, 
                    97, 6, -1, 2, 105, 1, -1, 1, 105, 4, -1, 1, 101, 1, 
                    99, 3, -1, 1, 101, 8, -1, 1, 79, 2, 116, 2, -1, 1, 116, 
                    1, 97, 2, 110, 1, 99, 1, 120, 1, 108, 1, 104, 1, 108, 
                    1, 114, 1, 116, 1, 67, 1, 105, 1, 114, 1, 101, 1, 115, 
                    1, 100, 1, 107, 1, 97, 1, 105, 1, 97, 1, 101, 1, 102, 
                    1, 109, 1, 108, 1, 67, 1, 111, 1, 105, 1, 103, 1, 115, 
                    2, 97, 1, 116, 1, 110, 1, -1, 1, 109, 2, 97, 1, 101, 
                    1, 73, 1, 110, 1, 98, 1, 111, 1, 97, 2, -1, 1, 105, 
                    1, 97, 1, 101, 2, -1, 1, 97, 1, 45, 1, 97, 1, 117, 1, 
                    114, 1, -1, 1, 111, 1, -1, 1, 97, 1, -1, 1, 65, 1, 97, 
                    1, -1, 1, 116, 1, 121, 1, 110, 4, -1, 1, 101, 2, 97, 
                    1, 115, 2, -1, 1, 97, 1, -1 )
      MAX = unpack( 1, 126, 1, 97, 1, 105, 1, 45, 1, 116, 2, -1, 1, 39, 
                    1, 108, 6, -1, 1, 105, 1, 111, 1, -1, 1, 105, 4, -1, 
                    2, 101, 3, -1, 1, 105, 8, -1, 1, 79, 2, 116, 2, -1, 
                    1, 116, 1, 97, 2, 110, 1, 99, 1, 120, 1, 108, 1, 104, 
                    1, 108, 1, 114, 1, 116, 1, 67, 1, 105, 1, 114, 1, 101, 
                    1, 115, 1, 100, 1, 107, 1, 97, 1, 105, 1, 122, 1, 101, 
                    1, 102, 1, 109, 1, 108, 1, 67, 1, 111, 1, 105, 1, 103, 
                    1, 115, 2, 122, 1, 116, 1, 110, 1, -1, 1, 109, 2, 122, 
                    1, 101, 1, 73, 1, 110, 1, 98, 1, 111, 1, 122, 2, -1, 
                    1, 105, 1, 122, 1, 101, 2, -1, 1, 122, 1, 45, 1, 122, 
                    1, 117, 1, 114, 1, -1, 1, 111, 1, -1, 1, 122, 1, -1, 
                    1, 76, 1, 122, 1, -1, 1, 116, 1, 121, 1, 110, 4, -1, 
                    1, 101, 2, 122, 1, 115, 2, -1, 1, 122, 1, -1 )
      ACCEPT = unpack( 5, -1, 1, 7, 1, 8, 2, -1, 1, 13, 1, 14, 1, 15, 1, 
                       16, 1, 17, 1, 18, 2, -1, 1, 22, 1, -1, 1, 24, 1, 
                       25, 1, 26, 1, 27, 2, -1, 1, 31, 1, 32, 1, 33, 1, 
                       -1, 1, 35, 1, 37, 1, 38, 1, 39, 1, 40, 1, 41, 1, 
                       1, 1, 2, 3, -1, 1, 42, 1, 10, 34, -1, 1, 28, 9, -1, 
                       1, 19, 1, 20, 3, -1, 1, 30, 1, 34, 5, -1, 1, 12, 
                       1, -1, 1, 23, 1, -1, 1, 36, 2, -1, 1, 5, 3, -1, 1, 
                       29, 1, 3, 1, 4, 1, 6, 4, -1, 1, 11, 1, 21, 1, -1, 
                       1, 9 )
      SPECIAL = unpack( 121, -1 )
      TRANSITION = [
        unpack( 2, 34, 1, -1, 2, 34, 18, -1, 1, 34, 1, -1, 1, 22, 1, 14, 
                1, -1, 1, 19, 1, 5, 1, 27, 3, -1, 1, 20, 1, -1, 1, 10, 1, 
                11, 1, 26, 10, 33, 1, 9, 1, 25, 1, 17, 1, 12, 1, 13, 1, 
                21, 1, 6, 2, 32, 1, 1, 8, 32, 1, 2, 11, 32, 1, 3, 2, 32, 
                1, -1, 1, 7, 2, -1, 1, 30, 1, -1, 1, 4, 1, 31, 1, 8, 7, 
                31, 1, 15, 1, 16, 1, 18, 4, 31, 1, 23, 1, 24, 1, 28, 6, 
                31, 3, -1, 1, 29 ),
        unpack( 1, 35 ),
        unpack( 1, 36 ),
        unpack( 1, 37 ),
        unpack( 1, 38, 16, -1, 1, 39 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 40, 4, -1, 1, 40 ),
        unpack( 1, 42, 10, -1, 1, 43 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 44 ),
        unpack( 1, 45, 5, -1, 1, 46 ),
        unpack(  ),
        unpack( 1, 47 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 48 ),
        unpack( 1, 49, 1, -1, 1, 50 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 51, 3, -1, 1, 52 ),
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
        unpack( 1, 55 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 56 ),
        unpack( 1, 57 ),
        unpack( 1, 58 ),
        unpack( 1, 59 ),
        unpack( 1, 60 ),
        unpack( 1, 61 ),
        unpack( 1, 62 ),
        unpack( 1, 63 ),
        unpack( 1, 64 ),
        unpack( 1, 65 ),
        unpack( 1, 66 ),
        unpack( 1, 67 ),
        unpack( 1, 68 ),
        unpack( 1, 69 ),
        unpack( 1, 70 ),
        unpack( 1, 71 ),
        unpack( 1, 72 ),
        unpack( 1, 73 ),
        unpack( 1, 74 ),
        unpack( 1, 75 ),
        unpack( 26, 31 ),
        unpack( 1, 77 ),
        unpack( 1, 78 ),
        unpack( 1, 79 ),
        unpack( 1, 80 ),
        unpack( 1, 81 ),
        unpack( 1, 82 ),
        unpack( 1, 83 ),
        unpack( 1, 84 ),
        unpack( 1, 85 ),
        unpack( 26, 31 ),
        unpack( 26, 31 ),
        unpack( 1, 88 ),
        unpack( 1, 89 ),
        unpack(  ),
        unpack( 1, 90 ),
        unpack( 26, 31 ),
        unpack( 26, 31 ),
        unpack( 1, 93 ),
        unpack( 1, 94 ),
        unpack( 1, 95 ),
        unpack( 1, 96 ),
        unpack( 1, 97 ),
        unpack( 26, 31 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 99 ),
        unpack( 26, 31 ),
        unpack( 1, 101 ),
        unpack(  ),
        unpack(  ),
        unpack( 26, 31 ),
        unpack( 1, 103 ),
        unpack( 18, 31, 1, 104, 7, 31 ),
        unpack( 1, 106 ),
        unpack( 1, 107 ),
        unpack(  ),
        unpack( 1, 108 ),
        unpack(  ),
        unpack( 26, 31 ),
        unpack(  ),
        unpack( 1, 110, 10, -1, 1, 111 ),
        unpack( 26, 31 ),
        unpack(  ),
        unpack( 1, 113 ),
        unpack( 1, 114 ),
        unpack( 1, 115 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 116 ),
        unpack( 26, 31 ),
        unpack( 26, 31 ),
        unpack( 1, 119 ),
        unpack(  ),
        unpack(  ),
        unpack( 26, 31 ),
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
          1:1: Tokens : ( CATEGORY_KEY | LINK_KEY | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | ACTION | ACTIONS | AMPERSAND | AT | ATTRIBUTES | BACKSLASH | CATEGORY | CLASS | COLON | DASH | DOT | EQUALS | GT | HASH | KIND | LINK | LOCATION | LT | MIXIN | PERCENT | PLUS | QUESTION | QUOTE | REL | SCHEME | SELF | SEMICOLON | SLASH | SQUOTE | TERM | TILDE | TITLE | UNDERSCORE | LOALPHA | UPALPHA | DIGIT | WS | ESC );
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

