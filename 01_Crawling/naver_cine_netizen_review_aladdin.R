# NAVER 영화('알라딘') 네티즌 리뷰 크롤링
library(rvest)
library(stringr)
library(dplyr)
library(xlsx)
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

url_base <- 'https://movie.naver.com'
start_url <- '/movie/bi/mi/point.nhn?code=163788'
url <- paste0(url_base, start_url)
html <- read_html(url)
html %>%
  html_node('iframe.ifr') %>%
  html_attr('src') -> if_url
ifr_url <- paste0(url_base, if_url) 
html2 <- read_html(ifr_url)

# 총 데이터 건수로부터 총 페이지수 구하기
html2 %>%
  html_node('div.score_total') %>%
  html_nodes('em') -> ems
pages <- ems[2] %>% html_text()
pages <- gsub(",", "", pages)
total_page <- ceiling(as.numeric(pages)/10)

# 페이지별 url 기본 구하기
html2 %>%
  html_node('div.paging') %>%
  html_node('a') %>%
  html_attr('href') -> tmp
page_url_base <- str_sub(tmp, 1, -2)

# 평점 데이터를 저장할 데이터프레임 초기화
df_points <- data.frame(score=c(), review=c(), writer=c(), time=c())

for (i in 1:total_page) {
  if (i %% 100 == 0)
    print(i)
  page_url <- paste0(url_base, page_url_base, i)
  html <- read_html(page_url)
  html %>%
    html_node('div.score_result') %>%
    html_nodes('li') -> lis
  
  score <- c()
  review <- c()
  writer <- c()
  time <- c()
  for (li in lis) {
    score <- c(score, html_node(li, '.star_score') %>% html_text('em') %>% trim())
    li %>%
      html_node('.score_reple') %>%
      html_text('p') %>%
      trim() -> tmp
    idx <- str_locate(tmp, "\r")
    rev <- str_sub(tmp, 1, idx[1]-1)
    #print(rev)
    review <- c(review, rev)
    tmp <- trim(str_sub(tmp, idx[1], -1))
    idx <- str_locate(tmp, "\r")
    writer <- c(writer, str_sub(tmp, 1, idx[1]-1))
    tmp <- trim(str_sub(tmp, idx[1], -1))
    idx <- str_locate(tmp, "\r")
    time <- c(time, str_sub(tmp, 1, idx[1]-1))
  }
  points <- data.frame(score=score, review=review, writer=writer, time=time)
  df_points <- rbind.data.frame(df_points, points)
}
write.xlsx(df_points, file="D:/Workspace/R_Project/01_Crawling/aladdin.xlsx", 
           sheetName="네티즌평점", 
           col.names=TRUE, row.names=FALSE, append=FALSE)
