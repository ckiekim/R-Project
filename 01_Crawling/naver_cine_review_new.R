# NAVER 영화('알라딘') 전문가리뷰 크롤링
library(rvest)
library(stringr)
library(dplyr)
trim <- function(x) gsub("^\\s+|\\s+$", "", x)

url_base <- 'https://movie.naver.com/movie/bi/mi/point.nhn?code=163788#tab'
url <- paste0(url_base, encoding="euc-kr")
html <- read_html(url)
head(html)
html

html %>%
  html_nodes('.obj_section') %>%
  html_nodes('.score_result') %>%
  html_nodes('li') -> lis
lis
score <- c()
reple <- c()
company <- c()
name <- c()
for (li in lis) {
  star_score <- html_node(li, '.star_score')
  score <- c(score, trim(html_text(star_score, 'em')))
  li %>%
    html_node('.score_reple') %>%
    html_text('.score_reple') %>%
    trim() %>%
    str_split("\r\n") %>%
    .[[1]] -> rep
  reple <- c(reple, trim(rep[1]))
  company <- c(company, trim(rep[2]))
  name <- c(name, str_sub(trim(rep[4]), 3, -1))
}

review = data.frame(score=score, reple=reple, company=company, name=name)
review
str(review)
