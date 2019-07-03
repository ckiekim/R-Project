# Naver 에 로그인하기
library(RSelenium)
library(rvest)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445L, browserName="chrome")
remDr$open()

remDr$navigate("https://nid.naver.com/nidlogin.login")
txt_id <- remDr$findElement(using="id", value="id")
txt_pw <- remDr$findElement(using="id", value="pw")
login_btn <- remDr$findElement(using="class", value="btn_global")

txt_id$setElementAttribute("value", "*****") # *에 아이디 입력
txt_pw$setElementAttribute("value", "*****") # *에 비밀번호 입력
login_btn$clickElement()

remDr$navigate("https://mail.naver.com/")
mail_subject <- remDr$findElement(using="class", value="subject")
                            # (using = 'css selector', "subject")
mail_subject$getElementText()

#subjects<-unlist(lapply(mail_title, function(x){x$getElementText()}))
#subjects

remDr$close()
