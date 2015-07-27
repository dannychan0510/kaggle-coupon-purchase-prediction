# Kaggle Coupon Purchase Prediction Competition

## Predict which coupons a customer will buy
Recruit Ponpare is Japan's leading joint coupon site, offering huge discounts on everything from hot yoga, to gourmet sushi, to a summer concert bonanza. Ponpare's coupons open doors for customers they've only dreamed of stepping through. They can learn difficult to acquire skills, go on unheard of adventures, and dine like (and with) the stars.

Investing in a new experience is not cheap. We fear wasting our time and money on a product or service that we may not enjoy or fully understand. Ponpare takes the high price out of this equation, making it easier for you to take the leap towards your first sky-dive or diamond engagement ring.

Using past purchase and browsing behavior, this competition asks you to predict which coupons a customer will buy in a given period of time. The resulting models will be used to improve Ponpare's recommendation system, so they can make sure their customers don't miss out on their next favorite thing.

## Data
### Data Files
You are provided with a year of transactional data for 22,873 users on the site ponpare.jp. The training set spans the dates 2011-07-01 to 2012-06-23. The test set spans the week after the end of the training set, 2012-06-24 to 2012-06-30. The goal of the competition is to recommend a ranked list of coupons for each user in the dataset (found in user_list.csv). Your predictions are scored against the actual coupon purchases, made during the test set week, of the 310 possible test set coupons.

## File Descriptions
The dataset has relational format, with hashed ID columns for each entity.

* **user_list.csv** - the master list of users in the dataset

| Column Name        | Description            | Type     | Length | Decimal | Note                           |
|:------------------ |:-----------------------|:---------|:-------|:--------|:-------------------------------|
| USER_ID_hash       | User ID                | VARCHAR2 | 32     |         |                                |
| REG_DATE           | Regostered date        | DATE     |        |         | Sign up date                   |
| SEX_ID             | Gender                 | CHAR     | 1      |         | f = female; m = male           |
| AGE                | Age                    | NUMBER   | 4      | 0       |                                |
| WITHDRAW_DATE      | Unregistered date      | DATE     | 1      |         |                                |
| PREF_NAME          | Residential Prefecture | VARCHAR2 | 2      |         | [JPN] Note registered if empty |

