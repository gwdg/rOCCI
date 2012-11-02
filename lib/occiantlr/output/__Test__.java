import java.io.*;
import org.antlr.runtime.*;
import org.antlr.runtime.debug.DebugEventSocketProxy;


public class __Test__ {

    public static void main(String args[]) throws Exception {
        testLexer lex = new testLexer(new ANTLRFileStream("/Users/ffeldhaus/Development/rOcci/lib/Occiantlr/output/__Test___input.txt", "UTF8"));
        CommonTokenStream tokens = new CommonTokenStream(lex);

        testParser g = new testParser(tokens, 49100, null);
        try {
            g.test();
        } catch (RecognitionException e) {
            e.printStackTrace();
        }
    }
}