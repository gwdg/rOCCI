#!/usr/bin/env ruby
#
# Occi_ruby.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: Occi_ruby.g
# Generated at: 2011-06-02 16:45:34
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
                   :DIGITS => 7, :T__21 => 21, :T__20 => 20, :TARGET_VALUE => 6, 
                   :TERM_VALUE => 4, :FLOAT => 8, :QUOTED_VALUE => 5, :EOF => -1, 
                   :URL => 9, :T__30 => 30, :T__19 => 19, :QUOTE => 10, 
                   :T__31 => 31, :WS => 11, :T__16 => 16, :T__15 => 15, 
                   :T__18 => 18, :T__17 => 17, :T__12 => 12, :T__14 => 14, 
                   :T__13 => 13 )

    # register the proper human-readable name or literal value
    # for each token type
    #
    # this is necessary because anonymous tokens, which are
    # created from literal values in the grammar, do not
    # have descriptive names
    register_names( "TERM_VALUE", "QUOTED_VALUE", "TARGET_VALUE", "DIGITS", 
                    "FLOAT", "URL", "QUOTE", "WS", "'Category'", "':'", 
                    "','", "';'", "'scheme'", "'='", "'class'", "'title'", 
                    "'rel'", "'location'", "'attributes'", "'actions'", 
                    "'Link'", "'<'", "'?action='", "'>'", "'self'", "'category'", 
                    "'X-OCCI-Attribute'", "'X-OCCI-Location'" )
    
  end


  class Parser < ANTLR3::Parser
    @grammar_home = Occi

    RULE_METHODS = [ :headers, :category, :category_values, :category_value, 
                     :term_attr, :scheme_attr, :klass_attr, :title_attr, 
                     :rel_attr, :location_attr, :c_attributes_attr, :actions_attr, 
                     :link, :link_values, :link_value, :target_attr, :self_attr, 
                     :category_attr, :attribute_attr, :attributes_attr, 
                     :attribute_kv_attr, :attribute_name_attr, :attribute_value_attr, 
                     :attribute, :location, :location_values ].freeze


    include TokenData

    begin
      generated_using( "Occi_ruby.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end

    def initialize( input, options = {} )
      super( input, options )


    end
    # - - - - - - - - - - - - Rules - - - - - - - - - - - - -

    # 
    # parser rule headers
    # 
    # (in Occi_ruby.g)
    # 30:1: headers : ( category | link | attribute | location )* ;
    # 
    def headers
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      begin
        # at line 30:11: ( category | link | attribute | location )*
        # at line 30:11: ( category | link | attribute | location )*
        while true # decision 1
          alt_1 = 5
          case look_1 = @input.peek( 1 )
          when T__12 then alt_1 = 1
          when T__24 then alt_1 = 2
          when T__30 then alt_1 = 3
          when T__31 then alt_1 = 4
          end
          case alt_1
          when 1
            # at line 30:12: category
            @state.following.push( TOKENS_FOLLOWING_category_IN_headers_14 )
            category
            @state.following.pop

          when 2
            # at line 30:23: link
            @state.following.push( TOKENS_FOLLOWING_link_IN_headers_18 )
            link
            @state.following.pop

          when 3
            # at line 30:30: attribute
            @state.following.push( TOKENS_FOLLOWING_attribute_IN_headers_22 )
            attribute
            @state.following.pop

          when 4
            # at line 30:42: location
            @state.following.push( TOKENS_FOLLOWING_location_IN_headers_26 )
            location
            @state.following.pop

          else
            break # out of loop for decision 1
          end
        end # loop for decision 1

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 1 )

      end
      
      return 
    end


    # 
    # parser rule category
    # 
    # (in Occi_ruby.g)
    # 44:1: category : 'Category' ':' category_values ;
    # 
    def category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      begin
        # at line 44:11: 'Category' ':' category_values
        match( T__12, TOKENS_FOLLOWING_T__12_IN_category_39 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_41 )
        @state.following.push( TOKENS_FOLLOWING_category_values_IN_category_43 )
        category_values
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 2 )

      end
      
      return 
    end


    # 
    # parser rule category_values
    # 
    # (in Occi_ruby.g)
    # 45:2: category_values : category_value ( ',' category_value )* ;
    # 
    def category_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      begin
        # at line 45:19: category_value ( ',' category_value )*
        @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_values_50 )
        category_value
        @state.following.pop
        # at line 45:34: ( ',' category_value )*
        while true # decision 2
          alt_2 = 2
          look_2_0 = @input.peek( 1 )

          if ( look_2_0 == T__14 )
            alt_2 = 1

          end
          case alt_2
          when 1
            # at line 45:35: ',' category_value
            match( T__14, TOKENS_FOLLOWING_T__14_IN_category_values_53 )
            @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_values_55 )
            category_value
            @state.following.pop

          else
            break # out of loop for decision 2
          end
        end # loop for decision 2

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 3 )

      end
      
      return 
    end


    # 
    # parser rule category_value
    # 
    # (in Occi_ruby.g)
    # 46:2: category_value : term_attr scheme_attr klass_attr ( title_attr )? ( rel_attr )? ( location_attr )? ( c_attributes_attr )? ( actions_attr )? ;
    # 
    def category_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      begin
        # at line 46:18: term_attr scheme_attr klass_attr ( title_attr )? ( rel_attr )? ( location_attr )? ( c_attributes_attr )? ( actions_attr )?
        @state.following.push( TOKENS_FOLLOWING_term_attr_IN_category_value_64 )
        term_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_scheme_attr_IN_category_value_66 )
        scheme_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_klass_attr_IN_category_value_68 )
        klass_attr
        @state.following.pop
        # at line 46:51: ( title_attr )?
        alt_3 = 2
        look_3_0 = @input.peek( 1 )

        if ( look_3_0 == T__15 )
          look_3_1 = @input.peek( 2 )

          if ( look_3_1 == T__19 )
            alt_3 = 1
          end
        end
        case alt_3
        when 1
          # at line 46:51: title_attr
          @state.following.push( TOKENS_FOLLOWING_title_attr_IN_category_value_70 )
          title_attr
          @state.following.pop

        end
        # at line 46:63: ( rel_attr )?
        alt_4 = 2
        look_4_0 = @input.peek( 1 )

        if ( look_4_0 == T__15 )
          look_4_1 = @input.peek( 2 )

          if ( look_4_1 == T__20 )
            alt_4 = 1
          end
        end
        case alt_4
        when 1
          # at line 46:63: rel_attr
          @state.following.push( TOKENS_FOLLOWING_rel_attr_IN_category_value_73 )
          rel_attr
          @state.following.pop

        end
        # at line 46:73: ( location_attr )?
        alt_5 = 2
        look_5_0 = @input.peek( 1 )

        if ( look_5_0 == T__15 )
          look_5_1 = @input.peek( 2 )

          if ( look_5_1 == T__21 )
            alt_5 = 1
          end
        end
        case alt_5
        when 1
          # at line 46:73: location_attr
          @state.following.push( TOKENS_FOLLOWING_location_attr_IN_category_value_76 )
          location_attr
          @state.following.pop

        end
        # at line 46:88: ( c_attributes_attr )?
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == T__15 )
          look_6_1 = @input.peek( 2 )

          if ( look_6_1 == T__22 )
            alt_6 = 1
          end
        end
        case alt_6
        when 1
          # at line 46:88: c_attributes_attr
          @state.following.push( TOKENS_FOLLOWING_c_attributes_attr_IN_category_value_79 )
          c_attributes_attr
          @state.following.pop

        end
        # at line 46:107: ( actions_attr )?
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == T__15 )
          alt_7 = 1
        end
        case alt_7
        when 1
          # at line 46:107: actions_attr
          @state.following.push( TOKENS_FOLLOWING_actions_attr_IN_category_value_82 )
          actions_attr
          @state.following.pop

        end

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 4 )

      end
      
      return 
    end


    # 
    # parser rule term_attr
    # 
    # (in Occi_ruby.g)
    # 47:2: term_attr : TERM_VALUE ;
    # 
    def term_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      begin
        # at line 47:25: TERM_VALUE
        match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_term_attr_102 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 5 )

      end
      
      return 
    end


    # 
    # parser rule scheme_attr
    # 
    # (in Occi_ruby.g)
    # 48:2: scheme_attr : ';' 'scheme' '=' QUOTED_VALUE ;
    # 
    def scheme_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      begin
        # at line 48:25: ';' 'scheme' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_scheme_attr_119 )
        match( T__16, TOKENS_FOLLOWING_T__16_IN_scheme_attr_121 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_scheme_attr_123 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_scheme_attr_125 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 6 )

      end
      
      return 
    end


    # 
    # parser rule klass_attr
    # 
    # (in Occi_ruby.g)
    # 49:2: klass_attr : ';' 'class' '=' QUOTED_VALUE ;
    # 
    def klass_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      begin
        # at line 49:25: ';' 'class' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_klass_attr_144 )
        match( T__18, TOKENS_FOLLOWING_T__18_IN_klass_attr_146 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_klass_attr_148 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_klass_attr_150 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 7 )

      end
      
      return 
    end


    # 
    # parser rule title_attr
    # 
    # (in Occi_ruby.g)
    # 50:2: title_attr : ';' 'title' '=' QUOTED_VALUE ;
    # 
    def title_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      begin
        # at line 50:25: ';' 'title' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_title_attr_168 )
        match( T__19, TOKENS_FOLLOWING_T__19_IN_title_attr_170 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_title_attr_172 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_title_attr_174 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 8 )

      end
      
      return 
    end


    # 
    # parser rule rel_attr
    # 
    # (in Occi_ruby.g)
    # 51:2: rel_attr : ';' 'rel' '=' QUOTED_VALUE ;
    # 
    def rel_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      begin
        # at line 51:25: ';' 'rel' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_rel_attr_194 )
        match( T__20, TOKENS_FOLLOWING_T__20_IN_rel_attr_196 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_rel_attr_198 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_rel_attr_200 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 9 )

      end
      
      return 
    end


    # 
    # parser rule location_attr
    # 
    # (in Occi_ruby.g)
    # 52:2: location_attr : ';' 'location' '=' TARGET_VALUE ;
    # 
    def location_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      begin
        # at line 52:25: ';' 'location' '=' TARGET_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_location_attr_216 )
        match( T__21, TOKENS_FOLLOWING_T__21_IN_location_attr_218 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_location_attr_220 )
        match( TARGET_VALUE, TOKENS_FOLLOWING_TARGET_VALUE_IN_location_attr_222 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 10 )

      end
      
      return 
    end


    # 
    # parser rule c_attributes_attr
    # 
    # (in Occi_ruby.g)
    # 53:2: c_attributes_attr : ';' 'attributes' '=' QUOTED_VALUE ;
    # 
    def c_attributes_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      begin
        # at line 53:25: ';' 'attributes' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_c_attributes_attr_234 )
        match( T__22, TOKENS_FOLLOWING_T__22_IN_c_attributes_attr_236 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_c_attributes_attr_238 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_c_attributes_attr_240 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 11 )

      end
      
      return 
    end


    # 
    # parser rule actions_attr
    # 
    # (in Occi_ruby.g)
    # 54:2: actions_attr : ';' 'actions' '=' QUOTED_VALUE ;
    # 
    def actions_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      begin
        # at line 54:25: ';' 'actions' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_actions_attr_257 )
        match( T__23, TOKENS_FOLLOWING_T__23_IN_actions_attr_259 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_actions_attr_261 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_actions_attr_263 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 12 )

      end
      
      return 
    end


    # 
    # parser rule link
    # 
    # (in Occi_ruby.g)
    # 65:1: link : 'Link' ':' link_values ;
    # 
    def link
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      begin
        # at line 65:7: 'Link' ':' link_values
        match( T__24, TOKENS_FOLLOWING_T__24_IN_link_274 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_276 )
        @state.following.push( TOKENS_FOLLOWING_link_values_IN_link_278 )
        link_values
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 13 )

      end
      
      return 
    end


    # 
    # parser rule link_values
    # 
    # (in Occi_ruby.g)
    # 66:2: link_values : link_value ( ',' link_value )* ;
    # 
    def link_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      begin
        # at line 66:15: link_value ( ',' link_value )*
        @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_values_285 )
        link_value
        @state.following.pop
        # at line 66:26: ( ',' link_value )*
        while true # decision 8
          alt_8 = 2
          look_8_0 = @input.peek( 1 )

          if ( look_8_0 == T__14 )
            alt_8 = 1

          end
          case alt_8
          when 1
            # at line 66:27: ',' link_value
            match( T__14, TOKENS_FOLLOWING_T__14_IN_link_values_288 )
            @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_values_290 )
            link_value
            @state.following.pop

          else
            break # out of loop for decision 8
          end
        end # loop for decision 8

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 14 )

      end
      
      return 
    end


    # 
    # parser rule link_value
    # 
    # (in Occi_ruby.g)
    # 67:2: link_value : target_attr rel_attr ( self_attr )? ( category_attr )? ( attribute_attr )? ;
    # 
    def link_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      begin
        # at line 67:14: target_attr rel_attr ( self_attr )? ( category_attr )? ( attribute_attr )?
        @state.following.push( TOKENS_FOLLOWING_target_attr_IN_link_value_299 )
        target_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_rel_attr_IN_link_value_301 )
        rel_attr
        @state.following.pop
        # at line 67:35: ( self_attr )?
        alt_9 = 2
        look_9_0 = @input.peek( 1 )

        if ( look_9_0 == T__15 )
          look_9_1 = @input.peek( 2 )

          if ( look_9_1 == T__28 )
            alt_9 = 1
          end
        end
        case alt_9
        when 1
          # at line 67:35: self_attr
          @state.following.push( TOKENS_FOLLOWING_self_attr_IN_link_value_303 )
          self_attr
          @state.following.pop

        end
        # at line 67:46: ( category_attr )?
        alt_10 = 2
        look_10_0 = @input.peek( 1 )

        if ( look_10_0 == T__15 )
          look_10_1 = @input.peek( 2 )

          if ( look_10_1 == T__29 )
            alt_10 = 1
          end
        end
        case alt_10
        when 1
          # at line 67:46: category_attr
          @state.following.push( TOKENS_FOLLOWING_category_attr_IN_link_value_306 )
          category_attr
          @state.following.pop

        end
        # at line 67:61: ( attribute_attr )?
        alt_11 = 2
        look_11_0 = @input.peek( 1 )

        if ( look_11_0 == T__15 )
          alt_11 = 1
        end
        case alt_11
        when 1
          # at line 67:61: attribute_attr
          @state.following.push( TOKENS_FOLLOWING_attribute_attr_IN_link_value_309 )
          attribute_attr
          @state.following.pop

        end

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 15 )

      end
      
      return 
    end


    # 
    # parser rule target_attr
    # 
    # (in Occi_ruby.g)
    # 68:2: target_attr : '<' ( TARGET_VALUE ) ( '?action=' TERM_VALUE )? '>' ;
    # 
    def target_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )

      begin
        # at line 68:27: '<' ( TARGET_VALUE ) ( '?action=' TERM_VALUE )? '>'
        match( T__25, TOKENS_FOLLOWING_T__25_IN_target_attr_330 )
        # at line 68:31: ( TARGET_VALUE )
        # at line 68:32: TARGET_VALUE
        match( TARGET_VALUE, TOKENS_FOLLOWING_TARGET_VALUE_IN_target_attr_333 )

        # at line 68:46: ( '?action=' TERM_VALUE )?
        alt_12 = 2
        look_12_0 = @input.peek( 1 )

        if ( look_12_0 == T__26 )
          alt_12 = 1
        end
        case alt_12
        when 1
          # at line 68:47: '?action=' TERM_VALUE
          match( T__26, TOKENS_FOLLOWING_T__26_IN_target_attr_337 )
          match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_target_attr_339 )

        end
        match( T__27, TOKENS_FOLLOWING_T__27_IN_target_attr_343 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 16 )

      end
      
      return 
    end


    # 
    # parser rule self_attr
    # 
    # (in Occi_ruby.g)
    # 69:2: self_attr : ';' 'self' '=' QUOTED_VALUE ;
    # 
    def self_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )

      begin
        # at line 69:27: ';' 'self' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_self_attr_366 )
        match( T__28, TOKENS_FOLLOWING_T__28_IN_self_attr_368 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_self_attr_370 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_self_attr_372 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 17 )

      end
      
      return 
    end


    # 
    # parser rule category_attr
    # 
    # (in Occi_ruby.g)
    # 70:2: category_attr : ';' 'category' '=' QUOTED_VALUE ;
    # 
    def category_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )

      begin
        # at line 70:27: ';' 'category' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_category_attr_391 )
        match( T__29, TOKENS_FOLLOWING_T__29_IN_category_attr_393 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_category_attr_395 )
        match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_category_attr_397 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 18 )

      end
      
      return 
    end


    # 
    # parser rule attribute_attr
    # 
    # (in Occi_ruby.g)
    # 71:2: attribute_attr : ';' attributes_attr ;
    # 
    def attribute_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )

      begin
        # at line 71:27: ';' attributes_attr
        match( T__15, TOKENS_FOLLOWING_T__15_IN_attribute_attr_415 )
        @state.following.push( TOKENS_FOLLOWING_attributes_attr_IN_attribute_attr_417 )
        attributes_attr
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 19 )

      end
      
      return 
    end


    # 
    # parser rule attributes_attr
    # 
    # (in Occi_ruby.g)
    # 72:3: attributes_attr : attribute_kv_attr ( ',' attribute_kv_attr )* ;
    # 
    def attributes_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      begin
        # at line 72:28: attribute_kv_attr ( ',' attribute_kv_attr )*
        @state.following.push( TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_436 )
        attribute_kv_attr
        @state.following.pop
        # at line 72:46: ( ',' attribute_kv_attr )*
        while true # decision 13
          alt_13 = 2
          look_13_0 = @input.peek( 1 )

          if ( look_13_0 == T__14 )
            look_13_1 = @input.peek( 2 )

            if ( look_13_1 == TERM_VALUE )
              alt_13 = 1

            end

          end
          case alt_13
          when 1
            # at line 72:47: ',' attribute_kv_attr
            match( T__14, TOKENS_FOLLOWING_T__14_IN_attributes_attr_439 )
            @state.following.push( TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_441 )
            attribute_kv_attr
            @state.following.pop

          else
            break # out of loop for decision 13
          end
        end # loop for decision 13

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 20 )

      end
      
      return 
    end


    # 
    # parser rule attribute_kv_attr
    # 
    # (in Occi_ruby.g)
    # 73:5: attribute_kv_attr : attribute_name_attr '=' attribute_value_attr ;
    # 
    def attribute_kv_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )

      begin
        # at line 73:30: attribute_name_attr '=' attribute_value_attr
        @state.following.push( TOKENS_FOLLOWING_attribute_name_attr_IN_attribute_kv_attr_462 )
        attribute_name_attr
        @state.following.pop
        match( T__17, TOKENS_FOLLOWING_T__17_IN_attribute_kv_attr_464 )
        @state.following.push( TOKENS_FOLLOWING_attribute_value_attr_IN_attribute_kv_attr_466 )
        attribute_value_attr
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 21 )

      end
      
      return 
    end


    # 
    # parser rule attribute_name_attr
    # 
    # (in Occi_ruby.g)
    # 74:7: attribute_name_attr : TERM_VALUE ;
    # 
    def attribute_name_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )

      begin
        # at line 74:32: TERM_VALUE
        match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_attribute_name_attr_484 )

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 22 )

      end
      
      return 
    end


    # 
    # parser rule attribute_value_attr
    # 
    # (in Occi_ruby.g)
    # 75:7: attribute_value_attr : ( QUOTED_VALUE | DIGITS | FLOAT );
    # 
    def attribute_value_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )

      begin
        # at line 
        if @input.peek(1) == QUOTED_VALUE || @input.peek( 1 ).between?( DIGITS, FLOAT )
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
        # trace_out( __method__, 23 )

      end
      
      return 
    end


    # 
    # parser rule attribute
    # 
    # (in Occi_ruby.g)
    # 88:1: attribute : 'X-OCCI-Attribute' ':' attributes_attr ;
    # 
    def attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      begin
        # at line 88:12: 'X-OCCI-Attribute' ':' attributes_attr
        match( T__30, TOKENS_FOLLOWING_T__30_IN_attribute_520 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_attribute_522 )
        @state.following.push( TOKENS_FOLLOWING_attributes_attr_IN_attribute_524 )
        attributes_attr
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 24 )

      end
      
      return 
    end


    # 
    # parser rule location
    # 
    # (in Occi_ruby.g)
    # 97:1: location : 'X-OCCI-Location' ':' location_values ;
    # 
    def location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      begin
        # at line 97:11: 'X-OCCI-Location' ':' location_values
        match( T__31, TOKENS_FOLLOWING_T__31_IN_location_535 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_location_537 )
        @state.following.push( TOKENS_FOLLOWING_location_values_IN_location_539 )
        location_values
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 25 )

      end
      
      return 
    end


    # 
    # parser rule location_values
    # 
    # (in Occi_ruby.g)
    # 98:1: location_values : URL ( ',' URL )* ;
    # 
    def location_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      begin
        # at line 98:19: URL ( ',' URL )*
        match( URL, TOKENS_FOLLOWING_URL_IN_location_values_546 )
        # at line 98:23: ( ',' URL )*
        while true # decision 14
          alt_14 = 2
          look_14_0 = @input.peek( 1 )

          if ( look_14_0 == T__14 )
            alt_14 = 1

          end
          case alt_14
          when 1
            # at line 98:24: ',' URL
            match( T__14, TOKENS_FOLLOWING_T__14_IN_location_values_549 )
            match( URL, TOKENS_FOLLOWING_URL_IN_location_values_551 )

          else
            break # out of loop for decision 14
          end
        end # loop for decision 14

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 26 )

      end
      
      return 
    end



    TOKENS_FOLLOWING_category_IN_headers_14 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_link_IN_headers_18 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_attribute_IN_headers_22 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_location_IN_headers_26 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_T__12_IN_category_39 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_41 = Set[ 4 ]
    TOKENS_FOLLOWING_category_values_IN_category_43 = Set[ 1 ]
    TOKENS_FOLLOWING_category_value_IN_category_values_50 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_values_53 = Set[ 4 ]
    TOKENS_FOLLOWING_category_value_IN_category_values_55 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_term_attr_IN_category_value_64 = Set[ 15 ]
    TOKENS_FOLLOWING_scheme_attr_IN_category_value_66 = Set[ 15 ]
    TOKENS_FOLLOWING_klass_attr_IN_category_value_68 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_title_attr_IN_category_value_70 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_rel_attr_IN_category_value_73 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_location_attr_IN_category_value_76 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_c_attributes_attr_IN_category_value_79 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_actions_attr_IN_category_value_82 = Set[ 1 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_term_attr_102 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_scheme_attr_119 = Set[ 16 ]
    TOKENS_FOLLOWING_T__16_IN_scheme_attr_121 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_scheme_attr_123 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_scheme_attr_125 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_klass_attr_144 = Set[ 18 ]
    TOKENS_FOLLOWING_T__18_IN_klass_attr_146 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_klass_attr_148 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_klass_attr_150 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_title_attr_168 = Set[ 19 ]
    TOKENS_FOLLOWING_T__19_IN_title_attr_170 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_title_attr_172 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_title_attr_174 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_rel_attr_194 = Set[ 20 ]
    TOKENS_FOLLOWING_T__20_IN_rel_attr_196 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_rel_attr_198 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_rel_attr_200 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_location_attr_216 = Set[ 21 ]
    TOKENS_FOLLOWING_T__21_IN_location_attr_218 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_location_attr_220 = Set[ 6 ]
    TOKENS_FOLLOWING_TARGET_VALUE_IN_location_attr_222 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_c_attributes_attr_234 = Set[ 22 ]
    TOKENS_FOLLOWING_T__22_IN_c_attributes_attr_236 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_c_attributes_attr_238 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_c_attributes_attr_240 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_actions_attr_257 = Set[ 23 ]
    TOKENS_FOLLOWING_T__23_IN_actions_attr_259 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_actions_attr_261 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_actions_attr_263 = Set[ 1 ]
    TOKENS_FOLLOWING_T__24_IN_link_274 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_276 = Set[ 25 ]
    TOKENS_FOLLOWING_link_values_IN_link_278 = Set[ 1 ]
    TOKENS_FOLLOWING_link_value_IN_link_values_285 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_values_288 = Set[ 25 ]
    TOKENS_FOLLOWING_link_value_IN_link_values_290 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_target_attr_IN_link_value_299 = Set[ 15 ]
    TOKENS_FOLLOWING_rel_attr_IN_link_value_301 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_self_attr_IN_link_value_303 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_category_attr_IN_link_value_306 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_attribute_attr_IN_link_value_309 = Set[ 1 ]
    TOKENS_FOLLOWING_T__25_IN_target_attr_330 = Set[ 6 ]
    TOKENS_FOLLOWING_TARGET_VALUE_IN_target_attr_333 = Set[ 26, 27 ]
    TOKENS_FOLLOWING_T__26_IN_target_attr_337 = Set[ 4 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_target_attr_339 = Set[ 27 ]
    TOKENS_FOLLOWING_T__27_IN_target_attr_343 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_self_attr_366 = Set[ 28 ]
    TOKENS_FOLLOWING_T__28_IN_self_attr_368 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_self_attr_370 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_self_attr_372 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_category_attr_391 = Set[ 29 ]
    TOKENS_FOLLOWING_T__29_IN_category_attr_393 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_category_attr_395 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_category_attr_397 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_attribute_attr_415 = Set[ 4 ]
    TOKENS_FOLLOWING_attributes_attr_IN_attribute_attr_417 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_436 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_attributes_attr_439 = Set[ 4 ]
    TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_441 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_attribute_name_attr_IN_attribute_kv_attr_462 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_attribute_kv_attr_464 = Set[ 5, 7, 8 ]
    TOKENS_FOLLOWING_attribute_value_attr_IN_attribute_kv_attr_466 = Set[ 1 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_attribute_name_attr_484 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_attribute_value_attr_0 = Set[ 1 ]
    TOKENS_FOLLOWING_T__30_IN_attribute_520 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_attribute_522 = Set[ 4 ]
    TOKENS_FOLLOWING_attributes_attr_IN_attribute_524 = Set[ 1 ]
    TOKENS_FOLLOWING_T__31_IN_location_535 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_location_537 = Set[ 9 ]
    TOKENS_FOLLOWING_location_values_IN_location_539 = Set[ 1 ]
    TOKENS_FOLLOWING_URL_IN_location_values_546 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_location_values_549 = Set[ 9 ]
    TOKENS_FOLLOWING_URL_IN_location_values_551 = Set[ 1, 14 ]

  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0
end

