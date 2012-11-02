// $ANTLR 3.4 /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g 2012-09-05 18:51:20

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

import org.antlr.runtime.debug.*;
import java.io.IOException;
@SuppressWarnings({"all", "warnings", "unchecked"})
public class testParser extends DebugParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "WORD", "WS", "'\"'"
    };

    public static final int EOF=-1;
    public static final int T__6=6;
    public static final int WORD=4;
    public static final int WS=5;

    // delegates
    public Parser[] getDelegates() {
        return new Parser[] {};
    }

    // delegators


public static final String[] ruleNames = new String[] {
    "invalidRule", "test", "quoted_string"
};

public static final boolean[] decisionCanBacktrack = new boolean[] {
    false, // invalid decision
    false, false
};

 
    public int ruleLevel = 0;
    public int getRuleLevel() { return ruleLevel; }
    public void incRuleLevel() { ruleLevel++; }
    public void decRuleLevel() { ruleLevel--; }
    public testParser(TokenStream input) {
        this(input, DebugEventSocketProxy.DEFAULT_DEBUGGER_PORT, new RecognizerSharedState());
    }
    public testParser(TokenStream input, int port, RecognizerSharedState state) {
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

public testParser(TokenStream input, DebugEventListener dbg) {
    super(input, dbg, new RecognizerSharedState());
}

protected boolean evalPredicate(boolean result, String predicate) {
    dbg.semanticPredicate(result, predicate);
    return result;
}

    public String[] getTokenNames() { return testParser.tokenNames; }
    public String getGrammarFileName() { return "/Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g"; }



    // $ANTLR start "test"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:3:1: test :{...}? WORD ( WS )? quoted_string ;
    public final void test() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "test");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(3, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:3:7: ({...}? WORD ( WS )? quoted_string )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:3:9: {...}? WORD ( WS )? quoted_string
            {
            dbg.location(3,9);
            if ( !(evalPredicate(input.LT(1).getText().equals("Category"),"input.LT(1).getText().equals(\"Category\")")) ) {
                throw new FailedPredicateException(input, "test", "input.LT(1).getText().equals(\"Category\")");
            }
            dbg.location(3,53);
            match(input,WORD,FOLLOW_WORD_in_test13); 
            dbg.location(3,58);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:3:58: ( WS )?
            int alt1=2;
            try { dbg.enterSubRule(1);
            try { dbg.enterDecision(1, decisionCanBacktrack[1]);

            int LA1_0 = input.LA(1);

            if ( (LA1_0==WS) ) {
                alt1=1;
            }
            } finally {dbg.exitDecision(1);}

            switch (alt1) {
                case 1 :
                    dbg.enterAlt(1);

                    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:3:58: WS
                    {
                    dbg.location(3,58);
                    match(input,WS,FOLLOW_WS_in_test15); 

                    }
                    break;

            }
            } finally {dbg.exitSubRule(1);}

            dbg.location(3,62);
            pushFollow(FOLLOW_quoted_string_in_test18);
            quoted_string();

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
        dbg.location(3, 74);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "test");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "test"



    // $ANTLR start "quoted_string"
    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:7:1: quoted_string : '\"' ( . )* '\"' ;
    public final void quoted_string() throws RecognitionException {
        try { dbg.enterRule(getGrammarFileName(), "quoted_string");
        if ( getRuleLevel()==0 ) {dbg.commence();}
        incRuleLevel();
        dbg.location(7, 0);

        try {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:8:2: ( '\"' ( . )* '\"' )
            dbg.enterAlt(1);

            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:8:4: '\"' ( . )* '\"'
            {
            dbg.location(8,4);
            match(input,6,FOLLOW_6_in_quoted_string62); 
            dbg.location(8,8);
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:8:8: ( . )*
            try { dbg.enterSubRule(2);

            loop2:
            do {
                int alt2=2;
                try { dbg.enterDecision(2, decisionCanBacktrack[2]);

                int LA2_0 = input.LA(1);

                if ( (LA2_0==6) ) {
                    alt2=2;
                }
                else if ( ((LA2_0 >= WORD && LA2_0 <= WS)) ) {
                    alt2=1;
                }


                } finally {dbg.exitDecision(2);}

                switch (alt2) {
            	case 1 :
            	    dbg.enterAlt(1);

            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:8:8: .
            	    {
            	    dbg.location(8,8);
            	    matchAny(input); 

            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);
            } finally {dbg.exitSubRule(2);}

            dbg.location(8,11);
            match(input,6,FOLLOW_6_in_quoted_string67); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }

        finally {
        	// do for sure before leaving
        }
        dbg.location(8, 13);

        }
        finally {
            dbg.exitRule(getGrammarFileName(), "quoted_string");
            decRuleLevel();
            if ( getRuleLevel()==0 ) {dbg.terminate();}
        }

        return ;
    }
    // $ANTLR end "quoted_string"

    // Delegated rules


 

    public static final BitSet FOLLOW_WORD_in_test13 = new BitSet(new long[]{0x0000000000000060L});
    public static final BitSet FOLLOW_WS_in_test15 = new BitSet(new long[]{0x0000000000000040L});
    public static final BitSet FOLLOW_quoted_string_in_test18 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_6_in_quoted_string62 = new BitSet(new long[]{0x0000000000000070L});
    public static final BitSet FOLLOW_6_in_quoted_string67 = new BitSet(new long[]{0x0000000000000002L});

}