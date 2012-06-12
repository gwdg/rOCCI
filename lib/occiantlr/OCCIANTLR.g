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
	: 'Category' ':' category_value { hash = $category_value.hash };
	 category_value returns [hash]
	@init{ hash = Hashie::Mash.new( {:kinds=>[],:mixins=>[],:actions=>[] } ) }
	           : category_term category_scheme category_class category_title? category_rel? category_location? category_attributes? category_actions? ';'?
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
	 category_scheme returns [value]	: ';' WS? 'scheme' '=' '"' scheme '"' 
	 				  	   { value = $scheme.text };
	 category_class returns [value]		: ';' WS? 'class' '=' '"' class_type '"'
	 					  { value = $class_type.text };
	 category_title returns [value]		: ';' WS? 'title' '=' '"' title '"'
	 				  	  { value = $title.text };
	 category_rel returns [value]		: ';' WS? 'rel' '=' '"' uri '"'
					  	  { value = $uri.text };
	 category_location returns [value]	: ';' WS? 'location' '=' '"' uri '"'
	 				  	  { value = $uri.text };
	 category_attributes  returns [hash] 	@init{hash = Hashie::Mash.new}
	 					: ';' WS? 'attributes' '=' '"' attr=attribute_name { hash.merge!($attr.hash) }
	 					  ( WS next_attr=attribute_name  { hash.merge!($next_attr.hash) } )* '"';
	 category_actions  returns [array]     	@init{array = Array.new}
	 					: ';' WS? 'actions' '=' '"' act=uri { array << $act.text } 
	 					  ( WS next_act=uri { array << $next_act.text } )* '"'; 

/* e.g.
Link:
</storage/disk03>;
rel="http://example.com/occi/resource#storage";
self="/link/456-456-456";
category="http://example.com/occi/link#disk_drive";
com.example.drive0.interface="ide0"; com.example.drive1.interface="ide1"
*/

link returns [hash]
	: 'Link' ':' link_value { hash = $link_value.hash };
	link_value returns [hash]
	@init{ hash = Hashie::Mash.new }
			: link_target { hash[:target] = $link_target.value }
			  link_rel { hash[:rel] = $link_rel.value }
			  link_self? { hash[:self] = $link_self.value }
			  link_category? { hash[:category] = $link_category.value }
			  link_attributes { hash[:attributes] = $link_attributes.hash }
			  ';'?
			  ;
	link_target returns [value]	: WS? '<' uri '>' { value = $uri.text };
	link_rel  returns [value]	: ';' WS? 'rel' '=' '"' uri '"' { value = $uri.text };
	link_self  returns [value]	: ';' WS? 'self' '=' '"' uri '"' { value = $uri.text };
	link_category  returns [value]	: ';' WS? 'category' '=' '"' uri '"' { value = $uri.text };
	link_attributes  returns [hash] @init { hash = Hashie::Mash.new }
					: (';' WS? attribute { hash.merge!($attribute.hash) } )*;

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
	: 'X-OCCI-Attribute' ':' WS? attribute ';'? { hash = $attribute.hash } ;

/*
e.g.
X-OCCI-Location: http://example.com/compute/123
X-OCCI-Location: http://example.com/compute/456
*/

x_occi_location returns [location]
	: 'X-OCCI-Location' ':' WS? uri ';'? { location = URI.parse($uri.text) } ;

uri			: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' | 'location' | 'attributes' | 'rel' | 'title' | 'actions' | 'scheme' | 'term' | 'category' | 'self' | 'Link' )+;
term			: LOALPHA ( LOALPHA | DIGIT | '-' | '_')*;
scheme 		        : uri; 
class_type		: ( 'kind' | 'mixin' | 'action' );
title			: ( ESC | ~( '\\' | '"' | '\'' ) | '\'' )*;
attribute returns [hash] @init { hash = Hashie::Mash.new }
			: comp_first=attribute_component { cur_hash = hash; comp = $comp_first.text }
			  ( '.' comp_next=attribute_component { cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = $comp_next.text })*
			  '=' attribute_value { cur_hash[comp.to_sym] = $attribute_value.value };
attribute_name returns [hash] @init { hash = Hashie::Mash.new }
                        : comp_first=attribute_component { cur_hash = hash; comp = $comp_first.text }
			  ( '.' comp_next=attribute_component { cur_hash[comp.to_sym] = Hashie::Mash.new; cur_hash = cur_hash[comp.to_sym]; comp = $comp_next.text })*
			  { cur_hash[comp.to_sym] = ATTRIBUTE };
attribute_component	: LOALPHA ( LOALPHA | DIGIT | '-' | '_' | 'action' | 'kind' | 'mixin' | 'location' | 'attributes' | 'rel' | 'title' | 'actions' | 'scheme' | 'term' | 'category' | 'self' | 'link' )*;
attribute_value returns [value]	: ( string { value = $string.text } | number { value = $number.text.to_i } );
string			: ( '"' ( ESC | ~( '\\' | '"' | '\'' ) | '\'' )* '"');
number			: ( DIGIT* ( '.' DIGIT+ )? );

LOALPHA : ('a'..'z')+;
UPALPHA	: ('A'..'Z')+;
DIGIT   : ('0'..'9');	
WS      : ( '\t' | ' ' | '\r' | '\n'| '\u000C' )+;
ESC     : '\\' ( '"' | '\'' );
