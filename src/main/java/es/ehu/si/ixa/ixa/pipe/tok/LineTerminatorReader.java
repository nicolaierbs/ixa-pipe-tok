package es.ehu.si.ixa.ixa.pipe.tok;

import java.io.IOException;
import java.io.Reader;

public class LineTerminatorReader {
  private Reader delegate;
  private StringBuilder readBuffer;
  private int nextCh = SOL;
  private int readChars;

  private static final int SOL = -10; // Start Of Line

  public LineTerminatorReader(Reader delegate) {
    this.delegate = delegate;
    readBuffer = new StringBuilder();
  }

  /**
   * Reads all chars of a line, returning also line terminators
   * 
   * @return The line text
   */
  public String readLine() throws IOException {
    String res = null;
    readBuffer.setLength(0);
    int ch = (char) -10;

    if (nextCh == -1) {
      res = null;
    } else {

      boolean newLine = false;
      boolean eof = false;
      while (!newLine && !eof) {
        if (nextCh != SOL) {
          readBuffer.append((char) nextCh);
        }
        nextCh = SOL;
        ch = delegate.read();
        switch (ch) {
        case '\r':
          // check for double newline char
          nextCh = delegate.read();
          if (nextCh == '\n') {
            // double line found
            readBuffer.append("\r\n");
            newLine = true;
            nextCh = SOL;
          } else {
            readBuffer.append("\r");
            newLine = true;
          }
          break;
        case '\n':
          readBuffer.append("\n");
          newLine = true;
          break;
        case -1:
          eof = true;
          nextCh = -1;
          break;
        default:
          if (ch != -1)
            readBuffer.append((char) ch);
        }
      }
      res = readBuffer.toString();
      readChars += res.length();
    }
    return res;
  }

  public void close() throws IOException {
    delegate.close();
  }

  public int readChars() {
    return readChars;
  }
}
