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

# - - - - - - begin action @parser::header - - - - - -
# Occi_ruby.g


  require 'ostruct';

# - - - - - - end action @parser::header - - - - - - -


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
    @grammar_home = OCCI

    RULE_METHODS = [ :headers, :category, :category_values, :category_value, 
                     :term_attr, :scheme_attr, :klass_attr, :title_attr, 
                     :rel_attr, :location_attr, :c_attributes_attr, :actions_attr, 
                     :link, :link_values, :link_value, :target_attr, :related_attr, 
                     :self_attr, :category_attr, :attribute_attr, :attributes_attr, 
                     :attribute_kv_attr, :attribute_name_attr, :attribute_value_attr, 
                     :attribute, :location, :location_values ].freeze

    @@category_value = Scope( "category" )
    @@link_value = Scope( "link" )
    @@attributes_attr = Scope( "data" )


    include TokenData

    begin
      generated_using( "Occi_ruby.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11" )
    rescue NoMethodError => error
      # ignore
    end

    def initialize( input, options = {} )
      super( input, options )
      @category_value_stack = []
      @link_value_stack = []
      @attributes_attr_stack = []


    end


      def emit_error_message(message)
        $log.warn(message)
      end

      def remove_quotes(s)
        s.gsub!(/^["|'](.*?)['|"]$/,'\1')
      end

    # - - - - - - - - - - - - Rules - - - - - - - - - - - - -

    # 
    # parser rule headers
    # 
    # (in Occi_ruby.g)
    # 47:1: headers : ( category | link | attribute | location )* ;
    # 
    def headers
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      begin
        # at line 47:11: ( category | link | attribute | location )*
        # at line 47:11: ( category | link | attribute | location )*
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
            # at line 47:12: category
            @state.following.push( TOKENS_FOLLOWING_category_IN_headers_38 )
            category
            @state.following.pop

          when 2
            # at line 47:23: link
            @state.following.push( TOKENS_FOLLOWING_link_IN_headers_42 )
            link
            @state.following.pop

          when 3
            # at line 47:30: attribute
            @state.following.push( TOKENS_FOLLOWING_attribute_IN_headers_46 )
            attribute
            @state.following.pop

          when 4
            # at line 47:42: location
            @state.following.push( TOKENS_FOLLOWING_location_IN_headers_50 )
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
    # 62:1: category returns [categories] : 'Category' ':' category_values ;
    # 
    def category
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )
      categories = nil
      category_values1 = nil

      begin
        # at line 64:3: 'Category' ':' category_values
        match( T__12, TOKENS_FOLLOWING_T__12_IN_category_71 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_category_73 )
        @state.following.push( TOKENS_FOLLOWING_category_values_IN_category_75 )
        category_values1 = category_values
        @state.following.pop
        # --> action
         categories = category_values1 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 2 )

      end
      
      return categories
    end


    # 
    # parser rule category_values
    # 
    # (in Occi_ruby.g)
    # 66:3: category_values returns [category_list] : cv1= category_value ( ',' cv2= category_value )* ;
    # 
    def category_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )
      category_list = nil
      cv1 = nil
      cv2 = nil
      # - - - - @init action - - - -
       category_list =  Array.new 

      begin
        # at line 70:9: cv1= category_value ( ',' cv2= category_value )*
        @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_values_113 )
        cv1 = category_value
        @state.following.pop
        # --> action
         category_list << cv1 
        # <-- action
        # at line 71:9: ( ',' cv2= category_value )*
        while true # decision 2
          alt_2 = 2
          look_2_0 = @input.peek( 1 )

          if ( look_2_0 == T__14 )
            alt_2 = 1

          end
          case alt_2
          when 1
            # at line 71:10: ',' cv2= category_value
            match( T__14, TOKENS_FOLLOWING_T__14_IN_category_values_131 )
            @state.following.push( TOKENS_FOLLOWING_category_value_IN_category_values_137 )
            cv2 = category_value
            @state.following.pop
            # --> action
             category_list << cv2 
            # <-- action

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
      
      return category_list
    end


    # 
    # parser rule category_value
    # 
    # (in Occi_ruby.g)
    # 73:2: category_value returns [data] : term_attr scheme_attr klass_attr ( title_attr )? ( rel_attr )? ( location_attr )? ( c_attributes_attr )? ( actions_attr )? ;
    # 
    def category_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )
      @category_value_stack.push( @@category_value.new )
      data = nil
      # - - - - @init action - - - -
       @category_value_stack.last.category =  Hash.new 

      begin
        # at line 78:7: term_attr scheme_attr klass_attr ( title_attr )? ( rel_attr )? ( location_attr )? ( c_attributes_attr )? ( actions_attr )?
        @state.following.push( TOKENS_FOLLOWING_term_attr_IN_category_value_177 )
        term_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_scheme_attr_IN_category_value_179 )
        scheme_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_klass_attr_IN_category_value_181 )
        klass_attr
        @state.following.pop
        # at line 78:40: ( title_attr )?
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
          # at line 78:40: title_attr
          @state.following.push( TOKENS_FOLLOWING_title_attr_IN_category_value_183 )
          title_attr
          @state.following.pop

        end
        # at line 78:52: ( rel_attr )?
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
          # at line 78:52: rel_attr
          @state.following.push( TOKENS_FOLLOWING_rel_attr_IN_category_value_186 )
          rel_attr
          @state.following.pop

        end
        # at line 78:62: ( location_attr )?
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
          # at line 78:62: location_attr
          @state.following.push( TOKENS_FOLLOWING_location_attr_IN_category_value_189 )
          location_attr
          @state.following.pop

        end
        # at line 78:77: ( c_attributes_attr )?
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
          # at line 78:77: c_attributes_attr
          @state.following.push( TOKENS_FOLLOWING_c_attributes_attr_IN_category_value_192 )
          c_attributes_attr
          @state.following.pop

        end
        # at line 78:96: ( actions_attr )?
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0 == T__15 )
          alt_7 = 1
        end
        case alt_7
        when 1
          # at line 78:96: actions_attr
          @state.following.push( TOKENS_FOLLOWING_actions_attr_IN_category_value_195 )
          actions_attr
          @state.following.pop

        end
        # --> action
         data = OpenStruct.new(@category_value_stack.last.category) 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 4 )
        @category_value_stack.pop

      end
      
      return data
    end


    # 
    # parser rule term_attr
    # 
    # (in Occi_ruby.g)
    # 81:2: term_attr : TERM_VALUE ;
    # 
    def term_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )
      __TERM_VALUE2__ = nil

      begin
        # at line 81:22: TERM_VALUE
        __TERM_VALUE2__ = match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_term_attr_221 )
        # --> action
         @category_value_stack.last.category['term'] = __TERM_VALUE2__.text 
        # <-- action

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
    # 85:2: scheme_attr : ';' 'scheme' '=' QUOTED_VALUE ;
    # 
    def scheme_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )
      __QUOTED_VALUE3__ = nil

      begin
        # at line 85:22: ';' 'scheme' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_scheme_attr_263 )
        match( T__16, TOKENS_FOLLOWING_T__16_IN_scheme_attr_265 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_scheme_attr_271 )
        __QUOTED_VALUE3__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_scheme_attr_273 )
        # --> action
         @category_value_stack.last.category['scheme'] = remove_quotes __QUOTED_VALUE3__.text 
        # <-- action

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
    # 88:2: klass_attr : ';' 'class' '=' QUOTED_VALUE ;
    # 
    def klass_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )
      __QUOTED_VALUE4__ = nil

      begin
        # at line 88:22: ';' 'class' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_klass_attr_313 )
        match( T__18, TOKENS_FOLLOWING_T__18_IN_klass_attr_315 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_klass_attr_322 )
        __QUOTED_VALUE4__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_klass_attr_324 )
        # --> action
         @category_value_stack.last.category['clazz'] = remove_quotes __QUOTED_VALUE4__.text 
        # <-- action

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
    # 91:2: title_attr : ';' 'title' '=' QUOTED_VALUE ;
    # 
    def title_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )
      __QUOTED_VALUE5__ = nil

      begin
        # at line 91:22: ';' 'title' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_title_attr_384 )
        match( T__19, TOKENS_FOLLOWING_T__19_IN_title_attr_386 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_title_attr_393 )
        __QUOTED_VALUE5__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_title_attr_395 )
        # --> action
         @category_value_stack.last.category['title'] = remove_quotes __QUOTED_VALUE5__.text 
        # <-- action

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
    # 95:2: rel_attr : ';' 'rel' '=' QUOTED_VALUE ;
    # 
    def rel_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )
      __QUOTED_VALUE6__ = nil

      begin
        # at line 95:22: ';' 'rel' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_rel_attr_461 )
        match( T__20, TOKENS_FOLLOWING_T__20_IN_rel_attr_463 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_rel_attr_472 )
        __QUOTED_VALUE6__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_rel_attr_474 )
        # --> action
         @category_value_stack.last.category['related'] = remove_quotes __QUOTED_VALUE6__.text 
        # <-- action

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
    # 99:2: location_attr : ';' 'location' '=' TARGET_VALUE ;
    # 
    def location_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )
      __TARGET_VALUE7__ = nil

      begin
        # at line 99:22: ';' 'location' '=' TARGET_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_location_attr_514 )
        match( T__21, TOKENS_FOLLOWING_T__21_IN_location_attr_516 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_location_attr_520 )
        __TARGET_VALUE7__ = match( TARGET_VALUE, TOKENS_FOLLOWING_TARGET_VALUE_IN_location_attr_522 )
        # --> action
         @category_value_stack.last.category['location'] = __TARGET_VALUE7__.text 
        # <-- action

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
    # 103:2: c_attributes_attr : ';' 'attributes' '=' QUOTED_VALUE ;
    # 
    def c_attributes_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )
      __QUOTED_VALUE8__ = nil

      begin
        # at line 103:22: ';' 'attributes' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_c_attributes_attr_559 )
        match( T__22, TOKENS_FOLLOWING_T__22_IN_c_attributes_attr_561 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_c_attributes_attr_563 )
        __QUOTED_VALUE8__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_c_attributes_attr_565 )
        # --> action
         @category_value_stack.last.category['attributes'] = remove_quotes __QUOTED_VALUE8__.text 
        # <-- action

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
    # 107:2: actions_attr : ';' 'actions' '=' QUOTED_VALUE ;
    # 
    def actions_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )
      __QUOTED_VALUE9__ = nil

      begin
        # at line 107:22: ';' 'actions' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_actions_attr_607 )
        match( T__23, TOKENS_FOLLOWING_T__23_IN_actions_attr_609 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_actions_attr_614 )
        __QUOTED_VALUE9__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_actions_attr_616 )
        # --> action
         @category_value_stack.last.category['actions'] = remove_quotes __QUOTED_VALUE9__.text 
        # <-- action

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
    # 120:1: link returns [links] : 'Link' ':' link_values ;
    # 
    def link
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )
      links = nil
      link_values10 = nil

      begin
        # at line 122:3: 'Link' ':' link_values
        match( T__24, TOKENS_FOLLOWING_T__24_IN_link_657 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_link_659 )
        @state.following.push( TOKENS_FOLLOWING_link_values_IN_link_661 )
        link_values10 = link_values
        @state.following.pop
        # --> action
         links = link_values10 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 13 )

      end
      
      return links
    end


    # 
    # parser rule link_values
    # 
    # (in Occi_ruby.g)
    # 124:2: link_values returns [link_list] : lv1= link_value ( ',' lv2= link_value )* ;
    # 
    def link_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )
      link_list = nil
      lv1 = nil
      lv2 = nil
      # - - - - @init action - - - -
       link_list =  Array.new 

      begin
        # at line 128:7: lv1= link_value ( ',' lv2= link_value )*
        @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_values_695 )
        lv1 = link_value
        @state.following.pop
        # --> action
         link_list << lv1 
        # <-- action
        # at line 129:7: ( ',' lv2= link_value )*
        while true # decision 8
          alt_8 = 2
          look_8_0 = @input.peek( 1 )

          if ( look_8_0 == T__14 )
            alt_8 = 1

          end
          case alt_8
          when 1
            # at line 129:8: ',' lv2= link_value
            match( T__14, TOKENS_FOLLOWING_T__14_IN_link_values_711 )
            @state.following.push( TOKENS_FOLLOWING_link_value_IN_link_values_717 )
            lv2 = link_value
            @state.following.pop
            # --> action
             link_list << lv2 
            # <-- action

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
      
      return link_list
    end


    # 
    # parser rule link_value
    # 
    # (in Occi_ruby.g)
    # 131:2: link_value returns [data] : target_attr related_attr ( self_attr )? ( category_attr )? ( attribute_attr )? ;
    # 
    def link_value
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )
      @link_value_stack.push( @@link_value.new )
      data = nil
      attribute_attr11 = nil
      # - - - - @init action - - - -
       
      	   @link_value_stack.last.link =  Hash.new
      	 

      begin
        # at line 138:6: target_attr related_attr ( self_attr )? ( category_attr )? ( attribute_attr )?
        @state.following.push( TOKENS_FOLLOWING_target_attr_IN_link_value_754 )
        target_attr
        @state.following.pop
        @state.following.push( TOKENS_FOLLOWING_related_attr_IN_link_value_756 )
        related_attr
        @state.following.pop
        # at line 138:31: ( self_attr )?
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
          # at line 138:31: self_attr
          @state.following.push( TOKENS_FOLLOWING_self_attr_IN_link_value_758 )
          self_attr
          @state.following.pop

        end
        # at line 138:42: ( category_attr )?
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
          # at line 138:42: category_attr
          @state.following.push( TOKENS_FOLLOWING_category_attr_IN_link_value_761 )
          category_attr
          @state.following.pop

        end
        # at line 138:57: ( attribute_attr )?
        alt_11 = 2
        look_11_0 = @input.peek( 1 )

        if ( look_11_0 == T__15 )
          alt_11 = 1
        end
        case alt_11
        when 1
          # at line 138:57: attribute_attr
          @state.following.push( TOKENS_FOLLOWING_attribute_attr_IN_link_value_764 )
          attribute_attr11 = attribute_attr
          @state.following.pop

        end
        # --> action

        	       @link_value_stack.last.link['attributes'] = attribute_attr11 if attribute_attr11 != nil
        	       data = OpenStruct.new(@link_value_stack.last.link)
        	    
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 15 )
        @link_value_stack.pop

      end
      
      return data
    end


    # 
    # parser rule target_attr
    # 
    # (in Occi_ruby.g)
    # 145:2: target_attr : '<' ( TARGET_VALUE ) ( '?action=' TERM_VALUE )? '>' ;
    # 
    def target_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )
      __TARGET_VALUE12__ = nil
      __TERM_VALUE13__ = nil

      begin
        # at line 145:25: '<' ( TARGET_VALUE ) ( '?action=' TERM_VALUE )? '>'
        match( T__25, TOKENS_FOLLOWING_T__25_IN_target_attr_794 )
        # at line 145:29: ( TARGET_VALUE )
        # at line 145:30: TARGET_VALUE
        __TARGET_VALUE12__ = match( TARGET_VALUE, TOKENS_FOLLOWING_TARGET_VALUE_IN_target_attr_797 )

        # at line 145:44: ( '?action=' TERM_VALUE )?
        alt_12 = 2
        look_12_0 = @input.peek( 1 )

        if ( look_12_0 == T__26 )
          alt_12 = 1
        end
        case alt_12
        when 1
          # at line 145:45: '?action=' TERM_VALUE
          match( T__26, TOKENS_FOLLOWING_T__26_IN_target_attr_801 )
          __TERM_VALUE13__ = match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_target_attr_803 )

        end
        match( T__27, TOKENS_FOLLOWING_T__27_IN_target_attr_807 )
        # --> action

                                   @link_value_stack.last.link['target'] = __TARGET_VALUE12__.text;
                                   @link_value_stack.last.link['action'] = __TERM_VALUE13__.text;
                                 
        # <-- action

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
    # parser rule related_attr
    # 
    # (in Occi_ruby.g)
    # 151:3: related_attr : ';' 'rel' '=' QUOTED_VALUE ;
    # 
    def related_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )
      __QUOTED_VALUE14__ = nil

      begin
        # at line 151:26: ';' 'rel' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_related_attr_852 )
        match( T__20, TOKENS_FOLLOWING_T__20_IN_related_attr_854 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_related_attr_864 )
        __QUOTED_VALUE14__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_related_attr_866 )
        # --> action
         @link_value_stack.last.link['related'] = remove_quotes __QUOTED_VALUE14__.text 
        # <-- action

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
    # parser rule self_attr
    # 
    # (in Occi_ruby.g)
    # 155:2: self_attr : ';' 'self' '=' QUOTED_VALUE ;
    # 
    def self_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )
      __QUOTED_VALUE15__ = nil

      begin
        # at line 155:25: ';' 'self' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_self_attr_916 )
        match( T__28, TOKENS_FOLLOWING_T__28_IN_self_attr_918 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_self_attr_927 )
        __QUOTED_VALUE15__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_self_attr_929 )
        # --> action
         @link_value_stack.last.link['self'] = remove_quotes __QUOTED_VALUE15__.text; 
        # <-- action

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
    # parser rule category_attr
    # 
    # (in Occi_ruby.g)
    # 159:2: category_attr : ';' 'category' '=' QUOTED_VALUE ;
    # 
    def category_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )
      __QUOTED_VALUE16__ = nil

      begin
        # at line 159:25: ';' 'category' '=' QUOTED_VALUE
        match( T__15, TOKENS_FOLLOWING_T__15_IN_category_attr_974 )
        match( T__29, TOKENS_FOLLOWING_T__29_IN_category_attr_976 )
        match( T__17, TOKENS_FOLLOWING_T__17_IN_category_attr_981 )
        __QUOTED_VALUE16__ = match( QUOTED_VALUE, TOKENS_FOLLOWING_QUOTED_VALUE_IN_category_attr_983 )
        # --> action
         @link_value_stack.last.link['category'] = remove_quotes __QUOTED_VALUE16__.text; 
        # <-- action

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
    # parser rule attribute_attr
    # 
    # (in Occi_ruby.g)
    # 163:2: attribute_attr returns [attributes] : ';' attributes_attr ;
    # 
    def attribute_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )
      attributes = nil
      attributes_attr17 = nil

      begin
        # at line 165:25: ';' attributes_attr
        match( T__15, TOKENS_FOLLOWING_T__15_IN_attribute_attr_1049 )
        @state.following.push( TOKENS_FOLLOWING_attributes_attr_IN_attribute_attr_1051 )
        attributes_attr17 = attributes_attr
        @state.following.pop
        # --> action
         attributes = attributes_attr17 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 20 )

      end
      
      return attributes
    end


    # 
    # parser rule attributes_attr
    # 
    # (in Occi_ruby.g)
    # 169:3: attributes_attr returns [attributes] : attribute_kv_attr ( ',' attribute_kv_attr )* ;
    # 
    def attributes_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )
      @attributes_attr_stack.push( @@attributes_attr.new )
      attributes = nil
      # - - - - @init action - - - -
       @attributes_attr_stack.last.data = Hash.new 

      begin
        # at line 174:26: attribute_kv_attr ( ',' attribute_kv_attr )*
        @state.following.push( TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_1139 )
        attribute_kv_attr
        @state.following.pop
        # at line 174:44: ( ',' attribute_kv_attr )*
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
            # at line 174:45: ',' attribute_kv_attr
            match( T__14, TOKENS_FOLLOWING_T__14_IN_attributes_attr_1142 )
            @state.following.push( TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_1144 )
            attribute_kv_attr
            @state.following.pop

          else
            break # out of loop for decision 13
          end
        end # loop for decision 13
        # --> action
         attributes = @attributes_attr_stack.last.data 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 21 )
        @attributes_attr_stack.pop

      end
      
      return attributes
    end


    # 
    # parser rule attribute_kv_attr
    # 
    # (in Occi_ruby.g)
    # 178:3: attribute_kv_attr : attribute_name_attr '=' attribute_value_attr ;
    # 
    def attribute_kv_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )
      attribute_name_attr18 = nil
      attribute_value_attr19 = nil

      begin
        # at line 178:26: attribute_name_attr '=' attribute_value_attr
        @state.following.push( TOKENS_FOLLOWING_attribute_name_attr_IN_attribute_kv_attr_1191 )
        attribute_name_attr18 = attribute_name_attr
        @state.following.pop
        match( T__17, TOKENS_FOLLOWING_T__17_IN_attribute_kv_attr_1193 )
        @state.following.push( TOKENS_FOLLOWING_attribute_value_attr_IN_attribute_kv_attr_1195 )
        attribute_value_attr19 = attribute_value_attr
        @state.following.pop
        # --> action
         @attributes_attr_stack.last.data[( attribute_name_attr18 && @input.to_s( attribute_name_attr18.start, attribute_name_attr18.stop ) )] = ( attribute_value_attr19 && @input.to_s( attribute_value_attr19.start, attribute_value_attr19.stop ) ); 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 22 )

      end
      
      return 
    end

    AttributeNameAttrReturnValue = define_return_scope 

    # 
    # parser rule attribute_name_attr
    # 
    # (in Occi_ruby.g)
    # 182:3: attribute_name_attr : TERM_VALUE ;
    # 
    def attribute_name_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )
      return_value = AttributeNameAttrReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 182:26: TERM_VALUE
        match( TERM_VALUE, TOKENS_FOLLOWING_TERM_VALUE_IN_attribute_name_attr_1237 )
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

    AttributeValueAttrReturnValue = define_return_scope 

    # 
    # parser rule attribute_value_attr
    # 
    # (in Occi_ruby.g)
    # 185:3: attribute_value_attr : ( QUOTED_VALUE | DIGITS | FLOAT );
    # 
    def attribute_value_attr
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )
      return_value = AttributeValueAttrReturnValue.new

      # $rule.start = the first token seen before matching
      return_value.start = @input.look

      begin
        # at line 
        if @input.peek(1) == QUOTED_VALUE || @input.peek( 1 ).between?( DIGITS, FLOAT )
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
        # trace_out( __method__, 24 )

      end
      
      return return_value
    end


    # 
    # parser rule attribute
    # 
    # (in Occi_ruby.g)
    # 199:1: attribute returns [attributes] : 'X-OCCI-Attribute' ':' attributes_attr ;
    # 
    def attribute
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )
      attributes = nil
      attributes_attr20 = nil

      begin
        # at line 201:26: 'X-OCCI-Attribute' ':' attributes_attr
        match( T__30, TOKENS_FOLLOWING_T__30_IN_attribute_1300 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_attribute_1302 )
        @state.following.push( TOKENS_FOLLOWING_attributes_attr_IN_attribute_1304 )
        attributes_attr20 = attributes_attr
        @state.following.pop
        # --> action
         attributes = attributes_attr20 
        # <-- action

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 25 )

      end
      
      return attributes
    end


    # 
    # parser rule location
    # 
    # (in Occi_ruby.g)
    # 212:1: location : 'X-OCCI-Location' ':' location_values ;
    # 
    def location
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      begin
        # at line 212:11: 'X-OCCI-Location' ':' location_values
        match( T__31, TOKENS_FOLLOWING_T__31_IN_location_1343 )
        match( T__13, TOKENS_FOLLOWING_T__13_IN_location_1345 )
        @state.following.push( TOKENS_FOLLOWING_location_values_IN_location_1347 )
        location_values
        @state.following.pop

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 26 )

      end
      
      return 
    end


    # 
    # parser rule location_values
    # 
    # (in Occi_ruby.g)
    # 213:1: location_values : URL ( ',' URL )* ;
    # 
    def location_values
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      begin
        # at line 213:19: URL ( ',' URL )*
        match( URL, TOKENS_FOLLOWING_URL_IN_location_values_1354 )
        # at line 213:23: ( ',' URL )*
        while true # decision 14
          alt_14 = 2
          look_14_0 = @input.peek( 1 )

          if ( look_14_0 == T__14 )
            alt_14 = 1

          end
          case alt_14
          when 1
            # at line 213:24: ',' URL
            match( T__14, TOKENS_FOLLOWING_T__14_IN_location_values_1357 )
            match( URL, TOKENS_FOLLOWING_URL_IN_location_values_1359 )

          else
            break # out of loop for decision 14
          end
        end # loop for decision 14

      rescue ANTLR3::Error::RecognitionError => re
        report_error(re)
        recover(re)

      ensure
        # -> uncomment the next line to manually enable rule tracing
        # trace_out( __method__, 27 )

      end
      
      return 
    end



    TOKENS_FOLLOWING_category_IN_headers_38 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_link_IN_headers_42 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_attribute_IN_headers_46 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_location_IN_headers_50 = Set[ 1, 12, 24, 30, 31 ]
    TOKENS_FOLLOWING_T__12_IN_category_71 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_category_73 = Set[ 4 ]
    TOKENS_FOLLOWING_category_values_IN_category_75 = Set[ 1 ]
    TOKENS_FOLLOWING_category_value_IN_category_values_113 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_category_values_131 = Set[ 4 ]
    TOKENS_FOLLOWING_category_value_IN_category_values_137 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_term_attr_IN_category_value_177 = Set[ 15 ]
    TOKENS_FOLLOWING_scheme_attr_IN_category_value_179 = Set[ 15 ]
    TOKENS_FOLLOWING_klass_attr_IN_category_value_181 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_title_attr_IN_category_value_183 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_rel_attr_IN_category_value_186 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_location_attr_IN_category_value_189 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_c_attributes_attr_IN_category_value_192 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_actions_attr_IN_category_value_195 = Set[ 1 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_term_attr_221 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_scheme_attr_263 = Set[ 16 ]
    TOKENS_FOLLOWING_T__16_IN_scheme_attr_265 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_scheme_attr_271 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_scheme_attr_273 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_klass_attr_313 = Set[ 18 ]
    TOKENS_FOLLOWING_T__18_IN_klass_attr_315 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_klass_attr_322 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_klass_attr_324 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_title_attr_384 = Set[ 19 ]
    TOKENS_FOLLOWING_T__19_IN_title_attr_386 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_title_attr_393 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_title_attr_395 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_rel_attr_461 = Set[ 20 ]
    TOKENS_FOLLOWING_T__20_IN_rel_attr_463 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_rel_attr_472 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_rel_attr_474 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_location_attr_514 = Set[ 21 ]
    TOKENS_FOLLOWING_T__21_IN_location_attr_516 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_location_attr_520 = Set[ 6 ]
    TOKENS_FOLLOWING_TARGET_VALUE_IN_location_attr_522 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_c_attributes_attr_559 = Set[ 22 ]
    TOKENS_FOLLOWING_T__22_IN_c_attributes_attr_561 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_c_attributes_attr_563 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_c_attributes_attr_565 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_actions_attr_607 = Set[ 23 ]
    TOKENS_FOLLOWING_T__23_IN_actions_attr_609 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_actions_attr_614 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_actions_attr_616 = Set[ 1 ]
    TOKENS_FOLLOWING_T__24_IN_link_657 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_link_659 = Set[ 25 ]
    TOKENS_FOLLOWING_link_values_IN_link_661 = Set[ 1 ]
    TOKENS_FOLLOWING_link_value_IN_link_values_695 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_link_values_711 = Set[ 25 ]
    TOKENS_FOLLOWING_link_value_IN_link_values_717 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_target_attr_IN_link_value_754 = Set[ 15 ]
    TOKENS_FOLLOWING_related_attr_IN_link_value_756 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_self_attr_IN_link_value_758 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_category_attr_IN_link_value_761 = Set[ 1, 15 ]
    TOKENS_FOLLOWING_attribute_attr_IN_link_value_764 = Set[ 1 ]
    TOKENS_FOLLOWING_T__25_IN_target_attr_794 = Set[ 6 ]
    TOKENS_FOLLOWING_TARGET_VALUE_IN_target_attr_797 = Set[ 26, 27 ]
    TOKENS_FOLLOWING_T__26_IN_target_attr_801 = Set[ 4 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_target_attr_803 = Set[ 27 ]
    TOKENS_FOLLOWING_T__27_IN_target_attr_807 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_related_attr_852 = Set[ 20 ]
    TOKENS_FOLLOWING_T__20_IN_related_attr_854 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_related_attr_864 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_related_attr_866 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_self_attr_916 = Set[ 28 ]
    TOKENS_FOLLOWING_T__28_IN_self_attr_918 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_self_attr_927 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_self_attr_929 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_category_attr_974 = Set[ 29 ]
    TOKENS_FOLLOWING_T__29_IN_category_attr_976 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_category_attr_981 = Set[ 5 ]
    TOKENS_FOLLOWING_QUOTED_VALUE_IN_category_attr_983 = Set[ 1 ]
    TOKENS_FOLLOWING_T__15_IN_attribute_attr_1049 = Set[ 4 ]
    TOKENS_FOLLOWING_attributes_attr_IN_attribute_attr_1051 = Set[ 1 ]
    TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_1139 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_attributes_attr_1142 = Set[ 4 ]
    TOKENS_FOLLOWING_attribute_kv_attr_IN_attributes_attr_1144 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_attribute_name_attr_IN_attribute_kv_attr_1191 = Set[ 17 ]
    TOKENS_FOLLOWING_T__17_IN_attribute_kv_attr_1193 = Set[ 5, 7, 8 ]
    TOKENS_FOLLOWING_attribute_value_attr_IN_attribute_kv_attr_1195 = Set[ 1 ]
    TOKENS_FOLLOWING_TERM_VALUE_IN_attribute_name_attr_1237 = Set[ 1 ]
    TOKENS_FOLLOWING_set_IN_attribute_value_attr_0 = Set[ 1 ]
    TOKENS_FOLLOWING_T__30_IN_attribute_1300 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_attribute_1302 = Set[ 4 ]
    TOKENS_FOLLOWING_attributes_attr_IN_attribute_1304 = Set[ 1 ]
    TOKENS_FOLLOWING_T__31_IN_location_1343 = Set[ 13 ]
    TOKENS_FOLLOWING_T__13_IN_location_1345 = Set[ 9 ]
    TOKENS_FOLLOWING_location_values_IN_location_1347 = Set[ 1 ]
    TOKENS_FOLLOWING_URL_IN_location_values_1354 = Set[ 1, 14 ]
    TOKENS_FOLLOWING_T__14_IN_location_values_1357 = Set[ 9 ]
    TOKENS_FOLLOWING_URL_IN_location_values_1359 = Set[ 1, 14 ]

  end # class Parser < ANTLR3::Parser

  at_exit { Parser.main( ARGV ) } if __FILE__ == $0
end

