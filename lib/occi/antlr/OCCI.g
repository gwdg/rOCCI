/*  
Copyright (c) 2008-2011, Intel Performance Learning Solutions Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Intel Performance Learning Solutions Ltd. nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Intel Performance Learning Solutions Ltd. BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

grammar OCCI;

options { 
	language = Ruby; 
}

@header { 
	require 'uri' 
	require 'hashie'
	ATTRIBUTE = { :mutable => true, :required => false, :type => { :string => {} }, :default => '' }
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

category returns [mash]
	: 'Category' ':' category_value { mash = $category_value.mash };
	 category_value returns [mash]
	@init{ mash = Hashie::Mash.new( {:kinds=>[],:mixins=>[],:actions=>[] } ) }
	           : category_term category_scheme category_class category_title? category_rel? category_location? category_attributes? category_actions? ';'?
	             { type = $category_class.value
	               cat = Hashie::Mash.new
	               cat.term 		= $category_term.value
	               cat.scheme 		= $category_scheme.value
	               cat.type_identifier	= cat.scheme + cat.term
	               cat.title		= $category_title.value
	               cat.related		= $category_rel.value
	               cat.location		= $category_location.value
	               cat.attributes		= $category_attributes.mash
	               cat.actions		= $category_actions.array
	               mash[(type+'s').to_sym] 	<< cat
	             };
	 category_term returns [value] 		: WS? term 
	 				 	  { value = $term.text };
	 category_scheme returns [value]	: ';' WS? 'scheme' '=' '"' scheme '"' 
	 				  	   { value = $scheme.text };
	 category_class returns [value]		: ';' WS? 'class' '=' '"' class_type '"'
	 					  { value = $class_type.text };
	 category_title returns [value]		: ';' WS? 'title' '=' '"' title '"'
	 				  	  { value = $title.text };
	 category_rel returns [value]		: ';' WS? 'rel' '=' '"' rel '"'
					  	  { value = $rel.text };
	 category_location returns [value]	: ';' WS? 'location' '=' '"' location '"'
	 				  	  { value = $location.text };
	 category_attributes  returns [mash] 	@init{mash = Hashie::Mash.new}
	 					: ';' WS? 'attributes' '=' '"' attr=attribute_name { mash.merge!($attr.mash) } 
	 					  ( WS? next_attr=attribute_name  { mash.merge!($next_attr.mash) } )* '"';
	 category_actions  returns [array]     	@init{array = Array.new}
	 					: ';' WS? 'actions' '=' '"' act=action_location { array << $act.text } 
	 					  ( WS? next_act=action_location { array << $next_act.text } )* '"'; 

/* e.g.
Link:
</storage/disk03>;
rel="http://example.com/occi/resource#storage";
self="/link/456-456-456";
category="http://example.com/occi/link#disk_drive";
com.example.drive0.interface="ide0"; com.example.drive1.interface="ide1"
*/

link returns [mash]
	@init{mash = Hashie::Mash.new}
	: 'Link' ':' link_value { mash = $link_value.mash };
	link_value returns [mash]
	@init{ mash = Hashie::Mash.new }
			: link_target { mash[:target] = $link_target.value }
			  link_rel { mash[:rel] = $link_rel.value }
			  link_self? { mash[:self] = $link_self.value }
			  link_category? { mash[:category] = $link_category.value }
			  link_attributes { mash[:attributes] = $link_attributes.mash }
			  ';'?
			  ;
	link_target returns [value]	: WS? '<' target '>' { value = $target.text };
	link_rel  returns [value]	: ';' WS? 'rel' '=' '"' rel '"' { value = $rel.text };
	link_self  returns [value]	: ';' WS? 'self' '=' '"' self_location '"' { value = $self_location.text };
	link_category  returns [value]	: ';' WS? 'category' '=' '"' category_name '"' { value = $category_name.text };
	link_attributes  returns [mash] @init { mash = Hashie::Mash.new }
					: (';' WS? attribute { mash.merge!($attribute.mash) } )*;

/*
e.g.
X-OCCI-Attribute: occi.compute.architechture="x86_64"
X-OCCI-Attribute: occi.compute.cores=2
X-OCCI-Attribute: occi.compute.hostname="testserver"
X-OCCI-Attribute: occi.compute.speed=2.66
X-OCCI-Attribute: occi.compute.memory=3.0
X-OCCI-Attribute: occi.compute.state="active"
*/

x_occi_attribute returns [mash]
	@init { mash = Hashie::Mash.new }
	: 'X-OCCI-Attribute' ':' WS? attribute ';'? { mash = $attribute.mash } ;

/*
e.g.
X-OCCI-Location: http://example.com/compute/123
X-OCCI-Location: http://example.com/compute/456
*/

x_occi_location returns [uri]
	: 'X-OCCI-Location' ':' WS? location ';'? { uri = URI.parse($location.text) } ;

uri			: ( LOALPHA | UPALPHA | DIGIT | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' | 'action' | 'kind' | 'mixin' )+;
term			: LOALPHA ( LOALPHA | DIGIT | '-' | '_')*;
scheme 		        : uri; 
class_type		: ( 'kind' | 'mixin' | 'action' );
title			: ( ESC | ~( '\\' | '"' | '\'' ) | '\'' )*;
rel			: uri;
location		: uri;
attribute returns [mash] @init { mash = Hashie::Mash.new }	
			: comp_first=attribute_component { cur_mash = mash; comp = $comp_first.text } 
			  ( '.' comp_next=attribute_component { cur_mash[comp.to_sym] = Hashie::Mash.new; cur_mash = cur_mash[comp.to_sym]; comp = $comp_next.text })* 
			  '=' attribute_value { cur_mash[comp.to_sym] = $attribute_value.text };
attribute_name returns [mash] @init { mash = Hashie::Mash.new }
                        : comp_first=attribute_component { cur_mash = mash; comp = $comp_first.text } 
			  ( '.' comp_next=attribute_component { cur_mash[comp.to_sym] = Hashie::Mash.new; cur_mash = cur_mash[comp.to_sym]; comp = $comp_next.text })*
			  { cur_mash[comp.to_sym] = ATTRIBUTE };	 
attribute_component	: LOALPHA ( LOALPHA | DIGIT | '-' | '_' )*;
attribute_value		: ( ( '"' ( ESC | ~( '\\' | '"' | '\'' ) | '\'' )* '"') | ( DIGIT ( '.' DIGIT )* ) );
action_location		: uri;
target			: uri;
self_location		: uri;
category_name		: uri;

LOALPHA : ('a'..'z')+;
UPALPHA	: ('A'..'Z')+;
DIGIT   : ('0'..'9')+;	
WS      : ( '\t' | ' ' | '\r' | '\n'| '\u000C' )+;
ESC     : '\\' ( '"' | '\'' );