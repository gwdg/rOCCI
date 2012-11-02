// $ANTLR 3.4 /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g 2012-06-12 16:34:37

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

import org.antlr.runtime.debug.*;
import java.io.IOException;
@SuppressWarnings({"all", "warnings", "unchecked"})
public class OCCIANTLRParser extends DebugParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "AMPERSAND", "AT", "BACKSLASH", "CATEGORY_KEY", "COLON", "DASH", "DIGIT", "DOT", "EQUALS", "ESC", "GT", "HASH", "LINK_KEY", "LOALPHA", "LT", "PERCENT", "PLUS", "QUESTION", "QUOTE", "SEMICOLON", "SLASH", "SQUOTE", "TILDE", "UNDERSCORE", "UPALPHA", "WS", "X_Occi_ATTRIBUTE_KEY", "X_Occi_LOCATION_KEY", "'action'", "'actions'", "'attributes'", "'category'", "'class'", "'kind'", "'link'", "'location'", "'mixin'", "'rel'", "'scheme'", "'self'", "'term'", "'title'"
    };

    public static final int EOF=-1;
    public static final int T__32=32;
    public static final int T__33=33;
    public static final int T__34=34;
    public static final int T__35=35;
    public static final int T__36=36;
    public static final int T__37=37;
    public static final int T__38=38;
    public static final int T__39=39;
    public static final int T__40=40;
    public static final int T__41=41;
    public static final int T__42=42;
    public static final int T__43=43;
    public static final int T__44=44;
    public static final int T__45=45;
    public static final int AMPERSAND=4;
    public static final int AT=5;
    public static final int BACKSLASH=6;
    public static final int CATEGORY_KEY=7;
    public static final int COLON=8;
    public static final int DASH=9;
    public static final int DIGIT=10;
    public static final int DOT=11;
    public static final int EQUALS=12;
    public static final int ESC=13;
    public static final int GT=14;
    public static final int HASH=15;
    public static final int LINK_KEY=16;
    public static final int LOALPHA=17;
    public static final int LT=18;
    public static final int PERCENT=19;
    public static final int PLUS=20;
    public static final int QUESTION=21;
    public static final int QUOTE=22;
    public static final int SEMICOLON=23;
    public static final int SLASH=24;
    public static final int SQUOTE=25;
    public static final int TILDE=26;
    public static final int UNDERSCORE=27;
    public static final int UPALPHA=28;
    public static final int WS=29;
    public static final int X_Occi_ATTRIBUTE_KEY=30;
    public static final int X_Occi_LOCATION_KEY=31;

    // delegates
    public Parser[] getDelegates() {
        return new Parser[] {};
    }

    // delegators


public static final String[] ruleNames = new String[] {
    "invalidRule", "category_rel", "link_attributes", "scheme", "category", 
    "link_rel", "category_scheme", "link_value", "link_self", "link_category", 
    "category_class", "category_term", "uri", "attribute", "attribute_value", 
    "attribute_name", "category_location", "x_Occi_location", "term", "category_attributes",
    "category_title", "title", "link_target", "category_value", "digits", 
    "number", "link", "class_type", "reserved_words", "attribute_component", 
    "category_actions", "x_Occi_attribute"
};

public static final boolean[] decisionCanBacktrack = new boolean[] {
    false, // invalid decision
    false, false, false, false, false, false, false, false, false, false, 
        false, false, false, false, false, false, false, false, false, false, 
        false, false, false, false, false, false, false, false, false, false, 
        false, false, false, false, false, false, false, false, false, false, 
        false
};

 
    public int ruleLevel = 0;
    public int getRuleLevel() { return ruleLevel; }
    public void incRuleLevel() { ruleLevel++; }
    public void decRuleLevel() { ruleLevel--; }
    public OCCIANTLRParser(TokenStream input) {
        this(input, DebugEventSocketProxy.DEFAULT_DEBUGGER_PORT, new RecognizerSharedState());
    }
    public OCCIANTLRParser(TokenStream input, int port, RecognizerSharedState state) {
        super(input, state);
        DebugEventSocketProxy proxy =
            new DebugEventSocketProxy(this, port, null);

        setDebugListener(proxy);
        try {
            proxy.handshake();
        }
        catch (IOException ioe) {
            reportError(ioe);
        }
    }

public OCCIANTLRParser(TokenStream input, DebugEventListener dbg) {
    super(input, dbg, new RecognizerSharedState());
}

protected boolean evalPredicate(boolean result, String predicate) {
    dbg.semanticPredicate(result, predicate);
    return result;
}

    public String[] getTokenNames() { return OCCIANTLRParser.tokenNames; }
    public String getGrammarFileName() { return "/Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g"; }



    // $ANTLR start "category"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:15:1: category : CATEGORY_KEY COLON category_value ;
    public final void category() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(15, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:16:2: ( CATEGORY_KEY COLON category_value )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:16:4: CATEGORY_KEY COLON category_value
            {
            dbg.location(16,4);
            match(input,CATEGORY_KEY,FOLLOW_CATEGORY_KEY_in_category15); 
            dbg.location(16,17);
            match(input,COLON,FOLLOW_COLON_in_category17); 
            dbg.location(16,23);
            pushFollow(FOLLOW_category_value_in_category19);
            category_value();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(16, 37);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category"



    // $ANTLR start "category_value"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:17:3: category_value : category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( SEMICOLON )? ;
    public final void category_value() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_value");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(17, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:13: ( category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( SEMICOLON )? )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:15: category_term category_scheme category_class ( category_title )? ( category_rel )? ( category_location )? ( category_attributes )? ( category_actions )? ( SEMICOLON )?
            {
            dbg.location(18,15);
            pushFollow(FOLLOW_category_term_in_category_value42);
            category_term();

            state._fsp--;

            dbg.location(18,29);
            pushFollow(FOLLOW_category_scheme_in_category_value44);
            category_scheme();

            state._fsp--;

            dbg.location(18,45);
            pushFollow(FOLLOW_category_class_in_category_value46);
            category_class();

            state._fsp--;

            dbg.location(18,60);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:60: ( category_title )?
            int alt1=2;
            try { dbg.enterSubRule(1);
            try { dbg.enterDecision(1, decisionCanBacktrack[1]);

            int LA1_0 = input.LA(1);

            if ( (LA1_0==SEMICOLON) ) {
                int LA1_1 = input.LA(2);

                if ( (LA1_1==WS) ) {
                    int LA1_3 = input.LA(3);

                    if ( (LA1_3==45) ) {
                        alt1=1;
                    }
                }
                else if ( (LA1_1==45) ) {
                    alt1=1;
                }
            }
            } finally {dbg.exitDecision(1);}

            switch (alt1) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:60: category_title
                    {
                    dbg.location(18,60);
                    pushFollow(FOLLOW_category_title_in_category_value48);
                    category_title();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(1);}

            dbg.location(18,76);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:76: ( category_rel )?
            int alt2=2;
            try { dbg.enterSubRule(2);
            try { dbg.enterDecision(2, decisionCanBacktrack[2]);

            int LA2_0 = input.LA(1);

            if ( (LA2_0==SEMICOLON) ) {
                int LA2_1 = input.LA(2);

                if ( (LA2_1==WS) ) {
                    int LA2_3 = input.LA(3);

                    if ( (LA2_3==41) ) {
                        alt2=1;
                    }
                }
                else if ( (LA2_1==41) ) {
                    alt2=1;
                }
            }
            } finally {dbg.exitDecision(2);}

            switch (alt2) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:76: category_rel
                    {
                    dbg.location(18,76);
                    pushFollow(FOLLOW_category_rel_in_category_value51);
                    category_rel();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(2);}

            dbg.location(18,90);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:90: ( category_location )?
            int alt3=2;
            try { dbg.enterSubRule(3);
            try { dbg.enterDecision(3, decisionCanBacktrack[3]);

            int LA3_0 = input.LA(1);

            if ( (LA3_0==SEMICOLON) ) {
                int LA3_1 = input.LA(2);

                if ( (LA3_1==WS) ) {
                    int LA3_3 = input.LA(3);

                    if ( (LA3_3==39) ) {
                        alt3=1;
                    }
                }
                else if ( (LA3_1==39) ) {
                    alt3=1;
                }
            }
            } finally {dbg.exitDecision(3);}

            switch (alt3) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:90: category_location
                    {
                    dbg.location(18,90);
                    pushFollow(FOLLOW_category_location_in_category_value54);
                    category_location();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(3);}

            dbg.location(18,109);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:109: ( category_attributes )?
            int alt4=2;
            try { dbg.enterSubRule(4);
            try { dbg.enterDecision(4, decisionCanBacktrack[4]);

            int LA4_0 = input.LA(1);

            if ( (LA4_0==SEMICOLON) ) {
                int LA4_1 = input.LA(2);

                if ( (LA4_1==WS) ) {
                    int LA4_3 = input.LA(3);

                    if ( (LA4_3==34) ) {
                        alt4=1;
                    }
                }
                else if ( (LA4_1==34) ) {
                    alt4=1;
                }
            }
            } finally {dbg.exitDecision(4);}

            switch (alt4) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:109: category_attributes
                    {
                    dbg.location(18,109);
                    pushFollow(FOLLOW_category_attributes_in_category_value57);
                    category_attributes();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(4);}

            dbg.location(18,130);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:130: ( category_actions )?
            int alt5=2;
            try { dbg.enterSubRule(5);
            try { dbg.enterDecision(5, decisionCanBacktrack[5]);

            int LA5_0 = input.LA(1);

            if ( (LA5_0==SEMICOLON) ) {
                int LA5_1 = input.LA(2);

                if ( (LA5_1==WS||LA5_1==33) ) {
                    alt5=1;
                }
            }
            } finally {dbg.exitDecision(5);}

            switch (alt5) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:130: category_actions
                    {
                    dbg.location(18,130);
                    pushFollow(FOLLOW_category_actions_in_category_value60);
                    category_actions();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(5);}

            dbg.location(18,148);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:148: ( SEMICOLON )?
            int alt6=2;
            try { dbg.enterSubRule(6);
            try { dbg.enterDecision(6, decisionCanBacktrack[6]);

            int LA6_0 = input.LA(1);

            if ( (LA6_0==SEMICOLON) ) {
                alt6=1;
            }
            } finally {dbg.exitDecision(6);}

            switch (alt6) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:18:148: SEMICOLON
                    {
                    dbg.location(18,148);
                    match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_value63); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(6);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(18, 157);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_value");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_value"



    // $ANTLR start "category_term"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:19:3: category_term : ( WS )? term ;
    public final void category_term() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_term");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(19, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:19:20: ( ( WS )? term )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:19:22: ( WS )? term
            {
            dbg.location(19,22);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:19:22: ( WS )?
            int alt7=2;
            try { dbg.enterSubRule(7);
            try { dbg.enterDecision(7, decisionCanBacktrack[7]);

            int LA7_0 = input.LA(1);

            if ( (LA7_0==WS) ) {
                alt7=1;
            }
            } finally {dbg.exitDecision(7);}

            switch (alt7) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:19:22: WS
                    {
                    dbg.location(19,22);
                    match(input,WS,FOLLOW_WS_in_category_term76); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(7);}

            dbg.location(19,26);
            pushFollow(FOLLOW_term_in_category_term79);
            term();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(19, 29);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_term");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_term"



    // $ANTLR start "category_scheme"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:20:3: category_scheme : SEMICOLON ( WS )? 'scheme' EQUALS QUOTE scheme QUOTE ;
    public final void category_scheme() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_scheme");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(20, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:20:20: ( SEMICOLON ( WS )? 'scheme' EQUALS QUOTE scheme QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:20:22: SEMICOLON ( WS )? 'scheme' EQUALS QUOTE scheme QUOTE
            {
            dbg.location(20,22);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_scheme89); 
            dbg.location(20,32);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:20:32: ( WS )?
            int alt8=2;
            try { dbg.enterSubRule(8);
            try { dbg.enterDecision(8, decisionCanBacktrack[8]);

            int LA8_0 = input.LA(1);

            if ( (LA8_0==WS) ) {
                alt8=1;
            }
            } finally {dbg.exitDecision(8);}

            switch (alt8) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:20:32: WS
                    {
                    dbg.location(20,32);
                    match(input,WS,FOLLOW_WS_in_category_scheme91); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(8);}

            dbg.location(20,36);
            match(input,42,FOLLOW_42_in_category_scheme94); 
            dbg.location(20,45);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_scheme96); 
            dbg.location(20,52);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_scheme98); 
            dbg.location(20,58);
            pushFollow(FOLLOW_scheme_in_category_scheme100);
            scheme();

            state._fsp--;

            dbg.location(20,65);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_scheme102); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(20, 69);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_scheme");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_scheme"



    // $ANTLR start "category_class"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:21:3: category_class : SEMICOLON ( WS )? 'class' EQUALS QUOTE class_type QUOTE ;
    public final void category_class() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_class");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(21, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:21:20: ( SEMICOLON ( WS )? 'class' EQUALS QUOTE class_type QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:21:22: SEMICOLON ( WS )? 'class' EQUALS QUOTE class_type QUOTE
            {
            dbg.location(21,22);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_class113); 
            dbg.location(21,32);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:21:32: ( WS )?
            int alt9=2;
            try { dbg.enterSubRule(9);
            try { dbg.enterDecision(9, decisionCanBacktrack[9]);

            int LA9_0 = input.LA(1);

            if ( (LA9_0==WS) ) {
                alt9=1;
            }
            } finally {dbg.exitDecision(9);}

            switch (alt9) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:21:32: WS
                    {
                    dbg.location(21,32);
                    match(input,WS,FOLLOW_WS_in_category_class115); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(9);}

            dbg.location(21,36);
            match(input,36,FOLLOW_36_in_category_class118); 
            dbg.location(21,44);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_class120); 
            dbg.location(21,51);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_class122); 
            dbg.location(21,57);
            pushFollow(FOLLOW_class_type_in_category_class124);
            class_type();

            state._fsp--;

            dbg.location(21,68);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_class126); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(21, 72);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_class");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_class"



    // $ANTLR start "category_title"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:22:3: category_title : SEMICOLON ( WS )? 'title' EQUALS QUOTE title QUOTE ;
    public final void category_title() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_title");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(22, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:22:19: ( SEMICOLON ( WS )? 'title' EQUALS QUOTE title QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:22:21: SEMICOLON ( WS )? 'title' EQUALS QUOTE title QUOTE
            {
            dbg.location(22,21);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_title136); 
            dbg.location(22,31);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:22:31: ( WS )?
            int alt10=2;
            try { dbg.enterSubRule(10);
            try { dbg.enterDecision(10, decisionCanBacktrack[10]);

            int LA10_0 = input.LA(1);

            if ( (LA10_0==WS) ) {
                alt10=1;
            }
            } finally {dbg.exitDecision(10);}

            switch (alt10) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:22:31: WS
                    {
                    dbg.location(22,31);
                    match(input,WS,FOLLOW_WS_in_category_title138); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(10);}

            dbg.location(22,35);
            match(input,45,FOLLOW_45_in_category_title141); 
            dbg.location(22,43);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_title143); 
            dbg.location(22,50);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_title145); 
            dbg.location(22,56);
            pushFollow(FOLLOW_title_in_category_title147);
            title();

            state._fsp--;

            dbg.location(22,62);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_title149); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(22, 66);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_title");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_title"



    // $ANTLR start "category_rel"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:23:3: category_rel : SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE ;
    public final void category_rel() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_rel");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(23, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:23:18: ( SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:23:20: SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE
            {
            dbg.location(23,20);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_rel160); 
            dbg.location(23,30);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:23:30: ( WS )?
            int alt11=2;
            try { dbg.enterSubRule(11);
            try { dbg.enterDecision(11, decisionCanBacktrack[11]);

            int LA11_0 = input.LA(1);

            if ( (LA11_0==WS) ) {
                alt11=1;
            }
            } finally {dbg.exitDecision(11);}

            switch (alt11) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:23:30: WS
                    {
                    dbg.location(23,30);
                    match(input,WS,FOLLOW_WS_in_category_rel162); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(11);}

            dbg.location(23,34);
            match(input,41,FOLLOW_41_in_category_rel165); 
            dbg.location(23,40);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_rel167); 
            dbg.location(23,47);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_rel169); 
            dbg.location(23,53);
            pushFollow(FOLLOW_uri_in_category_rel171);
            uri();

            state._fsp--;

            dbg.location(23,57);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_rel173); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(23, 61);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_rel");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_rel"



    // $ANTLR start "category_location"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:24:3: category_location : SEMICOLON ( WS )? 'location' EQUALS QUOTE uri QUOTE ;
    public final void category_location() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_location");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(24, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:24:22: ( SEMICOLON ( WS )? 'location' EQUALS QUOTE uri QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:24:24: SEMICOLON ( WS )? 'location' EQUALS QUOTE uri QUOTE
            {
            dbg.location(24,24);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_location183); 
            dbg.location(24,34);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:24:34: ( WS )?
            int alt12=2;
            try { dbg.enterSubRule(12);
            try { dbg.enterDecision(12, decisionCanBacktrack[12]);

            int LA12_0 = input.LA(1);

            if ( (LA12_0==WS) ) {
                alt12=1;
            }
            } finally {dbg.exitDecision(12);}

            switch (alt12) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:24:34: WS
                    {
                    dbg.location(24,34);
                    match(input,WS,FOLLOW_WS_in_category_location185); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(12);}

            dbg.location(24,38);
            match(input,39,FOLLOW_39_in_category_location188); 
            dbg.location(24,49);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_location190); 
            dbg.location(24,56);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_location192); 
            dbg.location(24,62);
            pushFollow(FOLLOW_uri_in_category_location194);
            uri();

            state._fsp--;

            dbg.location(24,66);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_location196); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(24, 70);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_location");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_location"



    // $ANTLR start "category_attributes"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:25:3: category_attributes : SEMICOLON ( WS )? 'attributes' EQUALS QUOTE attr= attribute_name ( WS next_attr= attribute_name )* QUOTE ;
    public final void category_attributes() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "category_attributes");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(25, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:25:24: ( SEMICOLON ( WS )? 'attributes' EQUALS QUOTE attr= attribute_name ( WS next_attr= attribute_name )* QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:25:26: SEMICOLON ( WS )? 'attributes' EQUALS QUOTE attr= attribute_name ( WS next_attr= attribute_name )* QUOTE
            {
            dbg.location(25,26);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_attributes206); 
            dbg.location(25,36);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:25:36: ( WS )?
            int alt13=2;
            try { dbg.enterSubRule(13);
            try { dbg.enterDecision(13, decisionCanBacktrack[13]);

            int LA13_0 = input.LA(1);

            if ( (LA13_0==WS) ) {
                alt13=1;
            }
            } finally {dbg.exitDecision(13);}

            switch (alt13) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:25:36: WS
                    {
                    dbg.location(25,36);
                    match(input,WS,FOLLOW_WS_in_category_attributes208); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(13);}

            dbg.location(25,40);
            match(input,34,FOLLOW_34_in_category_attributes211); 
            dbg.location(25,53);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_attributes213); 
            dbg.location(25,60);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_attributes215); 
            dbg.location(25,70);
            pushFollow(FOLLOW_attribute_name_in_category_attributes219);
            attribute_name();

            state._fsp--;

            dbg.location(26,10);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:26:10: ( WS next_attr= attribute_name )*
            try { dbg.enterSubRule(14);

            loop14:
            do {
                int alt14=2;
                try { dbg.enterDecision(14, decisionCanBacktrack[14]);

                int LA14_0 = input.LA(1);

                if ( (LA14_0==WS) ) {
                    alt14=1;
                }


                } finally {dbg.exitDecision(14);}

                switch (alt14) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:26:12: WS next_attr= attribute_name
            	    {
            	    dbg.location(26,12);
            	    match(input,WS,FOLLOW_WS_in_category_attributes233); 
            	    dbg.location(26,24);
            	    pushFollow(FOLLOW_attribute_name_in_category_attributes237);
            	    attribute_name();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop14;
                }
            } while (true);
            } finally {dbg.exitSubRule(14);}

            dbg.location(26,45);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_attributes244); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(26, 49);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_attributes");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_attributes"



    // $ANTLR start "category_actions"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:27:3: category_actions : SEMICOLON ( WS )? 'actions' EQUALS QUOTE act= uri ( WS next_act= uri )* QUOTE ;
    public final void category_actions() throws RecognitionException {
        OCCIANTLRParser.uri_return act =null;

        OCCIANTLRParser.uri_return next_act =null;


        try { dbg.enterRule(getGrammarFileName(), "category_actions");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(27, 2);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:27:28: ( SEMICOLON ( WS )? 'actions' EQUALS QUOTE act= uri ( WS next_act= uri )* QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:27:30: SEMICOLON ( WS )? 'actions' EQUALS QUOTE act= uri ( WS next_act= uri )* QUOTE
            {
            dbg.location(27,30);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_category_actions261); 
            dbg.location(27,40);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:27:40: ( WS )?
            int alt15=2;
            try { dbg.enterSubRule(15);
            try { dbg.enterDecision(15, decisionCanBacktrack[15]);

            int LA15_0 = input.LA(1);

            if ( (LA15_0==WS) ) {
                alt15=1;
            }
            } finally {dbg.exitDecision(15);}

            switch (alt15) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:27:40: WS
                    {
                    dbg.location(27,40);
                    match(input,WS,FOLLOW_WS_in_category_actions263); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(15);}

            dbg.location(27,44);
            match(input,33,FOLLOW_33_in_category_actions266); 
            dbg.location(27,54);
            match(input,EQUALS,FOLLOW_EQUALS_in_category_actions268); 
            dbg.location(27,61);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_actions270); 
            dbg.location(27,70);
            pushFollow(FOLLOW_uri_in_category_actions274);
            act=uri();

            state._fsp--;

            dbg.location(28,10);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:28:10: ( WS next_act= uri )*
            try { dbg.enterSubRule(16);

            loop16:
            do {
                int alt16=2;
                try { dbg.enterDecision(16, decisionCanBacktrack[16]);

                int LA16_0 = input.LA(1);

                if ( (LA16_0==WS) ) {
                    alt16=1;
                }


                } finally {dbg.exitDecision(16);}

                switch (alt16) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:28:12: WS next_act= uri
            	    {
            	    dbg.location(28,12);
            	    match(input,WS,FOLLOW_WS_in_category_actions287); 
            	    dbg.location(28,23);
            	    pushFollow(FOLLOW_uri_in_category_actions291);
            	    next_act=uri();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop16;
                }
            } while (true);
            } finally {dbg.exitSubRule(16);}

            dbg.location(28,32);
            match(input,QUOTE,FOLLOW_QUOTE_in_category_actions297); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(28, 36);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "category_actions");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "category_actions"



    // $ANTLR start "link"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:39:1: link : LINK_KEY COLON link_value ;
    public final void link() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(39, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:40:2: ( LINK_KEY COLON link_value )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:40:4: LINK_KEY COLON link_value
            {
            dbg.location(40,4);
            match(input,LINK_KEY,FOLLOW_LINK_KEY_in_link311); 
            dbg.location(40,13);
            match(input,COLON,FOLLOW_COLON_in_link313); 
            dbg.location(40,19);
            pushFollow(FOLLOW_link_value_in_link315);
            link_value();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(40, 29);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link"



    // $ANTLR start "link_value"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:41:2: link_value : link_target link_rel ( link_self )? ( link_category )? link_attributes ( SEMICOLON )? ;
    public final void link_value() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link_value");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(41, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:42:4: ( link_target link_rel ( link_self )? ( link_category )? link_attributes ( SEMICOLON )? )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:42:6: link_target link_rel ( link_self )? ( link_category )? link_attributes ( SEMICOLON )?
            {
            dbg.location(42,6);
            pushFollow(FOLLOW_link_target_in_link_value328);
            link_target();

            state._fsp--;

            dbg.location(43,6);
            pushFollow(FOLLOW_link_rel_in_link_value336);
            link_rel();

            state._fsp--;

            dbg.location(44,6);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:44:6: ( link_self )?
            int alt17=2;
            try { dbg.enterSubRule(17);
            try { dbg.enterDecision(17, decisionCanBacktrack[17]);

            try {
                isCyclicDecision = true;
                alt17 = dfa17.predict(input);
            }
            catch (NoViableAltException nvae) {
                dbg.recognitionException(nvae);
                throw nvae;
            }
            } finally {dbg.exitDecision(17);}

            switch (alt17) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:44:6: link_self
                    {
                    dbg.location(44,6);
                    pushFollow(FOLLOW_link_self_in_link_value343);
                    link_self();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(17);}

            dbg.location(45,6);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:45:6: ( link_category )?
            int alt18=2;
            try { dbg.enterSubRule(18);
            try { dbg.enterDecision(18, decisionCanBacktrack[18]);

            try {
                isCyclicDecision = true;
                alt18 = dfa18.predict(input);
            }
            catch (NoViableAltException nvae) {
                dbg.recognitionException(nvae);
                throw nvae;
            }
            } finally {dbg.exitDecision(18);}

            switch (alt18) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:45:6: link_category
                    {
                    dbg.location(45,6);
                    pushFollow(FOLLOW_link_category_in_link_value352);
                    link_category();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(18);}

            dbg.location(46,6);
            pushFollow(FOLLOW_link_attributes_in_link_value361);
            link_attributes();

            state._fsp--;

            dbg.location(47,6);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:47:6: ( SEMICOLON )?
            int alt19=2;
            try { dbg.enterSubRule(19);
            try { dbg.enterDecision(19, decisionCanBacktrack[19]);

            int LA19_0 = input.LA(1);

            if ( (LA19_0==SEMICOLON) ) {
                alt19=1;
            }
            } finally {dbg.exitDecision(19);}

            switch (alt19) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:47:6: SEMICOLON
                    {
                    dbg.location(47,6);
                    match(input,SEMICOLON,FOLLOW_SEMICOLON_in_link_value369); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(19);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(48, 5);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_value");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_value"



    // $ANTLR start "link_target"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:49:2: link_target : ( WS )? LT uri GT ;
    public final void link_target() throws RecognitionException {
        OCCIANTLRParser.uri_return uri1 =null;


        try { dbg.enterRule(getGrammarFileName(), "link_target");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(49, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:49:13: ( ( WS )? LT uri GT )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:49:15: ( WS )? LT uri GT
            {
            dbg.location(49,15);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:49:15: ( WS )?
            int alt20=2;
            try { dbg.enterSubRule(20);
            try { dbg.enterDecision(20, decisionCanBacktrack[20]);

            int LA20_0 = input.LA(1);

            if ( (LA20_0==WS) ) {
                alt20=1;
            }
            } finally {dbg.exitDecision(20);}

            switch (alt20) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:49:15: WS
                    {
                    dbg.location(49,15);
                    match(input,WS,FOLLOW_WS_in_link_target383); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(20);}

            dbg.location(49,19);
            match(input,LT,FOLLOW_LT_in_link_target386); 
            dbg.location(49,22);
            pushFollow(FOLLOW_uri_in_link_target388);
            uri1=uri();

            state._fsp--;

            dbg.location(49,26);
            match(input,GT,FOLLOW_GT_in_link_target390); 
            dbg.location(49,29);
             value = (uri1!=null?input.toString(uri1.start,uri1.stop):null) 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(49, 49);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_target");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_target"



    // $ANTLR start "link_rel"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:50:2: link_rel : SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE ;
    public final void link_rel() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link_rel");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(50, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:50:12: ( SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:50:14: SEMICOLON ( WS )? 'rel' EQUALS QUOTE uri QUOTE
            {
            dbg.location(50,14);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_link_rel401); 
            dbg.location(50,24);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:50:24: ( WS )?
            int alt21=2;
            try { dbg.enterSubRule(21);
            try { dbg.enterDecision(21, decisionCanBacktrack[21]);

            int LA21_0 = input.LA(1);

            if ( (LA21_0==WS) ) {
                alt21=1;
            }
            } finally {dbg.exitDecision(21);}

            switch (alt21) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:50:24: WS
                    {
                    dbg.location(50,24);
                    match(input,WS,FOLLOW_WS_in_link_rel403); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(21);}

            dbg.location(50,28);
            match(input,41,FOLLOW_41_in_link_rel406); 
            dbg.location(50,34);
            match(input,EQUALS,FOLLOW_EQUALS_in_link_rel408); 
            dbg.location(50,41);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_rel410); 
            dbg.location(50,47);
            pushFollow(FOLLOW_uri_in_link_rel412);
            uri();

            state._fsp--;

            dbg.location(50,51);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_rel414); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(50, 56);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_rel");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_rel"



    // $ANTLR start "link_self"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:51:2: link_self : SEMICOLON ( WS )? 'self' EQUALS QUOTE uri QUOTE ;
    public final void link_self() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link_self");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(51, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:51:13: ( SEMICOLON ( WS )? 'self' EQUALS QUOTE uri QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:51:15: SEMICOLON ( WS )? 'self' EQUALS QUOTE uri QUOTE
            {
            dbg.location(51,15);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_link_self424); 
            dbg.location(51,25);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:51:25: ( WS )?
            int alt22=2;
            try { dbg.enterSubRule(22);
            try { dbg.enterDecision(22, decisionCanBacktrack[22]);

            int LA22_0 = input.LA(1);

            if ( (LA22_0==WS) ) {
                alt22=1;
            }
            } finally {dbg.exitDecision(22);}

            switch (alt22) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:51:25: WS
                    {
                    dbg.location(51,25);
                    match(input,WS,FOLLOW_WS_in_link_self426); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(22);}

            dbg.location(51,29);
            match(input,43,FOLLOW_43_in_link_self429); 
            dbg.location(51,36);
            match(input,EQUALS,FOLLOW_EQUALS_in_link_self431); 
            dbg.location(51,43);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_self433); 
            dbg.location(51,49);
            pushFollow(FOLLOW_uri_in_link_self435);
            uri();

            state._fsp--;

            dbg.location(51,53);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_self437); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(51, 57);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_self");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_self"



    // $ANTLR start "link_category"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:52:2: link_category : SEMICOLON ( WS )? 'category' EQUALS QUOTE uri QUOTE ;
    public final void link_category() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link_category");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(52, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:52:17: ( SEMICOLON ( WS )? 'category' EQUALS QUOTE uri QUOTE )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:52:19: SEMICOLON ( WS )? 'category' EQUALS QUOTE uri QUOTE
            {
            dbg.location(52,19);
            match(input,SEMICOLON,FOLLOW_SEMICOLON_in_link_category446); 
            dbg.location(52,29);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:52:29: ( WS )?
            int alt23=2;
            try { dbg.enterSubRule(23);
            try { dbg.enterDecision(23, decisionCanBacktrack[23]);

            int LA23_0 = input.LA(1);

            if ( (LA23_0==WS) ) {
                alt23=1;
            }
            } finally {dbg.exitDecision(23);}

            switch (alt23) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:52:29: WS
                    {
                    dbg.location(52,29);
                    match(input,WS,FOLLOW_WS_in_link_category448); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(23);}

            dbg.location(52,33);
            match(input,35,FOLLOW_35_in_link_category451); 
            dbg.location(52,44);
            match(input,EQUALS,FOLLOW_EQUALS_in_link_category453); 
            dbg.location(52,51);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_category455); 
            dbg.location(52,57);
            pushFollow(FOLLOW_uri_in_link_category457);
            uri();

            state._fsp--;

            dbg.location(52,61);
            match(input,QUOTE,FOLLOW_QUOTE_in_link_category459); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(52, 66);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_category");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_category"



    // $ANTLR start "link_attributes"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:2: link_attributes : ( SEMICOLON ( WS )? attribute )* ;
    public final void link_attributes() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "link_attributes");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(53, 1);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:18: ( ( SEMICOLON ( WS )? attribute )* )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:20: ( SEMICOLON ( WS )? attribute )*
            {
            dbg.location(53,20);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:20: ( SEMICOLON ( WS )? attribute )*
            try { dbg.enterSubRule(25);

            loop25:
            do {
                int alt25=2;
                try { dbg.enterDecision(25, decisionCanBacktrack[25]);

                int LA25_0 = input.LA(1);

                if ( (LA25_0==SEMICOLON) ) {
                    int LA25_1 = input.LA(2);

                    if ( (LA25_1==LOALPHA||LA25_1==WS||(LA25_1 >= 32 && LA25_1 <= 45)) ) {
                        alt25=1;
                    }


                }


                } finally {dbg.exitDecision(25);}

                switch (alt25) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:21: SEMICOLON ( WS )? attribute
            	    {
            	    dbg.location(53,21);
            	    match(input,SEMICOLON,FOLLOW_SEMICOLON_in_link_attributes469); 
            	    dbg.location(53,31);
            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:31: ( WS )?
            	    int alt24=2;
            	    try { dbg.enterSubRule(24);
            	    try { dbg.enterDecision(24, decisionCanBacktrack[24]);

            	    int LA24_0 = input.LA(1);

            	    if ( (LA24_0==WS) ) {
            	        alt24=1;
            	    }
            	    } finally {dbg.exitDecision(24);}

            	    switch (alt24) {
            	        case 1 :
            	            dbg.enterAlt(1);

            	            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:53:31: WS
            	            {
            	            dbg.location(53,31);
            	            match(input,WS,FOLLOW_WS_in_link_attributes471); 

            	            }
            	            break;

            	    }
            	    } finally {dbg.exitSubRule(24);}

            	    dbg.location(53,35);
            	    pushFollow(FOLLOW_attribute_in_link_attributes474);
            	    attribute();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop25;
                }
            } while (true);
            } finally {dbg.exitSubRule(25);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(53, 47);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "link_attributes");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "link_attributes"



    // $ANTLR start "x_Occi_attribute"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:65:1: x_Occi_attribute : X_Occi_ATTRIBUTE_KEY COLON ( WS )? attribute ( SEMICOLON )? ;
    public final void x_Occi_attribute() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "x_Occi_attribute");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(65, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:2: ( X_Occi_ATTRIBUTE_KEY COLON ( WS )? attribute ( SEMICOLON )? )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:4: X_Occi_ATTRIBUTE_KEY COLON ( WS )? attribute ( SEMICOLON )?
            {
            dbg.location(66,4);
            match(input,X_Occi_ATTRIBUTE_KEY,FOLLOW_X_Occi_ATTRIBUTE_KEY_in_x_Occi_attribute491);
            dbg.location(66,25);
            match(input,COLON,FOLLOW_COLON_in_x_Occi_attribute493);
            dbg.location(66,31);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:31: ( WS )?
            int alt26=2;
            try { dbg.enterSubRule(26);
            try { dbg.enterDecision(26, decisionCanBacktrack[26]);

            int LA26_0 = input.LA(1);

            if ( (LA26_0==WS) ) {
                alt26=1;
            }
            } finally {dbg.exitDecision(26);}

            switch (alt26) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:31: WS
                    {
                    dbg.location(66,31);
                    match(input,WS,FOLLOW_WS_in_x_Occi_attribute495);

                    }
                    break;

            }
            } finally {dbg.exitSubRule(26);}

            dbg.location(66,35);
            pushFollow(FOLLOW_attribute_in_x_Occi_attribute498);
            attribute();

            state._fsp--;

            dbg.location(66,45);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:45: ( SEMICOLON )?
            int alt27=2;
            try { dbg.enterSubRule(27);
            try { dbg.enterDecision(27, decisionCanBacktrack[27]);

            int LA27_0 = input.LA(1);

            if ( (LA27_0==SEMICOLON) ) {
                alt27=1;
            }
            } finally {dbg.exitDecision(27);}

            switch (alt27) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:66:45: SEMICOLON
                    {
                    dbg.location(66,45);
                    match(input,SEMICOLON,FOLLOW_SEMICOLON_in_x_Occi_attribute500);

                    }
                    break;

            }
            } finally {dbg.exitSubRule(27);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(66, 55);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "x_Occi_attribute");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "x_Occi_attribute"



    // $ANTLR start "x_Occi_location"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:74:1: x_Occi_location : X_Occi_LOCATION_KEY COLON ( WS )? uri ( SEMICOLON )? ;
    public final void x_Occi_location() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "x_Occi_location");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(74, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:2: ( X_Occi_LOCATION_KEY COLON ( WS )? uri ( SEMICOLON )? )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:4: X_Occi_LOCATION_KEY COLON ( WS )? uri ( SEMICOLON )?
            {
            dbg.location(75,4);
            match(input,X_Occi_LOCATION_KEY,FOLLOW_X_Occi_LOCATION_KEY_in_x_Occi_location515);
            dbg.location(75,24);
            match(input,COLON,FOLLOW_COLON_in_x_Occi_location517);
            dbg.location(75,30);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:30: ( WS )?
            int alt28=2;
            try { dbg.enterSubRule(28);
            try { dbg.enterDecision(28, decisionCanBacktrack[28]);

            int LA28_0 = input.LA(1);

            if ( (LA28_0==WS) ) {
                alt28=1;
            }
            } finally {dbg.exitDecision(28);}

            switch (alt28) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:30: WS
                    {
                    dbg.location(75,30);
                    match(input,WS,FOLLOW_WS_in_x_Occi_location519);

                    }
                    break;

            }
            } finally {dbg.exitSubRule(28);}

            dbg.location(75,34);
            pushFollow(FOLLOW_uri_in_x_Occi_location522);
            uri();

            state._fsp--;

            dbg.location(75,38);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:38: ( SEMICOLON )?
            int alt29=2;
            try { dbg.enterSubRule(29);
            try { dbg.enterDecision(29, decisionCanBacktrack[29]);

            int LA29_0 = input.LA(1);

            if ( (LA29_0==SEMICOLON) ) {
                alt29=1;
            }
            } finally {dbg.exitDecision(29);}

            switch (alt29) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:75:38: SEMICOLON
                    {
                    dbg.location(75,38);
                    match(input,SEMICOLON,FOLLOW_SEMICOLON_in_x_Occi_location524);

                    }
                    break;

            }
            } finally {dbg.exitSubRule(29);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(75, 49);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "x_Occi_location");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "x_Occi_location"


    public static class uri_return extends ParserRuleReturnScope {
    };


    // $ANTLR start "uri"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:1: uri : ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_Occi_ATTRIBUTE_KEY | X_Occi_LOCATION_KEY | reserved_words )+ ;
    public final OCCIANTLRParser.uri_return uri() throws RecognitionException {
        OCCIANTLRParser.uri_return retval = new OCCIANTLRParser.uri_return();
        retval.start = input.LT(1);


        try { dbg.enterRule(getGrammarFileName(), "uri");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(77, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:7: ( ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_Occi_ATTRIBUTE_KEY | X_Occi_LOCATION_KEY | reserved_words )+ )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:9: ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_Occi_ATTRIBUTE_KEY | X_Occi_LOCATION_KEY | reserved_words )+
            {
            dbg.location(77,9);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:9: ( LOALPHA | UPALPHA | DIGIT | AT | COLON | PERCENT | UNDERSCORE | BACKSLASH | PLUS | DOT | TILDE | HASH | QUESTION | AMPERSAND | SLASH | EQUALS | DASH | X_Occi_ATTRIBUTE_KEY | X_Occi_LOCATION_KEY | reserved_words )+
            int cnt30=0;
            try { dbg.enterSubRule(30);

            loop30:
            do {
                int alt30=21;
                try { dbg.enterDecision(30, decisionCanBacktrack[30]);

                switch ( input.LA(1) ) {
                case LOALPHA:
                    {
                    alt30=1;
                    }
                    break;
                case UPALPHA:
                    {
                    alt30=2;
                    }
                    break;
                case DIGIT:
                    {
                    alt30=3;
                    }
                    break;
                case AT:
                    {
                    alt30=4;
                    }
                    break;
                case COLON:
                    {
                    alt30=5;
                    }
                    break;
                case PERCENT:
                    {
                    alt30=6;
                    }
                    break;
                case UNDERSCORE:
                    {
                    alt30=7;
                    }
                    break;
                case BACKSLASH:
                    {
                    alt30=8;
                    }
                    break;
                case PLUS:
                    {
                    alt30=9;
                    }
                    break;
                case DOT:
                    {
                    alt30=10;
                    }
                    break;
                case TILDE:
                    {
                    alt30=11;
                    }
                    break;
                case HASH:
                    {
                    alt30=12;
                    }
                    break;
                case QUESTION:
                    {
                    alt30=13;
                    }
                    break;
                case AMPERSAND:
                    {
                    alt30=14;
                    }
                    break;
                case SLASH:
                    {
                    alt30=15;
                    }
                    break;
                case EQUALS:
                    {
                    alt30=16;
                    }
                    break;
                case DASH:
                    {
                    alt30=17;
                    }
                    break;
                case X_Occi_ATTRIBUTE_KEY:
                    {
                    alt30=18;
                    }
                    break;
                case X_Occi_LOCATION_KEY:
                    {
                    alt30=19;
                    }
                    break;
                case 32:
                case 33:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                    {
                    alt30=20;
                    }
                    break;

                }

                } finally {dbg.exitDecision(30);}

                switch (alt30) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:11: LOALPHA
            	    {
            	    dbg.location(77,11);
            	    match(input,LOALPHA,FOLLOW_LOALPHA_in_uri539); 

            	    }
            	    break;
            	case 2 :
            	    dbg.enterAlt(2);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:21: UPALPHA
            	    {
            	    dbg.location(77,21);
            	    match(input,UPALPHA,FOLLOW_UPALPHA_in_uri543); 

            	    }
            	    break;
            	case 3 :
            	    dbg.enterAlt(3);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:31: DIGIT
            	    {
            	    dbg.location(77,31);
            	    match(input,DIGIT,FOLLOW_DIGIT_in_uri547); 

            	    }
            	    break;
            	case 4 :
            	    dbg.enterAlt(4);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:39: AT
            	    {
            	    dbg.location(77,39);
            	    match(input,AT,FOLLOW_AT_in_uri551); 

            	    }
            	    break;
            	case 5 :
            	    dbg.enterAlt(5);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:44: COLON
            	    {
            	    dbg.location(77,44);
            	    match(input,COLON,FOLLOW_COLON_in_uri555); 

            	    }
            	    break;
            	case 6 :
            	    dbg.enterAlt(6);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:52: PERCENT
            	    {
            	    dbg.location(77,52);
            	    match(input,PERCENT,FOLLOW_PERCENT_in_uri559); 

            	    }
            	    break;
            	case 7 :
            	    dbg.enterAlt(7);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:62: UNDERSCORE
            	    {
            	    dbg.location(77,62);
            	    match(input,UNDERSCORE,FOLLOW_UNDERSCORE_in_uri563); 

            	    }
            	    break;
            	case 8 :
            	    dbg.enterAlt(8);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:75: BACKSLASH
            	    {
            	    dbg.location(77,75);
            	    match(input,BACKSLASH,FOLLOW_BACKSLASH_in_uri567); 

            	    }
            	    break;
            	case 9 :
            	    dbg.enterAlt(9);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:87: PLUS
            	    {
            	    dbg.location(77,87);
            	    match(input,PLUS,FOLLOW_PLUS_in_uri571); 

            	    }
            	    break;
            	case 10 :
            	    dbg.enterAlt(10);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:94: DOT
            	    {
            	    dbg.location(77,94);
            	    match(input,DOT,FOLLOW_DOT_in_uri575); 

            	    }
            	    break;
            	case 11 :
            	    dbg.enterAlt(11);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:100: TILDE
            	    {
            	    dbg.location(77,100);
            	    match(input,TILDE,FOLLOW_TILDE_in_uri579); 

            	    }
            	    break;
            	case 12 :
            	    dbg.enterAlt(12);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:108: HASH
            	    {
            	    dbg.location(77,108);
            	    match(input,HASH,FOLLOW_HASH_in_uri583); 

            	    }
            	    break;
            	case 13 :
            	    dbg.enterAlt(13);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:115: QUESTION
            	    {
            	    dbg.location(77,115);
            	    match(input,QUESTION,FOLLOW_QUESTION_in_uri587); 

            	    }
            	    break;
            	case 14 :
            	    dbg.enterAlt(14);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:126: AMPERSAND
            	    {
            	    dbg.location(77,126);
            	    match(input,AMPERSAND,FOLLOW_AMPERSAND_in_uri591); 

            	    }
            	    break;
            	case 15 :
            	    dbg.enterAlt(15);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:138: SLASH
            	    {
            	    dbg.location(77,138);
            	    match(input,SLASH,FOLLOW_SLASH_in_uri595); 

            	    }
            	    break;
            	case 16 :
            	    dbg.enterAlt(16);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:146: EQUALS
            	    {
            	    dbg.location(77,146);
            	    match(input,EQUALS,FOLLOW_EQUALS_in_uri599); 

            	    }
            	    break;
            	case 17 :
            	    dbg.enterAlt(17);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:155: DASH
            	    {
            	    dbg.location(77,155);
            	    match(input,DASH,FOLLOW_DASH_in_uri603); 

            	    }
            	    break;
            	case 18 :
            	    dbg.enterAlt(18);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:162: X_Occi_ATTRIBUTE_KEY
            	    {
            	    dbg.location(77,162);
            	    match(input,X_Occi_ATTRIBUTE_KEY,FOLLOW_X_Occi_ATTRIBUTE_KEY_in_uri607);

            	    }
            	    break;
            	case 19 :
            	    dbg.enterAlt(19);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:185: X_Occi_LOCATION_KEY
            	    {
            	    dbg.location(77,185);
            	    match(input,X_Occi_LOCATION_KEY,FOLLOW_X_Occi_LOCATION_KEY_in_uri611);

            	    }
            	    break;
            	case 20 :
            	    dbg.enterAlt(20);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:77:207: reserved_words
            	    {
            	    dbg.location(77,207);
            	    pushFollow(FOLLOW_reserved_words_in_uri615);
            	    reserved_words();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    if ( cnt30 >= 1 ) break loop30;
                        EarlyExitException eee =
                            new EarlyExitException(30, input);
                        dbg.recognitionException(eee);

                        throw eee;
                }
                cnt30++;
            } while (true);
            } finally {dbg.exitSubRule(30);}


            }

            retval.stop = input.LT(-1);


        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(77, 222);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "uri");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return retval;
    }
    // $ANTLR end "uri"



    // $ANTLR start "term"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:1: term : ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )* ;
    public final void term() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "term");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(78, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:8: ( ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )* )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:10: ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
            {
            dbg.location(78,10);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:10: ( LOALPHA | reserved_words )
            int alt31=2;
            try { dbg.enterSubRule(31);
            try { dbg.enterDecision(31, decisionCanBacktrack[31]);

            int LA31_0 = input.LA(1);

            if ( (LA31_0==LOALPHA) ) {
                alt31=1;
            }
            else if ( ((LA31_0 >= 32 && LA31_0 <= 45)) ) {
                alt31=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 31, 0, input);

                dbg.recognitionException(nvae);
                throw nvae;

            }
            } finally {dbg.exitDecision(31);}

            switch (alt31) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:12: LOALPHA
                    {
                    dbg.location(78,12);
                    match(input,LOALPHA,FOLLOW_LOALPHA_in_term628); 

                    }
                    break;
                case 2 :
                    dbg.enterAlt(2);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:22: reserved_words
                    {
                    dbg.location(78,22);
                    pushFollow(FOLLOW_reserved_words_in_term632);
                    reserved_words();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(31);}

            dbg.location(78,39);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:39: ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
            try { dbg.enterSubRule(32);

            loop32:
            do {
                int alt32=6;
                try { dbg.enterDecision(32, decisionCanBacktrack[32]);

                switch ( input.LA(1) ) {
                case LOALPHA:
                    {
                    alt32=1;
                    }
                    break;
                case DIGIT:
                    {
                    alt32=2;
                    }
                    break;
                case DASH:
                    {
                    alt32=3;
                    }
                    break;
                case UNDERSCORE:
                    {
                    alt32=4;
                    }
                    break;
                case 32:
                case 33:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                    {
                    alt32=5;
                    }
                    break;

                }

                } finally {dbg.exitDecision(32);}

                switch (alt32) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:41: LOALPHA
            	    {
            	    dbg.location(78,41);
            	    match(input,LOALPHA,FOLLOW_LOALPHA_in_term638); 

            	    }
            	    break;
            	case 2 :
            	    dbg.enterAlt(2);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:51: DIGIT
            	    {
            	    dbg.location(78,51);
            	    match(input,DIGIT,FOLLOW_DIGIT_in_term642); 

            	    }
            	    break;
            	case 3 :
            	    dbg.enterAlt(3);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:59: DASH
            	    {
            	    dbg.location(78,59);
            	    match(input,DASH,FOLLOW_DASH_in_term646); 

            	    }
            	    break;
            	case 4 :
            	    dbg.enterAlt(4);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:66: UNDERSCORE
            	    {
            	    dbg.location(78,66);
            	    match(input,UNDERSCORE,FOLLOW_UNDERSCORE_in_term650); 

            	    }
            	    break;
            	case 5 :
            	    dbg.enterAlt(5);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:78:79: reserved_words
            	    {
            	    dbg.location(78,79);
            	    pushFollow(FOLLOW_reserved_words_in_term654);
            	    reserved_words();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop32;
                }
            } while (true);
            } finally {dbg.exitSubRule(32);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(78, 95);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "term");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "term"



    // $ANTLR start "scheme"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:79:1: scheme : uri ;
    public final void scheme() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "scheme");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(79, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:79:18: ( uri )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:79:20: uri
            {
            dbg.location(79,20);
            pushFollow(FOLLOW_uri_in_scheme674);
            uri();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(79, 22);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "scheme");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "scheme"



    // $ANTLR start "class_type"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:80:1: class_type : ( 'kind' | 'mixin' | 'action' ) ;
    public final void class_type() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "class_type");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(80, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:80:13: ( ( 'kind' | 'mixin' | 'action' ) )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:
            {
            dbg.location(80,13);
            if ( input.LA(1)==32||input.LA(1)==37||input.LA(1)==40 ) {
                input.consume();
                state.errorRecovery=false;
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                dbg.recognitionException(mse);
                throw mse;
            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(80, 45);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "class_type");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "class_type"



    // $ANTLR start "title"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:81:1: title : ( ESC |~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )* ;
    public final void title() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "title");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(81, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:81:9: ( ( ESC |~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )* )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:81:11: ( ESC |~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )*
            {
            dbg.location(81,11);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:81:11: ( ESC |~ ( BACKSLASH | QUOTE | SQUOTE ) | SQUOTE )*
            try { dbg.enterSubRule(33);

            loop33:
            do {
                int alt33=2;
                try { dbg.enterDecision(33, decisionCanBacktrack[33]);

                int LA33_0 = input.LA(1);

                if ( ((LA33_0 >= AMPERSAND && LA33_0 <= AT)||(LA33_0 >= CATEGORY_KEY && LA33_0 <= QUESTION)||(LA33_0 >= SEMICOLON && LA33_0 <= 45)) ) {
                    alt33=1;
                }


                } finally {dbg.exitDecision(33);}

                switch (alt33) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:
            	    {
            	    dbg.location(81,11);
            	    if ( (input.LA(1) >= AMPERSAND && input.LA(1) <= AT)||(input.LA(1) >= CATEGORY_KEY && input.LA(1) <= QUESTION)||(input.LA(1) >= SEMICOLON && input.LA(1) <= 45) ) {
            	        input.consume();
            	        state.errorRecovery=false;
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        dbg.recognitionException(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    break loop33;
                }
            } while (true);
            } finally {dbg.exitSubRule(33);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(81, 61);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "title");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "title"



    // $ANTLR start "attribute"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:82:1: attribute : comp_first= attribute_component ( '.' comp_next= attribute_component )* EQUALS attribute_value ;
    public final void attribute() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "attribute");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(82, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:82:11: (comp_first= attribute_component ( '.' comp_next= attribute_component )* EQUALS attribute_value )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:82:13: comp_first= attribute_component ( '.' comp_next= attribute_component )* EQUALS attribute_value
            {
            dbg.location(82,23);
            pushFollow(FOLLOW_attribute_component_in_attribute739);
            attribute_component();

            state._fsp--;

            dbg.location(83,6);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:83:6: ( '.' comp_next= attribute_component )*
            try { dbg.enterSubRule(34);

            loop34:
            do {
                int alt34=2;
                try { dbg.enterDecision(34, decisionCanBacktrack[34]);

                int LA34_0 = input.LA(1);

                if ( (LA34_0==DOT) ) {
                    alt34=1;
                }


                } finally {dbg.exitDecision(34);}

                switch (alt34) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:83:8: '.' comp_next= attribute_component
            	    {
            	    dbg.location(83,8);
            	    match(input,DOT,FOLLOW_DOT_in_attribute749); 
            	    dbg.location(83,21);
            	    pushFollow(FOLLOW_attribute_component_in_attribute753);
            	    attribute_component();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop34;
                }
            } while (true);
            } finally {dbg.exitSubRule(34);}

            dbg.location(84,6);
            match(input,EQUALS,FOLLOW_EQUALS_in_attribute763); 
            dbg.location(84,13);
            pushFollow(FOLLOW_attribute_value_in_attribute765);
            attribute_value();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(84, 28);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "attribute");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "attribute"



    // $ANTLR start "attribute_name"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:85:1: attribute_name : comp_first= attribute_component ( '.' comp_next= attribute_component )* ;
    public final void attribute_name() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "attribute_name");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(85, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:86:25: (comp_first= attribute_component ( '.' comp_next= attribute_component )* )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:86:27: comp_first= attribute_component ( '.' comp_next= attribute_component )*
            {
            dbg.location(86,37);
            pushFollow(FOLLOW_attribute_component_in_attribute_name800);
            attribute_component();

            state._fsp--;

            dbg.location(87,6);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:87:6: ( '.' comp_next= attribute_component )*
            try { dbg.enterSubRule(35);

            loop35:
            do {
                int alt35=2;
                try { dbg.enterDecision(35, decisionCanBacktrack[35]);

                int LA35_0 = input.LA(1);

                if ( (LA35_0==DOT) ) {
                    alt35=1;
                }


                } finally {dbg.exitDecision(35);}

                switch (alt35) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:87:8: '.' comp_next= attribute_component
            	    {
            	    dbg.location(87,8);
            	    match(input,DOT,FOLLOW_DOT_in_attribute_name810); 
            	    dbg.location(87,21);
            	    pushFollow(FOLLOW_attribute_component_in_attribute_name814);
            	    attribute_component();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop35;
                }
            } while (true);
            } finally {dbg.exitSubRule(35);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(87, 43);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "attribute_name");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "attribute_name"



    // $ANTLR start "attribute_component"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:1: attribute_component : ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )* ;
    public final void attribute_component() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "attribute_component");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(88, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:21: ( ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )* )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:23: ( LOALPHA | reserved_words ) ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
            {
            dbg.location(88,23);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:23: ( LOALPHA | reserved_words )
            int alt36=2;
            try { dbg.enterSubRule(36);
            try { dbg.enterDecision(36, decisionCanBacktrack[36]);

            int LA36_0 = input.LA(1);

            if ( (LA36_0==LOALPHA) ) {
                alt36=1;
            }
            else if ( ((LA36_0 >= 32 && LA36_0 <= 45)) ) {
                alt36=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 36, 0, input);

                dbg.recognitionException(nvae);
                throw nvae;

            }
            } finally {dbg.exitDecision(36);}

            switch (alt36) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:25: LOALPHA
                    {
                    dbg.location(88,25);
                    match(input,LOALPHA,FOLLOW_LOALPHA_in_attribute_component826); 

                    }
                    break;
                case 2 :
                    dbg.enterAlt(2);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:35: reserved_words
                    {
                    dbg.location(88,35);
                    pushFollow(FOLLOW_reserved_words_in_attribute_component830);
                    reserved_words();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(36);}

            dbg.location(88,51);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:51: ( LOALPHA | DIGIT | DASH | UNDERSCORE | reserved_words )*
            try { dbg.enterSubRule(37);

            loop37:
            do {
                int alt37=6;
                try { dbg.enterDecision(37, decisionCanBacktrack[37]);

                switch ( input.LA(1) ) {
                case LOALPHA:
                    {
                    alt37=1;
                    }
                    break;
                case DIGIT:
                    {
                    alt37=2;
                    }
                    break;
                case DASH:
                    {
                    alt37=3;
                    }
                    break;
                case UNDERSCORE:
                    {
                    alt37=4;
                    }
                    break;
                case 32:
                case 33:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                    {
                    alt37=5;
                    }
                    break;

                }

                } finally {dbg.exitDecision(37);}

                switch (alt37) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:53: LOALPHA
            	    {
            	    dbg.location(88,53);
            	    match(input,LOALPHA,FOLLOW_LOALPHA_in_attribute_component835); 

            	    }
            	    break;
            	case 2 :
            	    dbg.enterAlt(2);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:63: DIGIT
            	    {
            	    dbg.location(88,63);
            	    match(input,DIGIT,FOLLOW_DIGIT_in_attribute_component839); 

            	    }
            	    break;
            	case 3 :
            	    dbg.enterAlt(3);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:71: DASH
            	    {
            	    dbg.location(88,71);
            	    match(input,DASH,FOLLOW_DASH_in_attribute_component843); 

            	    }
            	    break;
            	case 4 :
            	    dbg.enterAlt(4);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:78: UNDERSCORE
            	    {
            	    dbg.location(88,78);
            	    match(input,UNDERSCORE,FOLLOW_UNDERSCORE_in_attribute_component847); 

            	    }
            	    break;
            	case 5 :
            	    dbg.enterAlt(5);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:88:91: reserved_words
            	    {
            	    dbg.location(88,91);
            	    pushFollow(FOLLOW_reserved_words_in_attribute_component851);
            	    reserved_words();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop37;
                }
            } while (true);
            } finally {dbg.exitSubRule(37);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(88, 108);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "attribute_component");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "attribute_component"



    // $ANTLR start "attribute_value"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:1: attribute_value : ( ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE ) | number ) ;
    public final void attribute_value() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "attribute_value");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(89, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:18: ( ( ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE ) | number ) )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:20: ( ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE ) | number )
            {
            dbg.location(89,20);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:20: ( ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE ) | number )
            int alt39=2;
            try { dbg.enterSubRule(39);
            try { dbg.enterDecision(39, decisionCanBacktrack[39]);

            int LA39_0 = input.LA(1);

            if ( (LA39_0==QUOTE) ) {
                alt39=1;
            }
            else if ( (LA39_0==DIGIT) ) {
                alt39=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 39, 0, input);

                dbg.recognitionException(nvae);
                throw nvae;

            }
            } finally {dbg.exitDecision(39);}

            switch (alt39) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:22: ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE )
                    {
                    dbg.location(89,22);
                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:22: ( QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE )
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:24: QUOTE ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )* QUOTE
                    {
                    dbg.location(89,24);
                    match(input,QUOTE,FOLLOW_QUOTE_in_attribute_value867); 
                    dbg.location(89,30);
                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:30: ( ESC |~ ( '\\\\' | QUOTE | '\\'' ) | '\\'' )*
                    try { dbg.enterSubRule(38);

                    loop38:
                    do {
                        int alt38=2;
                        try { dbg.enterDecision(38, decisionCanBacktrack[38]);

                        int LA38_0 = input.LA(1);

                        if ( ((LA38_0 >= AMPERSAND && LA38_0 <= AT)||(LA38_0 >= CATEGORY_KEY && LA38_0 <= QUESTION)||(LA38_0 >= SEMICOLON && LA38_0 <= 45)) ) {
                            alt38=1;
                        }


                        } finally {dbg.exitDecision(38);}

                        switch (alt38) {
                    	case 1 :
                    	    dbg.enterAlt(1);

                    	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:
                    	    {
                    	    dbg.location(89,30);
                    	    if ( (input.LA(1) >= AMPERSAND && input.LA(1) <= AT)||(input.LA(1) >= CATEGORY_KEY && input.LA(1) <= QUESTION)||(input.LA(1) >= SEMICOLON && input.LA(1) <= 45) ) {
                    	        input.consume();
                    	        state.errorRecovery=false;
                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        dbg.recognitionException(mse);
                    	        throw mse;
                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop38;
                        }
                    } while (true);
                    } finally {dbg.exitSubRule(38);}

                    dbg.location(89,73);
                    match(input,QUOTE,FOLLOW_QUOTE_in_attribute_value897); 

                    }


                    }
                    break;
                case 2 :
                    dbg.enterAlt(2);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:89:83: number
                    {
                    dbg.location(89,83);
                    pushFollow(FOLLOW_number_in_attribute_value903);
                    number();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(39);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(89, 90);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "attribute_value");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "attribute_value"



    // $ANTLR start "number"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:1: number : ( digits ( DOT digits )? ) ;
    public final void number() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "number");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(90, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:10: ( ( digits ( DOT digits )? ) )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:12: ( digits ( DOT digits )? )
            {
            dbg.location(90,12);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:12: ( digits ( DOT digits )? )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:14: digits ( DOT digits )?
            {
            dbg.location(90,14);
            pushFollow(FOLLOW_digits_in_number916);
            digits();

            state._fsp--;

            dbg.location(90,21);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:21: ( DOT digits )?
            int alt40=2;
            try { dbg.enterSubRule(40);
            try { dbg.enterDecision(40, decisionCanBacktrack[40]);

            int LA40_0 = input.LA(1);

            if ( (LA40_0==DOT) ) {
                alt40=1;
            }
            } finally {dbg.exitDecision(40);}

            switch (alt40) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:90:23: DOT digits
                    {
                    dbg.location(90,23);
                    match(input,DOT,FOLLOW_DOT_in_number920); 
                    dbg.location(90,27);
                    pushFollow(FOLLOW_digits_in_number922);
                    digits();

                    state._fsp--;


                    }
                    break;

            }
            } finally {dbg.exitSubRule(40);}


            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(90, 37);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "number");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "number"



    // $ANTLR start "reserved_words"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:91:1: reserved_words : ( 'action' | 'actions' | 'attributes' | 'category' | 'class' | 'kind' | 'link' | 'location' | 'mixin' | 'rel' | 'scheme' | 'self' | 'term' | 'title' ) ;
    public final void reserved_words() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "reserved_words");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(91, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:92:2: ( ( 'action' | 'actions' | 'attributes' | 'category' | 'class' | 'kind' | 'link' | 'location' | 'mixin' | 'rel' | 'scheme' | 'self' | 'term' | 'title' ) )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:
            {
            dbg.location(92,2);
            if ( (input.LA(1) >= 32 && input.LA(1) <= 45) ) {
                input.consume();
                state.errorRecovery=false;
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                dbg.recognitionException(mse);
                throw mse;
            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(92, 153);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "reserved_words");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "reserved_words"



    // $ANTLR start "digits"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:133:1: digits : ( DIGIT )+ ;
    public final void digits() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "digits");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(133, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:133:8: ( ( DIGIT )+ )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:133:10: ( DIGIT )+
            {
            dbg.location(133,10);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:133:10: ( DIGIT )+
            int cnt41=0;
            try { dbg.enterSubRule(41);

            loop41:
            do {
                int alt41=2;
                try { dbg.enterDecision(41, decisionCanBacktrack[41]);

                int LA41_0 = input.LA(1);

                if ( (LA41_0==DIGIT) ) {
                    alt41=1;
                }


                } finally {dbg.exitDecision(41);}

                switch (alt41) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/OCCIANTLR.g:133:10: DIGIT
            	    {
            	    dbg.location(133,10);
            	    match(input,DIGIT,FOLLOW_DIGIT_in_digits1264); 

            	    }
            	    break;

            	default :
            	    if ( cnt41 >= 1 ) break loop41;
                        EarlyExitException eee =
                            new EarlyExitException(41, input);
                        dbg.recognitionException(eee);

                        throw eee;
                }
                cnt41++;
            } while (true);
            } finally {dbg.exitSubRule(41);}


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(133, 15);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "digits");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "digits"

    // Delegated rules


    protected DFA17 dfa17 = new DFA17(this);
    protected DFA18 dfa18 = new DFA18(this);
    static final String DFA17_eotS =
        "\34\uffff";
    static final String DFA17_eofS =
        "\2\2\32\uffff";
    static final String DFA17_minS =
        "\1\27\1\21\1\uffff\1\21\1\11\1\12\10\4\1\uffff\14\4\1\uffff";
    static final String DFA17_maxS =
        "\1\27\1\55\1\uffff\2\55\1\26\10\55\1\uffff\14\55\1\uffff";
    static final String DFA17_acceptS =
        "\2\uffff\1\2\13\uffff\1\1\14\uffff\1\1";
    static final String DFA17_specialS =
        "\34\uffff}>";
    static final String[] DFA17_transitionS = {
            "\1\1",
            "\1\2\13\uffff\1\3\2\uffff\13\2\1\4\2\2",
            "",
            "\1\2\16\uffff\13\2\1\4\2\2",
            "\3\2\1\5\4\uffff\1\2\11\uffff\1\2\4\uffff\16\2",
            "\1\2\13\uffff\1\6",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\2\2\1\25\1\2\1\21\1\15\1\10\1\2\1\30\1"+
            "\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            ""
    };

    static final short[] DFA17_eot = DFA.unpackEncodedString(DFA17_eotS);
    static final short[] DFA17_eof = DFA.unpackEncodedString(DFA17_eofS);
    static final char[] DFA17_min = DFA.unpackEncodedStringToUnsignedChars(DFA17_minS);
    static final char[] DFA17_max = DFA.unpackEncodedStringToUnsignedChars(DFA17_maxS);
    static final short[] DFA17_accept = DFA.unpackEncodedString(DFA17_acceptS);
    static final short[] DFA17_special = DFA.unpackEncodedString(DFA17_specialS);
    static final short[][] DFA17_transition;

    static {
        int numStates = DFA17_transitionS.length;
        DFA17_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA17_transition[i] = DFA.unpackEncodedString(DFA17_transitionS[i]);
        }
    }

    class DFA17 extends DFA {

        public DFA17(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 17;
            this.eot = DFA17_eot;
            this.eof = DFA17_eof;
            this.min = DFA17_min;
            this.max = DFA17_max;
            this.accept = DFA17_accept;
            this.special = DFA17_special;
            this.transition = DFA17_transition;
        }
        public String getDescription() {
            return "44:6: ( link_self )?";
        }
        public void error(NoViableAltException nvae) {
            dbg.recognitionException(nvae);
        }
    }
    static final String DFA18_eotS =
        "\34\uffff";
    static final String DFA18_eofS =
        "\2\2\32\uffff";
    static final String DFA18_minS =
        "\1\27\1\21\1\uffff\1\21\1\11\1\12\10\4\1\uffff\14\4\1\uffff";
    static final String DFA18_maxS =
        "\1\27\1\55\1\uffff\2\55\1\26\10\55\1\uffff\14\55\1\uffff";
    static final String DFA18_acceptS =
        "\2\uffff\1\2\13\uffff\1\1\14\uffff\1\1";
    static final String DFA18_specialS =
        "\34\uffff}>";
    static final String[] DFA18_transitionS = {
            "\1\1",
            "\1\2\13\uffff\1\3\2\uffff\3\2\1\4\12\2",
            "",
            "\1\2\16\uffff\3\2\1\4\12\2",
            "\3\2\1\5\4\uffff\1\2\11\uffff\1\2\4\uffff\16\2",
            "\1\2\13\uffff\1\6",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\2\2\1\25\1\2\1\21\1\15\1\10\1\2\1\30\1"+
            "\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            "\1\24\1\12\1\16\1\2\1\13\1\27\1\11\1\20\1\26\2\2\1\22\1\2\1"+
            "\7\1\2\1\14\1\17\1\23\1\33\1\2\1\25\1\2\1\21\1\15\1\10\1\2\1"+
            "\30\1\31\16\32",
            ""
    };

    static final short[] DFA18_eot = DFA.unpackEncodedString(DFA18_eotS);
    static final short[] DFA18_eof = DFA.unpackEncodedString(DFA18_eofS);
    static final char[] DFA18_min = DFA.unpackEncodedStringToUnsignedChars(DFA18_minS);
    static final char[] DFA18_max = DFA.unpackEncodedStringToUnsignedChars(DFA18_maxS);
    static final short[] DFA18_accept = DFA.unpackEncodedString(DFA18_acceptS);
    static final short[] DFA18_special = DFA.unpackEncodedString(DFA18_specialS);
    static final short[][] DFA18_transition;

    static {
        int numStates = DFA18_transitionS.length;
        DFA18_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA18_transition[i] = DFA.unpackEncodedString(DFA18_transitionS[i]);
        }
    }

    class DFA18 extends DFA {

        public DFA18(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 18;
            this.eot = DFA18_eot;
            this.eof = DFA18_eof;
            this.min = DFA18_min;
            this.max = DFA18_max;
            this.accept = DFA18_accept;
            this.special = DFA18_special;
            this.transition = DFA18_transition;
        }
        public String getDescription() {
            return "45:6: ( link_category )?";
        }
        public void error(NoViableAltException nvae) {
            dbg.recognitionException(nvae);
        }
    }
 

    public static final BitSet FOLLOW_CATEGORY_KEY_in_category15 = new BitSet(new long[]{0x0000000000000100L});
    public static final BitSet FOLLOW_COLON_in_category17 = new BitSet(new long[]{0x00003FFF20020000L});
    public static final BitSet FOLLOW_category_value_in_category19 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_category_term_in_category_value42 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_category_scheme_in_category_value44 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_category_class_in_category_value46 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_category_title_in_category_value48 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_category_rel_in_category_value51 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_category_location_in_category_value54 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_category_attributes_in_category_value57 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_category_actions_in_category_value60 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_value63 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_WS_in_category_term76 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_term_in_category_term79 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_scheme89 = new BitSet(new long[]{0x0000040020000000L});
    public static final BitSet FOLLOW_WS_in_category_scheme91 = new BitSet(new long[]{0x0000040000000000L});
    public static final BitSet FOLLOW_42_in_category_scheme94 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_scheme96 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_scheme98 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_scheme_in_category_scheme100 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_scheme102 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_class113 = new BitSet(new long[]{0x0000001020000000L});
    public static final BitSet FOLLOW_WS_in_category_class115 = new BitSet(new long[]{0x0000001000000000L});
    public static final BitSet FOLLOW_36_in_category_class118 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_class120 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_class122 = new BitSet(new long[]{0x0000012100000000L});
    public static final BitSet FOLLOW_class_type_in_category_class124 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_class126 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_title136 = new BitSet(new long[]{0x0000200020000000L});
    public static final BitSet FOLLOW_WS_in_category_title138 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_category_title141 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_title143 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_title145 = new BitSet(new long[]{0x00003FFFFFFFFFB0L});
    public static final BitSet FOLLOW_title_in_category_title147 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_title149 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_rel160 = new BitSet(new long[]{0x0000020020000000L});
    public static final BitSet FOLLOW_WS_in_category_rel162 = new BitSet(new long[]{0x0000020000000000L});
    public static final BitSet FOLLOW_41_in_category_rel165 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_rel167 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_rel169 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_category_rel171 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_rel173 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_location183 = new BitSet(new long[]{0x0000008020000000L});
    public static final BitSet FOLLOW_WS_in_category_location185 = new BitSet(new long[]{0x0000008000000000L});
    public static final BitSet FOLLOW_39_in_category_location188 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_location190 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_location192 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_category_location194 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_location196 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_attributes206 = new BitSet(new long[]{0x0000000420000000L});
    public static final BitSet FOLLOW_WS_in_category_attributes208 = new BitSet(new long[]{0x0000000400000000L});
    public static final BitSet FOLLOW_34_in_category_attributes211 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_attributes213 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_attributes215 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_name_in_category_attributes219 = new BitSet(new long[]{0x0000000020400000L});
    public static final BitSet FOLLOW_WS_in_category_attributes233 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_name_in_category_attributes237 = new BitSet(new long[]{0x0000000020400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_attributes244 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_category_actions261 = new BitSet(new long[]{0x0000000220000000L});
    public static final BitSet FOLLOW_WS_in_category_actions263 = new BitSet(new long[]{0x0000000200000000L});
    public static final BitSet FOLLOW_33_in_category_actions266 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_category_actions268 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_actions270 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_category_actions274 = new BitSet(new long[]{0x0000000020400000L});
    public static final BitSet FOLLOW_WS_in_category_actions287 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_category_actions291 = new BitSet(new long[]{0x0000000020400000L});
    public static final BitSet FOLLOW_QUOTE_in_category_actions297 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_LINK_KEY_in_link311 = new BitSet(new long[]{0x0000000000000100L});
    public static final BitSet FOLLOW_COLON_in_link313 = new BitSet(new long[]{0x0000000020040000L});
    public static final BitSet FOLLOW_link_value_in_link315 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_link_target_in_link_value328 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_link_rel_in_link_value336 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_link_self_in_link_value343 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_link_category_in_link_value352 = new BitSet(new long[]{0x0000000000800000L});
    public static final BitSet FOLLOW_link_attributes_in_link_value361 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_SEMICOLON_in_link_value369 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_WS_in_link_target383 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_LT_in_link_target386 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_link_target388 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_GT_in_link_target390 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_link_rel401 = new BitSet(new long[]{0x0000020020000000L});
    public static final BitSet FOLLOW_WS_in_link_rel403 = new BitSet(new long[]{0x0000020000000000L});
    public static final BitSet FOLLOW_41_in_link_rel406 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_link_rel408 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_rel410 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_link_rel412 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_rel414 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_link_self424 = new BitSet(new long[]{0x0000080020000000L});
    public static final BitSet FOLLOW_WS_in_link_self426 = new BitSet(new long[]{0x0000080000000000L});
    public static final BitSet FOLLOW_43_in_link_self429 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_link_self431 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_self433 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_link_self435 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_self437 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_link_category446 = new BitSet(new long[]{0x0000000820000000L});
    public static final BitSet FOLLOW_WS_in_link_category448 = new BitSet(new long[]{0x0000000800000000L});
    public static final BitSet FOLLOW_35_in_link_category451 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_EQUALS_in_link_category453 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_category455 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_link_category457 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_QUOTE_in_link_category459 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_SEMICOLON_in_link_attributes469 = new BitSet(new long[]{0x00003FFF20020000L});
    public static final BitSet FOLLOW_WS_in_link_attributes471 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_in_link_attributes474 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_X_Occi_ATTRIBUTE_KEY_in_x_Occi_attribute491 = new BitSet(new long[]{0x0000000000000100L});
    public static final BitSet FOLLOW_COLON_in_x_Occi_attribute493 = new BitSet(new long[]{0x00003FFF20020000L});
    public static final BitSet FOLLOW_WS_in_x_Occi_attribute495 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_in_x_Occi_attribute498 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_SEMICOLON_in_x_Occi_attribute500 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_X_Occi_LOCATION_KEY_in_x_Occi_location515 = new BitSet(new long[]{0x0000000000000100L});
    public static final BitSet FOLLOW_COLON_in_x_Occi_location517 = new BitSet(new long[]{0x00003FFFFD3A9F70L});
    public static final BitSet FOLLOW_WS_in_x_Occi_location519 = new BitSet(new long[]{0x00003FFFDD3A9F70L});
    public static final BitSet FOLLOW_uri_in_x_Occi_location522 = new BitSet(new long[]{0x0000000000800002L});
    public static final BitSet FOLLOW_SEMICOLON_in_x_Occi_location524 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_LOALPHA_in_uri539 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_UPALPHA_in_uri543 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_DIGIT_in_uri547 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_AT_in_uri551 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_COLON_in_uri555 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_PERCENT_in_uri559 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_UNDERSCORE_in_uri563 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_BACKSLASH_in_uri567 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_PLUS_in_uri571 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_DOT_in_uri575 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_TILDE_in_uri579 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_HASH_in_uri583 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_QUESTION_in_uri587 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_AMPERSAND_in_uri591 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_SLASH_in_uri595 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_EQUALS_in_uri599 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_DASH_in_uri603 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_X_Occi_ATTRIBUTE_KEY_in_uri607 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_X_Occi_LOCATION_KEY_in_uri611 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_reserved_words_in_uri615 = new BitSet(new long[]{0x00003FFFDD3A9F72L});
    public static final BitSet FOLLOW_LOALPHA_in_term628 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_reserved_words_in_term632 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_LOALPHA_in_term638 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_DIGIT_in_term642 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_DASH_in_term646 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_UNDERSCORE_in_term650 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_reserved_words_in_term654 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_uri_in_scheme674 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_attribute_component_in_attribute739 = new BitSet(new long[]{0x0000000000001800L});
    public static final BitSet FOLLOW_DOT_in_attribute749 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_component_in_attribute753 = new BitSet(new long[]{0x0000000000001800L});
    public static final BitSet FOLLOW_EQUALS_in_attribute763 = new BitSet(new long[]{0x0000000000400400L});
    public static final BitSet FOLLOW_attribute_value_in_attribute765 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_attribute_component_in_attribute_name800 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_DOT_in_attribute_name810 = new BitSet(new long[]{0x00003FFF00020000L});
    public static final BitSet FOLLOW_attribute_component_in_attribute_name814 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_LOALPHA_in_attribute_component826 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_reserved_words_in_attribute_component830 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_LOALPHA_in_attribute_component835 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_DIGIT_in_attribute_component839 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_DASH_in_attribute_component843 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_UNDERSCORE_in_attribute_component847 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_reserved_words_in_attribute_component851 = new BitSet(new long[]{0x00003FFF08020602L});
    public static final BitSet FOLLOW_QUOTE_in_attribute_value867 = new BitSet(new long[]{0x00003FFFFFFFFFB0L});
    public static final BitSet FOLLOW_QUOTE_in_attribute_value897 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_number_in_attribute_value903 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_digits_in_number916 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_DOT_in_number920 = new BitSet(new long[]{0x0000000000000400L});
    public static final BitSet FOLLOW_digits_in_number922 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_DIGIT_in_digits1264 = new BitSet(new long[]{0x0000000000000402L});

}