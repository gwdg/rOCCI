#!/usr/bin/env ruby
#
# Occi.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: Occi.g
# Generated at: 2012-03-21 18:34:24
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


module Occi
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
    @grammar_home = Occi

    RULE_METHODS = [ :category, :category_value, :category_term, :category_scheme, 
                     :category_class, :category_title, :category_rel, :category_location, 
                     :category_attributes, :category_actions, :link, :link_value, 
                     :link_target, :link_rel, :link_self, :link_category, 
                     :link_attributes, :x_occi_attribute, :x_occi_location, 
                     :uri, :term, :scheme, :class_type, :title, :rel, :location, 
                     :attribute, :attribute_name, :attribute_component, 
                     :attribute_value, :action_location, :target, :self_location, 
                     :category_name ].freeze


    include TokenData

    begin
      generated_using( "Occi.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
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
    # (in Occi.g)
    # 44:1: category returns [hash] : 'Category' ':' category_value ;
    # 
    def category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )
      hash = nil
      category_value1 = nil
      # - - - - @init action - - - -
      hash = Hash.new

      begin
        # at line 46:2: 'Category' ':' category_value
        match( T__9, TOKENS_FOLLOWING_T__9_IN_category_38 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_category_40 )
        @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_42 )
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
    # (in Occi.g)
    # 47:3: category_value returns [hash] : category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( ';' )? ;
    # 
    def category_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )
      hash = nil
      category_term2 = nil
      category_scheme3 = nil
      category_class4 = nil
      category_title5 = nil
      category_rel6 = nil
      category_location7 = nil
      category_attributes8 = nil
      category_actions9 = nil
      # - - - - @init action - - - -
       hash = Hash.new 

      begin
        # at line 49:15: category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( ';' )?
        @state.following.push( TOKENS_FOLLOWING_category_term_IN_category_value_74 )
        category_term2 = category_term
        @state.following.pop
        # --> action
         hash[:term] = category_term2 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_category_scheme_IN_category_value_92 )
        category_scheme3 = category_scheme
        @state.following.pop
        # --> action
         hash[:scheme] = category_scheme3 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_category_class_IN_category_value_110 )
        category_class4 = category_class
        @state.following.pop
        # --> action
         hash[:class] = category_class4 
        # <-- action
        # at line 52:15: ( category_title )?
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
          # at line 52:15: category_title
          @state.following.push( TOKENS_FOLLOWING_category_title_IN_category_value_128 )
          category_title5 = category_title
          @state.following.pop

        end
        # --> action
         hash[:title] = category_title5 
        # <-- action
        # at line 53:15: ( category_rel )?
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
          # at line 53:15: category_rel
          @state.following.push( TOKENS_FOLLOWING_category_rel_IN_category_value_147 )
          category_rel6 = category_rel
          @state.following.pop

        end
        # --> action
         hash[:rel] = category_rel6 
        # <-- action
        # at line 54:15: ( category_location )?
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
          # at line 54:15: category_location
          @state.following.push( TOKENS_FOLLOWING_category_location_IN_category_value_166 )
          category_location7 = category_location
          @state.following.pop

        end
        # --> action
         hash[:location] = category_location7 
        # <-- action
        # at line 55:15: ( category_attributes )?
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
          # at line 55:15: category_attributes
          @state.following.push( TOKENS_FOLLOWING_category_attributes_IN_category_value_185 )
          category_attributes8 = category_attributes
          @state.following.pop

        end
        # --> action
         hash[:attributes] = category_attributes8 
        # <-- action
        # at line 56:15: ( category_actions )?
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
          # at line 56:15: category_actions
          @state.following.push( TOKENS_FOLLOWING_category_actions_IN_category_value_204 )
          category_actions9 = category_actions
          @state.following.pop

        end
        # --> action
         hash[:actions] = category_actions9 
        # <-- action
        # at line 57:15: ( ';' )?
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == T__11 )
          alt_6 = 1
        end
        case alt_6
        when 1
          # at line 57:15: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_category_value_223 )

        end

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
    # (in Occi.g)
    # 59:3: category_term returns [term_value] : ( WS )? term ;
    # 
    def category_term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )
      term_value = nil
      term10 = nil

      begin
        # at line 59:42: ( WS )? term
        # at line 59:42: ( WS )?
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == WS )
          alt_7 = 1
        end
        case alt_7
        when 1
          # at line 59:42: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_term_254 )

        end
        @state.following.push( TOKENS_FOLLOWING_term_IN_category_term_257 )
        term10 = term
        @state.following.pop
        # --> action
         term_value = ( term10 && @input.to_s( term10.start, term10.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 3 )

      end
      
      return term_value
    end


    # 
    # parser rule category_scheme
    # 
    # (in Occi.g)
    # 61:3: category_scheme returns [scheme_value] : ';' ( WS )? 'scheme' '=' '\"' scheme '\"' ;
    # 
    def category_scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )
      scheme_value = nil
      scheme11 = nil

      begin
        # at line 61:45: ';' ( WS )? 'scheme' '=' '\"' scheme '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_scheme_287 )
        # at line 61:49: ( WS )?
        alt_8 = 2
        look_8_0 = @input.peek( 1 )

        if ( look_8_0 == WS )
          alt_8 = 1
        end
        case alt_8
        when 1
          # at line 61:49: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_scheme_289 )

        end
        match( T__12, TOKENS_FOLLOWING_T__12_IN_category_scheme_292 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_scheme_294 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_scheme_296 )
        @state.following.push( TOKENS_FOLLOWING_scheme_IN_category_scheme_298 )
        scheme11 = scheme
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_scheme_300 )
        # --> action
         scheme_value = ( scheme11 && @input.to_s( scheme11.start, scheme11.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 4 )

      end
      
      return scheme_value
    end


    # 
    # parser rule category_class
    # 
    # (in Occi.g)
    # 63:3: category_class returns [class_value] : ';' ( WS )? 'class' '=' '\"' class_type '\"' ;
    # 
    def category_class
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )
      class_value = nil
      class_type12 = nil

      begin
        # at line 63:43: ';' ( WS )? 'class' '=' '\"' class_type '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_class_330 )
        # at line 63:47: ( WS )?
        alt_9 = 2
        look_9_0 = @input.peek( 1 )

        if ( look_9_0 == WS )
          alt_9 = 1
        end
        case alt_9
        when 1
          # at line 63:47: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_class_332 )

        end
        match( T__15, TOKENS_FOLLOWING_T__15_IN_category_class_335 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_class_337 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_class_339 )
        @state.following.push( TOKENS_FOLLOWING_class_type_IN_category_class_341 )
        class_type12 = class_type
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_class_343 )
        # --> action
         class_value = ( class_type12 && @input.to_s( class_type12.start, class_type12.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 5 )

      end
      
      return class_value
    end


    # 
    # parser rule category_title
    # 
    # (in Occi.g)
    # 65:3: category_title returns [title_value] : ';' ( WS )? 'title' '=' '\"' title '\"' ;
    # 
    def category_title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )
      title_value = nil
      title13 = nil

      begin
        # at line 65:43: ';' ( WS )? 'title' '=' '\"' title '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_title_370 )
        # at line 65:47: ( WS )?
        alt_10 = 2
        look_10_0 = @input.peek( 1 )

        if ( look_10_0 == WS )
          alt_10 = 1
        end
        case alt_10
        when 1
          # at line 65:47: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_title_372 )

        end
        match( T__16, TOKENS_FOLLOWING_T__16_IN_category_title_375 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_title_377 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_title_379 )
        @state.following.push( TOKENS_FOLLOWING_title_IN_category_title_381 )
        title13 = title
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_title_383 )
        # --> action
         title_value = ( title13 && @input.to_s( title13.start, title13.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 6 )

      end
      
      return title_value
    end


    # 
    # parser rule category_rel
    # 
    # (in Occi.g)
    # 67:3: category_rel returns [rel_value] : ';' ( WS )? 'rel' '=' '\"' rel '\"' ;
    # 
    def category_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )
      rel_value = nil
      rel14 = nil

      begin
        # at line 67:39: ';' ( WS )? 'rel' '=' '\"' rel '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_rel_411 )
        # at line 67:43: ( WS )?
        alt_11 = 2
        look_11_0 = @input.peek( 1 )

        if ( look_11_0 == WS )
          alt_11 = 1
        end
        case alt_11
        when 1
          # at line 67:43: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_rel_413 )

        end
        match( T__17, TOKENS_FOLLOWING_T__17_IN_category_rel_416 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_rel_418 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_rel_420 )
        @state.following.push( TOKENS_FOLLOWING_rel_IN_category_rel_422 )
        rel14 = rel
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_rel_424 )
        # --> action
         rel_value = ( rel14 && @input.to_s( rel14.start, rel14.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 7 )

      end
      
      return rel_value
    end


    # 
    # parser rule category_location
    # 
    # (in Occi.g)
    # 69:3: category_location returns [location_value] : ';' ( WS )? 'location' '=' '\"' location '\"' ;
    # 
    def category_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )
      location_value = nil
      location15 = nil

      begin
        # at line 69:48: ';' ( WS )? 'location' '=' '\"' location '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_location_450 )
        # at line 69:52: ( WS )?
        alt_12 = 2
        look_12_0 = @input.peek( 1 )

        if ( look_12_0 == WS )
          alt_12 = 1
        end
        case alt_12
        when 1
          # at line 69:52: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_location_452 )

        end
        match( T__18, TOKENS_FOLLOWING_T__18_IN_category_location_455 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_location_457 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_location_459 )
        @state.following.push( TOKENS_FOLLOWING_location_IN_category_location_461 )
        location15 = location
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_location_463 )
        # --> action
         location_value = ( location15 && @input.to_s( location15.start, location15.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 8 )

      end
      
      return location_value
    end


    # 
    # parser rule category_attributes
    # 
    # (in Occi.g)
    # 71:3: category_attributes returns [attributes_value] : ';' ( WS )? 'attributes' '=' '\"' attr= attribute_name ( ( WS )? next_attr= attribute_name )* '\"' ;
    # 
    def category_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )
      attributes_value = nil
      attr = nil
      next_attr = nil
      # - - - - @init action - - - -
      attributes_value = Array.new

      begin
        # at line 72:11: ';' ( WS )? 'attributes' '=' '\"' attr= attribute_name ( ( WS )? next_attr= attribute_name )* '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_attributes_503 )
        # at line 72:15: ( WS )?
        alt_13 = 2
        look_13_0 = @input.peek( 1 )

        if ( look_13_0 == WS )
          alt_13 = 1
        end
        case alt_13
        when 1
          # at line 72:15: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_505 )

        end
        match( T__19, TOKENS_FOLLOWING_T__19_IN_category_attributes_508 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_attributes_510 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_attributes_512 )
        @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_category_attributes_516 )
        attr = attribute_name
        @state.following.pop
        # --> action
         attributes_value << ( attr && @input.to_s( attr.start, attr.stop ) ) 
        # <-- action
        # at line 73:11: ( ( WS )? next_attr= attribute_name )*
        while true # decision 15
          alt_15 = 2
          look_15_0 = @input.peek( 1 )

          if ( look_15_0.between?( WS, LOALPHA ) )
            alt_15 = 1

          end
          case alt_15
          when 1
            # at line 73:13: ( WS )? next_attr= attribute_name
            # at line 73:13: ( WS )?
            alt_14 = 2
            look_14_0 = @input.peek( 1 )

            if ( look_14_0 == WS )
              alt_14 = 1
            end
            case alt_14
            when 1
              # at line 73:13: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_category_attributes_533 )

            end
            @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_category_attributes_538 )
            next_attr = attribute_name
            @state.following.pop
            # --> action
             attributes_value << ( next_attr && @input.to_s( next_attr.start, next_attr.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 15
          end
        end # loop for decision 15
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_attributes_546 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 9 )

      end
      
      return attributes_value
    end


    # 
    # parser rule category_actions
    # 
    # (in Occi.g)
    # 74:3: category_actions returns [actions_value] : ';' ( WS )? 'actions' '=' '\"' act= action_location ( ( WS )? next_act= action_location )* '\"' ;
    # 
    def category_actions
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )
      actions_value = nil
      act = nil
      next_act = nil
      # - - - - @init action - - - -
      actions_value = Array.new

      begin
        # at line 75:11: ';' ( WS )? 'actions' '=' '\"' act= action_location ( ( WS )? next_act= action_location )* '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_category_actions_577 )
        # at line 75:15: ( WS )?
        alt_16 = 2
        look_16_0 = @input.peek( 1 )

        if ( look_16_0 == WS )
          alt_16 = 1
        end
        case alt_16
        when 1
          # at line 75:15: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_579 )

        end
        match( T__20, TOKENS_FOLLOWING_T__20_IN_category_actions_582 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_actions_584 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_actions_586 )
        @state.following.push( TOKENS_FOLLOWING_action_location_IN_category_actions_590 )
        act = action_location
        @state.following.pop
        # --> action
         actions_value << ( act && @input.to_s( act.start, act.stop ) ) 
        # <-- action
        # at line 76:11: ( ( WS )? next_act= action_location )*
        while true # decision 18
          alt_18 = 2
          look_18_0 = @input.peek( 1 )

          if ( look_18_0.between?( WS, DIGIT ) || look_18_0 == T__10 || look_18_0 == T__13 || look_18_0.between?( T__28, T__42 ) )
            alt_18 = 1

          end
          case alt_18
          when 1
            # at line 76:13: ( WS )? next_act= action_location
            # at line 76:13: ( WS )?
            alt_17 = 2
            look_17_0 = @input.peek( 1 )

            if ( look_17_0 == WS )
              alt_17 = 1
            end
            case alt_17
            when 1
              # at line 76:13: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_category_actions_607 )

            end
            @state.following.push( TOKENS_FOLLOWING_action_location_IN_category_actions_612 )
            next_act = action_location
            @state.following.pop
            # --> action
             actions_value << ( next_act && @input.to_s( next_act.start, next_act.stop ) ) 
            # <-- action

          else
            break # out of loop for decision 18
          end
        end # loop for decision 18
        match( T__14, TOKENS_FOLLOWING_T__14_IN_category_actions_619 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 10 )

      end
      
      return actions_value
    end


    # 
    # parser rule link
    # 
    # (in Occi.g)
    # 87:1: link returns [hash] : 'Link' ':' link_value ;
    # 
    def link
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )
      hash = nil
      link_value16 = nil
      # - - - - @init action - - - -
      hash = Hash.new

      begin
        # at line 89:4: 'Link' ':' link_value
        match( T__21, TOKENS_FOLLOWING_T__21_IN_link_641 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_link_643 )
        @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_645 )
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
    # (in Occi.g)
    # 90:2: link_value returns [hash] : link_target link_rel ( link_self )? ( link_category )? link_attributes ( ';' )? ;
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
       hash = Hash.new 

      begin
        # at line 92:6: link_target link_rel ( link_self )? ( link_category )? link_attributes ( ';' )?
        @state.following.push( TOKENS_FOLLOWING_link_target_IN_link_value_667 )
        link_target17 = link_target
        @state.following.pop
        # --> action
         hash[:target] = link_target17 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_rel_IN_link_value_676 )
        link_rel18 = link_rel
        @state.following.pop
        # --> action
         hash[:rel] = link_rel18 
        # <-- action
        # at line 94:6: ( link_self )?
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
          # at line 94:6: link_self
          @state.following.push( TOKENS_FOLLOWING_link_self_IN_link_value_685 )
          link_self19 = link_self
          @state.following.pop

        end
        # --> action
         hash[:self] = link_self19 
        # <-- action
        # at line 95:6: ( link_category )?
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
          # at line 95:6: link_category
          @state.following.push( TOKENS_FOLLOWING_link_category_IN_link_value_695 )
          link_category20 = link_category
          @state.following.pop

        end
        # --> action
         hash[:category] = link_category20 
        # <-- action
        @state.following.push( TOKENS_FOLLOWING_link_attributes_IN_link_value_705 )
        link_attributes21 = link_attributes
        @state.following.pop
        # --> action
         hash[:attributes] = link_attributes21 
        # <-- action
        # at line 97:6: ( ';' )?
        alt_21 = 2
        look_21_0 = @input.peek( 1 )

        if ( look_21_0 == T__11 )
          alt_21 = 1
        end
        case alt_21
        when 1
          # at line 97:6: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_link_value_714 )

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
    # (in Occi.g)
    # 99:2: link_target returns [value] : ( WS )? '<' target '>' ;
    # 
    def link_target
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )
      value = nil
      target22 = nil

      begin
        # at line 99:32: ( WS )? '<' target '>'
        # at line 99:32: ( WS )?
        alt_22 = 2
        look_22_0 = @input.peek( 1 )

        if ( look_22_0 == WS )
          alt_22 = 1
        end
        case alt_22
        when 1
          # at line 99:32: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_target_733 )

        end
        match( T__22, TOKENS_FOLLOWING_T__22_IN_link_target_736 )
        @state.following.push( TOKENS_FOLLOWING_target_IN_link_target_738 )
        target22 = target
        @state.following.pop
        match( T__23, TOKENS_FOLLOWING_T__23_IN_link_target_740 )
        # --> action
         value = ( target22 && @input.to_s( target22.start, target22.stop ) ) 
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
    # (in Occi.g)
    # 100:2: link_rel returns [value] : ';' ( WS )? 'rel' '=' '\"' rel '\"' ;
    # 
    def link_rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )
      value = nil
      rel23 = nil

      begin
        # at line 100:30: ';' ( WS )? 'rel' '=' '\"' rel '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_rel_755 )
        # at line 100:34: ( WS )?
        alt_23 = 2
        look_23_0 = @input.peek( 1 )

        if ( look_23_0 == WS )
          alt_23 = 1
        end
        case alt_23
        when 1
          # at line 100:34: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_rel_757 )

        end
        match( T__17, TOKENS_FOLLOWING_T__17_IN_link_rel_760 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_rel_762 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_rel_764 )
        @state.following.push( TOKENS_FOLLOWING_rel_IN_link_rel_766 )
        rel23 = rel
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_rel_768 )
        # --> action
         value = ( rel23 && @input.to_s( rel23.start, rel23.stop ) ) 
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
    # (in Occi.g)
    # 101:2: link_self returns [value] : ';' ( WS )? 'self' '=' '\"' self_location '\"' ;
    # 
    def link_self
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )
      value = nil
      self_location24 = nil

      begin
        # at line 101:31: ';' ( WS )? 'self' '=' '\"' self_location '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_self_783 )
        # at line 101:35: ( WS )?
        alt_24 = 2
        look_24_0 = @input.peek( 1 )

        if ( look_24_0 == WS )
          alt_24 = 1
        end
        case alt_24
        when 1
          # at line 101:35: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_self_785 )

        end
        match( T__24, TOKENS_FOLLOWING_T__24_IN_link_self_788 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_self_790 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_self_792 )
        @state.following.push( TOKENS_FOLLOWING_self_location_IN_link_self_794 )
        self_location24 = self_location
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_self_796 )
        # --> action
         value = ( self_location24 && @input.to_s( self_location24.start, self_location24.stop ) ) 
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
    # (in Occi.g)
    # 102:2: link_category returns [value] : ';' ( WS )? 'category' '=' '\"' category_name '\"' ;
    # 
    def link_category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )
      value = nil
      category_name25 = nil

      begin
        # at line 102:35: ';' ( WS )? 'category' '=' '\"' category_name '\"'
        match( T__11, TOKENS_FOLLOWING_T__11_IN_link_category_811 )
        # at line 102:39: ( WS )?
        alt_25 = 2
        look_25_0 = @input.peek( 1 )

        if ( look_25_0 == WS )
          alt_25 = 1
        end
        case alt_25
        when 1
          # at line 102:39: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_link_category_813 )

        end
        match( T__25, TOKENS_FOLLOWING_T__25_IN_link_category_816 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_category_818 )
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_category_820 )
        @state.following.push( TOKENS_FOLLOWING_category_name_IN_link_category_822 )
        category_name25 = category_name
        @state.following.pop
        match( T__14, TOKENS_FOLLOWING_T__14_IN_link_category_824 )
        # --> action
         value = ( category_name25 && @input.to_s( category_name25.start, category_name25.stop ) ) 
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
    # (in Occi.g)
    # 103:2: link_attributes returns [value] : ( ';' ( WS )? attribute )* ;
    # 
    def link_attributes
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )
      value = nil
      attribute26 = nil
      # - - - - @init action - - - -
       value = Hash.new 

      begin
        # at line 104:8: ( ';' ( WS )? attribute )*
        # at line 104:8: ( ';' ( WS )? attribute )*
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
            # at line 104:9: ';' ( WS )? attribute
            match( T__11, TOKENS_FOLLOWING_T__11_IN_link_attributes_850 )
            # at line 104:13: ( WS )?
            alt_26 = 2
            look_26_0 = @input.peek( 1 )

            if ( look_26_0 == WS )
              alt_26 = 1
            end
            case alt_26
            when 1
              # at line 104:13: WS
              match( WS, TOKENS_FOLLOWING_WS_IN_link_attributes_852 )

            end
            @state.following.push( TOKENS_FOLLOWING_attribute_IN_link_attributes_855 )
            attribute26 = attribute
            @state.following.pop
            # --> action
             value.merge!(attribute26) 
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
      
      return value
    end


    # 
    # parser rule x_occi_attribute
    # 
    # (in Occi.g)
    # 116:1: x_occi_attribute returns [hash] : 'X-OCCI-Attribute' ':' ( WS )? attribute ( ';' )? ;
    # 
    def x_occi_attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )
      hash = nil
      attribute27 = nil
      # - - - - @init action - - - -
       hash = Hash.new 

      begin
        # at line 118:4: 'X-OCCI-Attribute' ':' ( WS )? attribute ( ';' )?
        match( T__26, TOKENS_FOLLOWING_T__26_IN_x_occi_attribute_882 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_x_occi_attribute_884 )
        # at line 118:27: ( WS )?
        alt_28 = 2
        look_28_0 = @input.peek( 1 )

        if ( look_28_0 == WS )
          alt_28 = 1
        end
        case alt_28
        when 1
          # at line 118:27: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_attribute_886 )

        end
        @state.following.push( TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_889 )
        attribute27 = attribute
        @state.following.pop
        # at line 118:41: ( ';' )?
        alt_29 = 2
        look_29_0 = @input.peek( 1 )

        if ( look_29_0 == T__11 )
          alt_29 = 1
        end
        case alt_29
        when 1
          # at line 118:41: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_x_occi_attribute_891 )

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
    # (in Occi.g)
    # 126:1: x_occi_location returns [string] : 'X-OCCI-Location' ':' ( WS )? location ( ';' )? ;
    # 
    def x_occi_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )
      string = nil
      location28 = nil
      # - - - - @init action - - - -
       string = String.new 

      begin
        # at line 128:4: 'X-OCCI-Location' ':' ( WS )? location ( ';' )?
        match( T__27, TOKENS_FOLLOWING_T__27_IN_x_occi_location_917 )
        match( T__10, TOKENS_FOLLOWING_T__10_IN_x_occi_location_919 )
        # at line 128:26: ( WS )?
        alt_30 = 2
        look_30_0 = @input.peek( 1 )

        if ( look_30_0 == WS )
          alt_30 = 1
        end
        case alt_30
        when 1
          # at line 128:26: WS
          match( WS, TOKENS_FOLLOWING_WS_IN_x_occi_location_921 )

        end
        @state.following.push( TOKENS_FOLLOWING_location_IN_x_occi_location_924 )
        location28 = location
        @state.following.pop
        # at line 128:39: ( ';' )?
        alt_31 = 2
        look_31_0 = @input.peek( 1 )

        if ( look_31_0 == T__11 )
          alt_31 = 1
        end
        case alt_31
        when 1
          # at line 128:39: ';'
          match( T__11, TOKENS_FOLLOWING_T__11_IN_x_occi_location_926 )

        end
        # --> action
         string = ( location28 && @input.to_s( location28.start, location28.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 19 )

      end
      
      return string
    end


    # 
    # parser rule uri
    # 
    # (in Occi.g)
    # 130:1: uri : ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+ ;
    # 
    def uri
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      begin
        # at line 130:7: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+
        # at file 130:7: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+
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


      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 20 )

      end
      
      return 
    end

    TermReturnValue = define_return_scope 

    # 
    # parser rule term
    # 
    # (in Occi.g)
    # 132:1: term : LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* ;
    # 
    def term
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )
      return_value = TermReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 132:10: LOALPHA ( LOALPHA | DIGIT | '-' | '_' )*
        match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_term_1029 )
        # at line 132:18: ( LOALPHA | DIGIT | '-' | '_' )*
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
    # (in Occi.g)
    # 133:1: scheme : uri ;
    # 
    def scheme
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )
      return_value = SchemeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 133:20: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_scheme_1064 )
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
    # (in Occi.g)
    # 134:1: class_type : ( 'kind' | 'mixin' | 'action' ) ;
    # 
    def class_type
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )
      return_value = ClassTypeReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 134:15: ( 'kind' | 'mixin' | 'action' )
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
    # (in Occi.g)
    # 135:1: title : ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* ;
    # 
    def title
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )
      return_value = TitleReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 135:11: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
        # at line 135:11: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
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

    RelReturnValue = define_return_scope 

    # 
    # parser rule rel
    # 
    # (in Occi.g)
    # 136:1: rel : uri ;
    # 
    def rel
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )
      return_value = RelReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 136:9: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_rel_1129 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 25 )

      end
      
      return return_value
    end

    LocationReturnValue = define_return_scope 

    # 
    # parser rule location
    # 
    # (in Occi.g)
    # 137:1: location : uri ;
    # 
    def location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )
      return_value = LocationReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 137:13: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_location_1137 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 26 )

      end
      
      return return_value
    end


    # 
    # parser rule attribute
    # 
    # (in Occi.g)
    # 138:1: attribute returns [value] : attribute_name '=' attribute_value ;
    # 
    def attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )
      value = nil
      attribute_name29 = nil
      attribute_value30 = nil
      # - - - - @init action - - - -
       value = Hash.new 

      begin
        # at line 139:6: attribute_name '=' attribute_value
        @state.following.push( TOKENS_FOLLOWING_attribute_name_IN_attribute_1157 )
        attribute_name29 = attribute_name
        @state.following.pop
        match( T__13, TOKENS_FOLLOWING_T__13_IN_attribute_1159 )
        @state.following.push( TOKENS_FOLLOWING_attribute_value_IN_attribute_1161 )
        attribute_value30 = attribute_value
        @state.following.pop
        # --> action
         value[( attribute_name29 && @input.to_s( attribute_name29.start, attribute_name29.stop ) )] = ( attribute_value30 && @input.to_s( attribute_value30.start, attribute_value30.stop ) ) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 27 )

      end
      
      return value
    end

    AttributeNameReturnValue = define_return_scope 

    # 
    # parser rule attribute_name
    # 
    # (in Occi.g)
    # 140:1: attribute_name : attribute_component ( '.' attribute_component )* ;
    # 
    def attribute_name
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )
      return_value = AttributeNameReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 140:19: attribute_component ( '.' attribute_component )*
        @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1171 )
        attribute_component
        @state.following.pop
        # at line 140:39: ( '.' attribute_component )*
        while true # decision 35
          alt_35 = 2
          look_35_0 = @input.peek( 1 )

          if ( look_35_0 == T__33 )
            alt_35 = 1

          end
          case alt_35
          when 1
            # at line 140:41: '.' attribute_component
            match( T__33, TOKENS_FOLLOWING_T__33_IN_attribute_name_1175 )
            @state.following.push( TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1177 )
            attribute_component
            @state.following.pop

          else
            break # out of loop for decision 35
          end
        end # loop for decision 35
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 28 )

      end
      
      return return_value
    end


    # 
    # parser rule attribute_component
    # 
    # (in Occi.g)
    # 141:1: attribute_component : ( LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* ) ;
    # 
    def attribute_component
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )

      begin
        # at line 141:23: ( LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* )
        # at line 141:23: ( LOALPHA ( LOALPHA | DIGIT | '-' | '_' )* )
        # at line 141:25: LOALPHA ( LOALPHA | DIGIT | '-' | '_' )*
        match( LOALPHA, TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1189 )
        # at line 141:33: ( LOALPHA | DIGIT | '-' | '_' )*
        while true # decision 36
          alt_36 = 2
          look_36_0 = @input.peek( 1 )

          if ( look_36_0 == LOALPHA || look_36_0 == DIGIT || look_36_0 == T__30 || look_36_0 == T__39 )
            alt_36 = 1

          end
          case alt_36
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
            break # out of loop for decision 36
          end
        end # loop for decision 36


      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 29 )

      end
      
      return 
    end

    AttributeValueReturnValue = define_return_scope 

    # 
    # parser rule attribute_value
    # 
    # (in Occi.g)
    # 142:1: attribute_value : ( ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' ) | ( DIGIT ( '.' DIGIT )* ) ) ;
    # 
    def attribute_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )
      return_value = AttributeValueReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 142:20: ( ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' ) | ( DIGIT ( '.' DIGIT )* ) )
        # at line 142:20: ( ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' ) | ( DIGIT ( '.' DIGIT )* ) )
        alt_39 = 2
        look_39_0 = @input.peek( 1 )

        if ( look_39_0 == T__14 )
          alt_39 = 1
        elsif ( look_39_0 == DIGIT )
          alt_39 = 2
        else
          raise NoViableAlternative( "", 39, 0 )
        end
        case alt_39
        when 1
          # at line 142:22: ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' )
          # at line 142:22: ( '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"' )
          # at line 142:24: '\"' ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )* '\"'
          match( T__14, TOKENS_FOLLOWING_T__14_IN_attribute_value_1222 )
          # at line 142:28: ( ESC | ~ ( '\\\\' | '\"' | '\\'' ) | '\\'' )*
          while true # decision 37
            alt_37 = 2
            look_37_0 = @input.peek( 1 )

            if ( look_37_0.between?( WS, T__13 ) || look_37_0.between?( T__15, T__30 ) || look_37_0.between?( T__32, T__43 ) )
              alt_37 = 1

            end
            case alt_37
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
              break # out of loop for decision 37
            end
          end # loop for decision 37
          match( T__14, TOKENS_FOLLOWING_T__14_IN_attribute_value_1252 )


        when 2
          # at line 142:76: ( DIGIT ( '.' DIGIT )* )
          # at line 142:76: ( DIGIT ( '.' DIGIT )* )
          # at line 142:78: DIGIT ( '.' DIGIT )*
          match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_attribute_value_1259 )
          # at line 142:84: ( '.' DIGIT )*
          while true # decision 38
            alt_38 = 2
            look_38_0 = @input.peek( 1 )

            if ( look_38_0 == T__33 )
              alt_38 = 1

            end
            case alt_38
            when 1
              # at line 142:86: '.' DIGIT
              match( T__33, TOKENS_FOLLOWING_T__33_IN_attribute_value_1263 )
              match( DIGIT, TOKENS_FOLLOWING_DIGIT_IN_attribute_value_1265 )

            else
              break # out of loop for decision 38
            end
          end # loop for decision 38


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

    ActionLocationReturnValue = define_return_scope 

    # 
    # parser rule action_location
    # 
    # (in Occi.g)
    # 143:1: action_location : uri ;
    # 
    def action_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )
      return_value = ActionLocationReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 143:20: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_action_location_1280 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 31 )

      end
      
      return return_value
    end

    TargetReturnValue = define_return_scope 

    # 
    # parser rule target
    # 
    # (in Occi.g)
    # 144:1: target : uri ;
    # 
    def target
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )
      return_value = TargetReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 144:12: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_target_1289 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 32 )

      end
      
      return return_value
    end

    SelfLocationReturnValue = define_return_scope 

    # 
    # parser rule self_location
    # 
    # (in Occi.g)
    # 145:1: self_location : uri ;
    # 
    def self_location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )
      return_value = SelfLocationReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 145:18: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_self_location_1297 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 33 )

      end
      
      return return_value
    end

    CategoryNameReturnValue = define_return_scope 

    # 
    # parser rule category_name
    # 
    # (in Occi.g)
    # 146:1: category_name : uri ;
    # 
    def category_name
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 34 )
      return_value = CategoryNameReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 146:18: uri
        @state.following.push( TOKENS_FOLLOWING_uri_IN_category_name_1305 )
        uri
        @state.following.pop
        # - - - - - - - rule clean up - - - - - - - -
        return_value.stop = @input.look( -1 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 34 )

      end
      
      return return_value
    end



    TOKENS_FOLLOWING_T__9_IN_category_38 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_category_40 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_category_value_IN_category_42 = Set[ 1 ]
    TOKENS_FOLLOWING_category_term_IN_category_value_74 = Set[ 11 ]
    TOKENS_FOLLOWING_category_scheme_IN_category_value_92 = Set[ 11 ]
    TOKENS_FOLLOWING_category_class_IN_category_value_110 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_title_IN_category_value_128 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_rel_IN_category_value_147 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_location_IN_category_value_166 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_attributes_IN_category_value_185 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_category_actions_IN_category_value_204 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_category_value_223 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_category_term_254 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_term_IN_category_term_257 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_scheme_287 = Set[ 4, 12 ]
    TOKENS_FOLLOWING_WS_IN_category_scheme_289 = Set[ 12 ]
    TOKENS_FOLLOWING_T__12_IN_category_scheme_292 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_scheme_294 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_scheme_296 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_scheme_IN_category_scheme_298 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_scheme_300 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_class_330 = Set[ 4, 15 ]
    TOKENS_FOLLOWING_WS_IN_category_class_332 = Set[ 15 ]
    TOKENS_FOLLOWING_T__15_IN_category_class_335 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_class_337 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_class_339 = Set[ 40, 41, 42 ]
    TOKENS_FOLLOWING_class_type_IN_category_class_341 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_class_343 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_title_370 = Set[ 4, 16 ]
    TOKENS_FOLLOWING_WS_IN_category_title_372 = Set[ 16 ]
    TOKENS_FOLLOWING_T__16_IN_category_title_375 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_title_377 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_title_379 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_title_IN_category_title_381 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_title_383 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_rel_411 = Set[ 4, 17 ]
    TOKENS_FOLLOWING_WS_IN_category_rel_413 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_category_rel_416 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_rel_418 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_rel_420 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_rel_IN_category_rel_422 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_rel_424 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_location_450 = Set[ 4, 18 ]
    TOKENS_FOLLOWING_WS_IN_category_location_452 = Set[ 18 ]
    TOKENS_FOLLOWING_T__18_IN_category_location_455 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_location_457 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_location_459 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_location_IN_category_location_461 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_location_463 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_attributes_503 = Set[ 4, 19 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_505 = Set[ 19 ]
    TOKENS_FOLLOWING_T__19_IN_category_attributes_508 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_attributes_510 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_attributes_512 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_name_IN_category_attributes_516 = Set[ 4, 5, 14 ]
    TOKENS_FOLLOWING_WS_IN_category_attributes_533 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_name_IN_category_attributes_538 = Set[ 4, 5, 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_attributes_546 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_category_actions_577 = Set[ 4, 20 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_579 = Set[ 20 ]
    TOKENS_FOLLOWING_T__20_IN_category_actions_582 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_actions_584 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_actions_586 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_action_location_IN_category_actions_590 = Set[ 4, 5, 6, 7, 10, 13, 14, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_WS_IN_category_actions_607 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_action_location_IN_category_actions_612 = Set[ 4, 5, 6, 7, 10, 13, 14, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_T__14_IN_category_actions_619 = Set[ 1 ]
    TOKENS_FOLLOWING_T__21_IN_link_641 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_link_643 = Set[ 4, 22 ]
    TOKENS_FOLLOWING_link_value_IN_link_645 = Set[ 1 ]
    TOKENS_FOLLOWING_link_target_IN_link_value_667 = Set[ 11 ]
    TOKENS_FOLLOWING_link_rel_IN_link_value_676 = Set[ 11 ]
    TOKENS_FOLLOWING_link_self_IN_link_value_685 = Set[ 11 ]
    TOKENS_FOLLOWING_link_category_IN_link_value_695 = Set[ 11 ]
    TOKENS_FOLLOWING_link_attributes_IN_link_value_705 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_link_value_714 = Set[ 1 ]
    TOKENS_FOLLOWING_WS_IN_link_target_733 = Set[ 22 ]
    TOKENS_FOLLOWING_T__22_IN_link_target_736 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_target_IN_link_target_738 = Set[ 23 ]
    TOKENS_FOLLOWING_T__23_IN_link_target_740 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_rel_755 = Set[ 4, 17 ]
    TOKENS_FOLLOWING_WS_IN_link_rel_757 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_link_rel_760 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_rel_762 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_rel_764 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_rel_IN_link_rel_766 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_rel_768 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_self_783 = Set[ 4, 24 ]
    TOKENS_FOLLOWING_WS_IN_link_self_785 = Set[ 24 ]
    TOKENS_FOLLOWING_T__24_IN_link_self_788 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_self_790 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_self_792 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_self_location_IN_link_self_794 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_self_796 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_category_811 = Set[ 4, 25 ]
    TOKENS_FOLLOWING_WS_IN_link_category_813 = Set[ 25 ]
    TOKENS_FOLLOWING_T__25_IN_link_category_816 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_category_818 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_category_820 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_category_name_IN_link_category_822 = Set[ 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_category_824 = Set[ 1 ]
    TOKENS_FOLLOWING_T__11_IN_link_attributes_850 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_WS_IN_link_attributes_852 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_attribute_IN_link_attributes_855 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__26_IN_x_occi_attribute_882 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_x_occi_attribute_884 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_attribute_886 = Set[ 4, 5 ]
    TOKENS_FOLLOWING_attribute_IN_x_occi_attribute_889 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_x_occi_attribute_891 = Set[ 1 ]
    TOKENS_FOLLOWING_T__27_IN_x_occi_location_917 = Set[ 10 ]
    TOKENS_FOLLOWING_T__10_IN_x_occi_location_919 = Set[ 4, 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_WS_IN_x_occi_location_921 = Set[ 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_location_IN_x_occi_location_924 = Set[ 1, 11 ]
    TOKENS_FOLLOWING_T__11_IN_x_occi_location_926 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_uri_938 = Set[ 1, 5, 6, 7, 10, 13, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 ]
    TOKENS_FOLLOWING_LOALPHA_IN_term_1029 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_set_IN_term_1031 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_uri_IN_scheme_1064 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_class_type_1073 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_title_1094 = Set[ 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_uri_IN_rel_1129 = Set[ 1 ]
    TOKENS_FOLLOWING_uri_IN_location_1137 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_name_IN_attribute_1157 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_attribute_1159 = Set[ 7, 14 ]
    TOKENS_FOLLOWING_attribute_value_IN_attribute_1161 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1171 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_T__33_IN_attribute_name_1175 = Set[ 5 ]
    TOKENS_FOLLOWING_attribute_component_IN_attribute_name_1177 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_LOALPHA_IN_attribute_component_1189 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_set_IN_attribute_component_1191 = Set[ 1, 5, 7, 30, 39 ]
    TOKENS_FOLLOWING_T__14_IN_attribute_value_1222 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_set_IN_attribute_value_1224 = Set[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43 ]
    TOKENS_FOLLOWING_T__14_IN_attribute_value_1252 = Set[ 1 ]
    TOKENS_FOLLOWING_DIGIT_IN_attribute_value_1259 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_T__33_IN_attribute_value_1263 = Set[ 7 ]
    TOKENS_FOLLOWING_DIGIT_IN_attribute_value_1265 = Set[ 1, 33 ]
    TOKENS_FOLLOWING_uri_IN_action_location_1280 = Set[ 1 ]
    TOKENS_FOLLOWING_uri_IN_target_1289 = Set[ 1 ]
    TOKENS_FOLLOWING_uri_IN_self_location_1297 = Set[ 1 ]
    TOKENS_FOLLOWING_uri_IN_category_name_1305 = Set[ 1 ]

  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0
end

