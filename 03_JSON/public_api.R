# 공공데이터포털 API 이용하여 데이터 가져오기
# 지자체별 사고다발지역정보 조회 서비스
# https://www.dropbox.com/s/ykc5zwsmmh13cgh/sample.json?dl=0
library(rvest)
library(httr)
library(jsonlite)
library(dplyr)

base_url <- "http://apis.data.go.kr/B552061/frequentzoneLg/getRestFrequentzoneLg"
ServiceKey <- '7t1%2BJu7GtCa%2BLEPxtUypI5MoMfYEvnA77nfvT%2FA3snI9YBNqDRmfdsuYAh5kAxsXae1vs%2FX9WdowCCoQHbuJwQ%3D%3D'
searchYearCd <- 2017
siDo <- 30    # 대전광역시
guGun <- 170  # 서구
numOfRows <- 10
pageNo <- 1
# http://apis.data.go.kr/B552061/frequentzoneLg/getRestFrequentzoneLg?ServiceKey=서비스키&searchYearCd=2017&siDo=26&guGun=110&numOfRows=10&pageNo=1
callback_url <- paste0(base_url, '?ServiceKey=', ServiceKey, '&searchYearCd=', searchYearCd,
                       '&siDo=', siDo, '&guGun=', guGun, '&numOfRows=', numOfRows, 
                       '&pageNo=', pageNo, '&type=json')

# get.result = GET(callback_url)
# http_type(get.result)
# http_error(get.result)
# 
# jsonRespText <- content(get.result, as="text")
# write(jsonRespText, "tmp")
# jsonRespParsed <- content(get.result, as="parsed")
# str(jsonRespParsed)
# 
# itemJson <- jsonRespParsed$items 

data <- fromJSON(callback_url)
str(data)
data$pageNo
str(data$items)
str(data$items$item)
df_accidents <- data$items$item
write.csv(df_accidents, "tmp.txt")
geoms <- df_accidents$geom_json
str(geom)
for (geom in geoms) {
  str(fromJSON(geom))
}

