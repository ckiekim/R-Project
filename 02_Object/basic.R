# 사각형 면적 구하기
h<-10
v<-20
area<-function(h,v) {
  return(h*v)
}
area(h,v)

# R 객체지향 방식
Rectangle <- function(h, v) {
  obj <- list(h=h, v=v)
  class(obj) <- 'Rectangle'
  return(obj)
}
area <- function(obj) {
  UseMethod("area", obj)
}
area.Rectangle <- function(obj) {
  return(obj$h * obj$v)
}

r <- Rectangle(10, 20)    # r이 객체임
a <- area(r)
print(a)

# r 객체에서 사용할 수 있는 method
methods(class = class(r))

# Rectangle class 만드는 방법
a<-Rectangle(10,10)
b<-Rectangle(20,10)
c<-Rectangle(40,10)
cat(area(a), area(b), area(c))

# 생성자(Constructor)
# 클래스이름 <- function(속성값1, 속성값2, 속성값3) {
#   obj <- list(속성이름1=속성값1, 속성이름2=속성값2, 속성이름3=속성값3)
#   class(obj) <- "클래스이름"
#   return(obj)
# }

# 연습문제
# 사각 기둥의 부피를 계산하기 위한 클래스를 만든다. 이 클래스는 다음과 같은 속성을 가진다.
#   - 밑면의 가로 길이 a, 밑면의 세로 길이 b, 높이 h
#   - 부피를 계산하는 메서드 volume
#   - 겉넓이를 계산하는 메서드 surface
Pillar <- function(a, b, h) {
  obj <- list(a=a, b=b, h=h)
  class(obj)<-'Pillar'
  return(obj)
}
volume<-function(obj){
  UseMethod('volume', obj)
}
surface<-function(obj){
  UseMethod('surface', obj)
}
volume.Pillar<-function(obj){
  return(obj$a * obj$b * obj$h)
}
surface.Pillar<-function(obj){
  return(2*(obj$a * obj$b + obj$b * obj$h + obj$a * obj$h))
}

v<-Pillar(1,2,3)
cat(volume(v), surface(v))
