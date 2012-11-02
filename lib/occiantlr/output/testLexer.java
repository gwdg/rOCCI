// $ANTLR 3.4 /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g 2012-09-05 18:51:20

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked"})
public class testLexer extends Lexer {
    public static final int EOF=-1;
    public static final int T__6=6;
    public static final int WORD=4;
    public static final int WS=5;

    // delegates
    // delegators
    public Lexer[] getDelegates() {
        return new Lexer[] {};
    }

    public testLexer() {} 
    public testLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
    public testLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);
    }
    public String getGrammarFileName() { return "/Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g"; }

    // $ANTLR start "T__6"
    public final void mT__6() throws RecognitionException {
        try {
            int _type = T__6;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:2:6: ( '\"' )
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:2:8: '\"'
            {
            match('\"'); 

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "T__6"

    // $ANTLR start "WS"
    public final void mWS() throws RecognitionException {
        try {
            int _type = WS;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:5:9: ( ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+ )
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:5:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
            {
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:5:12: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
            int cnt1=0;
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( ((LA1_0 >= '\t' && LA1_0 <= '\n')||(LA1_0 >= '\f' && LA1_0 <= '\r')||LA1_0==' ') ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:
            	    {
            	    if ( (input.LA(1) >= '\t' && input.LA(1) <= '\n')||(input.LA(1) >= '\f' && input.LA(1) <= '\r')||input.LA(1)==' ' ) {
            	        input.consume();
            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;
            	    }


            	    }
            	    break;

            	default :
            	    if ( cnt1 >= 1 ) break loop1;
                        EarlyExitException eee =
                            new EarlyExitException(1, input);
                        throw eee;
                }
                cnt1++;
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "WS"

    // $ANTLR start "WORD"
    public final void mWORD() throws RecognitionException {
        try {
            int _type = WORD;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:10:7: ( 'a..Z' )
            // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:10:9: 'a..Z'
            {
            match("a..Z"); 



            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        	// do for sure before leaving
        }
    }
    // $ANTLR end "WORD"

    public void mTokens() throws RecognitionException {
        // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:1:8: ( T__6 | WS | WORD )
        int alt2=3;
        switch ( input.LA(1) ) {
        case '\"':
            {
            alt2=1;
            }
            break;
        case '\t':
        case '\n':
        case '\f':
        case '\r':
        case ' ':
            {
            alt2=2;
            }
            break;
        case 'a':
            {
            alt2=3;
            }
            break;
        default:
            NoViableAltException nvae =
                new NoViableAltException("", 2, 0, input);

            throw nvae;

        }

        switch (alt2) {
            case 1 :
                // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:1:10: T__6
                {
                mT__6(); 


                }
                break;
            case 2 :
                // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:1:15: WS
                {
                mWS(); 


                }
                break;
            case 3 :
                // /Users/ffeldhaus/Development/rOcci/lib/Occiantlr/test.g:1:18: WORD
                {
                mWORD(); 


                }
                break;

        }

    }


 

}