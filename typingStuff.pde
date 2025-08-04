//start of typingStuff.pde
//some basic utility methods for typing, if possible pleasde use the UiTextBox, it is better in every way. also theese will removed in the future

/**used to easaly process keyboard inputs
 @param mode what character mode to use
 @param leter the char from the keyboard to be processed
 @return a char that is compatbale with the selected mode
 */
char getCh(int mode, char leter) {
  if (mode==0) {
    if (Character.isLetter(leter) || leter==' ') {//mode 0 letters numbers and spcaes
      return leter;
    }
    if (leter==32) {
      return ' ';
    }

    if (leter=='1'||leter=='2'||leter=='3'||leter=='4'||leter=='5'||leter=='6'||leter=='7'||leter=='8'||leter=='9'||leter=='0') {
      return leter;
    }
  }
  if (mode==1) {//mode 1 number only
    if (leter=='1'||leter=='2'||leter=='3'||leter=='4'||leter=='5'||leter=='6'||leter=='7'||leter=='8'||leter=='9'||leter=='0') {
      return leter;
    }
  }
  if (mode==2) {//mode 2 ip mode(numbers and .)
    if (leter=='1'||leter=='2'||leter=='3'||leter=='4'||leter=='5'||leter=='6'||leter=='7'||leter=='8'||leter=='9'||leter=='0'||leter=='.') {
      return leter;
    }
  }
  if (mode==3) {//mode 3 mode 0 but also allows line returns and /
    if (Character.isLetter(leter) || leter==' ') {//mode 0 letters numbers and spcaes
      return leter;
    }
    if (leter==32) {
      return ' ';
    }

    if (leter=='1'||leter=='2'||leter=='3'||leter=='4'||leter=='5'||leter=='6'||leter=='7'||leter=='8'||leter=='9'||leter=='0'||leter=='\n'||leter=='/') {
      return leter;
    }
  }
  if (mode==4) {//mode 4 domain name mode. letter numbers and outher charicters found in domains
    if (Character.isLetter(leter)) {
      return leter;
    }
    if (leter=='1'||leter=='2'||leter=='3'||leter=='4'||leter=='5'||leter=='6'||leter=='7'||leter=='8'||leter=='9'||leter=='0'||leter=='.'||leter=='-'||leter=='_') {
      return leter;
    }
  }

  return 0;
}

/**Processes backspace operations
 @param imp the string that needs a backspace opperation
 @param code the key ID of the key that was pressed
 @return a string with 1 less char
 */
String doBackspace(String imp, int code) {
  if (code==8) {//if the key was backspace
    if (imp.length()>1) {//remove the last char
      return imp.substring(0, imp.length()-1);
    } else if (imp.length()==1) {
      return "";
    }
  }
  return imp;
}

/**Used to process keyboard inputs by modifying strings
 @param in the string to be modified
 @param x the allowed character mode
 @param code keyCode value
 @param leter key value
 @return in modified according to the mode selected by x
 */
String getInput(String in, int x, int code, char leter) {//code and leter exsist to allow sub windows to use this function correctly they shoud send the keyCode and key vaible in respectivlky
  if (getCh(x, leter)!=0) {
    in+=getCh(x, leter);
  }
  in=doBackspace(in, code);
  return in;
}

/**Used to process keyboard inputs by modifying strings||only use if in top level sketch||auto fills the outher values for getinput
 @param in the string to be modified
 @param x the allowed charicter mode
 @return in modified according to the mode selected by x
 */
String getInput(String in, int x) {//for use in the main sketch whre keyCode and key are the same as used here
  return getInput(in, x, keyCode, key);
}

//start of typingStuff.pde
