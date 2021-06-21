## Load Relevant Library Packages ========

library(tidyverse)
library(lubridate)
library(skimr)
library(scales)
library(cowplot)

## Import All Relevant Data Files In A Single Data Set =======

# get all the file names with their path in a variable ===========

list_of_files <- list.files("data/unconditioned_data", pattern = "*.csv", 
                            full.names = TRUE)
list_of_files
class(list_of_files)
length(list_of_files)


# before combining these files, we need to make sure that these files are being
# combined in the right format. To ascertain the right file structure, import a 
# a single file into R, and check the variables and define the variable type,
# if required

check_file_stru <- read_csv(list_of_files[1])
str(check_file_stru)
glimpse(check_file_stru)
colnames(check_file_stru)


# To Combine Data into a Data Frame =======

# use map_df function to match all the extracted data into a data frame variable
# in map_df function, '~' is used to define a modified function
# read_csv() is originally designed to read a single file, but '~' shows that
# the function has been modified to read a whole list instead of reading a 
# single file

tripdata_df <- list_of_files %>% 
  map_df(~read_csv(.x, col_types = "cfTTccccddddf"))
tripdata_df

dim(tripdata_df)

tripdata_df


# Save and .Rdata for saving data files ======

# Use "Save" and ".rdata" extension to reduce storage size of data file
# efficient write function for csv but takes a fraction (1/4th) of space as compared
# to write_csv function

save(tripdata_df, file = "data/master_data.rdata")


# Another advantage of .rdata file is that it can be easily loaded into R
# environment within seconds . This file can be carried anywhere in any other 
# R project, without the need of carrying original bulk spaced .csv files.
# load the .rdata file

load("data/master_data.rdata")

glimpse(tripdata_df)


## Graphing - To Check the Relationship Between Various Variables =====

# qplot(data = tripdata_df, rideable_type, member_casual)



# hist(tripdata_df$started_at, col = "orange", breaks = 200)

# table(tripdata_df$member_casual, tripdata_df$rideable_type) %>% 
#  barplot(legend = TRUE)

# Make a copy of original dataset to avoid over writing original dataset

df2 <- tripdata_df


# make a new data frame with this information
save(df2, file = "data/df2.rdata")


## Load 'df2' dataset

load("data/df2.rdata")

class(df2)

# Data wrangling ==============

# arrange data with resepct to date and time

df2 <- df2 %>% 
  arrange(started_at)


# introduce a new column variable that can calculate trip length
# use duration calculation operator to calculate the trip duration


trip_dur <- df2 %>% 
  with(started_at %--% ended_at) %>%
  as.duration() %>% 
  as.numeric("minutes") %>% 
  round(2)

trip_dur


# add this new useful variable to the data frame df2

df2 <- df2 %>% 
  mutate(trip_dur)

glimpse(df2)
summary(df2$trip_dur)

# draw a boxplot to have a clear view of trip duration 
ggplot(df2) +
  geom_boxplot(aes(x = trip_dur)) +
  labs(title = "Boxplot for Trip Duration", x = "Trip Duration (in minutes)") +
  scale_x_continuous(labels = scales::comma)

# save this boxplot
ggsave("fig_out/00_0_neg_values_trip_duration.png")


# negative trip duration values
neg_dur <- df2 %>% 
  filter(trip_dur < 0)
dim(neg_dur)



# add a variable of type Date, it will make it easier to analyze data

df2$date <- as.Date(df2$started_at)
glimpse(df2)



# to view two plots together
par(mfrow = c(1, 2), cex = 0.7)

hist(df2$trip_dur)
boxplot(df2$trip_dur)

dev.off()


# add a weekday column

df2$day <- factor(format(df2$date, "%a"),
                    level = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
class(df2$day)
df2$day

# add a month column

df2$month <- factor(format(df2$date, "%b"),
                    level = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                              "Aug", "Sep", "Oct", "Nov", "Dec"))
class(df2$month)
df2$month

glimpse(df2)


# add a time column to create time bins for future analysis

df2$time <- factor(format(df2$started_at, "%H:00")) 
df2$time <- format(df2$started_at, "%H:00")
df2$time <- as_datetime(format(df2$started_at, "%H:00"))

df2$time
class(df2$time)
levels(df2$time)


dev.off()
par(mfrow = c(1, 2), cex = 0.7)
barplot(table(df2$month))
barplot(table(df2$day))


df2 %>% filter(is.na(month))
df2 %>% filter(is.na(day))



summary(neg_dur$trip_dur)


dev.off()
par(mfrow = c(1, 2), cex = 0.7)
hist(neg_dur$trip_dur)
boxplot(neg_dur$trip_dur)


neg_dur %>% 
  select(started_at, ended_at, trip_dur) %>% 
  filter(trip_dur < -100) %>% 
  sort(trip_dur, decreasing = TRUE)

df2 %>% filter(trip_dur < 5 & trip_dur > 0)



# create a new data frame and remove negative values from the data frame

df3 <- df2 %>% 
  filter(trip_dur >= 0 )


save(df3, file = "data/df3.rdata")

load("data/df3.rdata")
glimpse(df3)

dev.off()
par(mfrow = c(1, 2), cex = 0.7)
hist(df3$trip_dur)
boxplot(df3$trip_dur)

summary(df2$trip_dur)
summary(df3$trip_dur)

dev.off()
par(mfrow = c(1, 2), cex = 0.7)

hist(df3$trip_dur, main = "Histogram - Trip Duration", xlab = "Trip Duration - min",
     ylab = "no of trips")
boxplot(df3$trip_dur, horizontal = TRUE, main = "Histogram - Trip Duration", 
        xlab = "Trip Duration - min",
        ylab = "no of trips")


ggplot(data = df3) +
  geom_bar(aes(x = day), fill = "light blue") +
  xlab("Weekdays") +
  ylab("No. of Trips") +
  ggtitle("Total no. of Trips wrt. Weekdays") +
  scale_y_continuous(labels = scales::comma)

ggsave("fig_out/01_weekdays_total_trips.png")



ggplot(df3) +
  geom_point(aes(x = day, y = trip_dur)) +
  xlab("Weekdays") +
  ylab("Trip Duration (in Mins.)") +
  ggtitle("Trip durations by Weekdays") +
  scale_y_continuous(labels = scales::comma)

ggsave("fig_out/02_trip_dur_wrt_weekdays_point_plot.png")


# Draw total number of trips in member and casual segregation

ggplot(data = df3, aes(x = member_casual, fill = member_casual)) +
  geom_bar(aes(position = "dodge")) +
  xlab("Weekdays") +
  ylab("No. of Trips") +
  ggtitle("Trip durations by Weekdays") +
  scale_y_continuous(labels = scales::comma)


# Define a theme for your graphs =========

theme_for_graphs <- theme(
  legend.title = element_blank(), 
  legend.position = "right", 
  axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0))

theme_for_graphs_v <- theme(
  legend.title = element_blank(), 
  legend.position = "right", 
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0))



# Draw total number of trips in member and casual segregation - Percentage

ggplot(data = df3, aes(x = member_casual, fill = member_casual)) +
  geom_bar(aes(y = (..count..)/sum(..count..), position = "dodge")) +
  xlab("Member Status") +
  ylab("Percentage") +
  ggtitle("Trip Proportions - Member vs. Casual") +
  scale_y_continuous(labels = scales::percent)


plot_grid(
  ggplot(data = df3, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(position = "dodge")) +
    labs(x = "Member Status", y = "no_of_trips", title = "Total Trip Segregation \nMember vs. Casual") +
    theme_for_graphs +
    scale_y_continuous(labels = scales::comma),
  ggplot(data = df3, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(y = (..count..)/sum(..count..), position = "dodge")) +
    labs(x = "Member Status", y = "Percentage", title = " \n ") +
    theme_for_graphs +
    scale_y_continuous(labels = scales::percent)
  
)


ggsave("fig_out/03_no_of_trips_member_vs_casual.png")


ggplot(data = df3, aes(x = day)) +
  geom_bar(aes(fill = member_casual), position = "dodge") +
  xlab("Weekdays") +
  ylab("No. of Trips") +
  ggtitle("Trip durations by Weekdays") +
  theme_for_graphs +
  scale_y_continuous(labels = scales::comma)


df4 <- df3 %>% 
  select(rideable_type, start_station_id, start_station_name, end_station_id,
         end_station_name,  member_casual, trip_dur, date, day, month, time)

save(df4, file = "data/df4.rdata")

load("data/df4.rdata")
glimpse(df4)


ggplot(data = df4) +
  geom_bar(aes(x = day, fill = member_casual), position = "dodge") +
  labs(x = "Weekdays", y = "No. of Trips", 
       title = "Total no. of Trips wrt. Weekdays") +
  theme(legend.title = element_blank()) +
  scale_y_continuous(labels = scales::comma)

ggsave("fig_out/01_1_weekdays_total_trips.png")



# graph Busy hours round the clock
ggplot(df4, aes(x = time)) +
  geom_bar(aes(fill = member_casual), position = "dodge") +
  theme(legend.title = element_blank()) +
  labs(x = "time (hours)", y = "no. of trips", 
       title = "Trips - Round the Clock") +
  scale_y_continuous(labels = scales::comma)


# Create a new data frame to filter Saturday and Sunday traffic

df5_sat_sun <- df4 %>% 
  filter(day == "Sat" | day == "Sun")

df5_sat_sun


plot_grid(
  ggplot(data = df5_sat_sun, aes(x = day)) +
    geom_bar(aes(fill = member_casual), position = "dodge") +
    labs(x = "Weekdays", y = "No. of Trips", 
         title = "Total no. of Trips wrt. Weekdays") +
    theme(legend.title = element_blank(), legend.position = "none",
          axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0)) +
    scale_y_continuous(labels = scales::comma),
  ggplot(df5_sat_sun, aes(x = time)) +
    geom_bar(aes(fill = member_casual), position = "dodge") +
    theme(legend.title = element_blank(), legend.position = "right",
          axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0)) +
    labs(x = "time (hours)", y = "no. of trips", 
         title = "Trips - Round the Clock") +
    scale_y_continuous(labels = scales::comma)
)


ggsave("fig_out/05_sat_sun_trips.png")


ggplot(df5_sat_sun, aes(x = day)) +
    geom_bar(aes(fill = member_casual), position = "dodge") +
  labs(title = "Cycle Usage during the Day - Round the Clock", 
       x = "Time in Hours", y = "No. of Trips") +
  theme(legend.title = element_blank(), legend.position = "right",
        axis.text.x = element_blank()) +
  scale_y_continuous(labels = scales::comma) +
  facet_grid(day ~ time)


ggsave("fig_out/06_sat_sun_trips_pattern.png")



plot_grid(
  ggplot(data = df5_sat_sun, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(position = "dodge")) +
    labs(x = "Member Status", y = "no_of_trips", title = "Total Trips \nSaturdays & Sundays Only") +
    theme(legend.position = "none") +
    scale_y_continuous(labels = scales::comma),
  ggplot(data = df5_sat_sun, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(y = (..count..)/sum(..count..), position = "dodge")) +
    labs(x = "Member Status", y = "Percentage", title = " \n ") +
    theme_for_graphs +
    scale_y_continuous(labels = scales::percent)
)


ggsave("fig_out/07_no_of_trips_sat_sun.png")




plot_grid(
  ggplot(data = df4, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(position = "dodge")) +
    labs(x = "Member Status", y = "no_of_trips", title = "Total Trips \nAll Weekdays") +
    theme(legend.position = "none") +
    scale_y_continuous(labels = scales::comma),
  ggplot(data = df5_sat_sun, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(position = "dodge")) +
    labs(x = "Member Status", y = "", title = "Total Trips \nSaturdays & Sundays Only") +
    theme(legend.position = "none", legend.title = element_blank()) +
    scale_y_continuous(labels = scales::comma)
)

ggsave("fig_out/08_no_of_trips_weekdays_vs_weekend.png")


plot_grid(
  ggplot(data = df4, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(y = (..count..)/sum(..count..), position = "dodge")) +
    labs(x = "Member Status", y = "Percentage", title = "Total Trips \nAll Weekdays") +
    theme(legend.position = "none") +
    scale_y_continuous(labels = scales::percent),
  ggplot(data = df5_sat_sun, aes(x = member_casual, fill = member_casual)) +
    geom_bar(aes(y = (..count..)/sum(..count..), position = "dodge")) +
    labs(x = "Member Status", y = "", title = "Total Trips \nSaturdays & Sundays Only") +
    theme_for_graphs +
    scale_y_continuous(labels = scales::percent)
)  

ggsave("fig_out/09_no_of_trips_weekdays_vs_weekend.png")



# Calculate average duration of the trip w.r.t. weekdays

avg_trip_duration_day <- df4 %>%  
  group_by(day, member_casual) %>% 
  summarise(mean_trip_length = mean(trip_dur))

avg_trip_duration_day

ggplot(avg_trip_duration_day, aes(x = day, y= mean_trip_length, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Avg. Trip Duration During the Week", x = "Day",
       y = "Avg. Trip Duration \n(in minutes)") +
  theme(legend.title = element_blank())

ggsave("fig_out/10_avg_trip_dura.png")



avg_trip_duration_hour <- df4 %>% 
  group_by(time, member_casual) %>% 
  summarise(mean_trip_dura_hour = mean(trip_dur))

avg_trip_duration_hour

ggplot(avg_trip_duration_hour, aes(x = time, y = mean_trip_dura_hour, 
                                   fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Avg. Trip Duration at each Hour Round the Clock", x = "time",
       y = "Avg. Trip Duration \n(in minutes)") +
  theme(legend.title = element_blank())



df_trip_start_station <- df4 %>% 
  count(start_station_id, start_station_name, sort = TRUE)

df_trip_start_station

df_trip_end_station <- df4 %>% 
  count(end_station_id, end_station_name, sort = TRUE)

df_trip_end_station

df_trip_station <- df_trip_start_station %>% 
  filter(df_trip_start_station$n > quantile(df_trip_start_station$n, probs = 0.75))

df_trip_station

df_trip_station <- df_trip_station %>% 
  filter(start_station_id %in% df4)




df4 %>% 
  group_by(start_station_id, start_station_name) %>% 
  summarise(mean_trip_dur_station = mean(trip_dur)) %>% 
  arrange(desc(mean_trip_dur_station))
  
  
  
  
  
  

summary(df_trip_station$n)
quantile(df_trip_station$n, probs = 0.75)


df_trip_station %>% 






avg_trip_duration_member_type <- df3 %>% 
  select(started_at, month, day, trip_dur, member_casual, rideable_type) %>% 
  group_by(member_casual) %>% 
  summarise(mean_trip_length = mean(trip_dur))

avg_trip_duration_member_type





weekday_trip_count <- df3 %>% 
  group_by(day) %>% 
  count()

weekday_trip_count



plot_month_trip_count <- ggplot(data = df3) +
  geom_bar(aes(x = month), fill = "light blue") +
  scale_y_continuous(labels = scales::comma)

plot_month_trip_count


ggplot(df3) + 
  geom_bar(mapping = aes(x = month, fill = rideable_type)) +
  scale_y_continuous(labels = scales::comma)




ggplot(df3) + 
  geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) +
  scale_y_continuous(labels = scales::comma)


ggplot(avg_trip_duration) + 
  geom_bar(mapping = aes(x = member_casual, fill = trip_dur)) +
  scale_y_continuous(labels = scales::comma)

ggplot(df3) + 
  geom_boxplot(mapping = aes(x = date, y = member_casual, color = member_casual))


ggplot(df3) + 
  geom_bar(mapping = aes(x = member_casual, fill = rideable_type)) +
  scale_y_continuous(labels = scales::comma)










avg_trip_length <- df2 %>% 
  group_by(start_station_name, Order = FALSE) %>% 
  summarise(avg_trip = mean(trip_leng), units = "mins")
  
avg_trip_length











view(avg_trip_length)
most_common_start <- tripdata_df2 %>% 
  count(start_station_name, sort = TRUE)
view(most_common_start)

most_common_end <- tripdata_df2 %>% 
  count(end_station_name, sort = TRUE) %>% 
  top_n(5)
view(most_common_end)

most_common <- tripdata_df2 %>% 
  count(start_station_name, end_station_name, sort = TRUE)
  
view(most_common)

avg_trip_length <- tripdata_df2 %>% 
  summarise(mean(trip_leng))

class(tripdata_df2$trip_leng)

avg_trip_length


str(tripdata_df2$trip_leng)




ggplot(tripdata_df) + 
  geom_histogram(mapping = aes(x = started_at))

ggplot(tripdata_df) + 
  geom_boxplot(mapping = aes(x = member_casual, y = started_at))

ggplot(tripdata_df) + 
  geom_boxplot(mapping = aes(x = member_casual, y = started_at), fill = "red")

ggplot(tripdata_df) + 
  geom_bar(mapping = aes(x = member_casual, fill = rideable_type))

tripdata_df %>% 
  filter(rideable_type == "docked_bike") %>% 
  ggplot(aes(x = member_casual, fill = rideable_type)) + geom_bar()

ggplot(tripdata_df) + 
  geom_bar(mapping = aes(x = member_casual, position = "dodge"))