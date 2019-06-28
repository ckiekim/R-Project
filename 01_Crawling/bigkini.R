# https://kuduz.tistory.com/1041
# Crawling
library(rvest)
basic_url <- 'http://news.donga.com/search?query=bigkini&more=1&range=3&p='
uris <- NULL
for (x in 0:5) {
  uris[x+1] <- paste0(basic_url, x*15+1)
}
uris

html <- read_html(uris[1])
html2 <- html_nodes(html, '.searchCont')    # class = "searchCont"
html3 <- html_nodes(html2, 'a')             # <a> tag
links <- html_attr(html3, 'href')

library(dplyr)
links <- html %>%
  html_nodes('.searchCont') %>%
  html_nodes('a') %>%
  html_attr('href')
links <- unique(links)
grep('pdf', links)
links <- links[-grep('pdf', links)]

links <- c()
for (url in uris) {
  html <- read_html(url)
  links <- c(links, html %>%
               html_nodes('.searchCont') %>%
               html_nodes('a') %>%
               html_attr('href') %>%
               unique())
}

texts <- c()
for (link in links) {
  html <- read_html(link)
  texts <- c(texts, html %>%
               html_nodes('.article_txt') %>%
               html_text())
}
texts

write.csv(texts, "D:/Workspace/R_Project/01_Crawling/texts.csv")
