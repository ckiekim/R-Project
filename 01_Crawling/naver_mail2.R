# Naver 에 로그인하기
library(RSelenium)
library(rvest)
library(stringr)
trim <- function(x) gsub("^\\s+|\\s+$", "", x)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445L, browserName="chrome")
remDr$open()

remDr$navigate("https://nid.naver.com/nidlogin.login")
txt_id <- remDr$findElement(using="css selector", '#id')
txt_pw <- remDr$findElement(using="id", value="pw")
login_btn <- remDr$findElement(using="class", value="btn_global")

txt_id$setElementAttribute("value", "ckiekim") # 아이디 입력
txt_pw$setElementAttribute("value", "*****") # *에 비밀번호 입력
login_btn$clickElement()

remDr$navigate("https://mail.naver.com/")

#페이지 소스 읽어오기 
html <- remDr$getPageSource()[[1]] 
html <- read_html(html)
html %>%
  html_node('#list_for_view') %>%
  html_nodes('ol>li') -> lis

sender <- c()
subject <- c()
time <- c()
for (li in lis) {
  li %>%
    html_node('div.name') %>%
    html_node('a') %>%
    html_text() -> tmp
  sender <- c(sender, tmp)
  li %>%
    html_node('div.subject') %>%
    html_node('a') %>%
    html_node('strong') %>%
    html_text() %>%
    trim() -> tmp
  subject <- c(subject, str_sub(tmp, 7, -1))
  li %>%
    html_node('.iDate') %>%
    html_text() -> tmp
  time <- c(time, str_sub(tmp, 6, -1))
}
df_mail <- data.frame(sender=sender, subject=subject, time=time)
df_mail

remDr$close()


