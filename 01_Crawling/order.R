# 발표순서 정하기
students <- c('김상규', '김영진', '김준성', '김희범', '남궁하영', '류경민',
              '민다희', '박성지', '박수민', '박진원', '신은총', '안수현',
              '오진영', '이경욱', '이웅희', '이희철', '임도균', '임원기', 
              '전수연', '조병무', '최용호', '최준혁', '황성윤')
students2 <- c('김준성', '김희범', '류경민',
               '박진원', '안수현', '이경욱', '최용호')

# 개별발표
for (i in sample(x=1:7)) {
  readline('Press Enter Key: ')
  print(students2[i])
}

# 조별발표
for (group in sample(x=1:6)) {
  readline('Press Enter Key: ')
  print(group)
}

