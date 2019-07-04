# Google에 로그인한 후 gmail 가져오기
library(RSelenium)
library(rvest)
library(stringr)
trim <- function(x) gsub("^\\s+|\\s+$", "", x)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445L, browserName="chrome")
remDr$open()

remDr$navigate("https://accounts.google.com/signin/v2/identifier?continue=https%3A%2F%2Fmail.google.com%2Fmail%2F&service=mail&sacu=1&rip=1&flowName=GlifWebSignIn&flowEntry=ServiceLogin")
txt_id <- remDr$findElement(using="css selector", '#identifierId')
next_btn <- remDr$findElement(using="css selector", '.RveJvd.snByac')
txt_id$setElementAttribute("value", "ckiekim@gmail.com") # 아이디 입력
next_btn$clickElement()

#remDr$navigate("https://accounts.google.com/signin/v2/sl/pwd?continue=https%3A%2F%2Fmail.google.com%2Fmail&passive=1209600&sacu=1&ignoreShadow=0&hl=ko&acui=0&flowName=GlifWebSignIn&flowEntry=AddSession&cid=1&navigationDirection=forward")
#remDr$refresh()
txt_pw <- remDr$findElement(using="css selector", '.whsOnd.zHQkBf')
#txt_pw <- remDr$findElement(using="css selector", '.AxOyFc.snByac')
next_btn <- remDr$findElement(using="css selector", '.RveJvd.snByac')
txt_pw$setElementAttribute("value", "kim11067") # *에 비밀번호 입력
next_btn$clickElement()
remDr$close()
##########################################################
remDr$navigate("https://mail.naver.com/")
mail_texts <- remDr$findElement(using="id", value="list_for_view")
mail_texts
mail_texts <- mail_texts$getElementText()
tmp <- str_split(mail_texts, '\n') %>% .[[1]]

sender <- c()
subject <- c()
time <- c()
for (i in 1:20) {
  sender <- c(sender, tmp[4*i-3])
  subject <- c(subject, tmp[4*i-2])
  time <- c(time, tmp[4*i-1])
}
df_mail <- data.frame(sender=sender, subject=subject, time=time)
df_mail
remDr$close()

#subjects<-unlist(lapply(mail_subjects, function(x){x$getElementText()}))
#subjects

