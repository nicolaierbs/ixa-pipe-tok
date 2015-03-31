package es.ehu.si.ixa.ixa.pipe.tok;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Properties;

import es.ehu.si.ixa.ixa.pipe.tok.jflex.WhiteSpaceLexer;


/**
 *  WhiteSpaceTokenizer is based on the {@link WhiteSpaceLexer} class. 
 *  This Tokenizer overrides {@link AbstractTokenizer} getToken() method 
 *  by using the {@link WhiteSpaceLexer} yylex() method.
 *  
 *  The tokenizer detects whitespaces to separate tokens. It can also detect 
 *  and mark newlines and paragraphs using the CLI option --paragraphs.
 *  
 * @version 2014-01-30
 * 
 */
 
public class WhiteSpaceTokenizer<T> extends AbstractTokenizer<T> {

  
  private WhiteSpaceLexer jlexer;
  
  /**
   * Construct a new Tokenizer which uses the @link JFlexLexer specification
   * 
   * 
   * @param breader Reader
   * @param tokenFactory The TokenFactory that will be invoked to convert
   *        each string extracted by the @link JFlexLexer  into a @Token object
   * @param properties the ptions to the Tokenizer (the values of the -normalize parameter)
   * 
   */
  public WhiteSpaceTokenizer(BufferedReader breader, TokenFactory tokenFactory, Properties properties) {
    jlexer = new WhiteSpaceLexer(breader, tokenFactory, properties);
  }

  /**
   * It obtains the next token. This functions performs the actual tokenization 
   * by calling the @link JFlexLexer yylex() function
   *
   * @return the next token or null if none exists.
   */
  @Override
  @SuppressWarnings("unchecked")
  public T getToken() {
    try {
      return (T) jlexer.yylex();
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return nextToken;
  }
  
}
