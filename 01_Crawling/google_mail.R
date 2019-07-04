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
txt_id$setElementAttribute("value", "ckiekim@gmail.com")     # 아이디 입력
next_btn$clickElement()

txt_pw <- remDr$findElement(using="css selector", '.whsOnd.zHQkBf')
next_btn <- remDr$findElement(using="css selector", '.RveJvd.snByac')
txt_pw$sendKeysToElement(list("*"))     # *에 비밀번호 입력
next_btn$clickElement()

html <- remDr$getPageSource()[[1]] 
html <- read_html(html)

html %>%
  html_node('table.F.cf.zt') %>%
  html_nodes('tbody>tr') -> trs

sender <- c()
subject <- c()
time <- c()
for (tr in trs) {
  tr %>% 
    html_node('td.yX.xY') %>%
    html_node('div') %>%
    html_nodes('span') -> spans
  len <- length(spans)
  sender <- c(sender, html_text(spans[1]))       # Sender
  subject <- c(subject, html_text(spans[len-1]))     # Subject
  time <- c(time, html_text(spans[len]))           # Time
  
}
df_mail <- data.frame(sender=sender, subject=subject, time=time)
df_mail
remDr$close()
