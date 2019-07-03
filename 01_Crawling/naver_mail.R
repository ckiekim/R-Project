# Naver 에 로그인하기
library(RSelenium)
library(rvest)
library(stringr)
trim <- function(x) gsub("^\\s+|\\s+$", "", x)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445L, browserName="chrome")
remDr$open()

remDr$navigate("https://nid.naver.com/nidlogin.login")
txt_id <- remDr$findElement(using="id", value="id")
txt_pw <- remDr$findElement(using="id", value="pw")
login_btn <- remDr$findElement(using="class", value="btn_global")

txt_id$setElementAttribute("value", "ckiekim") # 아이디 입력
txt_pw$setElementAttribute("value", "*****") # *에 비밀번호 입력
login_btn$clickElement()

remDr$navigate("https://mail.naver.com/")
mail_texts <- remDr$findElement(using="id", value="list_for_view")
                            # (using = 'css selector', "subject")
mail_texts
mail_texts <- mail_texts$getElementText()
tmp <- str_split(mail_texts, '\n') %>% [[1]]

for (i in 1:20) {
  
}
#subjects<-unlist(lapply(mail_subjects, function(x){x$getElementText()}))
#subjects

remDr$close()