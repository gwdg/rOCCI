module Occi
  module Parser
    describe Text do

      describe '.category' do

        it 'parses a string to an OCCI Category' do
          category_string = 'Category: a_a1-_;scheme="http://a.a/a#";class="kind";title="aA1!\"§$%&/()=?`´ß+*#-_.:,;<>";rel="http://a.a/b#a";location="/a1-A/";attributes="a_1-_.a1-_a a-1.a.b";actions="http://a.a/a1#a1 http://a.b1/b1#b2"'
          category = Occi::Parser::Text.category category_string
          category.term.should == 'a_a1-_'
          category.scheme.should == 'http://a.a/a#'
          category.class.should == Occi::Core::Kind
          category.title.should == 'aA1!\"§$%&/()=?`´ß+*#-_.:,;<>'
          category.related.first.should == 'http://a.a/b#a'
          category.location.should == '/a1-A/'
          category.attributes['a_1-_'].class.should == Occi::Core::Attributes
          category.attributes['a_1-_']['a1-_a'].class.should == Occi::Core::AttributeProperties
          category.attributes['a-1'].class.should == Occi::Core::Attributes
          category.attributes['a-1']['a'].class.should == Occi::Core::Attributes
          category.attributes['a-1']['a']['b'].class.should == Occi::Core::AttributeProperties
          category.actions.to_a.first.to_s == 'http://a.a/a1#a1'
          category.actions.to_a.last.to_s == 'http://a.b1/b1#b2'
        end

      end

    end
  end
end