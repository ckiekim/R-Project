# 영화 알라딘 네티즌 평점/리뷰 분석하기
# 데이터 읽기
library(xlsx)
setwd("D:/Workspace/R_Project/01_Crawling")
aladdin <- read.xlsx("aladdin.xlsx", 1, encoding="UTF-8")

# 1. 워드 클라우드 만들기
library(rJava)
library(KoNLP)
library(stringr)
library(dplyr)
library(wordcloud)
library(ggplot2)

library(extrafont)
windowsFonts(myfont = "맑은 고딕")
theme_update(text=element_text(family="myfont"))
useSejongDic()

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

reply <- aladdin$review
write.csv(reply, "reply1.csv", row.names = F)

lines <- read.csv("D:/Workspace/R_Project/01_Crawling/reply1.csv")
lines <- as.character(lines$x)

raw_words <- sapply(lines, extractNoun, USE.NAMES = F)

words <- unlist(raw_words)
words <- str_replace_all(words, "[^[:alpha:]]", "")
words <- Filter(function(x) {nchar(x) >= 2}, words)
words <- Filter(function(x) {nchar(x) <= 10}, words)
words <- gsub(" ", "", words)
words <- gsub("\\d+", "", words)

write(unlist(words), "reply1.txt")
reviews <- read.table("reply1.txt")
wordcount <- table(reviews)
head(sort(wordcount, decreasing = T), 30)

rmwords <- c('영화', '진짜', 'ㅠㅠ', '관', '람객', '람')
for (rmword in rmwords) {
  words <- gsub(rmword, "", words)
}
words <- gsub('재밌게', '재미', words)
words <- gsub('재밌고', '재미', words)
words <- gsub('재밌어요', '재미', words)
words <- gsub('재밌었어요', '재미', words)
write(unlist(words), "reply1.txt")
reviews <- read.table("reply1.txt")
wordcount <- table(reviews)
head(sort(wordcount, decreasing = T), 30)

windowsFonts(font=windowsFont("맑은 고딕"))
palete <- brewer.pal(12, 'Paired')
par(mai=rep(0,4))
wordcloud(names(wordcount), freq=wordcount, 
          scale = c(7,0.3), rot.per = 0.1,
          min.freq = 20, random.order = F, 
          random.color = T, colors = palete, family="font")

