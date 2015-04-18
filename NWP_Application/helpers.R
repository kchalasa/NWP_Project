## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This Script defines utility routines called by NEXT_WORD_PREDICTION Shiny Application
##              It basically cleans the input phrase entered by the end-user before called prediction function.
##########################################################


## Expand any ENGLISH contractions
expand_contractions<-function(srcLine) {
  srcLine<-gsub("isn't",   "is not",         srcLine)
  srcLine<-gsub("aren't",   "are not",       srcLine)
  srcLine<-gsub("wasn't",   "was not",       srcLine)
  srcLine<-gsub("weren't",   "were not",     srcLine)
  srcLine<-gsub("haven't",   "have not",     srcLine)
  srcLine<-gsub("hasn't",   "has not",       srcLine)
  srcLine<-gsub("hadn't",   "had not",       srcLine)
  srcLine<-gsub("won't",   "will not",       srcLine)
  srcLine<-gsub("wouldn't",   "would not",   srcLine)
  srcLine<-gsub("don't",   "do not",         srcLine)
  srcLine<-gsub("doesn't",   "does not",     srcLine)
  srcLine<-gsub("didn't",   "did not",       srcLine)
  srcLine<-gsub("can't",   "cannot",         srcLine)
  srcLine<-gsub("couldn't",   "could not",   srcLine)
  srcLine<-gsub("shouldn't",   "should not", srcLine)
  srcLine<-gsub("mightn't",   "might not",   srcLine)
  srcLine<-gsub("mustn't",   "must not",     srcLine)
  srcLine<-gsub("would've",    "would have",   srcLine)	
  srcLine<-gsub("should've",   "should have",   srcLine)	
  srcLine<-gsub("could've",    "could have",   srcLine)	
  srcLine<-gsub("might've",    "might have",   srcLine)	
  srcLine<-gsub("must've",     "must have",   srcLine)
  srcLine<-	gsub("I'm","I am",	    srcLine)
  srcLine<-	gsub("I'll","I will",	srcLine)
  srcLine<-	gsub("I'd","I would",	srcLine)
  srcLine<-	gsub("I've","I have",	srcLine)
  srcLine<-	gsub("I'd","I had",	    srcLine)
  srcLine<-	gsub("we're","we are",	srcLine)
  srcLine<-	gsub("we'll","we will",	srcLine)
  srcLine<-	gsub("we'd","we would",	srcLine)
  srcLine<-	gsub("we've","we have",	srcLine)
  srcLine<-	gsub("we'd","we had",	srcLine)
  return(srcLine)
}		

## Tidy up input phrase 

tidy_up_sentence<-function(srcLine) {
  srcLine<-tolower(srcLine)
  srcLine<-gsub('Ã¢â‚¬â„¢',"'",srcLine)
  srcLine<-gsub('Ã¢â‚¬Å“','"',srcLine)
  srcLine<-gsub('Ã¢â‚¬Â¦',' ',srcLine)
  srcLine<-gsub("-"," ",srcLine)
  srcLine<-gsub("_","",srcLine)
  srcLine<-gsub("<","",srcLine)
  srcLine<-gsub(">","",srcLine)
  srcLine<-gsub("\\[","",srcLine)
  srcLine<-gsub("\\]","",srcLine)
  srcLine<-gsub("â€™","",srcLine)
  srcLine<-gsub('"',"",srcLine)
  ## Single spacing between words 
  srcLine<-gsub("(\\s+)"," ",srcLine)
  ## Remove spaces at the begining and end of the line. 
  srcLine<-gsub("^\\s+|\\s+$","",srcLine)
  srcLine<-gsub("[â€˜'Â´'`â€™â€™]","",srcLine)
  srcLine<-gsub('["â€â€:]','',srcLine)
  srcLine<-gsub('[!({})%#&-,/]',' ',srcLine)
  srcLine<-gsub('[\\^\\*\\$\\?]','',srcLine)
  srcLine<-gsub('\\.',' ',srcLine)
  srcLine<-gsub('\\,',',',srcLine)
  srcLine<-gsub('Ã¢â‚¬','"',srcLine)
  srcLine<-gsub('[0-9]','',srcLine)
  srcLine<-gsub('[;@~=>|]','',srcLine)
  srcLine<-iconv(srcLine, "latin1", "ASCII", sub="")
  srcLine<-gsub("(\\s+)"," ",srcLine)
  ## Clean HTML String
  srcLine <- gsub("<.*?>", "", srcLine)
  srcLine <- gsub("!Ã°Å¸â€˜Â¦","",srcLine)
  srcLine <-gsub("\xedÂ Â½\xedÂ±Â¦","",srcLine)
  srcLine<-gsub("[%#&Ã–Ã“Ã‰ÃŠÃ“ÃÂ·Ã¬Ã?â€¦ÃŒÅ½Ã†Ã Ã…Ã¨Â¡â€ºÃ¡ÃÃšÃ›â€¡â€ ÂºÃŽÃ¢Ã¦Â¥Å Ã¦Å¾ÂÃ¤Â½Â¿Ã£ÂÂ£Ã£ÂÂ¦Ã¥Â°ÂÃ£Ââ‚¬Å’ÂÂÂ¨â‚¬Â½Å“ÂÂ£Â¿ÂÂ¾Å¸Ã¯Â¼Å¡Ã¯Â¼â€°â„¢Ã¯ÂÂÂÂÅ“ÃƒÂ©Â¢Â¶Æ’Â§Ã‚Â¤â€œÂ³Â»Â®ÂÂÂÃ„ÂÂÂ¹Â³Â»Â®ÂÂÂ«Â«Ã§Âªâ€¹Ë†ËœÃ‘â€¢ÃÂµÃ™Ã˜Â±Â¬Ã‹â€žÂ²Ã«Â¸ÃªÃ©Ã®Â¯â€“â€“Ã—Ã‡\002\020\002#\023Ã°\035\037\177\032\031\003]","",srcLine)
  return(srcLine)
}

## Mask any bad words predicted by Language Model or entered by end user

mask_bad_words<-function(phrase) {
  masked_phrase<-unlist(strsplit(phrase,"\\s+"))
  masked_phrase[which(masked_phrase %in% filter_words)]<-"****"
  phrase<-paste(masked_phrase, collapse = " ")
  phrase
}