### Kaggle Scripts: Ponpare Coupon Purchase Prediction: KNN ###

# Setting working directory
setwd("~/Documents/R/kaggle-coupon-purchase-prediction")

# Read in all the input data
coupon_detail_train <- read.csv("Data/coupon_detail_train_en.csv")
coupon_list_train <- read.csv("Data/coupon_list_train_en.csv")
coupon_list_test <- read.csv("Data/coupon_list_test_en.csv")
user_list <- read.csv("Data/user_list_en.csv")

# Creating the training set
train <- merge(coupon_detail_train, coupon_list_train, by = "COUPON_ID_hash")

user_id <- unique(train$USER_ID_hash)
coupon_id <- unique(train$COUPON_ID_hash)

knn <- expand.grid(a = user_id, b = coupon_id)

knn$bought <- paste(knn$a, knn$b) %in% paste(train$USER_ID_hash, train$COUPON_ID_hash)

one <- paste(knn$a, knn$b) 
two <- paste(train$USER_ID_hash, train$COUPON_ID_hash)

k.nearest.neighbors <- function(i, distances, k = 25)
{
  return(order(distances[i, ])[2:(k+1)])
}

installation.probability <- function(user, package, train2, distances, k = 25)
{
  neighbors <- k.nearest.neighbors(package, distances, k = k)
  return(mean(sapply(neighbors, function (neighbor) {train2[user,neighbor]})))
}