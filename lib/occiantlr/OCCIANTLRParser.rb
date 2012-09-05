#!/usr/bin/env ruby
#
# OCCIANTLR.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: OCCIANTLR.g
# Generated at: 2012-09-05 21:22:48
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

# - - - - - - begin action @parser::header - - - - - -
# OCCIANTLR.g

 
	require 'uri' 
	require 'hashie'
	ATTRIBUTE = { :mutable => true, :required => false, :type => "string" }

# - - - - - - end action @parser::header - - - - - - -


module OCCIANTLR
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all 
  # ANTLR-generated recognizers.
  const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens( :TERM => 45, :CLASS => 11, :LT => 18, :ATTRIBUTES => 15, 
                   :ESC => 42, :EQUALS => 9, :EOF => -1, :ACTION => 41, 
                   :ACTIONS => 16, :LBRACKET => 46, :AT => 27, :QUOTE => 10, 
                   :T__51 => 51, :SLASH => 37, :T__52 => 52, :TILDE => 33, 
                   :PLUS => 31, :DIGIT => 26, :RBRACKET => 47, :LOALPHA => 24, 
                   :DOT => 32, :T__50 => 50, :X_OCCI_ATTRIBUTE_KEY => 22, 
                   :PERCENT => 28, :DASH => 38, :T__48 => 48, :T__49 => 49, 
                   :HASH => 34, :AMPERSAND => 36, :CATEGORY => 21, :UNDERSCORE => 29, 
                   :REL => 13, :SEMICOLON => 6, :CATEGORY_KEY => 4, :LINK => 44, 
                   :SQUOTE => 43, :KIND => 39, :SCHEME => 8, :COLON => 5, 
                   :MIXIN => 40, :WS => 7, :QUESTION => 35, :UPALPHA => 25, 
                   :LINK_KEY => 17, :LOCATION => 14, :GT => 19, :X_OCCI_LOCATION_KEY => 23, 
                   :SELF => 20, :TITLE => 12, :BACKSLASH => 30 )

    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names( "CATEGORY_KEY", "COLON", "SEMICOLON", "WS", "SCHEME", 
                    "EQUALS", "QUOTE", "CLASS", "TITLE", "REL", "LOCATION", 
                    "ATTRIBUTES", "ACTIONS", "LINK_KEY", "LT", "GT", "SELF", 
                    "CATEGORY", "X_OCCI_ATTRIBUTE_KEY", "X_OCCI_LOCATION_KEY", 
                    "LOALPHA", "UPALPHA", "DIGIT", "AT", "PERCENT", "UNDERSCORE", 
                    "BACKSLASH", "PLUS", "DOT", "TILDE", "HASH", "QUESTION", 
                    "AMPERSAND", "SLASH", "DASH", "KIND", "MIXIN", "ACTION", 
                    "ESC", "SQUOTE", "LINK", "TERM", "LBRACKET", "RBRACKET", 
                    "'{'", "'mutable'", "'immutable'", "'required'", "'}'" )
    
  end


  class Parser < ANTLR3::Parser
    @grammar_home = OCCIANTLR

    RULE_METHODS = [ :category, :category_value, :category_term, :category_scheme, 
                     :category_class, :category_title, :category_rel, :category_location, 
                     :category_attributes, :category_actions, :link, :link_value, 
                     :link_target, :link_rel, :link_self, :link_category, 
                     :link_attributes, :x_occi_attribute, :x_occi_location, 
                     :uri, :term, :scheme, :class_type, :title, :attribute, 
                     :attribute_name, :attribute_component, :attribute_value, 
                     :string, :number, :reserved_words, :quoted_string, 
                     :digits ].freeze


    include TokenData

    begin
      generated_using( "OCCIANTLR.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end

    def initialize( input, options = {} )
      super( input, options )


    end
    # - - - - - - - - - - - - Rules - - - - - - - - - - - - -

    # 
    # parser rule category
    # 
    # (in OCCIANTLR.g)
    # 25:1: category returns [hash] : CATEGORY_KEY COLON category_value ;
    # 
    def category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )
      hash = nil
      category_value1 = nil

      begin
        # at line 26:4: CATEGORY_KEY COLON category_value
        match( CATEGORY_KEY, TOKENS_FOLLOWING_CATEGORY_KEY_IN_category_39 )
        match( COLON, TOKENS_FOLLOWING_COLON_IN_category_41 )
        @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_43 )
        category_value1 = category_value
        @state.following.pop
        # --> action
         hash = category_value1 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 1 )

      end
      
      return hash
    end


    # 
    # parser rule category_value
    # 
    # (in OCCIANTLR.g)
    # 27:3: category_value returns [hash] : category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( SEMICOLON )? ;
    # 
    def category_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )
      hash = nil
      category_class2 = nil
      category_term3 = nil
      category_scheme4 = nil
      category_title5 = nil
      category_rel6 = nil
      category_location7 = nil
      category_attributes8 = nil
      category_actions9 = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new( {:kinds=>[],:mixins=>[],:actions=>[] } ) 

      begin
        # at line 29:15: category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( SEMICOLON )?
        @state.following.push( TOKENS_FOLLOWING_category_term_IN_category_value_75 )
        category_term3 = category_term
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_category_scheme_IN_category_value_77 )
        category_scheme4 = category_scheme
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_category_class_IN_category_value_79 )
        category_class2 = category_class
        @state.following.pop
        # at line 29:60: ( category_title )?
        alt_1 = 2
        look_1_0 = @input.peek( 1 )

        if ( look_1_0 == SEMICOLON )
          look_1_1 = @input.peek( 2 )

          if ( look_1_1 == WS )
            look_1_3 = @input.peek( 3 )

            if ( look_1_3 == TITLE )
              alt_1 = 1
            end
          elsif ( look_1_1 == TITLE )
            alt_1 = 1
          end
        end
        case alt_1
        when 1
          # at line 29:60: category_title
          @state.following.push( TOKENS_FOLLOWING_category_title_IN_category_value_81 )
          category_title5 = category_title
          @state.following.pop

        end
        # at line 29:76: ( category_rel )?
        alt_2 = 2
        look_2_0 = @input.peek( 1 )

        if ( look_2_0 == SEMICOLON )
          look_2_1 = @input.peek( 2 )

          if ( look_2_1 == WS )
            look_2_3 = @input.peek( 3 )

            if ( look_2_3 == REL )
              alt_2 = 1
            end
          elsif ( look_2_1 == REL )
            alt_2 = 1
          end
        end
        case alt_2
        when 1
          # at line 29:76: category_rel
          @state.following.push( TOKENS_FOLLOWING_category_rel_IN_category_value_84 )
          category_rel6 = category_rel
          @state.following.pop

        end
        # at line 29:90: ( category_location )?
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0 == SEMICOLON )
          look_3_1 = @input.peek( 2 )

          if ( look_3_1 == WS )
            look_3_3 = @input.peek( 3 )

            if ( look_3_3 == LOCATION )
              alt_3 = 1
            end
          elsif ( look_3_1 == LOCATION )
            alt_3 = 1
          end
        end
        case alt_3
        when 1
          # at line 29:90: category_location
          @state.following.push( TOKENS_FOLLOWING_category_location_IN_category_value_87 )
          category_location7 = category_location
          @state.following.pop

        end
        # at line 29:109: ( category_attributes )?
        alt_4 = 2
        look_4_0 = @input.peek( 1 )

        if ( look_4_0 == SEMICOLON )
          look_4_1 = @input.peek( 2 )

          if ( look_4_1 == WS )
            look_4_3 = @input.peek( 3 )

            if ( look_4_3 == ATTRIBUTES )
              alt_4 = 1
            end
          elsif ( look_4_1 == ATTRIBUTES )
            alt_4 = 1
          end
        end
        case alt_4
        when 1
          # at line 29:109: category_attributes
          @state.following.push( TOKENS_FOLLOWING_category_attributes_IN_category_value_90 )
          category_attributes8 = category_attributes
          @state.following.pop

        end
        # at line 29:130: ( category_actions )?
        alt_5 = 2
        look_5_0 = @input.peek( 1 )

        if ( look_5_0 == SEMICOLON )
          look_5_1 = @input.peek( 2 )

          if ( look_5_1 == WS || look_5_1 == ACTIONS )
            alt_5 = 1
          end
        end
        case alt_5
        when 1
          # at line 29:130: category_actions
          @state.following.push( TOKENS_FOLLOWING_category_actions_IN_category_value_93 )
          category_actions9 = category_actions
          @state.following.pop

        end
        # at line 29:148: ( SEMICOLON )?
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == SEMICOLON )
          alt_6 = 1
        end
        case alt_6
        when 1
          # at line 29:148: SEMICOLON
          match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_value_96 )

        end
        # --> action
         type = category_class2
        	               cat = Hashie::Mash.new
        	               cat.term 		= category_term3
        	               cat.scheme 		= category_scheme4
        	               cat.title		= category_title5
        	               cat.related		= category_rel6
        	               cat.location		= category_location7
        	               cat.attributes		= category_attributes8
        	               cat.actions		= category_actions9
        	               hash[(type+'s').to_sym] 	<< cat
        	             
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 2 )

      end
      
      return hash
    end


    # 
    # parser rule category_term
    # 
    # (in OCCIANTLR.g)
    # 41:3: category_term returns [value] : ( WS )? term ;
    # 
    def category_term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )
      value = nil
      term10 = nil

      begin
        # at line 41:37: ( WS )? term
        # at line 41:37: ( WS )?
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == WS )
          alt_7 = 1
        end
        case alt_7
        when 1
          # at line 41:37: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_term_128 )

        end
        @state.following.push( TOKENS_FOLLOWING_term_IN_category_term_131 )
        term10 = term
        @state.following.pop
        # --> action
         value = ( term10 && @input.to_s( term10.start, term10.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 3 )

      end
      
      return value
    end


    # 
    # parser rule category_scheme
    # 
    # (in OCCIANTLR.g)
    # 43:3: category_scheme returns [value] : SEMICOLON ( WS )? SCHEME EQUALS QUOTE scheme QUOTE ;
    # 
    def category_scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )
      value = nil
      scheme11 = nil

      begin
        # at line 43:37: SEMICOLON ( WS )? SCHEME EQUALS QUOTE scheme QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_scheme_157 )
        # at line 43:47: ( WS )?
        alt_8 = 2
        look_8_0 = @input.peek( 1 )

        if ( look_8_0 == WS )
          alt_8 = 1
        end
        case alt_8
        when 1
          # at line 43:47: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_scheme_159 )

        end
        match( SCHEME, TOKENS_FOLLOWING_SCHEME_IN_category_scheme_162 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_scheme_164 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_scheme_166 )
        @state.following.push( TOKENS_FOLLOWING_scheme_IN_category_scheme_168 )
        scheme11 = scheme
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_scheme_170 )
        # --> action
         value = ( scheme11 && @input.to_s( scheme11.start, scheme11.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 4 )

      end
      
      return value
    end


    # 
    # parser rule category_class
    # 
    # (in OCCIANTLR.g)
    # 45:3: category_class returns [value] : SEMICOLON ( WS )? CLASS EQUALS QUOTE class_type QUOTE ;
    # 
    def category_class
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )
      value = nil
      class_type12 = nil

      begin
        # at line 45:37: SEMICOLON ( WS )? CLASS EQUALS QUOTE class_type QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_class_199 )
        # at line 45:47: ( WS )?
        alt_9 = 2
        look_9_0 = @input.peek( 1 )

        if ( look_9_0 == WS )
          alt_9 = 1
        end
        case alt_9
        when 1
          # at line 45:47: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_class_201 )

        end
        match( CLASS, TOKENS_FOLLOWING_CLASS_IN_category_class_204 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_class_206 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_class_208 )
        @state.following.push( TOKENS_FOLLOWING_class_type_IN_category_class_210 )
        class_type12 = class_type
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_class_212 )
        # --> action
         value = ( class_type12 && @input.to_s( class_type12.start, class_type12.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 5 )

      end
      
      return value
    end


    # 
    # parser rule category_title
    # 
    # (in OCCIANTLR.g)
    # 47:3: category_title returns [value] : SEMICOLON ( WS )? TITLE EQUALS QUOTE title QUOTE ;
    # 
    def category_title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )
      value = nil
      title13 = nil

      begin
        # at line 47:37: SEMICOLON ( WS )? TITLE EQUALS QUOTE title QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_title_237 )
        # at line 47:47: ( WS )?
        alt_10 = 2
        look_10_0 = @input.peek( 1 )

        if ( look_10_0 == WS )
          alt_10 = 1
        end
        case alt_10
        when 1
          # at line 47:47: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_title_239 )

        end
        match( TITLE, TOKENS_FOLLOWING_TITLE_IN_category_title_242 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_title_244 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_title_246 )
        @state.following.push( TOKENS_FOLLOWING_title_IN_category_title_248 )
        title13 = title
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_title_250 )
        # --> action
         value = ( title13 && @input.to_s( title13.start, title13.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 6 )

      end
      
      return value
    end


    # 
    # parser rule category_rel
    # 
    # (in OCCIANTLR.g)
    # 49:3: category_rel returns [value] : SEMICOLON ( WS )? REL EQUALS QUOTE uri QUOTE ;
    # 
    def category_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )
      value = nil
      uri14 = nil

      begin
        # at line 49:35: SEMICOLON ( WS )? REL EQUALS QUOTE uri QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_rel_277 )
        # at line 49:45: ( WS )?
        alt_11 = 2
        look_11_0 = @input.peek( 1 )

        if ( look_11_0 == WS )
          alt_11 = 1
        end
        case alt_11
        when 1
          # at line 49:45: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_rel_279 )

        end
        match( REL, TOKENS_FOLLOWING_REL_IN_category_rel_282 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_rel_284 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_rel_286 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_rel_288 )
        uri14 = uri
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_rel_290 )
        # --> action
         value = [( uri14 && @input.to_s( uri14.start, uri14.stop ) )] 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 7 )

      end
      
      return value
    end


    # 
    # parser rule category_location
    # 
    # (in OCCIANTLR.g)
    # 51:3: category_location returns [value] : SEMICOLON ( WS )? LOCATION EQUALS QUOTE uri QUOTE ;
    # 
    def category_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )
      value = nil
      uri15 = nil

      begin
        # at line 51:39: SEMICOLON ( WS )? LOCATION EQUALS QUOTE uri QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_location_315 )
        # at line 51:49: ( WS )?
        alt_12 = 2
        look_12_0 = @input.peek( 1 )

        if ( look_12_0 == WS )
          alt_12 = 1
        end
        case alt_12
        when 1
          # at line 51:49: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_location_317 )

        end
        match( LOCATION, TOKENS_FOLLOWING_LOCATION_IN_category_location_320 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_location_322 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_location_324 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_location_326 )
        uri15 = uri
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_location_328 )
        # --> action
         value = ( uri15 && @input.to_s( uri15.start, uri15.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 8 )

      end
      
      return value
    end


    # 
    # parser rule category_attributes
    # 
    # (in OCCIANTLR.g)
    # 53:3: category_attributes returns [hash] : SEMICOLON ( WS )? ATTRIBUTES EQUALS QUOTE attr= attribute_name ( WS next_attr= attribute_name )* QUOTE ;
    # 
    def category_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )
      hash = nil
      attr = nil
      next_attr = nil
      # - - - - @init action - - - -
      hash = Hashie::Mash.new

      begin
        # at line 54:10: SEMICOLON ( WS )? ATTRIBUTES EQUALS QUOTE attr= attribute_name ( WS next_attr= attribute_name )* QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_attributes_367 )
        # at line 54:20: ( WS )?
        alt_13 = 2
        look_13_0 = @input.peek( 1 )

        if ( look_13_0 == WS )
          alt_13 = 1
        end
        case alt_13
        when 1
          # at line 54:20: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_369 )

        end
        match( ATTRIBUTES, TOKENS_FOLLOWING_ATTRIBUTES_IN_category_attributes_372 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_attributes_374 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_attributes_376 )
        @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_category_attributes_380 )
        attr = attribute_name
        @state.following.pop
        # --> action
         hash.merge!(attr) 
        # <-- action
        # at line 55:10: ( WS next_attr= attribute_name )*
        while true # decision 14
          alt_14 = 2
          look_14_0 = @input.peek( 1 )

          if ( look_14_0 == WS )
            alt_14 = 1

          end
          case alt_14
          when 1
            # at line 55:12: WS next_attr= attribute_name
            match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_395 )
            @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_category_attributes_399 )
            next_attr = attribute_name
            @state.following.pop
            # --> action
             hash.merge!(next_attr) 
            # <-- action

          else
            break # out of loop for decision 14
          end
        end # loop for decision 14
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_attributes_407 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 9 )

      end
      
      return hash
    end


    # 
    # parser rule category_actions
    # 
    # (in OCCIANTLR.g)
    # 56:3: category_actions returns [array] : SEMICOLON ( WS )? ACTIONS EQUALS QUOTE act= uri ( WS next_act= uri )* QUOTE ;
    # 
    def category_actions
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )
      array = nil
      act = nil
      next_act = nil
      # - - - - @init action - - - -
      array = Array.new

      begin
        # at line 57:10: SEMICOLON ( WS )? ACTIONS EQUALS QUOTE act= uri ( WS next_act= uri )* QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_category_actions_437 )
        # at line 57:20: ( WS )?
        alt_15 = 2
        look_15_0 = @input.peek( 1 )

        if ( look_15_0 == WS )
          alt_15 = 1
        end
        case alt_15
        when 1
          # at line 57:20: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_439 )

        end
        match( ACTIONS, TOKENS_FOLLOWING_ACTIONS_IN_category_actions_442 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_category_actions_444 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_actions_446 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_actions_450 )
        act = uri
        @state.following.pop
        # --> action
         array << ( act && @input.to_s( act.start, act.stop ) ) 
        # <-- action
        # at line 58:10: ( WS next_act= uri )*
        while true # decision 16
          alt_16 = 2
          look_16_0 = @input.peek( 1 )

          if ( look_16_0 == WS )
            alt_16 = 1

          end
          case alt_16
          when 1
            # at line 58:12: WS next_act= uri
            match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_466 )
            @state.following.push( TOKENS_FOLLOWING_uri_IN_category_actions_470 )
            next_act = uri
            @state.following.pop
            # --> action
             array << ( next_act && @input.to_s( next_act.start, next_act.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 16
          end
        end # loop for decision 16
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_category_actions_477 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 10 )

      end
      
      return array
    end


    # 
    # parser rule link
    # 
    # (in OCCIANTLR.g)
    # 69:1: link returns [hash] : LINK_KEY COLON link_value ;
    # 
    def link
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )
      hash = nil
      link_value16 = nil

      begin
        # at line 70:4: LINK_KEY COLON link_value
        match( LINK_KEY, TOKENS_FOLLOWING_LINK_KEY_IN_link_494 )
        match( COLON, TOKENS_FOLLOWING_COLON_IN_link_496 )
        @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_498 )
        link_value16 = link_value
        @state.following.pop
        # --> action
         hash = link_value16 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 11 )

      end
      
      return hash
    end


    # 
    # parser rule link_value
    # 
    # (in OCCIANTLR.g)
    # 71:2: link_value returns [hash] : link_target link_rel ( link_self )? ( link_category )? link_attributes ( SEMICOLON )? ;
    # 
    def link_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )
      hash = nil
      link_target17 = nil
      link_rel18 = nil
      link_self19 = nil
      link_category20 = nil
      link_attributes21 = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new 

      begin
        # at line 73:6: link_target link_rel ( link_self )? ( link_category )? link_attributes ( SEMICOLON )?
        @state.following.push( TOKENS_FOLLOWING_link_target_IN_link_value_520 )
        link_target17 = link_target
        @state.following.pop
        # --> action
         hash[:target] = link_target17 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_rel_IN_link_value_529 )
        link_rel18 = link_rel
        @state.following.pop
        # --> action
         hash[:rel] = link_rel18 
        # <-- action
        # at line 75:6: ( link_self )?
        alt_17 = 2
        alt_17 = @dfa17.predict( @input )
        case alt_17
        when 1
          # at line 75:6: link_self
          @state.following.push( TOKENS_FOLLOWING_link_self_IN_link_value_538 )
          link_self19 = link_self
          @state.following.pop

        end
        # --> action
         hash[:self] = link_self19 
        # <-- action
        # at line 76:6: ( link_category )?
        alt_18 = 2
        alt_18 = @dfa18.predict( @input )
        case alt_18
        when 1
          # at line 76:6: link_category
          @state.following.push( TOKENS_FOLLOWING_link_category_IN_link_value_548 )
          link_category20 = link_category
          @state.following.pop

        end
        # --> action
         hash[:category] = link_category20 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_attributes_IN_link_value_558 )
        link_attributes21 = link_attributes
        @state.following.pop
        # --> action
         hash[:attributes] = link_attributes21 
        # <-- action
        # at line 78:6: ( SEMICOLON )?
        alt_19 = 2
        look_19_0 = @input.peek( 1 )

        if ( look_19_0 == SEMICOLON )
          alt_19 = 1
        end
        case alt_19
        when 1
          # at line 78:6: SEMICOLON
          match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_link_value_567 )

        end

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 12 )

      end
      
      return hash
    end


    # 
    # parser rule link_target
    # 
    # (in OCCIANTLR.g)
    # 80:2: link_target returns [value] : ( WS )? LT uri GT ;
    # 
    def link_target
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )
      value = nil
      uri22 = nil

      begin
        # at line 80:32: ( WS )? LT uri GT
        # at line 80:32: ( WS )?
        alt_20 = 2
        look_20_0 = @input.peek( 1 )

        if ( look_20_0 == WS )
          alt_20 = 1
        end
        case alt_20
        when 1
          # at line 80:32: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_target_586 )

        end
        match( LT, TOKENS_FOLLOWING_LT_IN_link_target_589 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_target_591 )
        uri22 = uri
        @state.following.pop
        match( GT, TOKENS_FOLLOWING_GT_IN_link_target_593 )
        # --> action
         value = ( uri22 && @input.to_s( uri22.start, uri22.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 13 )

      end
      
      return value
    end


    # 
    # parser rule link_rel
    # 
    # (in OCCIANTLR.g)
    # 81:2: link_rel returns [value] : SEMICOLON ( WS )? REL EQUALS QUOTE uri QUOTE ;
    # 
    def link_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )
      value = nil
      uri23 = nil

      begin
        # at line 81:30: SEMICOLON ( WS )? REL EQUALS QUOTE uri QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_link_rel_608 )
        # at line 81:40: ( WS )?
        alt_21 = 2
        look_21_0 = @input.peek( 1 )

        if ( look_21_0 == WS )
          alt_21 = 1
        end
        case alt_21
        when 1
          # at line 81:40: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_rel_610 )

        end
        match( REL, TOKENS_FOLLOWING_REL_IN_link_rel_613 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_link_rel_615 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_rel_617 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_rel_619 )
        uri23 = uri
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_rel_621 )
        # --> action
         value = ( uri23 && @input.to_s( uri23.start, uri23.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 14 )

      end
      
      return value
    end


    # 
    # parser rule link_self
    # 
    # (in OCCIANTLR.g)
    # 82:2: link_self returns [value] : SEMICOLON ( WS )? SELF EQUALS QUOTE uri QUOTE ;
    # 
    def link_self
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )
      value = nil
      uri24 = nil

      begin
        # at line 82:31: SEMICOLON ( WS )? SELF EQUALS QUOTE uri QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_link_self_636 )
        # at line 82:41: ( WS )?
        alt_22 = 2
        look_22_0 = @input.peek( 1 )

        if ( look_22_0 == WS )
          alt_22 = 1
        end
        case alt_22
        when 1
          # at line 82:41: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_self_638 )

        end
        match( SELF, TOKENS_FOLLOWING_SELF_IN_link_self_641 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_link_self_643 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_self_645 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_self_647 )
        uri24 = uri
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_self_649 )
        # --> action
         value = ( uri24 && @input.to_s( uri24.start, uri24.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 15 )

      end
      
      return value
    end


    # 
    # parser rule link_category
    # 
    # (in OCCIANTLR.g)
    # 83:2: link_category returns [value] : SEMICOLON ( WS )? CATEGORY EQUALS QUOTE uri QUOTE ;
    # 
    def link_category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )
      value = nil
      uri25 = nil

      begin
        # at line 83:35: SEMICOLON ( WS )? CATEGORY EQUALS QUOTE uri QUOTE
        match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_link_category_664 )
        # at line 83:45: ( WS )?
        alt_23 = 2
        look_23_0 = @input.peek( 1 )

        if ( look_23_0 == WS )
          alt_23 = 1
        end
        case alt_23
        when 1
          # at line 83:45: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_category_666 )

        end
        match( CATEGORY, TOKENS_FOLLOWING_CATEGORY_IN_link_category_669 )
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_link_category_671 )
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_category_673 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_category_675 )
        uri25 = uri
        @state.following.pop
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_link_category_677 )
        # --> action
         value = ( uri25 && @input.to_s( uri25.start, uri25.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 16 )

      end
      
      return value
    end


    # 
    # parser rule link_attributes
    # 
    # (in OCCIANTLR.g)
    # 84:2: link_attributes returns [hash] : ( SEMICOLON ( WS )? attribute )* ;
    # 
    def link_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )
      hash = nil
      attribute26 = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new 

      begin
        # at line 85:8: ( SEMICOLON ( WS )? attribute )*
        # at line 85:8: ( SEMICOLON ( WS )? attribute )*
        while true # decision 25
          alt_25 = 2
          look_25_0 = @input.peek( 1 )

          if ( look_25_0 == SEMICOLON )
            look_25_1 = @input.peek( 2 )

            if ( look_25_1.between?( WS, SCHEME ) || look_25_1.between?( CLASS, ACTIONS ) || look_25_1.between?( SELF, CATEGORY ) || look_25_1 == LOALPHA || look_25_1.between?( KIND, ACTION ) || look_25_1.between?( LINK, TERM ) )
              alt_25 = 1

            end

          end
          case alt_25
          when 1
            # at line 85:9: SEMICOLON ( WS )? attribute
            match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_link_attributes_703 )
            # at line 85:19: ( WS )?
            alt_24 = 2
            look_24_0 = @input.peek( 1 )

            if ( look_24_0 == WS )
              alt_24 = 1
            end
            case alt_24
            when 1
              # at line 85:19: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_link_attributes_705 )

            end
            @state.following.push( TOKENS_FOLLOWING_attribute_IN_link_attributes_708 )
            attribute26 = attribute
            @state.following.pop
            # --> action
             hash.merge!(attribute26) 
            # <-- action

          else
            break # out of loop for decision 25
          end
        end # loop for decision 25

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 17 )

      end
      
      return hash
    end


    # 
    # parser rule x_occi_attribute
    # 
    # (in OCCIANTLR.g)
    # 97:1: x_occi_attribute returns [hash] : X_OCCI_ATTRIBUTE_KEY COLON ( WS )? attribute ( SEMICOLON )? ;
    # 
    def x_occi_attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )
      hash = nil
      attribute27 = nil

      begin
        # at line 98:4: X_OCCI_ATTRIBUTE_KEY COLON ( WS )? attribute ( SEMICOLON )?
        match( X_OCCI_ATTRIBUTE_KEY, TOKENS_FOLLOWING_X_OCCI_ATTRIBUTE_KEY_IN_x_occi_attribute_729 )
        match( COLON, TOKENS_FOLLOWING_COLON_IN_x_occi_attribute_731 )
        # at line 98:31: ( WS )?
        alt_26 = 2
        look_26_0 = @input.peek( 1 )

        if ( look_26_0 == WS )
          alt_26 = 1
        end
        case alt_26
        when 1
          # at line 98:31: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_attribute_733 )

        end
        @state.following.push( TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_736 )
        attribute27 = attribute
        @state.following.pop
        # at line 98:45: ( SEMICOLON )?
        alt_27 = 2
        look_27_0 = @input.peek( 1 )

        if ( look_27_0 == SEMICOLON )
          alt_27 = 1
        end
        case alt_27
        when 1
          # at line 98:45: SEMICOLON
          match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_x_occi_attribute_738 )

        end
        # --> action
         hash = attribute27 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 18 )

      end
      
      return hash
    end


    # 
    # parser rule x_occi_location
    # 
    # (in OCCIANTLR.g)
    # 106:1: x_occi_location returns [location] : X_OCCI_LOCATION_KEY COLON ( WS )? uri ( SEMICOLON )? ;
    # 
    def x_occi_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )
      location = nil
      uri28 = nil

      begin
        # at line 107:4: X_OCCI_LOCATION_KEY COLON ( WS )? uri ( SEMICOLON )?
        match( X_OCCI_LOCATION_KEY, TOKENS_FOLLOWING_X_OCCI_LOCATION_KEY_IN_x_occi_location_758 )
        match( COLON, TOKENS_FOLLOWING_COLON_IN_x_occi_location_760 )
        # at line 107:30: ( WS )?
        alt_28 = 2
        look_28_0 = @input.peek( 1 )

        if ( look_28_0 == WS )
          alt_28 = 1
        end
        case alt_28
        when 1
          # at line 107:30: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_location_762 )

        end
        @state.following.push( TOKENS_FOLLOWING_uri_IN_x_occi_location_765 )
        uri28 = uri
        @state.following.pop
        # at line 107:38: ( SEMICOLON )?
        alt_29 = 2
        look_29_0 = @input.peek( 1 )

        if ( look_29_0 == SEMICOLON )
          alt_29 = 1
        end
        case alt_29
        when 1
          # at line 107:38: SEMICOLON
          match( SEMICOLON, TOKENS_FOLLOWING_SEMICOLON_IN_x_occi_location_767 )

        end
        # --> action
         location = URI.parse(( uri28 && @input.to_s( uri28.start, uri28.stop ) )) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 19 )

      end
      
      return location
    end

    UriReturnValue = define_return_scope 

    # 
    # parser rule uri
    # 
    # (in OCCIANTLR.g)
    # 109:1: uri : ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | reserved_words )+ ;
    # 
    def uri
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )
      return_value = UriReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 109:9: ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | reserved_words )+
        # at file 109:9: ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | reserved_words )+
        match_count_30 = 0
        while true
          alt_30 = 21
          case look_30 = @input.peek( 1 )
          when LOALPHA then alt_30 = 1
          when UPALPHA then alt_30 = 2
          when DIGIT then alt_30 = 3
          when AT then alt_30 = 4
          when COLON then alt_30 = 5
          when PERCENT then alt_30 = 6
          when UNDERSCORE then alt_30 = 7
          when BACKSLASH then alt_30 = 8
          when PLUS then alt_30 = 9
          when DOT then alt_30 = 10
          when TILDE then alt_30 = 11
          when HASH then alt_30 = 12
          when QUESTION then alt_30 = 13
          when AMPERSAND then alt_30 = 14
          when SLASH then alt_30 = 15
          when EQUALS then alt_30 = 16
          when DASH then alt_30 = 17
          when X_OCCI_ATTRIBUTE_KEY then alt_30 = 18
          when X_OCCI_LOCATION_KEY then alt_30 = 19
          when SCHEME, CLASS, TITLE, REL, LOCATION, ATTRIBUTES, ACTIONS, SELF, CATEGORY, KIND, MIXIN, ACTION, LINK, TERM then alt_30 = 20
          end
          case alt_30
          when 1
            # at line 109:11: LOALPHA
            match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_uri_783 )

          when 2
            # at line 109:21: UPALPHA
            match( UPALPHA, TOKENS_FOLLOWING_UPALPHA_IN_uri_787 )

          when 3
            # at line 109:31: DIGIT
            match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_uri_791 )

          when 4
            # at line 109:39: AT
            match( AT, TOKENS_FOLLOWING_AT_IN_uri_795 )

          when 5
            # at line 109:44: COLON
            match( COLON, TOKENS_FOLLOWING_COLON_IN_uri_799 )

          when 6
            # at line 109:52: PERCENT
            match( PERCENT, TOKENS_FOLLOWING_PERCENT_IN_uri_803 )

          when 7
            # at line 109:62: UNDERSCORE
            match( UNDERSCORE, TOKENS_FOLLOWING_UNDERSCORE_IN_uri_807 )

          when 8
            # at line 109:75: BACKSLASH
            match( BACKSLASH, TOKENS_FOLLOWING_BACKSLASH_IN_uri_811 )

          when 9
            # at line 109:87: PLUS
            match( PLUS, TOKENS_FOLLOWING_PLUS_IN_uri_815 )

          when 10
            # at line 109:94: DOT
            match( DOT, TOKENS_FOLLOWING_DOT_IN_uri_819 )

          when 11
            # at line 109:100: TILDE
            match( TILDE, TOKENS_FOLLOWING_TILDE_IN_uri_823 )

          when 12
            # at line 109:108: HASH
            match( HASH, TOKENS_FOLLOWING_HASH_IN_uri_827 )

          when 13
            # at line 109:115: QUESTION
            match( QUESTION, TOKENS_FOLLOWING_QUESTION_IN_uri_831 )

          when 14
            # at line 109:126: AMPERSAND
            match( AMPERSAND, TOKENS_FOLLOWING_AMPERSAND_IN_uri_835 )

          when 15
            # at line 109:138: SLASH
            match( SLASH, TOKENS_FOLLOWING_SLASH_IN_uri_839 )

          when 16
            # at line 109:146: EQUALS
            match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_uri_843 )

          when 17
            # at line 109:155: DASH
            match( DASH, TOKENS_FOLLOWING_DASH_IN_uri_847 )

          when 18
            # at line 109:162: X_OCCI_ATTRIBUTE_KEY
            match( X_OCCI_ATTRIBUTE_KEY, TOKENS_FOLLOWING_X_OCCI_ATTRIBUTE_KEY_IN_uri_851 )

          when 19
            # at line 109:185: X_OCCI_LOCATION_KEY
            match( X_OCCI_LOCATION_KEY, TOKENS_FOLLOWING_X_OCCI_LOCATION_KEY_IN_uri_855 )

          when 20
            # at line 109:207: reserved_words
            @state.following.push( TOKENS_FOLLOWING_reserved_words_IN_uri_859 )
            reserved_words
            @state.following.pop

          else
            match_count_30 > 0 and break
            eee = EarlyExit(30)


            raise eee
          end
          match_count_30 += 1
        end

        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 20 )

      end
      
      return return_value
    end

    TermReturnValue = define_return_scope 

    # 
    # parser rule term
    # 
    # (in OCCIANTLR.g)
    # 110:1: term : ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | DOT | reserved_words )* ;
    # 
    def term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )
      return_value = TermReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 110:10: ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | DOT | reserved_words )*
        # at line 110:10: ( LOALPHA | reserved_words )
        alt_31 = 2
        look_31_0 = @input.peek( 1 )

        if ( look_31_0 == LOALPHA )
          alt_31 = 1
        elsif ( look_31_0 == SCHEME || look_31_0.between?( CLASS, ACTIONS ) || look_31_0.between?( SELF, CATEGORY ) || look_31_0.between?( KIND, ACTION ) || look_31_0.between?( LINK, TERM ) )
          alt_31 = 2
        else
          raise NoViableAlternative( "", 31, 0 )
        end
        case alt_31
        when 1
          # at line 110:12: LOALPHA
          match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_term_872 )

        when 2
          # at line 110:22: reserved_words
          @state.following.push( TOKENS_FOLLOWING_reserved_words_IN_term_876 )
          reserved_words
          @state.following.pop

        end
        # at line 110:39: ( LOALPHA | DIGIT | DASH | UNDERSCORE | DOT | reserved_words )*
        while true # decision 32
          alt_32 = 7
          case look_32 = @input.peek( 1 )
          when LOALPHA then alt_32 = 1
          when DIGIT then alt_32 = 2
          when DASH then alt_32 = 3
          when UNDERSCORE then alt_32 = 4
          when DOT then alt_32 = 5
          when SCHEME, CLASS, TITLE, REL, LOCATION, ATTRIBUTES, ACTIONS, SELF, CATEGORY, KIND, MIXIN, ACTION, LINK, TERM then alt_32 = 6
          end
          case alt_32
          when 1
            # at line 110:41: LOALPHA
            match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_term_882 )

          when 2
            # at line 110:51: DIGIT
            match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_term_886 )

          when 3
            # at line 110:59: DASH
            match( DASH, TOKENS_FOLLOWING_DASH_IN_term_890 )

          when 4
            # at line 110:66: UNDERSCORE
            match( UNDERSCORE, TOKENS_FOLLOWING_UNDERSCORE_IN_term_894 )

          when 5
            # at line 110:79: DOT
            match( DOT, TOKENS_FOLLOWING_DOT_IN_term_898 )

          when 6
            # at line 110:85: reserved_words
            @state.following.push( TOKENS_FOLLOWING_reserved_words_IN_term_902 )
            reserved_words
            @state.following.pop

          else
            break # out of loop for decision 32
          end
        end # loop for decision 32
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 21 )

      end
      
      return return_value
    end

    SchemeReturnValue = define_return_scope 

    # 
    # parser rule scheme
    # 
    # (in OCCIANTLR.g)
    # 111:1: scheme : uri ;
    # 
    def scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )
      return_value = SchemeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 111:20: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_scheme_922 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 22 )

      end
      
      return return_value
    end

    ClassTypeReturnValue = define_return_scope 

    # 
    # parser rule class_type
    # 
    # (in OCCIANTLR.g)
    # 112:1: class_type : ( KIND | MIXIN | ACTION ) ;
    # 
    def class_type
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )
      return_value = ClassTypeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 112:15: ( KIND | MIXIN | ACTION )
        if @input.peek( 1 ).between?( KIND, ACTION )
          @input.consume
          @state.error_recovery = false
        else
          mse = MismatchedSet( nil )
          raise mse
        end


        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 23 )

      end
      
      return return_value
    end

    TitleReturnValue = define_return_scope 

    # 
    # parser rule title
    # 
    # (in OCCIANTLR.g)
    # 113:1: title : ( ESC | ~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )* ;
    # 
    def title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )
      return_value = TitleReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 113:11: ( ESC | ~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )*
        # at line 113:11: ( ESC | ~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )*
        while true # decision 33
          alt_33 = 2
          look_33_0 = @input.peek( 1 )

          if ( look_33_0.between?( CATEGORY_KEY, EQUALS ) || look_33_0.between?( CLASS, UNDERSCORE ) || look_33_0.between?( PLUS, T__52 ) )
            alt_33 = 1

          end
          case alt_33
          when 1
            # at line 
            if @input.peek( 1 ).between?( CATEGORY_KEY, EQUALS ) || @input.peek( 1 ).between?( CLASS, UNDERSCORE ) || @input.peek( 1 ).between?( PLUS, T__52 )
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            break # out of loop for decision 33
          end
        end # loop for decision 33
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 24 )

      end
      
      return return_value
    end


    # 
    # parser rule attribute
    # 
    # (in OCCIANTLR.g)
    # 114:1: attribute returns [hash] : comp_first= attribute_component ( '.' comp_next= attribute_component )* EQUALS attribute_value ;
    # 
    def attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )
      hash = nil
      comp_first = nil
      comp_next = nil
      attribute_value29 = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new 

      begin
        # at line 115:6: comp_first= attribute_component ( '.' comp_next= attribute_component )* EQUALS attribute_value
        @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_999 )
        comp_first = attribute_component
        @state.following.pop
        # --> action
         cur_hash = hash; comp = ( comp_first && @input.to_s( comp_first.start, comp_first.stop ) ) 
        # <-- action
        # at line 116:6: ( '.' comp_next= attribute_component )*
        while true # decision 34
          alt_34 = 2
          look_34_0 = @input.peek( 1 )

          if ( look_34_0 == DOT )
            alt_34 = 1

          end
          case alt_34
          when 1
            # at line 116:8: '.' comp_next= attribute_component
            match( DOT, TOKENS_FOLLOWING_DOT_IN_attribute_1010 )
            @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_1014 )
            comp_next = attribute_component
            @state.following.pop
            # --> action
             cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = ( comp_next && @input.to_s( comp_next.start, comp_next.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 34
          end
        end # loop for decision 34
        match( EQUALS, TOKENS_FOLLOWING_EQUALS_IN_attribute_1025 )
        @state.following.push( TOKENS_FOLLOWING_attribute_value_IN_attribute_1027 )
        attribute_value29 = attribute_value
        @state.following.pop
        # --> action
         cur_hash[comp.to_sym] = attribute_value29 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 25 )

      end
      
      return hash
    end


    # 
    # parser rule attribute_name
    # 
    # (in OCCIANTLR.g)
    # 118:1: attribute_name returns [hash] : comp_first= attribute_component ( '.' comp_next= attribute_component )* ( '{' ( 'mutable' )? ( 'immutable' )? ( 'required' )? '}' )? ;
    # 
    def attribute_name
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )
      hash = nil
      comp_first = nil
      comp_next = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new 

      begin
        # at line 119:27: comp_first= attribute_component ( '.' comp_next= attribute_component )* ( '{' ( 'mutable' )? ( 'immutable' )? ( 'required' )? '}' )?
        @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1071 )
        comp_first = attribute_component
        @state.following.pop
        # --> action
         cur_hash = hash; comp = ( comp_first && @input.to_s( comp_first.start, comp_first.stop ) ) 
        # <-- action
        # at line 120:6: ( '.' comp_next= attribute_component )*
        while true # decision 35
          alt_35 = 2
          look_35_0 = @input.peek( 1 )

          if ( look_35_0 == DOT )
            alt_35 = 1

          end
          case alt_35
          when 1
            # at line 120:8: '.' comp_next= attribute_component
            match( DOT, TOKENS_FOLLOWING_DOT_IN_attribute_name_1082 )
            @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1086 )
            comp_next = attribute_component
            @state.following.pop
            # --> action
             cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = ( comp_next && @input.to_s( comp_next.start, comp_next.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 35
          end
        end # loop for decision 35
        # --> action
         cur_hash[comp.to_sym] = ATTRIBUTE 
        # <-- action
        # at line 122:6: ( '{' ( 'mutable' )? ( 'immutable' )? ( 'required' )? '}' )?
        alt_39 = 2
        look_39_0 = @input.peek( 1 )

        if ( look_39_0 == T__48 )
          alt_39 = 1
        end
        case alt_39
        when 1
          # at line 122:7: '{' ( 'mutable' )? ( 'immutable' )? ( 'required' )? '}'
          match( T__48, TOKENS_FOLLOWING_T__48_IN_attribute_name_1106 )
          # at line 122:11: ( 'mutable' )?
          alt_36 = 2
          look_36_0 = @input.peek( 1 )

          if ( look_36_0 == T__49 )
            alt_36 = 1
          end
          case alt_36
          when 1
            # at line 122:12: 'mutable'
            match( T__49, TOKENS_FOLLOWING_T__49_IN_attribute_name_1109 )
            # --> action
             cur_hash[comp.to_sym][:mutable] = true 
            # <-- action

          end
          # at line 122:67: ( 'immutable' )?
          alt_37 = 2
          look_37_0 = @input.peek( 1 )

          if ( look_37_0 == T__50 )
            alt_37 = 1
          end
          case alt_37
          when 1
            # at line 122:68: 'immutable'
            match( T__50, TOKENS_FOLLOWING_T__50_IN_attribute_name_1116 )
            # --> action
             cur_hash[comp.to_sym][:mutable] = false 
            # <-- action

          end
          # at line 122:126: ( 'required' )?
          alt_38 = 2
          look_38_0 = @input.peek( 1 )

          if ( look_38_0 == T__51 )
            alt_38 = 1
          end
          case alt_38
          when 1
            # at line 122:127: 'required'
            match( T__51, TOKENS_FOLLOWING_T__51_IN_attribute_name_1123 )
            # --> action
             cur_hash[comp.to_sym][:required] = true 
            # <-- action

          end
          match( T__52, TOKENS_FOLLOWING_T__52_IN_attribute_name_1129 )

        end

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 26 )

      end
      
      return hash
    end

    AttributeComponentReturnValue = define_return_scope 

    # 
    # parser rule attribute_component
    # 
    # (in OCCIANTLR.g)
    # 123:1: attribute_component : ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )* ;
    # 
    def attribute_component
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )
      return_value = AttributeComponentReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 123:23: ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
        # at line 123:23: ( LOALPHA | reserved_words )
        alt_40 = 2
        look_40_0 = @input.peek( 1 )

        if ( look_40_0 == LOALPHA )
          alt_40 = 1
        elsif ( look_40_0 == SCHEME || look_40_0.between?( CLASS, ACTIONS ) || look_40_0.between?( SELF, CATEGORY ) || look_40_0.between?( KIND, ACTION ) || look_40_0.between?( LINK, TERM ) )
          alt_40 = 2
        else
          raise NoViableAlternative( "", 40, 0 )
        end
        case alt_40
        when 1
          # at line 123:25: LOALPHA
          match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1141 )

        when 2
          # at line 123:35: reserved_words
          @state.following.push( TOKENS_FOLLOWING_reserved_words_IN_attribute_component_1145 )
          reserved_words
          @state.following.pop

        end
        # at line 123:51: ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
        while true # decision 41
          alt_41 = 6
          case look_41 = @input.peek( 1 )
          when LOALPHA then alt_41 = 1
          when DIGIT then alt_41 = 2
          when DASH then alt_41 = 3
          when UNDERSCORE then alt_41 = 4
          when SCHEME, CLASS, TITLE, REL, LOCATION, ATTRIBUTES, ACTIONS, SELF, CATEGORY, KIND, MIXIN, ACTION, LINK, TERM then alt_41 = 5
          end
          case alt_41
          when 1
            # at line 123:53: LOALPHA
            match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1150 )

          when 2
            # at line 123:63: DIGIT
            match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_attribute_component_1154 )

          when 3
            # at line 123:71: DASH
            match( DASH, TOKENS_FOLLOWING_DASH_IN_attribute_component_1158 )

          when 4
            # at line 123:78: UNDERSCORE
            match( UNDERSCORE, TOKENS_FOLLOWING_UNDERSCORE_IN_attribute_component_1162 )

          when 5
            # at line 123:91: reserved_words
            @state.following.push( TOKENS_FOLLOWING_reserved_words_IN_attribute_component_1166 )
            reserved_words
            @state.following.pop

          else
            break # out of loop for decision 41
          end
        end # loop for decision 41
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 27 )

      end
      
      return return_value
    end


    # 
    # parser rule attribute_value
    # 
    # (in OCCIANTLR.g)
    # 124:1: attribute_value returns [value] : ( string | number ) ;
    # 
    def attribute_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )
      value = nil
      string30 = nil
      number31 = nil

      begin
        # at line 124:35: ( string | number )
        # at line 124:35: ( string | number )
        alt_42 = 2
        look_42_0 = @input.peek( 1 )

        if ( look_42_0 == QUOTE )
          alt_42 = 1
        elsif ( look_42_0 == DIGIT )
          alt_42 = 2
        else
          raise NoViableAlternative( "", 42, 0 )
        end
        case alt_42
        when 1
          # at line 124:37: string
          @state.following.push( TOKENS_FOLLOWING_string_IN_attribute_value_1183 )
          string30 = string
          @state.following.pop
          # --> action
           value = ( string30 && @input.to_s( string30.start, string30.stop ) ) 
          # <-- action

        when 2
          # at line 124:71: number
          @state.following.push( TOKENS_FOLLOWING_number_IN_attribute_value_1189 )
          number31 = number
          @state.following.pop
          # --> action
           value = ( number31 && @input.to_s( number31.start, number31.stop ) ).to_i 
          # <-- action

        end

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 28 )

      end
      
      return value
    end

    StringReturnValue = define_return_scope 

    # 
    # parser rule string
    # 
    # (in OCCIANTLR.g)
    # 125:1: string : quoted_string ;
    # 
    def string
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )
      return_value = StringReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 125:12: quoted_string
        @state.following.push( TOKENS_FOLLOWING_quoted_string_IN_string_1202 )
        quoted_string
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 29 )

      end
      
      return return_value
    end

    NumberReturnValue = define_return_scope 

    # 
    # parser rule number
    # 
    # (in OCCIANTLR.g)
    # 126:1: number : ( digits ( DOT digits )? ) ;
    # 
    def number
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )
      return_value = NumberReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 126:12: ( digits ( DOT digits )? )
        # at line 126:12: ( digits ( DOT digits )? )
        # at line 126:14: digits ( DOT digits )?
        @state.following.push( TOKENS_FOLLOWING_digits_IN_number_1213 )
        digits
        @state.following.pop
        # at line 126:21: ( DOT digits )?
        alt_43 = 2
        look_43_0 = @input.peek( 1 )

        if ( look_43_0 == DOT )
          alt_43 = 1
        end
        case alt_43
        when 1
          # at line 126:23: DOT digits
          match( DOT, TOKENS_FOLLOWING_DOT_IN_number_1217 )
          @state.following.push( TOKENS_FOLLOWING_digits_IN_number_1219 )
          digits
          @state.following.pop

        end

        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 30 )

      end
      
      return return_value
    end


    # 
    # parser rule reserved_words
    # 
    # (in OCCIANTLR.g)
    # 127:1: reserved_words : ( ACTION | ACTIONS | ATTRIBUTES | CATEGORY | CLASS | KIND | LINK | LOCATION | MIXIN | REL | SCHEME | SELF | TERM | TITLE ) ;
    # 
    def reserved_words
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )

      begin
        # at line 128:4: ( ACTION | ACTIONS | ATTRIBUTES | CATEGORY | CLASS | KIND | LINK | LOCATION | MIXIN | REL | SCHEME | SELF | TERM | TITLE )
        if @input.peek(1) == SCHEME || @input.peek( 1 ).between?( CLASS, ACTIONS ) || @input.peek( 1 ).between?( SELF, CATEGORY ) || @input.peek( 1 ).between?( KIND, ACTION ) || @input.peek( 1 ).between?( LINK, TERM )
          @input.consume
          @state.error_recovery = false
        else
          mse = MismatchedSet( nil )
          raise mse
        end



      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 31 )

      end
      
      return 
    end


    # 
    # parser rule quoted_string
    # 
    # (in OCCIANTLR.g)
    # 188:1: quoted_string : ( QUOTE ( ESC | ~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE ) ;
    # 
    def quoted_string
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )

      begin
        # at line 189:4: ( QUOTE ( ESC | ~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE )
        # at line 189:4: ( QUOTE ( ESC | ~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE )
        # at line 189:6: QUOTE ( ESC | ~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_quoted_string_1683 )
        # at line 189:12: ( ESC | ~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )*
        while true # decision 44
          alt_44 = 2
          look_44_0 = @input.peek( 1 )

          if ( look_44_0.between?( CATEGORY_KEY, EQUALS ) || look_44_0.between?( CLASS, UNDERSCORE ) || look_44_0.between?( PLUS, T__52 ) )
            alt_44 = 1

          end
          case alt_44
          when 1
            # at line 
            if @input.peek( 1 ).between?( CATEGORY_KEY, EQUALS ) || @input.peek( 1 ).between?( CLASS, UNDERSCORE ) || @input.peek( 1 ).between?( PLUS, T__52 )
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            break # out of loop for decision 44
          end
        end # loop for decision 44
        match( QUOTE, TOKENS_FOLLOWING_QUOTE_IN_quoted_string_1713 )


      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 32 )

      end
      
      return 
    end


    # 
    # parser rule digits
    # 
    # (in OCCIANTLR.g)
    # 190:1: digits : ( DIGIT )+ ;
    # 
    def digits
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )

      begin
        # at line 190:10: ( DIGIT )+
        # at file 190:10: ( DIGIT )+
        match_count_45 = 0
        while true
          alt_45 = 2
          look_45_0 = @input.peek( 1 )

          if ( look_45_0 == DIGIT )
            alt_45 = 1

          end
          case alt_45
          when 1
            # at line 190:10: DIGIT
            match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_digits_1722 )

          else
            match_count_45 > 0 and break
            eee = EarlyExit(45)


            raise eee
          end
          match_count_45 += 1
        end


      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 33 )

      end
      
      return 
    end



    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA17 < ANTLR3::DFA
      EOT = unpack( 28, -1 )
      EOF = unpack( 2, 2, 26, -1 )
      MIN = unpack( 1, 6, 1, 7, 1, -1, 2, 8, 1, 10, 8, 4, 1, -1, 12, 4, 
                    1, -1 )
      MAX = unpack( 1, 6, 1, 45, 1, -1, 2, 45, 1, 26, 8, 52, 1, -1, 12, 
                    52, 1, -1 )
      ACCEPT = unpack( 2, -1, 1, 2, 11, -1, 1, 1, 12, -1, 1, 1 )
      SPECIAL = unpack( 28, -1 )
      TRANSITION = [
        unpack( 1, 1 ),
        unpack( 1, 3, 1, 2, 2, -1, 6, 2, 3, -1, 1, 4, 1, 2, 2, -1, 1, 2, 
                 14, -1, 3, 2, 2, -1, 2, 2 ),
        unpack(  ),
        unpack( 1, 2, 2, -1, 6, 2, 3, -1, 1, 4, 1, 2, 2, -1, 1, 2, 14, 
                 -1, 3, 2, 2, -1, 2, 2 ),
        unpack( 1, 2, 1, 5, 1, -1, 6, 2, 3, -1, 2, 2, 2, -1, 1, 2, 1, -1, 
                 1, 2, 2, -1, 1, 2, 2, -1, 1, 2, 5, -1, 4, 2, 2, -1, 2, 
                 2 ),
        unpack( 1, 6, 15, -1, 1, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 2, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack(  ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 17
      

      def description
        <<-'__dfa_description__'.strip!
          75:6: ( link_self )?
        __dfa_description__
      end
    end
    class DFA18 < ANTLR3::DFA
      EOT = unpack( 28, -1 )
      EOF = unpack( 2, 2, 26, -1 )
      MIN = unpack( 1, 6, 1, 7, 1, -1, 2, 8, 1, 10, 8, 4, 1, -1, 12, 4, 
                    1, -1 )
      MAX = unpack( 1, 6, 1, 45, 1, -1, 2, 45, 1, 26, 8, 52, 1, -1, 12, 
                    52, 1, -1 )
      ACCEPT = unpack( 2, -1, 1, 2, 11, -1, 1, 1, 12, -1, 1, 1 )
      SPECIAL = unpack( 28, -1 )
      TRANSITION = [
        unpack( 1, 1 ),
        unpack( 1, 3, 1, 2, 2, -1, 6, 2, 3, -1, 1, 2, 1, 4, 2, -1, 1, 2, 
                 14, -1, 3, 2, 2, -1, 2, 2 ),
        unpack(  ),
        unpack( 1, 2, 2, -1, 6, 2, 3, -1, 1, 2, 1, 4, 2, -1, 1, 2, 14, 
                 -1, 3, 2, 2, -1, 2, 2 ),
        unpack( 1, 2, 1, 5, 1, -1, 6, 2, 3, -1, 2, 2, 2, -1, 1, 2, 1, -1, 
                 1, 2, 2, -1, 1, 2, 2, -1, 1, 2, 5, -1, 4, 2, 2, -1, 2, 
                 2 ),
        unpack( 1, 6, 15, -1, 1, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 2, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack(  ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack( 1, 2, 1, 11, 2, 2, 1, 26, 1, 22, 1, 27, 6, 26, 3, 2, 2, 
                 26, 1, 24, 1, 25, 1, 7, 1, 8, 1, 9, 1, 10, 1, 12, 1, 13, 
                 1, 14, 1, 15, 1, 16, 1, 17, 1, 18, 1, 19, 1, 20, 1, 21, 
                 1, 23, 3, 26, 2, 2, 2, 26, 7, 2 ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 18
      

      def description
        <<-'__dfa_description__'.strip!
          76:6: ( link_category )?
        __dfa_description__
      end
    end


    private

    def initialize_dfas
      super rescue nil
      @dfa17 = DFA17.new( self, 17 )
      @dfa18 = DFA18.new( self, 18 )

    end
    TOKENS_FOLLOWING_CATEGORY_KEY_IN_category_39 = Set[ 5 ]
    TOKENS_FOLLOWING_COLON_IN_category_41 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_category_value_IN_category_43 = Set[ 1 ]
    TOKENS_FOLLOWING_category_term_IN_category_value_75 = Set[ 6 ]
    TOKENS_FOLLOWING_category_scheme_IN_category_value_77 = Set[ 6 ]
    TOKENS_FOLLOWING_category_class_IN_category_value_79 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_category_title_IN_category_value_81 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_category_rel_IN_category_value_84 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_category_location_IN_category_value_87 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_category_attributes_IN_category_value_90 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_category_actions_IN_category_value_93 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_value_96 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_category_term_128 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_term_IN_category_term_131 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_scheme_157 = Set[ 7, 8 ]
    TOKENS_FOLLOWING_WS_IN_category_scheme_159 = Set[ 8 ]
    TOKENS_FOLLOWING_SCHEME_IN_category_scheme_162 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_scheme_164 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_scheme_166 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_scheme_IN_category_scheme_168 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_scheme_170 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_class_199 = Set[ 7, 11 ]
    TOKENS_FOLLOWING_WS_IN_category_class_201 = Set[ 11 ]
    TOKENS_FOLLOWING_CLASS_IN_category_class_204 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_class_206 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_class_208 = Set[ 39, 40, 41 ]
    TOKENS_FOLLOWING_class_type_IN_category_class_210 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_class_212 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_title_237 = Set[ 7, 12 ]
    TOKENS_FOLLOWING_WS_IN_category_title_239 = Set[ 12 ]
    TOKENS_FOLLOWING_TITLE_IN_category_title_242 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_title_244 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_title_246 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 ]
    TOKENS_FOLLOWING_title_IN_category_title_248 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_title_250 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_rel_277 = Set[ 7, 13 ]
    TOKENS_FOLLOWING_WS_IN_category_rel_279 = Set[ 13 ]
    TOKENS_FOLLOWING_REL_IN_category_rel_282 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_rel_284 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_rel_286 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_category_rel_288 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_rel_290 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_location_315 = Set[ 7, 14 ]
    TOKENS_FOLLOWING_WS_IN_category_location_317 = Set[ 14 ]
    TOKENS_FOLLOWING_LOCATION_IN_category_location_320 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_location_322 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_location_324 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_category_location_326 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_location_328 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_attributes_367 = Set[ 7, 15 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_369 = Set[ 15 ]
    TOKENS_FOLLOWING_ATTRIBUTES_IN_category_attributes_372 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_attributes_374 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_attributes_376 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_name_IN_category_attributes_380 = Set[ 7, 10 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_395 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_name_IN_category_attributes_399 = Set[ 7, 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_attributes_407 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_category_actions_437 = Set[ 7, 16 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_439 = Set[ 16 ]
    TOKENS_FOLLOWING_ACTIONS_IN_category_actions_442 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_category_actions_444 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_actions_446 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_category_actions_450 = Set[ 7, 10 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_466 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_category_actions_470 = Set[ 7, 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_category_actions_477 = Set[ 1 ]
    TOKENS_FOLLOWING_LINK_KEY_IN_link_494 = Set[ 5 ]
    TOKENS_FOLLOWING_COLON_IN_link_496 = Set[ 7, 18 ]
    TOKENS_FOLLOWING_link_value_IN_link_498 = Set[ 1 ]
    TOKENS_FOLLOWING_link_target_IN_link_value_520 = Set[ 6 ]
    TOKENS_FOLLOWING_link_rel_IN_link_value_529 = Set[ 6 ]
    TOKENS_FOLLOWING_link_self_IN_link_value_538 = Set[ 6 ]
    TOKENS_FOLLOWING_link_category_IN_link_value_548 = Set[ 6 ]
    TOKENS_FOLLOWING_link_attributes_IN_link_value_558 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_link_value_567 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_link_target_586 = Set[ 18 ]
    TOKENS_FOLLOWING_LT_IN_link_target_589 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_link_target_591 = Set[ 19 ]
    TOKENS_FOLLOWING_GT_IN_link_target_593 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_link_rel_608 = Set[ 7, 13 ]
    TOKENS_FOLLOWING_WS_IN_link_rel_610 = Set[ 13 ]
    TOKENS_FOLLOWING_REL_IN_link_rel_613 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_link_rel_615 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_rel_617 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_link_rel_619 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_rel_621 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_link_self_636 = Set[ 7, 20 ]
    TOKENS_FOLLOWING_WS_IN_link_self_638 = Set[ 20 ]
    TOKENS_FOLLOWING_SELF_IN_link_self_641 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_link_self_643 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_self_645 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_link_self_647 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_self_649 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_link_category_664 = Set[ 7, 21 ]
    TOKENS_FOLLOWING_WS_IN_link_category_666 = Set[ 21 ]
    TOKENS_FOLLOWING_CATEGORY_IN_link_category_669 = Set[ 9 ]
    TOKENS_FOLLOWING_EQUALS_IN_link_category_671 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_category_673 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_link_category_675 = Set[ 10 ]
    TOKENS_FOLLOWING_QUOTE_IN_link_category_677 = Set[ 1 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_link_attributes_703 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_WS_IN_link_attributes_705 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_IN_link_attributes_708 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_X_OCCI_ATTRIBUTE_KEY_IN_x_occi_attribute_729 = Set[ 5 ]
    TOKENS_FOLLOWING_COLON_IN_x_occi_attribute_731 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_attribute_733 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_736 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_x_occi_attribute_738 = Set[ 1 ]
    TOKENS_FOLLOWING_X_OCCI_LOCATION_KEY_IN_x_occi_location_758 = Set[ 5 ]
    TOKENS_FOLLOWING_COLON_IN_x_occi_location_760 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_location_762 = Set[ 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_x_occi_location_765 = Set[ 1, 6 ]
    TOKENS_FOLLOWING_SEMICOLON_IN_x_occi_location_767 = Set[ 1 ]
    TOKENS_FOLLOWING_LOALPHA_IN_uri_783 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_UPALPHA_IN_uri_787 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DIGIT_IN_uri_791 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_AT_IN_uri_795 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_COLON_IN_uri_799 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_PERCENT_IN_uri_803 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_UNDERSCORE_IN_uri_807 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_BACKSLASH_IN_uri_811 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_PLUS_IN_uri_815 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DOT_IN_uri_819 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_TILDE_IN_uri_823 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_HASH_IN_uri_827 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_QUESTION_IN_uri_831 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_AMPERSAND_IN_uri_835 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_SLASH_IN_uri_839 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_EQUALS_IN_uri_843 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DASH_IN_uri_847 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_X_OCCI_ATTRIBUTE_KEY_IN_uri_851 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_X_OCCI_LOCATION_KEY_IN_uri_855 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_reserved_words_IN_uri_859 = Set[ 1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_LOALPHA_IN_term_872 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_reserved_words_IN_term_876 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_LOALPHA_IN_term_882 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DIGIT_IN_term_886 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DASH_IN_term_890 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_UNDERSCORE_IN_term_894 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DOT_IN_term_898 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_reserved_words_IN_term_902 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 32, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_uri_IN_scheme_922 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_class_type_931 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_title_952 = Set[ 1, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_999 = Set[ 9, 32 ]
    TOKENS_FOLLOWING_DOT_IN_attribute_1010 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_1014 = Set[ 9, 32 ]
    TOKENS_FOLLOWING_EQUALS_IN_attribute_1025 = Set[ 10, 26 ]
    TOKENS_FOLLOWING_attribute_value_IN_attribute_1027 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1071 = Set[ 1, 32, 48 ]
    TOKENS_FOLLOWING_DOT_IN_attribute_name_1082 = Set[ 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1086 = Set[ 1, 32, 48 ]
    TOKENS_FOLLOWING_T__48_IN_attribute_name_1106 = Set[ 49, 50, 51, 52 ]
    TOKENS_FOLLOWING_T__49_IN_attribute_name_1109 = Set[ 50, 51, 52 ]
    TOKENS_FOLLOWING_T__50_IN_attribute_name_1116 = Set[ 51, 52 ]
    TOKENS_FOLLOWING_T__51_IN_attribute_name_1123 = Set[ 52 ]
    TOKENS_FOLLOWING_T__52_IN_attribute_name_1129 = Set[ 1 ]
    TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1141 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_reserved_words_IN_attribute_component_1145 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1150 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DIGIT_IN_attribute_component_1154 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_DASH_IN_attribute_component_1158 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_UNDERSCORE_IN_attribute_component_1162 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_reserved_words_IN_attribute_component_1166 = Set[ 1, 7, 8, 11, 12, 13, 14, 15, 16, 20, 21, 24, 26, 29, 38, 39, 40, 41, 44, 45 ]
    TOKENS_FOLLOWING_string_IN_attribute_value_1183 = Set[ 1 ]
    TOKENS_FOLLOWING_number_IN_attribute_value_1189 = Set[ 1 ]
    TOKENS_FOLLOWING_quoted_string_IN_string_1202 = Set[ 1 ]
    TOKENS_FOLLOWING_digits_IN_number_1213 = Set[ 1, 32 ]
    TOKENS_FOLLOWING_DOT_IN_number_1217 = Set[ 10, 26 ]
    TOKENS_FOLLOWING_digits_IN_number_1219 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_reserved_words_1232 = Set[ 1 ]
    TOKENS_FOLLOWING_QUOTE_IN_quoted_string_1683 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 ]
    TOKENS_FOLLOWING_set_IN_quoted_string_1685 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 ]
    TOKENS_FOLLOWING_QUOTE_IN_quoted_string_1713 = Set[ 1 ]
    TOKENS_FOLLOWING_DIGIT_IN_digits_1722 = Set[ 1, 26 ]

  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0
end

