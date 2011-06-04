#!/usr/bin/env ruby
#
# Occi_ruby.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: Occi_ruby.g
# Generated at: 2011-06-04 08:44:07
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
                   :T__25 => 25, :T__24 => 24, :T__23 => 23, :T__22 => 22, 
                   :DIGITS => 7, :T__21 => 21, :T__20 => 20, :TARGET_VALUE => 6, 
                   :TERM_VALUE => 4, :FLOAT => 8, :QUOTED_VALUE => 5, :EOF => -1, 
                   :URL => 9, :T__19 => 19, :T__30 => 30, :T__31 => 31, 
                   :QUOTE => 10, :T__16 => 16, :WS => 11, :T__15 => 15, 
                   :T__18 => 18, :T__17 => 17, :T__12 => 12, :T__14 => 14, 
                   :T__13 => 13 )
    
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
                     "T__30", "T__31", "URL", "DIGITS", "FLOAT", "QUOTE", 
                     "TERM_VALUE", "TARGET_VALUE", "QUOTED_VALUE", "WS" ].freeze
    RULE_METHODS = [ :t__12!, :t__13!, :t__14!, :t__15!, :t__16!, :t__17!, 
                     :t__18!, :t__19!, :t__20!, :t__21!, :t__22!, :t__23!, 
                     :t__24!, :t__25!, :t__26!, :t__27!, :t__28!, :t__29!, 
                     :t__30!, :t__31!, :url!, :digits!, :float!, :quote!, 
                     :term_value!, :target_value!, :quoted_value!, :ws! ].freeze

    
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
      # at line 9:9: ','
      match( 0x2c )

      
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
      # at line 21:9: '?action='
      match( "?action=" )

      
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
      # at line 22:9: '>'
      match( 0x3e )

      
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
      # at line 23:9: 'self'
      match( "self" )

      
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
      # at line 24:9: 'category'
      match( "category" )

      
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
      # at line 25:9: 'X-OCCI-Attribute'
      match( "X-OCCI-Attribute" )

      
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
      # at line 26:9: 'X-OCCI-Location'
      match( "X-OCCI-Location" )

      
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
      # at line 217:15: ( 'http://' | 'https://' ) ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*
      # at line 217:15: ( 'http://' | 'https://' )
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
        # at line 217:17: 'http://'
        match( "http://" )

      when 2
        # at line 217:29: 'https://'
        match( "https://" )

      end
      # at line 217:41: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*
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
      # at line 218:15: ( '0' .. '9' )*
      # at line 218:15: ( '0' .. '9' )*
      while true # decision 3
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0.between?( 0x30, 0x39 ) )
          alt_3 = 1

        end
        case alt_3
        when 1
          # at line 218:16: '0' .. '9'
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
      # at line 219:15: ( '0' .. '9' | '.' )*
      # at line 219:15: ( '0' .. '9' | '.' )*
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

    # lexer rule quote! (QUOTE)
    # (in Occi_ruby.g)
    def quote!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      type = QUOTE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 
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
      # trace_out( __method__, 24 )

    end

    # lexer rule term_value! (TERM_VALUE)
    # (in Occi_ruby.g)
    def term_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      type = TERM_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 221:15: ( 'a' .. 'z' | 'A..Z' | '0' .. '9' | '-' | '_' | '.' )*
      # at line 221:15: ( 'a' .. 'z' | 'A..Z' | '0' .. '9' | '-' | '_' | '.' )*
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
          # at line 221:16: 'a' .. 'z'
          match_range( 0x61, 0x7a )

        when 2
          # at line 221:27: 'A..Z'
          match( "A..Z" )

        when 3
          # at line 221:36: '0' .. '9'
          match_range( 0x30, 0x39 )

        when 4
          # at line 221:47: '-'
          match( 0x2d )

        when 5
          # at line 221:53: '_'
          match( 0x5f )

        when 6
          # at line 221:59: '.'
          match( 0x2e )

        else
          break # out of loop for decision 5
        end
      end # loop for decision 5

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )

    end

    # lexer rule target_value! (TARGET_VALUE)
    # (in Occi_ruby.g)
    def target_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      type = TARGET_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 222:15: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '/' | '-' | '_' )*
      # at line 222:15: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '/' | '-' | '_' )*
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
      # trace_out( __method__, 26 )

    end

    # lexer rule quoted_value! (QUOTED_VALUE)
    # (in Occi_ruby.g)
    def quoted_value!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      type = QUOTED_VALUE
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 223:15: QUOTE ( options {greedy=false; } : . )* QUOTE
      quote!
      # at line 223:21: ( options {greedy=false; } : . )*
      while true # decision 7
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == 0x22 || look_7_0 == 0x27 )
          alt_7 = 2
        elsif ( look_7_0.between?( 0x0, 0x21 ) || look_7_0.between?( 0x23, 0x26 ) || look_7_0.between?( 0x28, 0xffff ) )
          alt_7 = 1

        end
        case alt_7
        when 1
          # at line 223:49: .
          match_any

        else
          break # out of loop for decision 7
        end
      end # loop for decision 7
      quote!

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )

    end

    # lexer rule ws! (WS)
    # (in Occi_ruby.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )

      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 224:15: ( ' ' | '\\t' | '\\r' | '\\n' )
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
      # at line 1:8: ( T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | URL | DIGITS | FLOAT | QUOTE | TERM_VALUE | TARGET_VALUE | QUOTED_VALUE | WS )
      alt_8 = 28
      alt_8 = @dfa8.predict( @input )
      case alt_8
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
        # at line 1:147: QUOTE
        quote!

      when 25
        # at line 1:153: TERM_VALUE
        term_value!

      when 26
        # at line 1:164: TARGET_VALUE
        target_value!

      when 27
        # at line 1:177: QUOTED_VALUE
        quoted_value!

      when 28
        # at line 1:190: WS
        ws!

      end
    end

    
    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA8 < ANTLR3::DFA
      EOT = unpack( 1, 19, 1, 26, 3, -1, 1, 31, 1, -1, 5, 31, 1, 26, 3, 
                    -1, 1, 26, 1, 31, 1, 19, 1, -1, 1, 43, 1, 45, 1, 31, 
                    1, 26, 2, 31, 2, -1, 1, 26, 2, 31, 1, -1, 8, 31, 2, 
                    26, 1, 31, 1, -1, 1, 43, 2, -1, 1, 26, 5, 31, 1, 66, 
                    3, 31, 2, 26, 1, 31, 1, 26, 1, 31, 1, 75, 3, 31, 1, 
                    -1, 3, 31, 1, 82, 1, 26, 1, 31, 1, 26, 1, 31, 1, -1, 
                    1, 88, 1, 31, 1, 90, 3, 31, 1, -1, 1, 26, 1, -1, 1, 
                    31, 1, 26, 1, 96, 1, -1, 1, 31, 1, -1, 3, 31, 2, 26, 
                    1, -1, 3, 31, 1, 106, 1, 26, 1, 109, 1, 110, 1, 111, 
                    1, 31, 1, -1, 2, 26, 3, -1, 1, 31, 2, 26, 1, 118, 2, 
                    26, 1, -1, 9, 26, 1, 130, 1, 131, 2, -1 )
      EOF = unpack( 132, -1 )
      MIN = unpack( 1, 9, 1, 97, 3, -1, 1, 45, 1, -1, 5, 45, 1, 105, 3, 
                    -1, 3, 45, 1, -1, 1, 45, 1, 0, 1, 45, 1, 46, 2, 45, 
                    2, -1, 1, 116, 2, 45, 1, -1, 8, 45, 1, 110, 1, 79, 1, 
                    45, 1, -1, 1, 45, 2, -1, 1, 101, 9, 45, 1, 107, 1, 67, 
                    1, 45, 1, 103, 5, 45, 1, -1, 4, 45, 1, 67, 1, 45, 1, 
                    111, 1, 45, 1, -1, 6, 45, 1, -1, 1, 73, 1, -1, 1, 45, 
                    1, 114, 1, 45, 1, -1, 1, 45, 1, -1, 4, 45, 1, 121, 1, 
                    -1, 4, 45, 1, 65, 4, 45, 1, -1, 1, 116, 1, 111, 3, -1, 
                    1, 45, 1, 116, 1, 99, 1, 45, 1, 114, 1, 97, 1, -1, 1, 
                    105, 1, 116, 1, 98, 1, 105, 1, 117, 1, 111, 1, 116, 
                    1, 110, 1, 101, 2, 45, 2, -1 )
      MAX = unpack( 1, 122, 1, 97, 3, -1, 1, 122, 1, -1, 5, 122, 1, 105, 
                    3, -1, 1, 45, 2, 122, 1, -1, 1, 122, 1, -1, 1, 122, 
                    1, 46, 2, 122, 2, -1, 1, 116, 2, 122, 1, -1, 8, 122, 
                    1, 110, 1, 79, 1, 122, 1, -1, 1, 122, 2, -1, 1, 101, 
                    9, 122, 1, 107, 1, 67, 1, 122, 1, 103, 5, 122, 1, -1, 
                    4, 122, 1, 67, 1, 122, 1, 111, 1, 122, 1, -1, 6, 122, 
                    1, -1, 1, 73, 1, -1, 1, 122, 1, 114, 1, 122, 1, -1, 
                    1, 122, 1, -1, 3, 122, 1, 45, 1, 121, 1, -1, 4, 122, 
                    1, 76, 4, 122, 1, -1, 1, 116, 1, 111, 3, -1, 1, 122, 
                    1, 116, 1, 99, 1, 122, 1, 114, 1, 97, 1, -1, 1, 105, 
                    1, 116, 1, 98, 1, 105, 1, 117, 1, 111, 1, 116, 1, 110, 
                    1, 101, 2, 122, 2, -1 )
      ACCEPT = unpack( 2, -1, 1, 2, 1, 3, 1, 4, 1, -1, 1, 6, 6, -1, 1, 14, 
                       1, 15, 1, 16, 3, -1, 1, 22, 6, -1, 1, 26, 1, 28, 
                       3, -1, 1, 25, 11, -1, 1, 23, 1, -1, 1, 24, 1, 27, 
                       19, -1, 1, 9, 8, -1, 1, 17, 6, -1, 1, 13, 1, -1, 
                       1, 21, 3, -1, 1, 7, 1, -1, 1, 8, 5, -1, 1, 5, 9, 
                       -1, 1, 12, 2, -1, 1, 1, 1, 18, 1, 10, 6, -1, 1, 11, 
                       11, -1, 1, 20, 1, 19 )
      SPECIAL = unpack( 21, -1, 1, 0, 110, -1 )
      TRANSITION = [
        unpack( 2, 27, 2, -1, 1, 27, 18, -1, 1, 27, 1, -1, 1, 21, 4, -1, 
                1, 21, 4, -1, 1, 3, 1, 24, 1, 20, 1, 26, 10, 18, 1, 2, 1, 
                4, 1, 13, 1, 6, 1, 15, 1, 14, 1, -1, 1, 23, 1, 26, 1, 1, 
                8, 26, 1, 12, 11, 26, 1, 16, 2, 26, 4, -1, 1, 25, 1, -1, 
                1, 11, 1, 22, 1, 7, 4, 22, 1, 17, 3, 22, 1, 10, 5, 22, 1, 
                9, 1, 5, 1, 8, 6, 22 ),
        unpack( 1, 28 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 2, 22, 1, 29, 1, 22, 1, 30, 21, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 1, 34, 10, 22, 1, 33, 14, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 8, 22, 1, 35, 17, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 36, 21, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 14, 22, 1, 37, 11, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 2, 22, 1, 39, 16, 22, 1, 38, 6, 22 ),
        unpack( 1, 40 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 41 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 42, 6, 22 ),
        unpack( 1, 24, 1, 20, 1, 26, 10, 18, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack(  ),
        unpack( 1, 31, 1, 20, 1, -1, 10, 44, 7, -1, 1, 31, 29, -1, 1, 31, 
                 1, -1, 26, 31 ),
        unpack( 0, 46 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 31 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 47 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 7, 22, 1, 48, 18, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 11, 22, 1, 49, 14, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 1, 50, 25, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 51, 6, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 52, 6, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 11, 22, 1, 53, 14, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 2, 22, 1, 54, 23, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 55, 6, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 56, 6, 22 ),
        unpack( 1, 57 ),
        unpack( 1, 58 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 59, 6, 22 ),
        unpack(  ),
        unpack( 1, 31, 1, 20, 1, -1, 10, 44, 7, -1, 1, 31, 29, -1, 1, 31, 
                 1, -1, 26, 31 ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 60 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 61, 21, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 5, 22, 1, 62, 20, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 18, 22, 1, 63, 7, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 64, 21, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 11, 22, 1, 65, 14, 22 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 1, 67, 25, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 17, 22, 1, 68, 8, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 8, 22, 1, 69, 17, 22 ),
        unpack( 1, 70 ),
        unpack( 1, 71 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 15, 22, 1, 72, 10, 22 ),
        unpack( 1, 73 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 12, 22, 1, 74, 13, 22 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 18, 22, 1, 76, 7, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 6, 22, 1, 77, 19, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 78, 21, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 79, 6, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 8, 22, 1, 80, 17, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 14, 22, 1, 81, 11, 22 ),
        unpack( 1, 26, 1, -1, 11, 26, 7, -1, 26, 26, 4, -1, 1, 26, 1, -1, 
                 26, 26 ),
        unpack( 1, 83 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 1, 84, 6, -1, 1, 23, 25, 26, 
                 4, -1, 1, 25, 1, -1, 18, 22, 1, 85, 7, 22 ),
        unpack( 1, 86 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 87, 21, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 14, 22, 1, 89, 11, 22 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 8, 22, 1, 91, 17, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 1, 22, 1, 92, 24, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 13, 22, 1, 93, 12, 22 ),
        unpack(  ),
        unpack( 1, 94 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 1, 84, 6, -1, 1, 23, 25, 26, 
                 4, -1, 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 95 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 17, 22, 1, 97, 8, 22 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 14, 22, 1, 98, 11, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 20, 22, 1, 99, 5, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 18, 22, 1, 100, 7, 22 ),
        unpack( 1, 101 ),
        unpack( 1, 102 ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 24, 22, 1, 103, 1, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 13, 22, 1, 104, 12, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 19, 22, 1, 105, 6, 22 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 107, 10, -1, 1, 108 ),
        unpack( 1, 26, 1, -1, 11, 26, 7, -1, 26, 26, 4, -1, 1, 26, 1, -1, 
                 26, 26 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 4, 22, 1, 112, 21, 22 ),
        unpack(  ),
        unpack( 1, 113 ),
        unpack( 1, 114 ),
        unpack(  ),
        unpack(  ),
        unpack(  ),
        unpack( 1, 24, 1, -1, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 18, 22, 1, 115, 7, 22 ),
        unpack( 1, 116 ),
        unpack( 1, 117 ),
        unpack( 1, 24, 1, 31, 1, 26, 10, 32, 7, -1, 1, 23, 25, 26, 4, -1, 
                 1, 25, 1, -1, 26, 22 ),
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
        unpack( 1, 26, 1, -1, 11, 26, 7, -1, 26, 26, 4, -1, 1, 26, 1, -1, 
                 26, 26 ),
        unpack( 1, 26, 1, -1, 11, 26, 7, -1, 26, 26, 4, -1, 1, 26, 1, -1, 
                 26, 26 ),
        unpack(  ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 8
      

      def description
        <<-'__dfa_description__'.strip!
          1:1: Tokens : ( T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | URL | DIGITS | FLOAT | QUOTE | TERM_VALUE | TARGET_VALUE | QUOTED_VALUE | WS );
        __dfa_description__
      end
    end

    
    private
    
    def initialize_dfas
      super rescue nil
      @dfa8 = DFA8.new( self, 8 ) do |s|
        case s
        when 0
          look_8_21 = @input.peek
          s = -1
          if ( look_8_21.between?( 0x0, 0xffff ) )
            s = 46
          else
            s = 45
          end

        end
        
        if s < 0
          nva = ANTLR3::Error::NoViableAlternative.new( @dfa8.description, 8, s, input )
          @dfa8.error( nva )
          raise nva
        end
        
        s
      end

    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main( ARGV ) } if __FILE__ == $0
end

