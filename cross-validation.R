### Kaggle Scripts: Ponpare Coupon Purchase Prediction: Setting up cross-validation datasets ###

# Setting working directory
setwd("~/Documents/R/kaggle-coupon-purchase-prediction")

# Installing and loading the Metrics package which allows us to evaluate MAP@10
# install.packages("Metrics")
library("Metrics")




# Cross-validation --------------------------------------------------------

# Read in all the input data
coupon_list_train <- read.csv("Data/coupon_list_train_en.csv")
coupon_list_test <- read.csv("Data/coupon_list_test_en.csv")
coupon_area_train <- read.csv("Data/coupon_area_train_en.csv")
coupon_area_test <- read.csv("Data/coupon_area_test_en.csv")
coupon_detail_train <- read.csv("Data/coupon_detail_train_en.csv")
user_list <- read.csv("Data/user_list_en.csv")
coupon_visit_train <- read.csv("Data/coupon_visit_train.csv")
prefecture_locations <- read.csv("Data/prefecture_locations_en.csv")

# Sort coupon_detail_train by date of purchase
coupon_detail_train <- coupon_detail_train[order(coupon_detail_train$I_DATE),]

# Split coupon_detail_train into further training and testing sets (last week of data as test)
# First generate the DATE variable
coupon_detail_train$DATE <- as.factor(substr(coupon_detail_train$I_DATE, 1, 10))
coupon_detail_train$DATE <- as.Date(coupon_detail_train$DATE, "%Y-%m-%d")

# Split data - cutoff date is 2012-06-17
coupon_detail_train_cv <- coupon_detail_train[coupon_detail_train$DATE < "2012-06-17", ]
coupon_detail_test_cv <- coupon_detail_train[coupon_detail_train$DATE >= "2012-06-17", ]

# Extract the test_cv coupon IDs from coupon_detail_test_cv
coupon_id_test_cv <- unique(coupon_detail_test_cv$COUPON_ID_hash)
coupon_id_train_cv <- unique(coupon_detail_train_cv$COUPON_ID_hash)
coupons_exclude <- coupon_id_test_cv %in% coupon_id_train_cv
coupon_id_test_cv <- coupon_id_test_cv[!coupons_exclude]

# Split coupon_area_train into further training and testing sets based on coupon_id_test_cv
# install.packages("Hmisc")
library("Hmisc") # For the use of %nin%
coupon_area_test_cv <- coupon_area_train[coupon_area_train$COUPON_ID_hash %in% coupon_id_test_cv, ]
coupon_area_train_cv <- coupon_area_train[coupon_area_train$COUPON_ID_hash %nin% coupon_id_test_cv, ]

# Split coupon_list_train into further training and testing sets based on coupon_id_test_cv
coupon_list_test_cv <- coupon_list_train[coupon_list_train$COUPON_ID_hash %in% coupon_id_test_cv, ]
coupon_list_train_cv <- coupon_list_train[coupon_list_train$COUPON_ID_hash %nin% coupon_id_test_cv, ]

# Split coupon_visit_train into further training and testing sets based on date (last week of data as test)
# First generate the DATE variable
coupon_visit_train$DATE <- as.factor(substr(coupon_visit_train$I_DATE, 1, 10))
coupon_visit_train$DATE <- as.Date(coupon_visit_train$DATE, "%Y-%m-%d")

# Extract the test_cv coupon IDs from coupon_detail_test_cv
coupon_visit_train_cv <- coupon_visit_train[coupon_visit_train$DATE < "2012-06-17", ]
coupon_visit_test_cv <- coupon_visit_train[coupon_visit_train$DATE >= "2012-06-17", ]



# Cosine similarity -------------------------------------------------------

# Creating the training set
train <- merge(coupon_detail_train_cv, coupon_list_train_cv, by = "COUPON_ID_hash")
# train <- merge(train, user_list, by = "USER_ID_hash")
train <- train[ , c("COUPON_ID_hash", "USER_ID_hash",
                    "en_GENRE_NAME", "DISCOUNT_PRICE", "PRICE_RATE",
                    "USABLE_DATE_MON", "USABLE_DATE_TUE", "USABLE_DATE_WED", "USABLE_DATE_THU",
                    "USABLE_DATE_FRI", "USABLE_DATE_SAT", "USABLE_DATE_SUN", "USABLE_DATE_HOLIDAY",
                    "USABLE_DATE_BEFORE_HOLIDAY", "en_ken_name", "en_small_area_name")]

# Combine the test set with the train (for feature engineering)
coupon_list_test_cv$USER_ID_hash <- "dummyuser"
coupon_char <- coupon_list_test_cv[ , c("COUPON_ID_hash", "USER_ID_hash",
                                     "en_GENRE_NAME", "DISCOUNT_PRICE", "PRICE_RATE",
                                     "USABLE_DATE_MON", "USABLE_DATE_TUE", "USABLE_DATE_WED", "USABLE_DATE_THU",
                                     "USABLE_DATE_FRI", "USABLE_DATE_SAT", "USABLE_DATE_SUN", "USABLE_DATE_HOLIDAY",
                                     "USABLE_DATE_BEFORE_HOLIDAY", "en_ken_name", "en_small_area_name")]
train <- rbind(train, coupon_char)

# NA imputation
train[is.na(train)] <- 1
# train[6:14][train[6:14] == 2] <- 1 # Currently the USABLE_DATE variables contain 2s. Assume to be 1s for the time being, but will continue to watch out for responses on the forums.

# Feature engineering
train$DISCOUNT_PRICE <- 1/log10(train$DISCOUNT_PRICE)
train$PRICE_RATE <- (train$PRICE_RATE*train$PRICE_RATE)/(100*100)

# Convert the factors to columns of 0's and 1's
train <- cbind(train[,c(1,2)],model.matrix(~ -1 + ., train[, -c(1, 2)],
                                           contrasts.arg = lapply(train[, names(which(sapply(train[ , -c(1, 2)], is.factor) == TRUE))], contrasts, contrasts = FALSE)))

# Separate the test from train
test <- train[train$USER_ID_hash == "dummyuser",]
test <- test[, -2]
train <- train[train$USER_ID_hash != "dummyuser",]

# Data frame of user characteristics
user_char <- aggregate( . ~ USER_ID_hash, data = train[, -1], FUN = mean)

# Weight Matrix: GENRE_NAME DISCOUNT_PRICE PRICE_RATE USABLE_DATE_ ken_name small_area_name
require(Matrix)
W <- as.matrix(Diagonal(x=c(rep(3,13), rep(1,1), rep(0.2,1), rep(0,9), rep(3,47), rep(3,55)))) # 0.005914

# Calculation of cosine similairties of users and coupons
score = as.matrix(user_char[, 2:ncol(user_char)]) %*% W %*% t(as.matrix(test[, 2:ncol(test)]))

# Order the list of coupons according to similairties and take only first 10 coupons
user_char$PURCHASED_COUPONS <- do.call(rbind, lapply(1:nrow(user_char), FUN=function(i){
  purchased_cp <- paste(test$COUPON_ID_hash[order(score[i,], decreasing = TRUE)][1:10],collapse=" ")
  return(purchased_cp)
}))

# Make submission
submission <- merge(user_list, user_char, all.x=TRUE)
submission <- submission[,c("USER_ID_hash","PURCHASED_COUPONS")]