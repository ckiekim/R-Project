# 공공데이터포털 API 이용하여 데이터 가져오기
# 지자체별 사고다발지역정보 조회 서비스
library(jsonlite)

base_url <- "http://apis.data.go.kr/B552061/frequentzoneLg/getRestFrequentzoneLg"
ServiceKey <- 'ServiceKey_from_PublicDataPortal'
searchYearCd <- 2017
siDo <- 30    # 대전광역시
guGun <- 170  # 서구
numOfRows <- 10
pageNo <- 1
# http://apis.data.go.kr/B552061/frequentzoneLg/getRestFrequentzoneLg?ServiceKey=서비스키&searchYearCd=2017&siDo=26&guGun=110&numOfRows=10&pageNo=1
callback_url <- paste0(base_url, '?ServiceKey=', ServiceKey, '&searchYearCd=', searchYearCd,
                       '&siDo=', siDo, '&guGun=', guGun, '&numOfRows=', numOfRows, 
                       '&pageNo=', pageNo, '&type=json')

responsData <- fromJSON(callback_url)
str(responsData)
cat("결과 코드 =", responsData$resultCode)
cat("결과 메시지 =", responsData$resultMsg)
cat("총 건수 =", responsData$totalCount)

str(responsData$items)
df_accidents <- responsData$items$item
str(df_accidents)

setwd('D:/Workspace/R_Project/03_JSON')
write.csv(df_accidents[-13], '사고다발지역.csv')

geoms <- df_accidents$geom_json
str(geoms)
# g1<-fromJSON(geoms[1])
# str(g1)
# str(g1$coordinates[1,,])
# write.csv(g1$coordinates[1,,], "poly.csv")

library(openxlsx)
wb <- createWorkbook()
for (i in 1:length(geoms)) {
  geom <- fromJSON(geoms[i])
  str(geom)
  # write.csv(geom$coordinates[1,,], paste0("olygon", i, ".csv"))
  df_geom <- as.data.frame(geom$coordinates[1,,])
  names(df_geom) <- c("경도", "위도")
  addWorksheet(wb, paste0("polygon", i))
  writeDataTable(wb, paste0("polygon", i), df_geom)
}
saveWorkbook(wb, file="polygon.xlsx")
