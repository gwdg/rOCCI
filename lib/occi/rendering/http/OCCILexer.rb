#!/usr/bin/env ruby
#
# Occi_ruby.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: Occi_ruby.g
# Generated at: 2011-11-30 08:53:13
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


module OCCI
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all 
  # ANTLR-generated recognizers.
  const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens( :T__29 => 29, :T__28 => 28, :T__27 => 27, :T__26 => 26, 
                   :T__25 => 25, :T__24 => 24, :T__23 => 23, :ESC => 10, 
                   :T__22 => 22, :DIGITS => 8, :T__21 => 21, :T__20 => 20, 
                   :TARGET_VALUE => 6, :TERM_VALUE => 4, :FLOAT => 9, :QUOTED_VALUE => 5, 
                   :EOF => -1, :URL => 7, :T__19 => 19, :T__30 => 30, :T__31 => 31, 
                   :T__16 => 16, :WS => 11, :T__15 => 15, :T__18 => 18, 
                   :T__17 => 17, :T__12 => 12, :T__14 => 14, :T__13 => 13 )
    
  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = OCCI
    include TokenData

    
    begin
      generated_using( "Occi_ruby.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end
    
    RULE_NAMES   = [ "T__12", "T__13", "T__14", "T__15", "T__16", "T__17", 
                     "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", 
                     "T__24", "T__25", "T__26", "T__27", "T__28", "T__29", 
                     "T__30", "T__31", "URL", "DIGITS", "FLOAT", "TERM_VALUE", 
                     "TARGET_VALUE", "QUOTED_VALUE", "WS", "ESC" ].freeze
    RULE_METHODS = [ :t__12!, :t__13!, :t__14!, :t__15!, :t__16!, :t__17!, 
                     :t__18!, :t__19!, :t__20!, :t__21!, :t__22!, :t__23!, 
                     :t__24!, :t__25!, :t__26!, :t__27!, :t__28!, :t__29!, 
                     :t__30!, :t__31!, :url!, :digits!, :float!, :term_value!, 
                     :target_value!, :quoted_value!, :ws!, :esc! ].freeze

    
    def initialize( input=nil, options = {} )
      super( input, options )

    end
    
    
    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule t__12! (T__12)
    # (in Occi_ruby.g)
    def t__12!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = T__12
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 7:9: 'Category'
      match( "Category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )

    end

    # lexer rule t__13! (T__13)
    # (in Occi_ruby.g)
    def t__13!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = T__13
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 8:9: ':'
      match( 0x3a )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )

    end

    # lexer rule t__14! (T__14)
    # (in Occi_ruby.g)
    def t__14!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = T__14
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 9:9: ';,'
      match( ";," )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )

    end

    # lexer rule t__15! (T__15)
    # (in Occi_ruby.g)
    def t__15!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = T__15
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 10:9: ';'
      match( 0x3b )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )

    end

    # lexer rule t__16! (T__16)
    # (in Occi_ruby.g)
    def t__16!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      type = T__16
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 11:9: 'scheme'
      match( "scheme" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )

    end

    # lexer rule t__17! (T__17)
    # (in Occi_ruby.g)
    def t__17!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      type = T__17
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 12:9: '='
      match( 0x3d )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )

    end

    # lexer rule t__18! (T__18)
    # (in Occi_ruby.g)
    def t__18!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      type = T__18
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 13:9: 'class'
      match( "class" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )

    end

    # lexer rule t__19! (T__19)
    # (in Occi_ruby.g)
    def t__19!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      type = T__19
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 14:9: 'title'
      match( "title" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )

    end

    # lexer rule t__20! (T__20)
    # (in Occi_ruby.g)
    def t__20!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      type = T__20
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 15:9: 'rel'
      match( "rel" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )

    end

    # lexer rule t__21! (T__21)
    # (in Occi_ruby.g)
    def t__21!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      type = T__21
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 16:9: 'location'
      match( "location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )

    end

    # lexer rule t__22! (T__22)
    # (in Occi_ruby.g)
    def t__22!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      type = T__22
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 17:9: 'attributes'
      match( "attributes" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )

    end

    # lexer rule t__23! (T__23)
    # (in Occi_ruby.g)
    def t__23!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      type = T__23
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 18:9: 'actions'
      match( "actions" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )

    end

    # lexer rule t__24! (T__24)
    # (in Occi_ruby.g)
    def t__24!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      type = T__24
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 19:9: 'Link'
      match( "Link" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )

    end

    # lexer rule t__25! (T__25)
    # (in Occi_ruby.g)
    def t__25!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      type = T__25
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 20:9: '<'
      match( 0x3c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )

    end

    # lexer rule t__26! (T__26)
    # (in Occi_ruby.g)
    def t__26!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      type = T__26
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 21:9: '>'
      match( 0x3e )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )

    end

    # lexer rule t__27! (T__27)
    # (in Occi_ruby.g)
    def t__27!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )

      type = T__27
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 22:9: 'self'
      match( "self" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 16 )

    end

    # lexer rule t__28! (T__28)
    # (in Occi_ruby.g)
    def t__28!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )

      type = T__28
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 23:9: 'category'
      match( "category" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 17 )

    end

    # lexer rule t__29! (T__29)
    # (in Occi_ruby.g)
    def t__29!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )

      type = T__29
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 24:9: 'X-OCCI-Attribute'
      match( "X-OCCI-Attribute" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 18 )

    end

    # lexer rule t__30! (T__30)
    # (in Occi_ruby.g)
    def t__30!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )

      type = T__30
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 25:9: 'X-OCCI-Location'
      match( "X-OCCI-Location" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 19 )

    end

    # lexer rule t__31! (T__31)
    # (in Occi_ruby.g)
    def t__31!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      type = T__31
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 26:9: ','
      match( 0x2c )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 20 )

    end

    # lexer rule url! (URL)
    # (in Occi_ruby.g)
    def url!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )

      type = URL
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 223:15: ( 'http://' | 'https://' ) ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*
      # at line 223:15: ( 'http://' | 'https://' )
      alt_1 = 2
      look_1_0 = @input.peek( 1 )

      if ( look_1_0 == 0x68 )
        look_1_1 = @input.peek( 2 )

        if ( look_1_1 == 0x74 )
          look_1_2 = @input.peek( 3 )

          if ( look_1_2 == 0x74 )
            look_1_3 = @input.peek( 4 )

            if ( look_1_3 == 0x70 )
              look_1_4 = @input.peek( 5 )

              if ( look_1_4 == 0x3a )
                alt_1 = 1
              elsif ( look_1_4 == 0x73 )
                alt_1 = 2
              else
                raise NoViableAlternative( "", 1, 4 )
              end
            else
              raise NoViableAlternative( "", 1, 3 )
            end
          else
            raise NoViableAlternative( "", 1, 2 )
          end
        else
          raise NoViableAlternative( "", 1, 1 )
        end
      else
        raise NoViableAlternative( "", 1, 0 )
      end
      case alt_1
      when 1
        # at line 223:17: 'http://'
        match( "http://" )

      when 2
        # at line 223:29: 'https://'
        match( "https://" )

      end
      # at line 223:41: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*
      while true # decision 2
        alt_2 = 2
        look_2_0 = @input.peek( 1 )

        if ( look_2_0 == 0x23 || look_2_0.between?( 0x25, 0x26 ) || look_2_0 == 0x2b || look_2_0.between?( 0x2d, 0x3a ) || look_2_0 == 0x3d || look_2_0.between?( 0x3f, 0x5a ) || look_2_0 == 0x5c || look_2_0 == 0x5f || look_2_0.between?( 0x61, 0x7a ) || look_2_0 == 0x7e )
          alt_2 = 1

        end
        case alt_2
        when 1
          # at line 
          if @input.peek(1) == 0x23 || @input.peek( 1 ).between?( 0x25, 0x26 ) || @input.peek(1) == 0x2b || @input.peek( 1 ).between?( 0x2d, 0x3a ) || @input.peek(1) == 0x3d || @input.peek( 1 ).between?( 0x3f, 0x5a ) || @input.peek(1) == 0x5c || @input.peek(1) == 0x5f || @input.peek( 1 ).between?( 0x61, 0x7a ) || @input.peek(1) == 0x7e
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 2
        end
      end # loop for decision 2

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 21 )

    end

    # lexer rule digits! (DIGITS)
    # (in Occi_ruby.g)
    def digits!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )

      type = DIGITS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 224:15: ( '0' .. '9' )*
      # at line 224:15: ( '0' .. '9' )*
      while true # decision 3
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0.between?( 0x30, 0x39 ) )
          alt_3 = 1

        end
        case alt_3
        when 1
          # at line 224:16: '0' .. '9'
          match_range( 0x30, 0x39 )

        else
          break # out of loop for decision 3
        end
      end # loop for decision 3

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 22 )

    end

    # lexer rule float! (FLOAT)
    # (in Occi_ruby.g)
    def float!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )

      type = FLOAT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 225:15: ( '0' .. '9' | '.' )*
      # at line 225:15: ( '0' .. '9' | '.' )*
      while true # decision 4
        alt_4 = 2
        look_4_0 = @input.peek( 1 )

        if ( look_4_0 == 0x2e || look_4_0.between?( 0x30, 0x39 ) )
          alt_4 = 1

        end
        case alt_4
        when 1
          # at line 
          if @input.peek(1) == 0x2e || @input.peek( 1 ).between?( 0x30, 0x39 )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 4
        end
      end # loop for decision 4

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 23 )

    end

    # lexer rule term_value! (TERM_VALUE)
    # (in Occi_ruby.g)
    def term_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      type = TERM_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 226:15: ( 'a' .. 'z' | 'A..Z' | '0' .. '9' | '-' | '_' | '.' )*
      # at line 226:15: ( 'a' .. 'z' | 'A..Z' | '0' .. '9' | '-' | '_' | '.' )*
      while true # decision 5
        alt_5 = 7
        case look_5 = @input.peek( 1 )
        when 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a then alt_5 = 1
        when 0x41 then alt_5 = 2
        when 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 then alt_5 = 3
        when 0x2d then alt_5 = 4
        when 0x5f then alt_5 = 5
        when 0x2e then alt_5 = 6
        end
        case alt_5
        when 1
          # at line 226:16: 'a' .. 'z'
          match_range( 0x61, 0x7a )

        when 2
          # at line 226:27: 'A..Z'
          match( "A..Z" )

        when 3
          # at line 226:36: '0' .. '9'
          match_range( 0x30, 0x39 )

        when 4
          # at line 226:47: '-'
          match( 0x2d )

        when 5
          # at line 226:53: '_'
          match( 0x5f )

        when 6
          # at line 226:59: '.'
          match( 0x2e )

        else
          break # out of loop for decision 5
        end
      end # loop for decision 5

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 24 )

    end

    # lexer rule target_value! (TARGET_VALUE)
    # (in Occi_ruby.g)
    def target_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      type = TARGET_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 227:15: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '/' | '-' | '_' )*
      # at line 227:15: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '/' | '-' | '_' )*
      while true # decision 6
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == 0x2d || look_6_0.between?( 0x2f, 0x39 ) || look_6_0.between?( 0x41, 0x5a ) || look_6_0 == 0x5f || look_6_0.between?( 0x61, 0x7a ) )
          alt_6 = 1

        end
        case alt_6
        when 1
          # at line 
          if @input.peek(1) == 0x2d || @input.peek( 1 ).between?( 0x2f, 0x39 ) || @input.peek( 1 ).between?( 0x41, 0x5a ) || @input.peek(1) == 0x5f || @input.peek( 1 ).between?( 0x61, 0x7a )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 6
        end
      end # loop for decision 6

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )

    end

    # lexer rule quoted_value! (QUOTED_VALUE)
    # (in Occi_ruby.g)
    def quoted_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      type = QUOTED_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 228:15: '\"' ( ESC | ~ ( '\\\\' | '\"' ) )* '\"'
      match( 0x22 )
      # at line 228:19: ( ESC | ~ ( '\\\\' | '\"' ) )*
      while true # decision 7
        alt_7 = 3
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == 0x5c )
          alt_7 = 1
        elsif ( look_7_0.between?( 0x0, 0x21 ) || look_7_0.between?( 0x23, 0x5b ) || look_7_0.between?( 0x5d, 0xffff ) )
          alt_7 = 2

        end
        case alt_7
        when 1
          # at line 228:20: ESC
          esc!

        when 2
          # at line 228:26: ~ ( '\\\\' | '\"' )
          if @input.peek( 1 ).between?( 0x0, 0x21 ) || @input.peek( 1 ).between?( 0x23, 0x5b ) || @input.peek( 1 ).between?( 0x5d, 0xff )
            @input.consume
          else
            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 7
        end
      end # loop for decision 7
      match( 0x22 )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 26 )

    end

    # lexer rule ws! (WS)
    # (in Occi_ruby.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 229:15: ( ' ' | '\\t' | '\\r' | '\\n' )
      if @input.peek( 1 ).between?( 0x9, 0xa ) || @input.peek(1) == 0xd || @input.peek(1) == 0x20
        @input.consume
      else
        mse = MismatchedSet( nil )
        recover mse
        raise mse
      end


      # --> action
      channel=HIDDEN;
      # <-- action

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )

    end

    # lexer rule esc! (ESC)
    # (in Occi_ruby.g)
    def esc!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )

      type = ESC
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 232:10: '\\\\' ( '\"' )*
      match( 0x5c )
      # at line 232:15: ( '\"' )*
      while true # decision 8
        alt_8 = 2
        look_8_0 = @input.peek( 1 )

        if ( look_8_0 == 0x22 )
          alt_8 = 1

        end
        case alt_8
        when 1
          # at line 232:16: '\"'
          match( 0x22 )

        else
          break # out of loop for decision 8
        end
      end # loop for decision 8

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 28 )

    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    # 
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | URL | DIGITS | FLOAT | TERM_VALUE | TARGET_VALUE | QUOTED_VALUE | WS | ESC )
      alt_9 = 28
      alt_9 = @dfa9.predict( @input )
      case alt_9
      when 1
        # at line 1:10: T__12
        t__12!

      when 2
        # at line 1:16: T__13
        t__13!

      when 3
        # at line 1:22: T__14
        t__14!

      when 4
        # at line 1:28: T__15
        t__15!

      when 5
        # at line 1:34: T__16
        t__16!

      when 6
        # at line 1:40: T__17
        t__17!

      when 7
        # at line 1:46: T__18
        t__18!

      when 8
        # at line 1:52: T__19
        t__19!

      when 9
        # at line 1:58: T__20
        t__20!

      when 10
        # at line 1:64: T__21
        t__21!

      when 11
        # at line 1:70: T__22
        t__22!

      when 12
        # at line 1:76: T__23
        t__23!

      when 13
        # at line 1:82: T__24
        t__24!

      when 14
        # at line 1:88: T__25
        t__25!

      when 15
        # at line 1:94: T__26
        t__26!

      when 16
        # at line 1:100: T__27
        t__27!

      when 17
        # at line 1:106: T__28
        t__28!

      when 18
        # at line 1:112: T__29
        t__29!

      when 19
        # at line 1:118: T__30
        t__30!

      when 20
        # at line 1:124: T__31
        t__31!

      when 21
        # at line 1:130: URL
        url!

      when 22
        # at line 1:134: DIGITS
        digits!

      when 23
        # at line 1:141: FLOAT
        float!

      when 24
        # at line 1:147: TERM_VALUE
        term_value!

      when 25
        # at line 1:158: TARGET_VALUE
        target_value!

      when 26
        # at line 1:171: QUOTED_VALUE
        quoted_value!

      when 27
        # at line 1:184: WS
        ws!

      when 28
        # at line 1:187: ESC
        esc!

      end
    end

    
    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA9 < ANTLR3::DFA
      EOT = unpack( 1, 18, 1, 24, 1, -1, 1, 30, 1, 33, 1, -1, 5, 33, 1, 
                    24, 2, -1, 1, 24, 1, -1, 1, 33, 1, 18, 1, -1, 1, 45, 
                    1, 33, 1, 24, 2, 33, 4, -1, 1, 24, 2, -1, 2, 33, 1, 
                    -1, 8, 33, 2, 24, 1, 33, 1, -1, 1, 45, 1, 24, 5, 33, 
                    1, 66, 3, 33, 2, 24, 1, 33, 1, 24, 1, 33, 1, 75, 3, 
                    33, 1, -1, 3, 33, 1, 82, 1, 24, 1, 33, 1, 24, 1, 33, 
                    1, -1, 1, 88, 1, 33, 1, 90, 3, 33, 1, -1, 1, 24, 1, 
                    -1, 1, 33, 1, 24, 1, 96, 1, -1, 1, 33, 1, -1, 3, 33, 
                    2, 24, 1, -1, 3, 33, 1, 106, 1, 24, 1, 109, 1, 110, 
                    1, 111, 1, 33, 1, -1, 2, 24, 3, -1, 1, 33, 2, 24, 1, 
                    118, 2, 24, 1, -1, 9, 24, 1, 130, 1, 131, 2, -1 )
      EOF = unpack( 132, -1 )
      MIN = unpack( 1, 9, 1, 97, 1, -1, 1, 44, 1, 45, 1, -1, 5, 45, 1, 105, 
                    2, -1, 1, 45, 1, -1, 2, 45, 1, -1, 2, 45, 1, 46, 2, 
                    45, 4, -1, 1, 116, 2, -1, 2, 45, 1, -1, 8, 45, 1, 110, 
                    1, 79, 1, 45, 1, -1, 1, 45, 1, 101, 9, 45, 1, 107, 1, 
                    67, 1, 45, 1, 103, 5, 45, 1, -1, 4, 45, 1, 67, 1, 45, 
                    1, 111, 1, 45, 1, -1, 6, 45, 1, -1, 1, 73, 1, -1, 1, 
                    45, 1, 114, 1, 45, 1, -1, 1, 45, 1, -1, 4, 45, 1, 121, 
                    1, -1, 4, 45, 1, 65, 4, 45, 1, -1, 1, 116, 1, 111, 3, 
                    -1, 1, 45, 1, 116, 1, 99, 1, 45, 1, 114, 1, 97, 1, -1, 
                    1, 105, 1, 116, 1, 98, 1, 105, 1, 117, 1, 111, 1, 116, 
                    1, 110, 1, 101, 2, 45, 2, -1 )
      MAX = unpack( 1, 122, 1, 97, 1, -1, 1, 44, 1, 122, 1, -1, 5, 122, 
                    1, 105, 2, -1, 1, 45, 1, -1, 2, 122, 1, -1, 2, 122, 
                    1, 46, 2, 122, 4, -1, 1, 116, 2, -1, 2, 122, 1, -1, 
                    8, 122, 1, 110, 1, 79, 1, 122, 1, -1, 1, 122, 1, 101, 
                    9, 122, 1, 107, 1, 67, 1, 122, 1, 103, 5, 122, 1, -1, 
                    4, 122, 1, 67, 1, 122, 1, 111, 1, 122, 1, -1, 6, 122, 
                    1, -1, 1, 73, 1, -1, 1, 122, 1, 114, 1, 122, 1, -1, 
                    1, 122, 1, -1, 3, 122, 1, 45, 1, 121, 1, -1, 4, 122, 
                    1, 76, 4, 122, 1, -1, 1, 116, 1, 111, 3, -1, 1, 122, 
                    1, 116, 1, 99, 1, 122, 1, 114, 1, 97, 1, -1, 1, 105, 
                    1, 116, 1, 98, 1, 105, 1, 117, 1, 111, 1, 116, 1, 110, 
                    1, 101, 2, 122, 2, -1 )
      ACCEPT = unpack( 2, -1, 1, 2, 2, -1, 1, 6, 6, -1, 1, 14, 1, 15, 1, 
                       -1, 1, 20, 2, -1, 1, 22, 5, -1, 1, 25, 1, 26, 1, 
                       27, 1, 28, 1, -1, 1, 3, 1, 4, 2, -1, 1, 24, 11, -1, 
                       1, 23, 20, -1, 1, 9, 8, -1, 1, 16, 6, -1, 1, 13, 
                       1, -1, 1, 21, 3, -1, 1, 7, 1, -1, 1, 8, 5, -1, 1, 
                       5, 9, -1, 1, 12, 2, -1, 1, 1, 1, 17, 1, 10, 6, -1, 
                       1, 11, 11, -1, 1, 19, 1, 18 )
      SPECIAL = unpack( 132, -1 )
      TRANSITION = [
        unpack( 2, 26, 2, -1, 1, 26, 18, -1, 1, 26, 1, -1, 1, 25, 9, -1, 
                1, 15, 1, 22, 1, 19, 1, 24, 10, 17, 1, 2, 1, 3, 1, 12, 1, 
                5, 1, 13, 2, -1, 1, 21, 1, 24, 1, 1, 8, 24, 1, 11, 11, 24, 
                1, 14, 2, 24, 1, -1, 1, 27, 2, -1, 1, 23, 1, -1, 1, 10, 
                1, 20, 1, 6, 4, 20, 1, 16, 3, 20, 1, 9, 5, 20, 1, 8, 1, 
                4, 1, 7, 6, 20 ),
        unpack( 1, 28 ),
        unpack(  ),
        unpack( 1, 29 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 2, 20, 1, 31, 1, 20, 1, 32, 21, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 1, 36, 10, 20, 1, 35, 14, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 8, 20, 1, 37, 17, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 38, 21, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 14, 20, 1, 39, 11, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 2, 20, 1, 41, 16, 20, 1, 40, 6, 20 ),
        unpack( 1, 42 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 43 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 44, 6, 20 ),
        unpack( 1, 22, 1, 19, 1, 24, 10, 17, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack(  ),
        unpack( 1, 33, 1, 19, 1, -1, 10, 46, 7, -1, 1, 33, 29, -1, 1, 33, 
                 1, -1, 26, 33 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 33 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 47 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 7, 20, 1, 48, 18, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 11, 20, 1, 49, 14, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 1, 50, 25, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 51, 6, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 52, 6, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 11, 20, 1, 53, 14, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 2, 20, 1, 54, 23, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 55, 6, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 56, 6, 20 ),
        unpack( 1, 57 ),
        unpack( 1, 58 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 59, 6, 20 ),
        unpack(  ),
        unpack( 1, 33, 1, 19, 1, -1, 10, 46, 7, -1, 1, 33, 29, -1, 1, 33, 
                 1, -1, 26, 33 ),
        unpack( 1, 60 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 61, 21, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 5, 20, 1, 62, 20, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 18, 20, 1, 63, 7, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 64, 21, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 11, 20, 1, 65, 14, 20 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 1, 67, 25, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 17, 20, 1, 68, 8, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 8, 20, 1, 69, 17, 20 ),
        unpack( 1, 70 ),
        unpack( 1, 71 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 15, 20, 1, 72, 10, 20 ),
        unpack( 1, 73 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 12, 20, 1, 74, 13, 20 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 18, 20, 1, 76, 7, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 6, 20, 1, 77, 19, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 78, 21, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 79, 6, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 8, 20, 1, 80, 17, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 14, 20, 1, 81, 11, 20 ),
        unpack( 1, 24, 1, -1, 11, 24, 7, -1, 26, 24, 4, -1, 1, 24, 1, -1, 
                 26, 24 ),
        unpack( 1, 83 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 1, 84, 6, -1, 1, 21, 25, 24, 
                 4, -1, 1, 23, 1, -1, 18, 20, 1, 85, 7, 20 ),
        unpack( 1, 86 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 87, 21, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 14, 20, 1, 89, 11, 20 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 8, 20, 1, 91, 17, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 1, 20, 1, 92, 24, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 13, 20, 1, 93, 12, 20 ),
        unpack(  ),
        unpack( 1, 94 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 1, 84, 6, -1, 1, 21, 25, 24, 
                 4, -1, 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 95 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 17, 20, 1, 97, 8, 20 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 14, 20, 1, 98, 11, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 20, 20, 1, 99, 5, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 18, 20, 1, 100, 7, 20 ),
        unpack( 1, 101 ),
        unpack( 1, 102 ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 24, 20, 1, 103, 1, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 13, 20, 1, 104, 12, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 19, 20, 1, 105, 6, 20 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 107, 10, -1, 1, 108 ),
        unpack( 1, 24, 1, -1, 11, 24, 7, -1, 26, 24, 4, -1, 1, 24, 1, -1, 
                 26, 24 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 4, 20, 1, 112, 21, 20 ),
        unpack(  ),
        unpack( 1, 113 ),
        unpack( 1, 114 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 22, 1, -1, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 18, 20, 1, 115, 7, 20 ),
        unpack( 1, 116 ),
        unpack( 1, 117 ),
        unpack( 1, 22, 1, 33, 1, 24, 10, 34, 7, -1, 1, 21, 25, 24, 4, -1, 
                 1, 23, 1, -1, 26, 20 ),
        unpack( 1, 119 ),
        unpack( 1, 120 ),
        unpack(  ),
        unpack( 1, 121 ),
        unpack( 1, 122 ),
        unpack( 1, 123 ),
        unpack( 1, 124 ),
        unpack( 1, 125 ),
        unpack( 1, 126 ),
        unpack( 1, 127 ),
        unpack( 1, 128 ),
        unpack( 1, 129 ),
        unpack( 1, 24, 1, -1, 11, 24, 7, -1, 26, 24, 4, -1, 1, 24, 1, -1, 
                 26, 24 ),
        unpack( 1, 24, 1, -1, 11, 24, 7, -1, 26, 24, 4, -1, 1, 24, 1, -1, 
                 26, 24 ),
        unpack(  ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 9
      

      def description
        <<-'__dfa_description__'.strip!
          1:1: Tokens : ( T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | URL | DIGITS | FLOAT | TERM_VALUE | TARGET_VALUE | QUOTED_VALUE | WS | ESC );
        __dfa_description__
      end
    end

    
    private
    
    def initialize_dfas
      super rescue nil
      @dfa9 = DFA9.new( self, 9 )

    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main( ARGV ) } if __FILE__ == $0
end

