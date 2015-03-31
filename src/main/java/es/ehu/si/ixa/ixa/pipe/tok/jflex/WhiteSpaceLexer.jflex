package es.ehu.si.ixa.ixa.pipe.tok.jflex;

// Based on the Stanford English Tokenizer -- a deterministic, fast high-quality tokenizer
// Copyright (c) 2002-2009 The Board of Trustees of
// The Leland Stanford Junior University. All Rights Reserved.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//
// For more information, bug reports, fixes, contact:
//    Christopher Manning
//    Dept of Computer Science, Gates 1A
//    Stanford CA 94305-9010
//    USA
//    java-nlp-support@lists.stanford.edu
//    http://nlp.stanford.edu/software/


/* --------------------------Usercode Section------------------------ */


import java.io.Reader;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import java.util.Properties;
import es.ehu.si.ixa.ixa.pipe.tok.Token;
import es.ehu.si.ixa.ixa.pipe.tok.TokenFactory;
	
/* -----------------Options and Declarations Section----------------- */

%%

%public
%class WhiteSpaceLexer
%unicode
%type Token
%caseless
%char
 
/* 
 * Member variables and functions
 */

%{

  private TokenFactory tokenFactory;
  private static final Logger LOGGER = Logger.getLogger(WhiteSpaceLexer.class.getName());
  
  
  /////////////////
  //// OPTIONS ////
  /////////////////
  
  
  /* Flags begin with ptb3Normalize minus americanize, brackets and forward slash escaping */
  
  //private boolean americanize = false;
  private boolean tokenizeNLs;
  private boolean tokenizeParagraphs;
 
  public WhiteSpaceLexer(Reader breader, TokenFactory tokenFactory, Properties properties) {
    this(breader);
    this.tokenFactory = tokenFactory;
    String options = properties.getProperty("paragraphs");
    if (options.equalsIgnoreCase("no")) {
      tokenizeNLs = false;
      tokenizeParagraphs = false;
    }
    else if (options.equalsIgnoreCase("yes")) {
        tokenizeNLs = true;
        tokenizeParagraphs = true;
    }  
  }
  
  //////////////////
  //// NEWLINES ////
  //////////////////
  
  public static final String NEWLINE_TOKEN = "*NL*";
  public static final String PARAGRAPH_TOKEN = "*<P>*";
  
  ////////////////////////
  //// MAIN FUNCTIONS ////
  ////////////////////////
  
  
  private Token makeToken() { 
    String tokenString = yytext();
    return makeToken(tokenString);
  }

  private Token makeToken(String tokenString) {
    Token token;
    if (tokenString.equalsIgnoreCase("*NL*") || tokenString.equalsIgnoreCase("*<P>*")) {
      token = tokenFactory.createToken(tokenString, yychar, 1);
    }
    else { 
      token = tokenFactory.createToken(tokenString, yychar, yylength());
    }
    return token;
  }

%}

  ////////////////
  //// MACROS ////
  ///////////////

/*---- SPACES ----*/ 

PARAGRAPH = [\n\u2028\u2029\u0085]{1,123}
NEWLINE = \r|\r?\n|\u2028|\u2029|\u0085
OTHER_NEWLINE = [\u000B\u000C]
SPACE = [ \t\u00A0\u1680\u180E\u2002-\u200B\u202F\u205F\u2060\u3000]
SPACES = {SPACE}+



TEXT = [^ \t\u00A0\u1680\u180E\u2002-\u200B\u202F\u205F\u2060\u3000\r\n\u0085\u2028\u2029\u000B\u000C]+

/* ------------------------Lexical Rules Section---------------------- */

%%


{PARAGRAPH}                             {   if (tokenizeParagraphs) { 
                                                return makeToken(PARAGRAPH_TOKEN);
                                            }
                                        } 

{NEWLINE}      				{   if (tokenizeNLs) {
                			        return makeToken(NEWLINE_TOKEN); 
                                            }
                                        }

{OTHER_NEWLINE} 			{   if (tokenizeNLs) {
                        		        return makeToken(NEWLINE_TOKEN); 
                                            }
                                        }

{SPACES}                                {
                                        }

{TEXT}                                  {   return makeToken(); 
                                        }

<<EOF>>     				{ return null; }
