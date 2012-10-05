grammar OCCIANTLR;

options { 
	language = Ruby; 
}

@header { 
	require 'uri' 
	require 'hashie'
	ATTRIBUTE = { :mutable => true, :required => false, :type => "string" }
}

/*
e.g.
Category: storage; 
  scheme="http://schemas.ogf.org/occi/infrastructure#";
  class="kind";
  title="Storage Resource How's your quote's escaping \" ?";
  rel="http://schemas.ogf.org/occi/core#resource";
  location="/storage/";
  attributes="occi.storage.size occi.storage.state";
  actions="http://schemas.ogf.org/occi/infrastructure/storage/action#resize http://schemas.ogf.org/occi/infrastructure/storage/action#online"
*/

category returns [hash]
	: CATEGORY_KEY COLON category_value { hash = $category_value.hash };
	 category_value returns [hash]
	@init{ hash = Hashie::Mash.new( {:kinds=>[],:mixins=>[],:actions=>[] } ) }
	           : category_term category_scheme category_class category_title? category_rel? category_location? category_attributes? category_actions? SEMICOLON?
	             { type = $category_class.value
	               cat = Hashie::Mash.new
	               cat.term 		= $category_term.value
	               cat.scheme 		= $category_scheme.value
	               cat.title		= $category_title.value
	               cat.related		= $category_rel.value
	               cat.location		= $category_location.value
	               cat.attributes		= $category_attributes.hash
	               cat.actions		= $category_actions.array
	               hash[(type+'s').to_sym] 	<< cat
	             };
	 category_term returns [value] 		: WS? term 
	 				 	  { value = $term.text };
	 category_scheme returns [value]	: SEMICOLON WS? SCHEME EQUALS QUOTE scheme QUOTE 
	 				  	   { value = $scheme.text };
	 category_class returns [value]		: SEMICOLON WS? CLASS EQUALS QUOTE class_type QUOTE
	 					  { value = $class_type.text };
	 category_title returns [value]		: SEMICOLON WS? TITLE EQUALS QUOTE title QUOTE
	 				  	  { value = $title.text };
	 category_rel returns [value]		: SEMICOLON WS? REL EQUALS QUOTE uri QUOTE
					  	  { value = [$uri.text] };
	 category_location returns [value]	: SEMICOLON WS? LOCATION EQUALS QUOTE uri QUOTE
	 				  	  { value = $uri.text };
	 category_attributes  returns [hash] 	@init{hash = Hashie::Mash.new}
	 					: SEMICOLON WS? ATTRIBUTES EQUALS QUOTE attr=attribute_name { hash.merge!($attr.hash) }
	 					  ( WS next_attr=attribute_name  { hash.merge!($next_attr.hash) } )* QUOTE;
	 category_actions  returns [array]     	@init{array = Array.new}
	 					: SEMICOLON WS? ACTIONS EQUALS QUOTE act=uri { array << $act.text } 
	 					  ( WS next_act=uri { array << $next_act.text } )* QUOTE; 

/* e.g.
Link:
</storage/disk03>;
rel="http://example.com/occi/resource#storage";
self="/link/456-456-456";
category="http://example.com/occi/link#disk_drive";
com.example.drive0.interface="ide0"; com.example.drive1.interface="ide1"
*/

link returns [hash]
	: LINK_KEY COLON link_value { hash = $link_value.hash };
	link_value returns [hash]
	@init{ hash = Hashie::Mash.new }
			: link_target { hash[:target] = $link_target.value }
			  link_rel { hash[:rel] = $link_rel.value }
			  link_self? { hash[:self] = $link_self.value }
			  link_category? { hash[:categories] = $link_category.array }
			  link_attributes { hash[:attributes] = $link_attributes.hash }
			  SEMICOLON?
			  ;
	link_target returns [value]	: WS? LT uri GT { value = $uri.text };
	link_rel  returns [value]	: SEMICOLON WS? REL EQUALS QUOTE uri QUOTE { value = $uri.text };
	link_self  returns [value]	: SEMICOLON WS? SELF EQUALS QUOTE uri QUOTE { value = $uri.text };
	link_category  returns [array] @init {array = Array.new}
	                                : SEMICOLON WS? CATEGORY EQUALS QUOTE kind=uri { array << $kind.text } (WS mixin=uri { array << $mixin.text })* QUOTE;
	link_attributes  returns [hash] @init {hash = Hashie::Mash.new}
					: (SEMICOLON WS? attribute { hash.merge!($attribute.hash) } )*;

/*
e.g.
X-OCCI-Attribute: occi.compute.architechture="x86_64"
X-OCCI-Attribute: occi.compute.cores=2
X-OCCI-Attribute: occi.compute.hostname="testserver"
X-OCCI-Attribute: occi.compute.speed=2.66
X-OCCI-Attribute: occi.compute.memory=3.0
X-OCCI-Attribute: occi.compute.state="active"
*/

x_occi_attribute returns [hash]
	: X_OCCI_ATTRIBUTE_KEY COLON WS? attribute SEMICOLON? { hash = $attribute.hash } ;

/*
e.g.
X-OCCI-Location: http://example.com/compute/123
X-OCCI-Location: http://example.com/compute/456
*/

x_occi_location returns [location]
	: X_OCCI_LOCATION_KEY COLON WS? uri SEMICOLON? { location = URI.parse($uri.text) } ;

uri			: ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_OCCI_ATTRIBUTE_KEY | X_OCCI_LOCATION_KEY | reserved_words)+;
term			: ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | DOT | reserved_words )*;
scheme 		        : uri; 
class_type		: ( KIND | MIXIN | ACTION );
title			: ( ESC | ~( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )*;
attribute returns [hash] @init { hash = Hashie::Mash.new }
			: comp_first=attribute_component { cur_hash = hash; comp = $comp_first.text }
			  ( '.' comp_next=attribute_component { cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = $comp_next.text })*
			  EQUALS attribute_value { cur_hash[comp.to_sym] = $attribute_value.value };
attribute_name returns [hash] @init { hash = Hashie::Mash.new }
                        : comp_first=attribute_component { cur_hash = hash; comp = $comp_first.text }
			  ( '.' comp_next=attribute_component { cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = $comp_next.text })*
			  { cur_hash[comp.to_sym] = ATTRIBUTE } 
			  ('{' ('mutable' { cur_hash[comp.to_sym][:mutable] = true })? ('immutable' { cur_hash[comp.to_sym][:mutable] = false })? ('required' { cur_hash[comp.to_sym][:required] = true })? '}' )?;
attribute_component	: ( LOALPHA | reserved_words) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words  )*;
attribute_value returns [value]	: ( quoted_string { value = $quoted_string.text } | number { value = $number.text.to_i } );
number			: ( digits ( DOT digits )? );
reserved_words
	:	( ACTION | ACTIONS | ATTRIBUTES | CATEGORY | CLASS | KIND | LINK | LOCATION | MIXIN | REL | SCHEME | SELF | TERM | TITLE );
	
CATEGORY_KEY
	:	'Category';
LINK_KEY
	:	'Link';
X_OCCI_ATTRIBUTE_KEY
	:	'X-OCCI-Attribute';
X_OCCI_LOCATION_KEY
	:	'X-OCCI-Location';

	

ACTION	:	'action'; 
ACTIONS	:	'actions';
AMPERSAND
	:	'&';
AT	:	'@';
ATTRIBUTES
	:	'attributes';
BACKSLASH
	:	'\\';
CATEGORY:	'category';
CLASS	:	'class';
COLON	:	':';
DASH	:	'-';
DOT	:	'.';
EQUALS	:	'=';
GT	:	'>';
HASH	:	'#';
KIND	:	'kind';
LINK	:	'link';
LOCATION:	'location';
LT	:	'<';
MIXIN	:	'mixin';
PERCENT	:	'%';
PLUS	:	'+';
QUESTION:	'?';
QUOTE	:	'"';
REL	:	'rel';
SCHEME	:	'scheme';
SELF	:	'self';
SEMICOLON
	:	';';
SLASH	:	'/';
SQUOTE	:	'\'';
TERM	:	'term';
TILDE	:	'~';
TITLE	:	'title';
UNDERSCORE
	:	'_';	
LBRACKET : '(';
RBRACKET : ')';

LOALPHA : 	('a'..'z')+;
UPALPHA	: 	('A'..'Z')+;
DIGIT   : 	('0'..'9')+;
WS      : 	( '\t' | ' ' | '\r' | '\n'| '\u000C' )+;
ESC     : 	'\\' ( QUOTE | '\'' );

quoted_string returns [text]
	:	QUOTE string QUOTE {text = $string.text};	
string : 	( ESC | ~( '\\' | QUOTE | '\'' ) | '\'' )*; 
digits	:	DIGIT+;	