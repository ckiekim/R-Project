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
lines <- read.csv("reply1.csv")

raw_words <- sapply(lines, extractNoun, USE.NAMES = F)

words <- unlist(raw_words)
words <- str_replace_all(words, "[^[:alpha:]]", "")
words <- Filter(function(x) {nchar(x) >= 2}, words)
words <- Filter(function(x) {nchar(x) <= 20}, words)
words <- gsub(" ", "", words)
words <- gsub("\\d+", "", words)
head(words, 20)
str(words)
