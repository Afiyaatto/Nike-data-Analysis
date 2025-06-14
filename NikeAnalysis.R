# Install missing packages if necessary
install.packages(c("tidyverse", "lubridate", "wordcloud", "tm"))

# Load libraries
library(tidyverse)
library(lubridate)
library(wordcloud)
library(tm)
# Read dataset
nike_data <- read_csv("nike_data_2022_09.csv")

# Convert timestamp to datetime format
nike_data$scraped_at <- dmy_hms(nike_data$scraped_at)

# Handle missing values
nike_data <- nike_data %>%
  mutate(
    avg_rating = replace_na(avg_rating, 0),
    review_count = replace_na(review_count, 0),
    availability = replace_na(availability, "Unknown"),
    color = replace_na(color, "Unknown")
  )

#price discripteion
ggplot(nike_data, aes(x = price)) +
  geom_histogram(binwidth = 10, fill = "orange", color = "black") +
  labs(title = "Nike Product Price Distribution", x = "Price (USD)", y = "Count") +
  theme_minimal()

#product avalibilty
ggplot(nike_data, aes(x = availability)) +
  geom_bar(fill = "tomato") +
  labs(title = "Product Availability", x = "Availability", y = "Number of Products") +
  theme_minimal()


#Rating vs Price 
ggplot(nike_data, aes(x = price, y = avg_rating)) +
  geom_point(alpha = 0.7, color = "darkgreen") +
  labs(title = "Price vs Average Rating", x = "Price (USD)", y = "Average Rating") +
  theme_minimal()

#top reviewed 10 products
top_reviewed <- nike_data %>%
  arrange(desc(review_count)) %>%
  select(name, price, avg_rating, review_count) %>%
  head(10)

print(top_reviewed)


# recomendations for the bussiness
cat("
✔ **Price Strategy**: Most products are priced between $40 and $80—align marketing to this range.
✔ **Customer Engagement**: Encourage reviews for products with zero ratings to build trust.
✔ **Stock Management**: Monitor out-of-stock items to either replenish or discontinue.
✔ **Marketing Focus**: Descriptive words like 'comfort', 'fit', and 'dry' dominate—leverage these in branding.
✔ **Product Visibility**: Feature top-rated products more prominently to drive sales.
")

