#!/usr/bin/env ruby
#
# OCCIANTLR.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: OCCIANTLR.g
# Generated at: 2012-06-08 21:42:57
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
    define_tokens( :T__29 => 29, :T__28 => 28, :T__27 => 27, :T__26 => 26, 
                   :T__25 => 25, :T__24 => 24, :T__23 => 23, :T__22 => 22, 
                   :ESC => 8, :T__21 => 21, :T__20 => 20, :EOF => -1, :T__9 => 9, 
                   :T__19 => 19, :T__16 => 16, :T__15 => 15, :T__18 => 18, 
                   :T__17 => 17, :T__12 => 12, :T__11 => 11, :T__14 => 14, 
                   :T__13 => 13, :T__10 => 10, :DIGIT => 7, :LOALPHA => 5, 
                   :T__42 => 42, :T__43 => 43, :T__40 => 40, :T__41 => 41, 
                   :T__30 => 30, :T__31 => 31, :T__32 => 32, :T__33 => 33, 
                   :WS => 4, :T__34 => 34, :T__35 => 35, :T__36 => 36, :T__37 => 37, 
                   :UPALPHA => 6, :T__38 => 38, :T__39 => 39 )

    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names( "WS", "LOALPHA", "UPALPHA", "DIGIT", "ESC", "'Category'", 
                    "':'", "';'", "'scheme'", "'='", "'\"'", "'class'", 
                    "'title'", "'rel'", "'location'", "'attributes'", "'actions'", 
                    "'Link'", "'<'", "'>'", "'self'", "'category'", "'X-OCCI-Attribute'", 
                    "'X-OCCI-Location'", "'@'", "'%'", "'_'", "'\\\\'", 
                    "'+'", "'.'", "'~'", "'#'", "'?'", "'&'", "'/'", "'-'", 
                    "'action'", "'kind'", "'mixin'", "'\\''" )
    
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
                     :string, :number ].freeze


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
    # 25:1: category returns [hash] : 'Category' ':' category_value ;
    # 
    def category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )
      hash = nil
      category_value1 = nil

      begin
        # at line 26:4: 'Category' ':' category_value
        match( T__9, TOKENS_FOLLOWING_T__9_IN_category_39 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_category_41 )
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
    # 27:3: category_value returns [hash] : category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( ';' )? ;
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
        # at line 29:15: category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( ';' )?
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

        if ( look_1_0 == T__11 )
          look_1_1 = @input.peek( 2 )

          if ( look_1_1 == WS )
            look_1_3 = @input.peek( 3 )

            if ( look_1_3 == T__16 )
              alt_1 = 1
            end
          elsif ( look_1_1 == T__16 )
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

        if ( look_2_0 == T__11 )
          look_2_1 = @input.peek( 2 )

          if ( look_2_1 == WS )
            look_2_3 = @input.peek( 3 )

            if ( look_2_3 == T__17 )
              alt_2 = 1
            end
          elsif ( look_2_1 == T__17 )
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

        if ( look_3_0 == T__11 )
          look_3_1 = @input.peek( 2 )

          if ( look_3_1 == WS )
            look_3_3 = @input.peek( 3 )

            if ( look_3_3 == T__18 )
              alt_3 = 1
            end
          elsif ( look_3_1 == T__18 )
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

        if ( look_4_0 == T__11 )
          look_4_1 = @input.peek( 2 )

          if ( look_4_1 == WS )
            look_4_3 = @input.peek( 3 )

            if ( look_4_3 == T__19 )
              alt_4 = 1
            end
          elsif ( look_4_1 == T__19 )
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

        if ( look_5_0 == T__11 )
          look_5_1 = @input.peek( 2 )

          if ( look_5_1 == WS || look_5_1 == T__20 )
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
        # at line 29:148: ( ';' )?
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == T__11 )
          alt_6 = 1
        end
        case alt_6
        when 1
          # at line 29:148: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_category_value_96 )

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
    # 43:3: category_scheme returns [value] : ';' ( WS )? 'scheme' '=' '\"' scheme '\"' ;
    # 
    def category_scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )
      value = nil
      scheme11 = nil

      begin
        # at line 43:37: ';' ( WS )? 'scheme' '=' '\"' scheme '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_scheme_157 )
        # at line 43:41: ( WS )?
        alt_8 = 2
        look_8_0 = @input.peek( 1 )

        if ( look_8_0 == WS )
          alt_8 = 1
        end
        case alt_8
        when 1
          # at line 43:41: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_scheme_159 )

        end
        match( T__12, TOKENS_FOLLOWING_T__12_IN_category_scheme_162 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_scheme_164 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_scheme_166 )
        @state.following.push( TOKENS_FOLLOWING_scheme_IN_category_scheme_168 )
        scheme11 = scheme
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_scheme_170 )
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
    # 45:3: category_class returns [value] : ';' ( WS )? 'class' '=' '\"' class_type '\"' ;
    # 
    def category_class
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )
      value = nil
      class_type12 = nil

      begin
        # at line 45:37: ';' ( WS )? 'class' '=' '\"' class_type '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_class_199 )
        # at line 45:41: ( WS )?
        alt_9 = 2
        look_9_0 = @input.peek( 1 )

        if ( look_9_0 == WS )
          alt_9 = 1
        end
        case alt_9
        when 1
          # at line 45:41: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_class_201 )

        end
        match( T__15, TOKENS_FOLLOWING_T__15_IN_category_class_204 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_class_206 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_class_208 )
        @state.following.push( TOKENS_FOLLOWING_class_type_IN_category_class_210 )
        class_type12 = class_type
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_class_212 )
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
    # 47:3: category_title returns [value] : ';' ( WS )? 'title' '=' '\"' title '\"' ;
    # 
    def category_title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )
      value = nil
      title13 = nil

      begin
        # at line 47:37: ';' ( WS )? 'title' '=' '\"' title '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_title_237 )
        # at line 47:41: ( WS )?
        alt_10 = 2
        look_10_0 = @input.peek( 1 )

        if ( look_10_0 == WS )
          alt_10 = 1
        end
        case alt_10
        when 1
          # at line 47:41: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_title_239 )

        end
        match( T__16, TOKENS_FOLLOWING_T__16_IN_category_title_242 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_title_244 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_title_246 )
        @state.following.push( TOKENS_FOLLOWING_title_IN_category_title_248 )
        title13 = title
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_title_250 )
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
    # 49:3: category_rel returns [value] : ';' ( WS )? 'rel' '=' '\"' uri '\"' ;
    # 
    def category_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )
      value = nil
      uri14 = nil

      begin
        # at line 49:35: ';' ( WS )? 'rel' '=' '\"' uri '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_rel_277 )
        # at line 49:39: ( WS )?
        alt_11 = 2
        look_11_0 = @input.peek( 1 )

        if ( look_11_0 == WS )
          alt_11 = 1
        end
        case alt_11
        when 1
          # at line 49:39: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_rel_279 )

        end
        match( T__17, TOKENS_FOLLOWING_T__17_IN_category_rel_282 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_rel_284 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_rel_286 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_rel_288 )
        uri14 = uri
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_rel_290 )
        # --> action
         value = ( uri14 && @input.to_s( uri14.start, uri14.stop ) ) 
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
    # 51:3: category_location returns [value] : ';' ( WS )? 'location' '=' '\"' uri '\"' ;
    # 
    def category_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )
      value = nil
      uri15 = nil

      begin
        # at line 51:39: ';' ( WS )? 'location' '=' '\"' uri '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_location_315 )
        # at line 51:43: ( WS )?
        alt_12 = 2
        look_12_0 = @input.peek( 1 )

        if ( look_12_0 == WS )
          alt_12 = 1
        end
        case alt_12
        when 1
          # at line 51:43: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_location_317 )

        end
        match( T__18, TOKENS_FOLLOWING_T__18_IN_category_location_320 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_location_322 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_location_324 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_location_326 )
        uri15 = uri
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_location_328 )
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
    # 53:3: category_attributes returns [hash] : ';' ( WS )? 'attributes' '=' '\"' (attr= attribute_name ( WS )? )+ '\"' ;
    # 
    def category_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )
      hash = nil
      attr = nil
      # - - - - @init action - - - -
      hash = Hashie::Mash.new

      begin
        # at line 54:10: ';' ( WS )? 'attributes' '=' '\"' (attr= attribute_name ( WS )? )+ '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_attributes_367 )
        # at line 54:14: ( WS )?
        alt_13 = 2
        look_13_0 = @input.peek( 1 )

        if ( look_13_0 == WS )
          alt_13 = 1
        end
        case alt_13
        when 1
          # at line 54:14: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_369 )

        end
        match( T__19, TOKENS_FOLLOWING_T__19_IN_category_attributes_372 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_attributes_374 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_attributes_376 )
        # at file 54:39: (attr= attribute_name ( WS )? )+
        match_count_15 = 0
        while true
          alt_15 = 2
          look_15_0 = @input.peek( 1 )

          if ( look_15_0 == LOALPHA )
            alt_15 = 1

          end
          case alt_15
          when 1
            # at line 54:41: attr= attribute_name ( WS )?
            @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_category_attributes_382 )
            attr = attribute_name
            @state.following.pop
            # --> action
             hash.merge!(attr) 
            # <-- action
            # at line 54:89: ( WS )?
            alt_14 = 2
            look_14_0 = @input.peek( 1 )

            if ( look_14_0 == WS )
              alt_14 = 1
            end
            case alt_14
            when 1
              # at line 54:89: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_386 )

            end

          else
            match_count_15 > 0 and break
            eee = EarlyExit(15)


            raise eee
          end
          match_count_15 += 1
        end

        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_attributes_392 )

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
    # 55:3: category_actions returns [array] : ';' ( WS )? 'actions' '=' '\"' (act= uri ( WS )? )+ '\"' ;
    # 
    def category_actions
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )
      array = nil
      act = nil
      # - - - - @init action - - - -
      array = Array.new

      begin
        # at line 56:10: ';' ( WS )? 'actions' '=' '\"' (act= uri ( WS )? )+ '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_actions_422 )
        # at line 56:14: ( WS )?
        alt_16 = 2
        look_16_0 = @input.peek( 1 )

        if ( look_16_0 == WS )
          alt_16 = 1
        end
        case alt_16
        when 1
          # at line 56:14: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_424 )

        end
        match( T__20, TOKENS_FOLLOWING_T__20_IN_category_actions_427 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_actions_429 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_actions_431 )
        # at file 56:36: (act= uri ( WS )? )+
        match_count_18 = 0
        while true
          alt_18 = 2
          look_18_0 = @input.peek( 1 )

          if ( look_18_0.between?( LOALPHA, DIGIT ) || look_18_0 == T__10 || look_18_0 == T__13 || look_18_0.between?( T__28, T__42 ) )
            alt_18 = 1

          end
          case alt_18
          when 1
            # at line 56:38: act= uri ( WS )?
            @state.following.push( TOKENS_FOLLOWING_uri_IN_category_actions_437 )
            act = uri
            @state.following.pop
            # --> action
             array << ( act && @input.to_s( act.start, act.stop ) ) 
            # <-- action
            # at line 56:69: ( WS )?
            alt_17 = 2
            look_17_0 = @input.peek( 1 )

            if ( look_17_0 == WS )
              alt_17 = 1
            end
            case alt_17
            when 1
              # at line 56:69: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_441 )

            end

          else
            match_count_18 > 0 and break
            eee = EarlyExit(18)


            raise eee
          end
          match_count_18 += 1
        end

        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_actions_447 )

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
    # 67:1: link returns [hash] : 'Link' ':' link_value ;
    # 
    def link
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )
      hash = nil
      link_value16 = nil

      begin
        # at line 68:4: 'Link' ':' link_value
        match( T__21, TOKENS_FOLLOWING_T__21_IN_link_464 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_link_466 )
        @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_468 )
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
    # 69:2: link_value returns [hash] : link_target link_rel ( link_self )? ( link_category )? link_attributes ( ';' )? ;
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
        # at line 71:6: link_target link_rel ( link_self )? ( link_category )? link_attributes ( ';' )?
        @state.following.push( TOKENS_FOLLOWING_link_target_IN_link_value_490 )
        link_target17 = link_target
        @state.following.pop
        # --> action
         hash[:target] = link_target17 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_rel_IN_link_value_499 )
        link_rel18 = link_rel
        @state.following.pop
        # --> action
         hash[:rel] = link_rel18 
        # <-- action
        # at line 73:6: ( link_self )?
        alt_19 = 2
        look_19_0 = @input.peek( 1 )

        if ( look_19_0 == T__11 )
          look_19_1 = @input.peek( 2 )

          if ( look_19_1 == WS )
            look_19_3 = @input.peek( 3 )

            if ( look_19_3 == T__24 )
              alt_19 = 1
            end
          elsif ( look_19_1 == T__24 )
            alt_19 = 1
          end
        end
        case alt_19
        when 1
          # at line 73:6: link_self
          @state.following.push( TOKENS_FOLLOWING_link_self_IN_link_value_508 )
          link_self19 = link_self
          @state.following.pop

        end
        # --> action
         hash[:self] = link_self19 
        # <-- action
        # at line 74:6: ( link_category )?
        alt_20 = 2
        look_20_0 = @input.peek( 1 )

        if ( look_20_0 == T__11 )
          look_20_1 = @input.peek( 2 )

          if ( look_20_1 == WS )
            look_20_3 = @input.peek( 3 )

            if ( look_20_3 == T__25 )
              alt_20 = 1
            end
          elsif ( look_20_1 == T__25 )
            alt_20 = 1
          end
        end
        case alt_20
        when 1
          # at line 74:6: link_category
          @state.following.push( TOKENS_FOLLOWING_link_category_IN_link_value_518 )
          link_category20 = link_category
          @state.following.pop

        end
        # --> action
         hash[:category] = link_category20 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_attributes_IN_link_value_528 )
        link_attributes21 = link_attributes
        @state.following.pop
        # --> action
         hash[:attributes] = link_attributes21 
        # <-- action
        # at line 76:6: ( ';' )?
        alt_21 = 2
        look_21_0 = @input.peek( 1 )

        if ( look_21_0 == T__11 )
          alt_21 = 1
        end
        case alt_21
        when 1
          # at line 76:6: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_link_value_537 )

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
    # 78:2: link_target returns [value] : ( WS )? '<' uri '>' ;
    # 
    def link_target
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )
      value = nil
      uri22 = nil

      begin
        # at line 78:32: ( WS )? '<' uri '>'
        # at line 78:32: ( WS )?
        alt_22 = 2
        look_22_0 = @input.peek( 1 )

        if ( look_22_0 == WS )
          alt_22 = 1
        end
        case alt_22
        when 1
          # at line 78:32: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_target_556 )

        end
        match( T__22, TOKENS_FOLLOWING_T__22_IN_link_target_559 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_target_561 )
        uri22 = uri
        @state.following.pop
        match( T__23, TOKENS_FOLLOWING_T__23_IN_link_target_563 )
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
    # 79:2: link_rel returns [value] : ';' ( WS )? 'rel' '=' '\"' uri '\"' ;
    # 
    def link_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )
      value = nil
      uri23 = nil

      begin
        # at line 79:30: ';' ( WS )? 'rel' '=' '\"' uri '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_rel_578 )
        # at line 79:34: ( WS )?
        alt_23 = 2
        look_23_0 = @input.peek( 1 )

        if ( look_23_0 == WS )
          alt_23 = 1
        end
        case alt_23
        when 1
          # at line 79:34: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_rel_580 )

        end
        match( T__17, TOKENS_FOLLOWING_T__17_IN_link_rel_583 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_rel_585 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_rel_587 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_rel_589 )
        uri23 = uri
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_rel_591 )
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
    # 80:2: link_self returns [value] : ';' ( WS )? 'self' '=' '\"' uri '\"' ;
    # 
    def link_self
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )
      value = nil
      uri24 = nil

      begin
        # at line 80:31: ';' ( WS )? 'self' '=' '\"' uri '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_self_606 )
        # at line 80:35: ( WS )?
        alt_24 = 2
        look_24_0 = @input.peek( 1 )

        if ( look_24_0 == WS )
          alt_24 = 1
        end
        case alt_24
        when 1
          # at line 80:35: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_self_608 )

        end
        match( T__24, TOKENS_FOLLOWING_T__24_IN_link_self_611 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_self_613 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_self_615 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_self_617 )
        uri24 = uri
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_self_619 )
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
    # 81:2: link_category returns [value] : ';' ( WS )? 'category' '=' '\"' uri '\"' ;
    # 
    def link_category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )
      value = nil
      uri25 = nil

      begin
        # at line 81:35: ';' ( WS )? 'category' '=' '\"' uri '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_category_634 )
        # at line 81:39: ( WS )?
        alt_25 = 2
        look_25_0 = @input.peek( 1 )

        if ( look_25_0 == WS )
          alt_25 = 1
        end
        case alt_25
        when 1
          # at line 81:39: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_category_636 )

        end
        match( T__25, TOKENS_FOLLOWING_T__25_IN_link_category_639 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_category_641 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_category_643 )
        @state.following.push( TOKENS_FOLLOWING_uri_IN_link_category_645 )
        uri25 = uri
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_category_647 )
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
    # 82:2: link_attributes returns [hash] : ( ';' ( WS )? attribute )* ;
    # 
    def link_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )
      hash = nil
      attribute26 = nil
      # - - - - @init action - - - -
       hash = Hashie::Mash.new 

      begin
        # at line 83:8: ( ';' ( WS )? attribute )*
        # at line 83:8: ( ';' ( WS )? attribute )*
        while true # decision 27
          alt_27 = 2
          look_27_0 = @input.peek( 1 )

          if ( look_27_0 == T__11 )
            look_27_1 = @input.peek( 2 )

            if ( look_27_1.between?( WS, LOALPHA ) )
              alt_27 = 1

            end

          end
          case alt_27
          when 1
            # at line 83:9: ';' ( WS )? attribute
            match( T__11, TOKENS_FOLLOWING_T__11_IN_link_attributes_673 )
            # at line 83:13: ( WS )?
            alt_26 = 2
            look_26_0 = @input.peek( 1 )

            if ( look_26_0 == WS )
              alt_26 = 1
            end
            case alt_26
            when 1
              # at line 83:13: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_link_attributes_675 )

            end
            @state.following.push( TOKENS_FOLLOWING_attribute_IN_link_attributes_678 )
            attribute26 = attribute
            @state.following.pop
            # --> action
             hash.merge!(attribute26) 
            # <-- action

          else
            break # out of loop for decision 27
          end
        end # loop for decision 27

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
    # 95:1: x_occi_attribute returns [hash] : 'X-OCCI-Attribute' ':' ( WS )? attribute ( ';' )? ;
    # 
    def x_occi_attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )
      hash = nil
      attribute27 = nil

      begin
        # at line 96:4: 'X-OCCI-Attribute' ':' ( WS )? attribute ( ';' )?
        match( T__26, TOKENS_FOLLOWING_T__26_IN_x_occi_attribute_699 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_x_occi_attribute_701 )
        # at line 96:27: ( WS )?
        alt_28 = 2
        look_28_0 = @input.peek( 1 )

        if ( look_28_0 == WS )
          alt_28 = 1
        end
        case alt_28
        when 1
          # at line 96:27: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_attribute_703 )

        end
        @state.following.push( TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_706 )
        attribute27 = attribute
        @state.following.pop
        # at line 96:41: ( ';' )?
        alt_29 = 2
        look_29_0 = @input.peek( 1 )

        if ( look_29_0 == T__11 )
          alt_29 = 1
        end
        case alt_29
        when 1
          # at line 96:41: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_x_occi_attribute_708 )

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
    # 104:1: x_occi_location returns [uri] : 'X-OCCI-Location' ':' ( WS )? uri ( ';' )? ;
    # 
    def x_occi_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )
      uri = nil
      uri28 = nil

      begin
        # at line 105:4: 'X-OCCI-Location' ':' ( WS )? uri ( ';' )?
        match( T__27, TOKENS_FOLLOWING_T__27_IN_x_occi_location_728 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_x_occi_location_730 )
        # at line 105:26: ( WS )?
        alt_30 = 2
        look_30_0 = @input.peek( 1 )

        if ( look_30_0 == WS )
          alt_30 = 1
        end
        case alt_30
        when 1
          # at line 105:26: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_location_732 )

        end
        @state.following.push( TOKENS_FOLLOWING_uri_IN_x_occi_location_735 )
        uri28 = uri
        @state.following.pop
        # at line 105:34: ( ';' )?
        alt_31 = 2
        look_31_0 = @input.peek( 1 )

        if ( look_31_0 == T__11 )
          alt_31 = 1
        end
        case alt_31
        when 1
          # at line 105:34: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_x_occi_location_737 )

        end
        # --> action
         puts ( uri28 && @input.to_s( uri28.start, uri28.stop ) ); uri = URI.parse(( uri28 && @input.to_s( uri28.start, uri28.stop ) )) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 19 )

      end
      
      return uri
    end

    UriReturnValue = define_return_scope 

    # 
    # parser rule uri
    # 
    # (in OCCIANTLR.g)
    # 107:1: uri : ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+ ;
    # 
    def uri
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )
      return_value = UriReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 107:9: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+
        # at file 107:9: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+
        match_count_32 = 0
        while true
          alt_32 = 2
          look_32_0 = @input.peek( 1 )

          if ( look_32_0.between?( LOALPHA, DIGIT ) || look_32_0 == T__10 || look_32_0 == T__13 || look_32_0.between?( T__28, T__42 ) )
            alt_32 = 1

          end
          case alt_32
          when 1
            # at line 
            if @input.peek( 1 ).between?( LOALPHA, DIGIT ) || @input.peek(1) == T__10 || @input.peek(1) == T__13 || @input.peek( 1 ).between?( T__28, T__42 )
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            match_count_32 > 0 and break
            eee = EarlyExit(32)


            raise eee
          end
          match_count_32 += 1
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
    # 108:1: term : LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* ;
    # 
    def term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )
      return_value = TermReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 108:10: LOALPHA ( LOALPHA | DIGIT | '-' | '_' )*
        match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_term_841 )
        # at line 108:18: ( LOALPHA | DIGIT | '-' | '_' )*
        while true # decision 33
          alt_33 = 2
          look_33_0 = @input.peek( 1 )

          if ( look_33_0 == LOALPHA || look_33_0 == DIGIT || look_33_0 == T__30 || look_33_0 == T__39 )
            alt_33 = 1

          end
          case alt_33
          when 1
            # at line 
            if @input.peek(1) == LOALPHA || @input.peek(1) == DIGIT || @input.peek(1) == T__30 || @input.peek(1) == T__39
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
        # trace_out( __method__, 21 )

      end
      
      return return_value
    end

    SchemeReturnValue = define_return_scope 

    # 
    # parser rule scheme
    # 
    # (in OCCIANTLR.g)
    # 109:1: scheme : uri ;
    # 
    def scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )
      return_value = SchemeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 109:20: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_scheme_876 )
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
    # 110:1: class_type : ( 'kind' | 'mixin' | 'action' ) ;
    # 
    def class_type
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )
      return_value = ClassTypeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 110:15: ( 'kind' | 'mixin' | 'action' )
        if @input.peek( 1 ).between?( T__40, T__42 )
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
    # 111:1: title : ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* ;
    # 
    def title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )
      return_value = TitleReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 111:11: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
        # at line 111:11: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
        while true # decision 34
          alt_34 = 2
          look_34_0 = @input.peek( 1 )

          if ( look_34_0.between?( WS, T__13 ) || look_34_0.between?( T__15, T__30 ) || look_34_0.between?( T__32, T__43 ) )
            alt_34 = 1

          end
          case alt_34
          when 1
            # at line 
            if @input.peek( 1 ).between?( WS, T__13 ) || @input.peek( 1 ).between?( T__15, T__30 ) || @input.peek( 1 ).between?( T__32, T__43 )
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            break # out of loop for decision 34
          end
        end # loop for decision 34
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
    # 112:1: attribute returns [hash] : comp_first= attribute_component ( '.' comp_next= attribute_component )* '=' attribute_value ;
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
        # at line 113:6: comp_first= attribute_component ( '.' comp_next= attribute_component )* '=' attribute_value
        @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_953 )
        comp_first = attribute_component
        @state.following.pop
        # --> action
         cur_hash = hash; comp = ( comp_first && @input.to_s( comp_first.start, comp_first.stop ) ) 
        # <-- action
        # at line 114:6: ( '.' comp_next= attribute_component )*
        while true # decision 35
          alt_35 = 2
          look_35_0 = @input.peek( 1 )

          if ( look_35_0 == T__33 )
            alt_35 = 1

          end
          case alt_35
          when 1
            # at line 114:8: '.' comp_next= attribute_component
            match( T__33, TOKENS_FOLLOWING_T__33_IN_attribute_964 )
            @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_968 )
            comp_next = attribute_component
            @state.following.pop
            # --> action
             cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = ( comp_next && @input.to_s( comp_next.start, comp_next.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 35
          end
        end # loop for decision 35
        match( T__13, TOKENS_FOLLOWING_T__13_IN_attribute_979 )
        @state.following.push( TOKENS_FOLLOWING_attribute_value_IN_attribute_981 )
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
    # 116:1: attribute_name returns [hash] : comp_first= attribute_component ( '.' comp_next= attribute_component )* ;
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
        # at line 117:27: comp_first= attribute_component ( '.' comp_next= attribute_component )*
        @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1025 )
        comp_first = attribute_component
        @state.following.pop
        # --> action
         cur_hash = hash; comp = ( comp_first && @input.to_s( comp_first.start, comp_first.stop ) ) 
        # <-- action
        # at line 118:6: ( '.' comp_next= attribute_component )*
        while true # decision 36
          alt_36 = 2
          look_36_0 = @input.peek( 1 )

          if ( look_36_0 == T__33 )
            alt_36 = 1

          end
          case alt_36
          when 1
            # at line 118:8: '.' comp_next= attribute_component
            match( T__33, TOKENS_FOLLOWING_T__33_IN_attribute_name_1036 )
            @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1040 )
            comp_next = attribute_component
            @state.following.pop
            # --> action
             cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = ( comp_next && @input.to_s( comp_next.start, comp_next.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 36
          end
        end # loop for decision 36
        # --> action
         cur_hash[comp.to_sym] = ATTRIBUTE 
        # <-- action

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
    # 120:1: attribute_component : LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* ;
    # 
    def attribute_component
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )
      return_value = AttributeComponentReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 120:23: LOALPHA ( LOALPHA | DIGIT | '-' | '_' )*
        match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1058 )
        # at line 120:31: ( LOALPHA | DIGIT | '-' | '_' )*
        while true # decision 37
          alt_37 = 2
          look_37_0 = @input.peek( 1 )

          if ( look_37_0 == LOALPHA || look_37_0 == DIGIT || look_37_0 == T__30 || look_37_0 == T__39 )
            alt_37 = 1

          end
          case alt_37
          when 1
            # at line 
            if @input.peek(1) == LOALPHA || @input.peek(1) == DIGIT || @input.peek(1) == T__30 || @input.peek(1) == T__39
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            break # out of loop for decision 37
          end
        end # loop for decision 37
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
    # 121:1: attribute_value returns [value] : ( string | number ) ;
    # 
    def attribute_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )
      value = nil
      string30 = nil
      number31 = nil

      begin
        # at line 121:35: ( string | number )
        # at line 121:35: ( string | number )
        alt_38 = 2
        look_38_0 = @input.peek( 1 )

        if ( look_38_0 == T__14 )
          alt_38 = 1
        elsif ( look_38_0 == EOF || look_38_0 == DIGIT || look_38_0 == T__11 || look_38_0 == T__33 )
          alt_38 = 2
        else
          raise NoViableAlternative( "", 38, 0 )
        end
        case alt_38
        when 1
          # at line 121:37: string
          @state.following.push( TOKENS_FOLLOWING_string_IN_attribute_value_1090 )
          string30 = string
          @state.following.pop
          # --> action
           value = ( string30 && @input.to_s( string30.start, string30.stop ) ) 
          # <-- action

        when 2
          # at line 121:71: number
          @state.following.push( TOKENS_FOLLOWING_number_IN_attribute_value_1096 )
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
    # 122:1: string : ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' ) ;
    # 
    def string
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )
      return_value = StringReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 122:12: ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' )
        # at line 122:12: ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' )
        # at line 122:14: '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"'
        match( T__14, TOKENS_FOLLOWING_T__14_IN_string_1111 )
        # at line 122:18: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
        while true # decision 39
          alt_39 = 2
          look_39_0 = @input.peek( 1 )

          if ( look_39_0.between?( WS, T__13 ) || look_39_0.between?( T__15, T__30 ) || look_39_0.between?( T__32, T__43 ) )
            alt_39 = 1

          end
          case alt_39
          when 1
            # at line 
            if @input.peek( 1 ).between?( WS, T__13 ) || @input.peek( 1 ).between?( T__15, T__30 ) || @input.peek( 1 ).between?( T__32, T__43 )
              @input.consume
              @state.error_recovery = false
            else
              mse = MismatchedSet( nil )
              raise mse
            end



          else
            break # out of loop for decision 39
          end
        end # loop for decision 39
        match( T__14, TOKENS_FOLLOWING_T__14_IN_string_1141 )

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
    # 123:1: number : ( ( DIGIT )* ( '.' ( DIGIT )+ )? ) ;
    # 
    def number
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )
      return_value = NumberReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 123:12: ( ( DIGIT )* ( '.' ( DIGIT )+ )? )
        # at line 123:12: ( ( DIGIT )* ( '.' ( DIGIT )+ )? )
        # at line 123:14: ( DIGIT )* ( '.' ( DIGIT )+ )?
        # at line 123:14: ( DIGIT )*
        while true # decision 40
          alt_40 = 2
          look_40_0 = @input.peek( 1 )

          if ( look_40_0 == DIGIT )
            alt_40 = 1

          end
          case alt_40
          when 1
            # at line 123:14: DIGIT
            match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_number_1153 )

          else
            break # out of loop for decision 40
          end
        end # loop for decision 40
        # at line 123:21: ( '.' ( DIGIT )+ )?
        alt_42 = 2
        look_42_0 = @input.peek( 1 )

        if ( look_42_0 == T__33 )
          alt_42 = 1
        end
        case alt_42
        when 1
          # at line 123:23: '.' ( DIGIT )+
          match( T__33, TOKENS_FOLLOWING_T__33_IN_number_1158 )
          # at file 123:27: ( DIGIT )+
          match_count_41 = 0
          while true
            alt_41 = 2
            look_41_0 = @input.peek( 1 )

            if ( look_41_0 == DIGIT )
              alt_41 = 1

            end
            case alt_41
            when 1
              # at line 123:27: DIGIT
              match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_number_1160 )

            else
              match_count_41 > 0 and break
              eee = EarlyExit(41)


              raise eee
            end
            match_count_41 += 1
          end


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



    TOKENS_FOLLOWING_T__9_IN_category_39 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_category_41 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_category_value_IN_category_43 = Set[ 1 ]
    TOKENS_FOLLOWING_category_term_IN_category_value_75 = Set[ 11 ]
    TOKENS_FOLLOWING_category_scheme_IN_category_value_77 = Set[ 11 ]
    TOKENS_FOLLOWING_category_class_IN_category_value_79 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_title_IN_category_value_81 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_rel_IN_category_value_84 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_location_IN_category_value_87 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_attributes_IN_category_value_90 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_actions_IN_category_value_93 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_category_value_96 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_category_term_128 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_term_IN_category_term_131 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_scheme_157 = Set[ 4, 12 ]
    TOKENS_FOLLOWING_WS_IN_category_scheme_159 = Set[ 12 ]
    TOKENS_FOLLOWING_T__12_IN_category_scheme_162 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_scheme_164 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_scheme_166 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_scheme_IN_category_scheme_168 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_scheme_170 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_class_199 = Set[ 4, 15 ]
    TOKENS_FOLLOWING_WS_IN_category_class_201 = Set[ 15 ]
    TOKENS_FOLLOWING_T__15_IN_category_class_204 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_class_206 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_class_208 = Set[ 40, 41, 42 ]
    TOKENS_FOLLOWING_class_type_IN_category_class_210 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_class_212 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_title_237 = Set[ 4, 16 ]
    TOKENS_FOLLOWING_WS_IN_category_title_239 = Set[ 16 ]
    TOKENS_FOLLOWING_T__16_IN_category_title_242 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_title_244 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_title_246 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_title_IN_category_title_248 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_title_250 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_rel_277 = Set[ 4, 17 ]
    TOKENS_FOLLOWING_WS_IN_category_rel_279 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_category_rel_282 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_rel_284 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_rel_286 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_category_rel_288 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_rel_290 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_location_315 = Set[ 4, 18 ]
    TOKENS_FOLLOWING_WS_IN_category_location_317 = Set[ 18 ]
    TOKENS_FOLLOWING_T__18_IN_category_location_320 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_location_322 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_location_324 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_category_location_326 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_location_328 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_attributes_367 = Set[ 4, 19 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_369 = Set[ 19 ]
    TOKENS_FOLLOWING_T__19_IN_category_attributes_372 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_attributes_374 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_attributes_376 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_name_IN_category_attributes_382 = Set[ 4, 5, 14 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_386 = Set[ 5, 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_attributes_392 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_actions_422 = Set[ 4, 20 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_424 = Set[ 20 ]
    TOKENS_FOLLOWING_T__20_IN_category_actions_427 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_actions_429 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_actions_431 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_category_actions_437 = Set[ 4, 5, 6, 7, 10, 13, 14, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_441 = Set[ 5, 6, 7, 10, 13, 14, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_T__14_IN_category_actions_447 = Set[ 1 ]
    TOKENS_FOLLOWING_T__21_IN_link_464 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_link_466 = Set[ 4, 22 ]
    TOKENS_FOLLOWING_link_value_IN_link_468 = Set[ 1 ]
    TOKENS_FOLLOWING_link_target_IN_link_value_490 = Set[ 11 ]
    TOKENS_FOLLOWING_link_rel_IN_link_value_499 = Set[ 11 ]
    TOKENS_FOLLOWING_link_self_IN_link_value_508 = Set[ 11 ]
    TOKENS_FOLLOWING_link_category_IN_link_value_518 = Set[ 11 ]
    TOKENS_FOLLOWING_link_attributes_IN_link_value_528 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_link_value_537 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_link_target_556 = Set[ 22 ]
    TOKENS_FOLLOWING_T__22_IN_link_target_559 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_link_target_561 = Set[ 23 ]
    TOKENS_FOLLOWING_T__23_IN_link_target_563 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_rel_578 = Set[ 4, 17 ]
    TOKENS_FOLLOWING_WS_IN_link_rel_580 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_link_rel_583 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_rel_585 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_rel_587 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_link_rel_589 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_rel_591 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_self_606 = Set[ 4, 24 ]
    TOKENS_FOLLOWING_WS_IN_link_self_608 = Set[ 24 ]
    TOKENS_FOLLOWING_T__24_IN_link_self_611 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_self_613 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_self_615 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_link_self_617 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_self_619 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_category_634 = Set[ 4, 25 ]
    TOKENS_FOLLOWING_WS_IN_link_category_636 = Set[ 25 ]
    TOKENS_FOLLOWING_T__25_IN_link_category_639 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_category_641 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_category_643 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_link_category_645 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_category_647 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_attributes_673 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_WS_IN_link_attributes_675 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_attribute_IN_link_attributes_678 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__26_IN_x_occi_attribute_699 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_x_occi_attribute_701 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_attribute_703 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_706 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_x_occi_attribute_708 = Set[ 1 ]
    TOKENS_FOLLOWING_T__27_IN_x_occi_location_728 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_x_occi_location_730 = Set[ 4, 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_location_732 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_uri_IN_x_occi_location_735 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_x_occi_location_737 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_uri_751 = Set[ 1, 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_LOALPHA_IN_term_841 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_set_IN_term_843 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_uri_IN_scheme_876 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_class_type_885 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_title_906 = Set[ 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_953 = Set[ 13, 33 ]
    TOKENS_FOLLOWING_T__33_IN_attribute_964 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_968 = Set[ 13, 33 ]
    TOKENS_FOLLOWING_T__13_IN_attribute_979 = Set[ 7, 14, 33 ]
    TOKENS_FOLLOWING_attribute_value_IN_attribute_981 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1025 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_T__33_IN_attribute_name_1036 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1040 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1058 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_set_IN_attribute_component_1060 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_string_IN_attribute_value_1090 = Set[ 1 ]
    TOKENS_FOLLOWING_number_IN_attribute_value_1096 = Set[ 1 ]
    TOKENS_FOLLOWING_T__14_IN_string_1111 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_set_IN_string_1113 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_T__14_IN_string_1141 = Set[ 1 ]
    TOKENS_FOLLOWING_DIGIT_IN_number_1153 = Set[ 1, 7, 33 ]
    TOKENS_FOLLOWING_T__33_IN_number_1158 = Set[ 7 ]
    TOKENS_FOLLOWING_DIGIT_IN_number_1160 = Set[ 1, 7 ]

  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0
end

