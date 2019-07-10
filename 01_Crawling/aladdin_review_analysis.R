# 영화 알라딘 네티즌 평점/리뷰 분석하기
# 데이터 읽기
library(rJava)
library(KoNLP)
library(xlsx)
setwd("D:/Workspace/R_Project/01_Crawling")
df_aladdin <- read.xlsx("aladdin.xlsx", 1, encoding="UTF-8")

# 1. 워드 클라우드 만들기
library(stringr)
library(dplyr)
library(wordcloud)
library(wordcloud2)
library(ggplot2)
library(gridExtra)
library(lubridate)
library(extrafont)
windowsFonts(myfont = "맑은 고딕")
theme_update(text=element_text(family="myfont"))
useSejongDic()

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

write.csv(df_aladdin$review, "aladdin_review.csv", row.names = F)
lines <- read.csv("aladdin_review.csv")
lines <- as.character(lines$x)

raw_words <- sapply(lines, extractNoun, USE.NAMES = F)

words <- unlist(raw_words)
words <- str_replace_all(words, "[^[:alpha:]]", "")
words <- Filter(function(x) {nchar(x) >= 2}, words)
words <- Filter(function(x) {nchar(x) <= 10}, words)
words <- gsub(" ", "", words)
words <- gsub('[~!/@#$%&*^()"_+=?<>]', "", words)
words <- gsub('[ㄱ-ㅎ]', "", words)
words <- gsub('(ㅜ|ㅠ)', "", words)
words <- gsub("\\d+", "", words)

write(words, "aladdin_words.txt")
reviews <- read.table("aladdin_words.txt")
wordcount <- table(reviews)
head(sort(wordcount, decreasing = T), 30)

rmwords <- c('영화', '진짜', '알라딘', '관람객', '관람', '관')
for (rmword in rmwords) {
  words <- gsub(rmword, "", words)
}
funwords <- c('재밌게','재밌고','재밌었','재밌어요','재밌네요',
              '재밌었고','재밌었음','재밌었어요')
for (funword in funwords) {
  words <- gsub(funword, '재미', words)
}
write(words, "aladdin_words.txt")
reviews <- read.table("aladdin_words.txt")
wordcount <- table(reviews)
head(sort(wordcount, decreasing = T), 30)

palete <- brewer.pal(12, 'Paired')
par(mai=rep(0,4))
set.seed(123)
wordcloud(names(wordcount), freq=wordcount, 
          scale = c(5,0.3), rot.per = 0.1,
          min.freq = 20, random.order = F, 
          random.color = T, colors = palete, family="myfont")

wordcount_top <- head(sort(wordcount, decreasing = T), 200)
wordcloud2(wordcount_top, size=1, col="random-light", 
           backgroundColor="black", shape='circle')

# 2. 평점 분석하기
tmp <- strptime(df_aladdin$time, '%Y.%m.%d')
df_aladdin$date <- as.character(tmp)
df_aladdin$hour <- as.character(strptime(df_aladdin$time, "%Y.%m.%d %H"))
df_aladdin$score <- as.numeric(as.character(df_aladdin$score))
str(df_aladdin)

# 2019년 5/23 ~ 7/7 까지 평점 변화
# 일별 평점 갯수
df_aladdin <- filter(df_aladdin, date !='2019-07-08')
df_aladdin$date <- str_sub(df_aladdin$date, 6)
count_review <- df_aladdin %>%
  group_by(date) %>%
  summarise(n=n()) %>%
  mutate(weekday = wday(as.Date(paste0("2019-", date)), label=T),
         group=ifelse(weekday %in% c('토','일'), '공휴일', '근무일'))

holidays <- c('01-01','03-01','05-05','06-06','08-15','10-03','10-09','12-25')
luna_holidays <- c('02-04','02-05','02-06','05-06','09-12','09-13')
count_review$group[count_review$date %in% holidays] <- '공휴일'
count_review$group[count_review$date %in% luna_holidays] <- '공휴일'

count_score_plot <- ggplot(data=count_review,
                           aes(x=date, y=n, group=1, fill=group)) +
  geom_bar(stat="identity", show.legend=F) +
  ggtitle('일별 평점 갯수 추이') +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle=45, hjust=1, vjust=1),
        plot.title = element_text(face = 'bold', size = 15, 
                                  vjust=2, hjust=0.5))

# 일별 평점 평균
mean_score <- df_aladdin %>%
  group_by(date) %>%
  summarise(mean_point = mean(score, na.rm = T))
mean_score_plot <- ggplot(data=mean_score,
                          aes(x=date, y=mean_point, group=1)) +
  geom_line(color = 'red') +
  ggtitle('일별 평점 평균 추이') +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle=45, hjust=1, vjust=1),
        plot.title = element_text(face = 'bold', size = 15, 
                                  vjust=2, hjust=0.5))

grid.arrange(count_score_plot, mean_score_plot)

# 시간대별 평점 갯수
df_aladdin$hour <- str_sub(df_aladdin$hour, 12, 13)
count_hour <- df_aladdin %>%
  group_by(hour) %>%
  tally()
count_hour_plot <- ggplot(data=count_hour,
                           aes(x=hour, y=n, group=1)) +
  geom_bar(stat="identity", fill=rainbow(24)) +
  ggtitle('시간대별 평점 갯수 추이') +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle=45, hjust=1, vjust=1),
        plot.title = element_text(face = 'bold', size = 15, 
                                  vjust=2, hjust=0.5))

# 시간대별 평점 평균
mean_hour <- df_aladdin %>%
  group_by(hour) %>%
  summarise(mean_hour = mean(score, na.rm = T))
mean_hour_plot <- ggplot(data=mean_hour,
                          aes(x=hour, y=mean_hour, group=1)) +
  geom_line(color = 'red') +
  ggtitle('시간대별 평점 평균 추이') +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle=45, hjust=1, vjust=1),
        plot.title = element_text(face = 'bold', size = 15, 
                                  vjust=2, hjust=0.5))

grid.arrange(count_hour_plot, mean_hour_plot)
