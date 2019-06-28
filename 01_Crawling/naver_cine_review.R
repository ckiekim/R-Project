# NAVER 영화('알라딘') 전문가리뷰 크롤링
library(rvest)
library(stringr)
library(dplyr)
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

url_base <- 'https://movie.naver.com/movie/bi/mi/point.nhn?code=163788#tab'
url <- paste(url_base,encoding="euc-kr",sep='')
html <- read_html(url)
head(html)
html

html1 <- html_nodes(html, '.obj_section')
html2 <- html_nodes(html1, '.score_result')
html2
lis <- html_nodes(html2, 'li')
lis
score <- c()
reple <- c()
company <- c()
name <- c()
for (li in lis) {
  star_score <- html_node(li, '.star_score')
  score <- c(score, trim(html_text(star_score, 'em')))
  score_reple <- html_node(li, '.score_reple')
  reps <- trim(html_text(score_reple, 'p'))
  reps <- str_split(reps, "\r\n")
  for (rep in reps) {
    reple <- c(reple, trim(rep[1]))
    company <- c(company, trim(rep[2]))
    name <- c(name, str_sub(trim(rep[4]), 3, -1))
  }
}

review = data.frame(score=score, reple=reple, company=company, name=name)
review
str(review)
