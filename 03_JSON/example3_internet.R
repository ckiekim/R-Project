# Converting JSON to R DataFrame
library(jsonlite)
library(httr)

df_repos <- fromJSON("https://api.github.com/users/hadley/repos")
str(df_repos)
names(df_repos)

names(df_repos$owner)

# Converting R DataFrame to JSON
json_repos <- toJSON(df_repos)
cat(json_repos)
minify(json_repos)
prettify(json_repos)
