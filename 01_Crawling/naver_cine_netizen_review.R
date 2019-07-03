# NAVER 영화('알라딘') 네티즌 리뷰 크롤링
library(rvest)
library(stringr)
library(dplyr)
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

url_base <- 'https://movie.naver.com'
start_url <- '/movie/bi/mi/point.nhn?code=163788#tab'
url <- paste0(url_base, start_url, encoding="euc-kr")
html <- read_html(url)
html %>%
  html_node('iframe.ifr') %>%
  html_attr('src') -> url2

ifr_url <- paste0(url_base, url2) 
html2 <- read_html(ifr_url)
html2 %>%
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
  review <- c(review, str_sub(tmp, 1, idx[1]-1))
  tmp <- trim(str_sub(tmp, idx[1], -1))
  idx <- str_locate(tmp, "\r")
  writer <- c(writer, str_sub(tmp, 1, idx[1]-1))
  tmp <- trim(str_sub(tmp, idx[1], -1))
  idx <- str_locate(tmp, "\r")
  time <- c(time, str_sub(tmp, 1, idx[1]-1))
  #print(time)
}

review <- data.frame(score=score, review=review, writer=writer, time=time)
review
