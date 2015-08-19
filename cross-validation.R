### Kaggle Scripts: Ponpare Coupon Purchase Prediction: Setting up cross-validation datasets ###

# Setting working directory
setwd("~/Documents/R/kaggle-coupon-purchase-prediction")

# Installing and loading the Metrics package which allows us to evaluate MAP@10
# install.packages("Metrics")
library("Metrics")

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



# library("dplyr")
# gmail2 <- anti_join(coupon_list_train_cv2, coupon_list_train_cv1)
# one <- unique(coupon_area_test_cv$COUPON_ID_hash)
# two <- unique(coupon_area_train_cv$COUPON_ID_hash)
