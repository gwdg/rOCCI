#!/usr/bin/env ruby
#
# OCCI.g
# --
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jul 31, 2010 19:34:52
# Ruby runtime library version: 1.8.11
# Input grammar file: OCCI.g
# Generated at: 2012-05-18 21:42:45
# 

# ~~~> start load path setup
this_directory = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(this_directory) unless $LOAD_PATH.include?(this_directory)

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join($/)
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

defined?(ANTLR3) or begin

                      # 1: try to load the ruby antlr3 runtime library from the system path
  require 'antlr3'

rescue LoadError

  # 2: try to load rubygems if it isn't already loaded
  defined?(Gem) or begin
    require 'rubygems'
  rescue LoadError
    antlr_load_failed.call
  end

  # 3: try to activate the antlr3 gem
  begin
    Gem.activate('antlr3', '~> 1.8.11')
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
  const_defined?(:TokenData) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens(:T__29 => 29, :T__28 => 28, :T__27 => 27, :T__26 => 26,
                  :T__25 => 25, :T__24 => 24, :T__23 => 23, :ESC => 8,
                  :T__22 => 22, :T__21 => 21, :T__20 => 20, :EOF => -1,
                  :T__9 => 9, :T__19 => 19, :T__16 => 16, :T__15 => 15,
                  :T__18 => 18, :T__17 => 17, :T__12 => 12, :T__11 => 11,
                  :T__14 => 14, :T__13 => 13, :T__10 => 10, :DIGIT => 7,
                  :LOALPHA => 5, :T__42 => 42, :T__43 => 43, :T__40 => 40,
                  :T__41 => 41, :T__30 => 30, :T__31 => 31, :T__32 => 32,
                  :T__33 => 33, :WS => 4, :T__34 => 34, :T__35 => 35, :T__36 => 36,
                  :T__37 => 37, :UPALPHA => 6, :T__38 => 38, :T__39 => 39)

  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = OCCI
    include TokenData


    begin
      generated_using("OCCI.g", "3.2.1-SNAPSHOT Jul 31, 2010 19:34:52", "1.8.11")
    rescue NoMethodError => error
      # ignore
    end

    RULE_NAMES = ["T__9", "T__10", "T__11", "T__12", "T__13", "T__14",
                  "T__15", "T__16", "T__17", "T__18", "T__19", "T__20",
                  "T__21", "T__22", "T__23", "T__24", "T__25", "T__26",
                  "T__27", "T__28", "T__29", "T__30", "T__31", "T__32",
                  "T__33", "T__34", "T__35", "T__36", "T__37", "T__38",
                  "T__39", "T__40", "T__41", "T__42", "T__43", "LOALPHA",
                  "UPALPHA", "DIGIT", "WS", "ESC"].freeze
    RULE_METHODS = [:t__9!, :t__10!, :t__11!, :t__12!, :t__13!, :t__14!,
                    :t__15!, :t__16!, :t__17!, :t__18!, :t__19!, :t__20!,
                    :t__21!, :t__22!, :t__23!, :t__24!, :t__25!, :t__26!,
                    :t__27!, :t__28!, :t__29!, :t__30!, :t__31!, :t__32!,
                    :t__33!, :t__34!, :t__35!, :t__36!, :t__37!, :t__38!,
                    :t__39!, :t__40!, :t__41!, :t__42!, :t__43!, :loalpha!,
                    :upalpha!, :digit!, :ws!, :esc!].freeze


    def initialize(input=nil, options = {})
      super(input, options)

    end


    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule t__9! (T__9)
    # (in OCCI.g)
    def t__9!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = T__9
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 7:8: 'Category'
      match("Category")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )

    end

    # lexer rule t__10! (T__10)
    # (in OCCI.g)
    def t__10!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = T__10
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 8:9: ':'
      match(0x3a)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )

    end

    # lexer rule t__11! (T__11)
    # (in OCCI.g)
    def t__11!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = T__11
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 9:9: ';'
      match(0x3b)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )

    end

    # lexer rule t__12! (T__12)
    # (in OCCI.g)
    def t__12!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = T__12
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 10:9: 'scheme'
      match("scheme")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )

    end

    # lexer rule t__13! (T__13)
    # (in OCCI.g)
    def t__13!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      type = T__13
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 11:9: '='
      match(0x3d)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )

    end

    # lexer rule t__14! (T__14)
    # (in OCCI.g)
    def t__14!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )

      type = T__14
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 12:9: '\"'
      match(0x22)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )

    end

    # lexer rule t__15! (T__15)
    # (in OCCI.g)
    def t__15!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      type = T__15
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 13:9: 'class'
      match("class")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )

    end

    # lexer rule t__16! (T__16)
    # (in OCCI.g)
    def t__16!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      type = T__16
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 14:9: 'title'
      match("title")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )

    end

    # lexer rule t__17! (T__17)
    # (in OCCI.g)
    def t__17!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      type = T__17
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 15:9: 'rel'
      match("rel")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )

    end

    # lexer rule t__18! (T__18)
    # (in OCCI.g)
    def t__18!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 10 )

      type = T__18
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 16:9: 'location'
      match("location")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 10 )

    end

    # lexer rule t__19! (T__19)
    # (in OCCI.g)
    def t__19!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 11 )

      type = T__19
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 17:9: 'attributes'
      match("attributes")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 11 )

    end

    # lexer rule t__20! (T__20)
    # (in OCCI.g)
    def t__20!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 12 )

      type = T__20
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 18:9: 'actions'
      match("actions")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 12 )

    end

    # lexer rule t__21! (T__21)
    # (in OCCI.g)
    def t__21!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 13 )

      type = T__21
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 19:9: 'Link'
      match("Link")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 13 )

    end

    # lexer rule t__22! (T__22)
    # (in OCCI.g)
    def t__22!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 14 )

      type = T__22
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 20:9: '<'
      match(0x3c)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 14 )

    end

    # lexer rule t__23! (T__23)
    # (in OCCI.g)
    def t__23!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 15 )

      type = T__23
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 21:9: '>'
      match(0x3e)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 15 )

    end

    # lexer rule t__24! (T__24)
    # (in OCCI.g)
    def t__24!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 16 )

      type = T__24
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 22:9: 'self'
      match("self")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 16 )

    end

    # lexer rule t__25! (T__25)
    # (in OCCI.g)
    def t__25!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 17 )

      type = T__25
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 23:9: 'category'
      match("category")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 17 )

    end

    # lexer rule t__26! (T__26)
    # (in OCCI.g)
    def t__26!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 18 )

      type = T__26
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 24:9: 'X-OCCI-Attribute'
      match("X-OCCI-Attribute")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 18 )

    end

    # lexer rule t__27! (T__27)
    # (in OCCI.g)
    def t__27!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 19 )

      type = T__27
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 25:9: 'X-OCCI-Location'
      match("X-OCCI-Location")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 19 )

    end

    # lexer rule t__28! (T__28)
    # (in OCCI.g)
    def t__28!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 20 )

      type = T__28
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 26:9: '@'
      match(0x40)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 20 )

    end

    # lexer rule t__29! (T__29)
    # (in OCCI.g)
    def t__29!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 21 )

      type = T__29
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 27:9: '%'
      match(0x25)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 21 )

    end

    # lexer rule t__30! (T__30)
    # (in OCCI.g)
    def t__30!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 22 )

      type = T__30
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 28:9: '_'
      match(0x5f)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 22 )

    end

    # lexer rule t__31! (T__31)
    # (in OCCI.g)
    def t__31!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 23 )

      type = T__31
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 29:9: '\\\\'
      match(0x5c)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 23 )

    end

    # lexer rule t__32! (T__32)
    # (in OCCI.g)
    def t__32!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 24 )

      type = T__32
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 30:9: '+'
      match(0x2b)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 24 )

    end

    # lexer rule t__33! (T__33)
    # (in OCCI.g)
    def t__33!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 25 )

      type = T__33
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 31:9: '.'
      match(0x2e)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 25 )

    end

    # lexer rule t__34! (T__34)
    # (in OCCI.g)
    def t__34!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 26 )

      type = T__34
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 32:9: '~'
      match(0x7e)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 26 )

    end

    # lexer rule t__35! (T__35)
    # (in OCCI.g)
    def t__35!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 27 )

      type = T__35
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 33:9: '#'
      match(0x23)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 27 )

    end

    # lexer rule t__36! (T__36)
    # (in OCCI.g)
    def t__36!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 28 )

      type = T__36
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 34:9: '?'
      match(0x3f)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 28 )

    end

    # lexer rule t__37! (T__37)
    # (in OCCI.g)
    def t__37!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 29 )

      type = T__37
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 35:9: '&'
      match(0x26)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 29 )

    end

    # lexer rule t__38! (T__38)
    # (in OCCI.g)
    def t__38!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 30 )

      type = T__38
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 36:9: '/'
      match(0x2f)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 30 )

    end

    # lexer rule t__39! (T__39)
    # (in OCCI.g)
    def t__39!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 31 )

      type = T__39
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 37:9: '-'
      match(0x2d)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 31 )

    end

    # lexer rule t__40! (T__40)
    # (in OCCI.g)
    def t__40!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 32 )

      type = T__40
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 38:9: 'action'
      match("action")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 32 )

    end

    # lexer rule t__41! (T__41)
    # (in OCCI.g)
    def t__41!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 33 )

      type = T__41
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 39:9: 'kind'
      match("kind")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 33 )

    end

    # lexer rule t__42! (T__42)
    # (in OCCI.g)
    def t__42!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 34 )

      type = T__42
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 40:9: 'mixin'
      match("mixin")


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 34 )

    end

    # lexer rule t__43! (T__43)
    # (in OCCI.g)
    def t__43!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 35 )

      type = T__43
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 41:9: '\\''
      match(0x27)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 35 )

    end

    # lexer rule loalpha! (LOALPHA)
    # (in OCCI.g)
    def loalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 36 )

      type = LOALPHA
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 160:11: ( 'a' .. 'z' )+
      # at file 160:11: ( 'a' .. 'z' )+
      match_count_1 = 0
      while true
        alt_1 = 2
        look_1_0 = @input.peek(1)

        if (look_1_0.between?(0x61, 0x7a))
          alt_1 = 1

        end
        case alt_1
          when 1
            # at line 160:12: 'a' .. 'z'
            match_range(0x61, 0x7a)

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
      # trace_out( __method__, 36 )

    end

    # lexer rule upalpha! (UPALPHA)
    # (in OCCI.g)
    def upalpha!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 37 )

      type = UPALPHA
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 161:11: ( 'A' .. 'Z' )+
      # at file 161:11: ( 'A' .. 'Z' )+
      match_count_2 = 0
      while true
        alt_2 = 2
        look_2_0 = @input.peek(1)

        if (look_2_0.between?(0x41, 0x5a))
          alt_2 = 1

        end
        case alt_2
          when 1
            # at line 161:12: 'A' .. 'Z'
            match_range(0x41, 0x5a)

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
      # trace_out( __method__, 37 )

    end

    # lexer rule digit! (DIGIT)
    # (in OCCI.g)
    def digit!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 38 )

      type = DIGIT
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 162:11: ( '0' .. '9' )
      # at line 162:11: ( '0' .. '9' )
      # at line 162:12: '0' .. '9'
      match_range(0x30, 0x39)


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 38 )

    end

    # lexer rule ws! (WS)
    # (in OCCI.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 39 )

      type = WS
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 163:11: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      # at file 163:11: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
      match_count_3 = 0
      while true
        alt_3 = 2
        look_3_0 = @input.peek(1)

        if (look_3_0.between?(0x9, 0xa) || look_3_0.between?(0xc, 0xd) || look_3_0 == 0x20)
          alt_3 = 1

        end
        case alt_3
          when 1
            # at line
            if @input.peek(1).between?(0x9, 0xa) || @input.peek(1).between?(0xc, 0xd) || @input.peek(1) == 0x20
              @input.consume
            else
              mse = MismatchedSet(nil)
              recover mse
              raise mse
            end


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
      # trace_out( __method__, 39 )

    end

    # lexer rule esc! (ESC)
    # (in OCCI.g)
    def esc!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 40 )

      type = ESC
      channel = ANTLR3::DEFAULT_CHANNEL


      # - - - - main rule block - - - -
      # at line 164:11: '\\\\' ( '\"' | '\\'' )
      match(0x5c)
      if @input.peek(1) == 0x22 || @input.peek(1) == 0x27
        @input.consume
      else
        mse = MismatchedSet(nil)
        recover mse
        raise mse
      end


      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 40 )

    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    # 
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:8: ( T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | T__37 | T__38 | T__39 | T__40 | T__41 | T__42 | T__43 | LOALPHA | UPALPHA | DIGIT | WS | ESC )
      alt_4 = 40
      alt_4 = @dfa4.predict(@input)
      case alt_4
        when 1
          # at line 1:10: T__9
          t__9!

        when 2
          # at line 1:15: T__10
          t__10!

        when 3
          # at line 1:21: T__11
          t__11!

        when 4
          # at line 1:27: T__12
          t__12!

        when 5
          # at line 1:33: T__13
          t__13!

        when 6
          # at line 1:39: T__14
          t__14!

        when 7
          # at line 1:45: T__15
          t__15!

        when 8
          # at line 1:51: T__16
          t__16!

        when 9
          # at line 1:57: T__17
          t__17!

        when 10
          # at line 1:63: T__18
          t__18!

        when 11
          # at line 1:69: T__19
          t__19!

        when 12
          # at line 1:75: T__20
          t__20!

        when 13
          # at line 1:81: T__21
          t__21!

        when 14
          # at line 1:87: T__22
          t__22!

        when 15
          # at line 1:93: T__23
          t__23!

        when 16
          # at line 1:99: T__24
          t__24!

        when 17
          # at line 1:105: T__25
          t__25!

        when 18
          # at line 1:111: T__26
          t__26!

        when 19
          # at line 1:117: T__27
          t__27!

        when 20
          # at line 1:123: T__28
          t__28!

        when 21
          # at line 1:129: T__29
          t__29!

        when 22
          # at line 1:135: T__30
          t__30!

        when 23
          # at line 1:141: T__31
          t__31!

        when 24
          # at line 1:147: T__32
          t__32!

        when 25
          # at line 1:153: T__33
          t__33!

        when 26
          # at line 1:159: T__34
          t__34!

        when 27
          # at line 1:165: T__35
          t__35!

        when 28
          # at line 1:171: T__36
          t__36!

        when 29
          # at line 1:177: T__37
          t__37!

        when 30
          # at line 1:183: T__38
          t__38!

        when 31
          # at line 1:189: T__39
          t__39!

        when 32
          # at line 1:195: T__40
          t__40!

        when 33
          # at line 1:201: T__41
          t__41!

        when 34
          # at line 1:207: T__42
          t__42!

        when 35
          # at line 1:213: T__43
          t__43!

        when 36
          # at line 1:219: LOALPHA
          loalpha!

        when 37
          # at line 1:227: UPALPHA
          upalpha!

        when 38
          # at line 1:235: DIGIT
          digit!

        when 39
          # at line 1:241: WS
          ws!

        when 40
          # at line 1:244: ESC
          esc!

      end
    end


    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA4 < ANTLR3::DFA
      EOT = unpack(1, -1, 1, 32, 2, -1, 1, 31, 2, -1, 5, 31, 1, 32, 2,
                   -1, 1, 32, 3, -1, 1, 48, 8, -1, 2, 31, 6, -1, 9, 31,
                   4, -1, 7, 31, 1, 68, 3, 31, 1, -1, 3, 31, 1, 76, 3,
                   31, 1, -1, 3, 31, 1, -1, 1, 84, 2, 31, 1, -1, 1, 87,
                   1, 31, 1, 89, 3, 31, 2, -1, 1, 94, 1, 95, 1, -1, 1,
                   31, 1, -1, 2, 31, 1, 100, 3, -1, 3, 31, 1, 105, 2, -1,
                   1, 108, 1, 109, 1, 31, 5, -1, 1, 31, 1, 112, 1, -1)
      EOF = unpack(113, -1)
      MIN = unpack(1, 9, 1, 97, 2, -1, 1, 99, 2, -1, 1, 97, 1, 105, 1,
                   101, 1, 111, 1, 99, 1, 105, 2, -1, 1, 45, 3, -1, 1,
                   34, 8, -1, 2, 105, 6, -1, 1, 104, 1, 108, 1, 97, 2,
                   116, 1, 108, 1, 99, 2, 116, 1, -1, 1, 79, 2, -1, 1,
                   110, 1, 120, 1, 101, 1, 102, 1, 115, 1, 101, 1, 108,
                   2, 97, 1, 114, 1, 105, 1, 67, 1, 100, 1, 105, 1, 109,
                   1, 97, 1, 115, 1, 103, 1, 101, 1, -1, 1, 116, 1, 105,
                   1, 111, 1, 67, 1, 97, 1, 110, 1, 101, 1, -1, 1, 97,
                   1, 111, 1, 97, 1, 105, 1, 98, 1, 110, 1, 73, 1, -1,
                   2, 97, 1, -1, 1, 114, 1, -1, 1, 111, 1, 117, 1, 97,
                   1, 45, 2, -1, 1, 121, 1, 110, 1, 116, 1, 97, 1, -1,
                   1, 65, 2, 97, 1, 101, 5, -1, 1, 115, 1, 97, 1, -1)
      MAX = unpack(1, 126, 1, 97, 2, -1, 1, 101, 2, -1, 1, 108, 1, 105,
                   1, 101, 1, 111, 1, 116, 1, 105, 2, -1, 1, 45, 3, -1,
                   1, 39, 8, -1, 2, 105, 6, -1, 1, 104, 1, 108, 1, 97,
                   2, 116, 1, 108, 1, 99, 2, 116, 1, -1, 1, 79, 2, -1,
                   1, 110, 1, 120, 1, 101, 1, 102, 1, 115, 1, 101, 1, 108,
                   1, 122, 1, 97, 1, 114, 1, 105, 1, 67, 1, 100, 1, 105,
                   1, 109, 1, 122, 1, 115, 1, 103, 1, 101, 1, -1, 1, 116,
                   1, 105, 1, 111, 1, 67, 1, 122, 1, 110, 1, 101, 1, -1,
                   1, 122, 1, 111, 1, 122, 1, 105, 1, 98, 1, 110, 1, 73,
                   1, -1, 2, 122, 1, -1, 1, 114, 1, -1, 1, 111, 1, 117,
                   1, 122, 1, 45, 2, -1, 1, 121, 1, 110, 1, 116, 1, 122,
                   1, -1, 1, 76, 2, 122, 1, 101, 5, -1, 1, 115, 1, 122,
                   1, -1)
      ACCEPT = unpack(2, -1, 1, 2, 1, 3, 1, -1, 1, 5, 1, 6, 6, -1, 1, 14,
                      1, 15, 1, -1, 1, 20, 1, 21, 1, 22, 1, -1, 1, 24,
                      1, 25, 1, 26, 1, 27, 1, 28, 1, 29, 1, 30, 1, 31,
                      2, -1, 1, 35, 1, 36, 1, 37, 1, 38, 1, 39, 1, 1, 9,
                      -1, 1, 13, 1, -1, 1, 40, 1, 23, 19, -1, 1, 9, 7,
                      -1, 1, 16, 7, -1, 1, 33, 2, -1, 1, 7, 1, -1, 1, 8,
                      4, -1, 1, 34, 1, 4, 4, -1, 1, 32, 4, -1, 1, 12, 1,
                      18, 1, 19, 1, 17, 1, 10, 2, -1, 1, 11)
      SPECIAL = unpack(113, -1)
      TRANSITION = [
          unpack(2, 34, 1, -1, 2, 34, 18, -1, 1, 34, 1, -1, 1, 6, 1, 23,
                 1, -1, 1, 17, 1, 25, 1, 30, 3, -1, 1, 20, 1, -1, 1, 27,
                 1, 21, 1, 26, 10, 33, 1, 2, 1, 3, 1, 13, 1, 5, 1, 14, 1,
                 24, 1, 16, 2, 32, 1, 1, 8, 32, 1, 12, 11, 32, 1, 15, 2,
                 32, 1, -1, 1, 19, 2, -1, 1, 18, 1, -1, 1, 11, 1, 31, 1,
                 7, 7, 31, 1, 28, 1, 10, 1, 29, 4, 31, 1, 9, 1, 4, 1, 8,
                 6, 31, 3, -1, 1, 22),
          unpack(1, 35),
          unpack(),
          unpack(),
          unpack(1, 36, 1, -1, 1, 37),
          unpack(),
          unpack(),
          unpack(1, 39, 10, -1, 1, 38),
          unpack(1, 40),
          unpack(1, 41),
          unpack(1, 42),
          unpack(1, 44, 16, -1, 1, 43),
          unpack(1, 45),
          unpack(),
          unpack(),
          unpack(1, 46),
          unpack(),
          unpack(),
          unpack(),
          unpack(1, 47, 4, -1, 1, 47),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(1, 49),
          unpack(1, 50),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(1, 51),
          unpack(1, 52),
          unpack(1, 53),
          unpack(1, 54),
          unpack(1, 55),
          unpack(1, 56),
          unpack(1, 57),
          unpack(1, 58),
          unpack(1, 59),
          unpack(),
          unpack(1, 60),
          unpack(),
          unpack(),
          unpack(1, 61),
          unpack(1, 62),
          unpack(1, 63),
          unpack(1, 64),
          unpack(1, 65),
          unpack(1, 66),
          unpack(1, 67),
          unpack(26, 31),
          unpack(1, 69),
          unpack(1, 70),
          unpack(1, 71),
          unpack(1, 72),
          unpack(1, 73),
          unpack(1, 74),
          unpack(1, 75),
          unpack(26, 31),
          unpack(1, 77),
          unpack(1, 78),
          unpack(1, 79),
          unpack(),
          unpack(1, 80),
          unpack(1, 81),
          unpack(1, 82),
          unpack(1, 83),
          unpack(26, 31),
          unpack(1, 85),
          unpack(1, 86),
          unpack(),
          unpack(26, 31),
          unpack(1, 88),
          unpack(26, 31),
          unpack(1, 90),
          unpack(1, 91),
          unpack(1, 92),
          unpack(1, 93),
          unpack(),
          unpack(26, 31),
          unpack(26, 31),
          unpack(),
          unpack(1, 96),
          unpack(),
          unpack(1, 97),
          unpack(1, 98),
          unpack(18, 31, 1, 99, 7, 31),
          unpack(1, 101),
          unpack(),
          unpack(),
          unpack(1, 102),
          unpack(1, 103),
          unpack(1, 104),
          unpack(26, 31),
          unpack(),
          unpack(1, 106, 10, -1, 1, 107),
          unpack(26, 31),
          unpack(26, 31),
          unpack(1, 110),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(),
          unpack(1, 111),
          unpack(26, 31),
          unpack()
      ].freeze

      (0 ... MIN.length).zip(MIN, MAX) do |i, a, z|
        if a > 0 and z < 0
          MAX[i] %= 0x10000
        end
      end

      @decision = 4


      def description
        <<-'__dfa_description__'.strip!
          1:1: Tokens : ( T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | T__32 | T__33 | T__34 | T__35 | T__36 | T__37 | T__38 | T__39 | T__40 | T__41 | T__42 | T__43 | LOALPHA | UPALPHA | DIGIT | WS | ESC );
        __dfa_description__
      end
    end


    private

    def initialize_dfas
      super rescue nil
      @dfa4 = DFA4.new(self, 4)

    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main(ARGV) } if __FILE__ == $0
end

