---
title: "Cyclistic Bike Share - Analysis"
author: "tk"
date: "6/4/2021"
output:
  html_document:
    keep_md: true
    toc: true
    toc_depth: 2
---

The analysis is a part of a full project that I did for getting qualified for Google Data Analytics certificate. For the purpose, a huge dataset of approximately 500MB was provided. It was too large to be uploaded here. However, this public dataset can be accessed [here](https://divvy-tripdata.s3.amazonaws.com/index.html).

There are 12 `.csv` files for past 12 months, starting from April 2020 till March 2021. These raw data files can be downloaded for data analysis. Due to high volume of these files, I will only attach `.rdata` file format here.

We will jump right to our task with a systematic step-by-step approach.

# Intorduction

Cyclistic Bike Share company's marketing manager is convinced that out of following two categories of riders\
  
\* Casual riders, and  
\* Members
  
Members category is more profitable and it will lead to future growth of the company. For the purpose, marketing manger wants to get aware of major trends for these two classes in order to devise a comprehensive marketing strategy to shift more and more casual riders to members category. A junior data analyst's task is to identify these trends and communicate to the marketing manager in an effective way so that he can build an effective campaign.

# Step-1 - Ask - Define the Business Task

The business task at hand is to increase the number of riders in **Members** category. Following is the business task statement:  
>To find a comprehensive strategy to convert casual riders to members category in order to maximize the prospects of long term growth and profitability of the Cyclistics.

# Step-2 - Prepare - Check the Authenticity and Reliability of Data
In order assess the data, it needs to be looked at. Although, the tool for analysis will be decided in next stage, but before going there, we have to make sure that this data is reliable enough that it has the worth to be analyzed further. We need to check the data for following parameters:
1. Where is the data is located? Since the data is provided by the company itself, and no second party or third party is involved, there is a high probability that data is reliable.
2. How is data organized? Data is organized in `.csv` file format and named in pretty conventional and easy to understand way. name starts with year, followed by month number.
3. Data is reproducible for research purposes.
4. Only primary data sources have been used for this data.


# Step-3 - Process - Start Navigating Through Given Data
Now when we have assessed the quality and source of data and have it downloaded to a secure location, the next step is to make data ready for analysis. Although there are many tools that can help analyze the data, I have used R to explore, analyze and then visualize the given dataset. There are number of reasons for doing so.
1. Data set is too large to manipulate in Excel. While Excel is a wonderful tool to analyze and visualize small-to-medium sized data sets, it has its limitation when it comes to large data sets. Excel can easily be slowed down by any huge dataset. Current data set contains almost 4 million rows and for Excel its too much of a task to go through this rows quickly.
2. Another option is using SQL. No doubt that SQL is much faster than Excel in handling these large data sets, but it needs some external server where data needs to be uploaded and where queries can be run to extract and manipulate data. Due to large size of `.csv` files, it was a challenging task to upload these data files to some external environment like Google Cloud services. These external cloud are exceptionally good with data storage and query execution, but most of the times these services offer limited access with free accounts.
3. Finally, I decided to go with R, not because it's an open source programming platform, but offers great flexibility in terms of manipulating and visualizing data. It's kind of one stop shop where you can perform many task without incurring any cost.

In order to process data before analysis, the first task is to import data into R. To do so, a couple of packages needs to be installed/loaded. You can write the following code to load these libraries:


```r
library(tidyverse) # This package is a combination of different packages required for data wrangling, analysis and visualization.
library(lubridate) # This package deals with manipulation of dates.
library(scales) # This package helps simplify scales while drawing different graphs and charts.
library(cowplot) # This package is helpful if multiple plots are required to be produced or saved side by side.
```

Next we need to import data into R studio to have an initial look of the given data. Due to large size of `*.csv` files, this code will not be executed in following chunks, and, hence will be commented out.  

First step to import these files into R is to get all the names of `*.csv` data files in the folder where these files are stored. Since I used `data/unconditioned_data` folder to download and store these files, I have given the path and used `list.files` of all `.csv` files in given folder.


```r
# # get all the file names with their path in a variable ===========
# 
# list_of_files <- list.files("data/unconditioned_data", pattern = "*.csv", 
#                             full.names = TRUE)
# list_of_files
# class(list_of_files)
# length(list_of_files)
```

Before moving further, instead of importing all the files together, its a good practice that we select a single file from above created list and import to check its structure and get a feel of raw data. Again, due to high volume these `.csv` files, this code will not be executed here. We will start our analysis once we get all the data in a single file that is compatible with R and easy to use to maipulate and analyze data.


```r
# # before combining these files, we need to make sure that these files are being
# # combined in the right format. To ascertain the right file structure, import a 
# # a single file into R, and check the variables and define the variable type,
# # if required
# 
# check_file_stru <- read_csv(list_of_files[1])
# str(check_file_stru)
# glimpse(check_file_stru)
# colnames(check_file_stru)
```


As these `.csv` file names are stored as a list in R, the next step is to import these raw `.csv` files into R as as a data frame. As this data frame is still not in compatible R format that we need, this code will also not be executed here. In `read_csv()`, we use `col_types = `, the types of columns that we need in our desired data frame are defined at the time of data import. By doing this, we get all the data in a uniform format that is compatible with each other and will remove and errors in future due to data incompatibility. `col_types` abbreviations represent the following:
* c = `character`
* f = `factor`
* T = `dateTime` of class `POSIXct`
* d = `double`


```r
# # To Combine Data into a Data Frame =======
# 
# # use map_df function to match all the extracted data into a data frame variable
# # in map_df function, '~' is used to define a modified function
# # read_csv() is originally designed to read a single file, but '~' shows that
# # the function has been modified to read a whole list instead of reading a 
# # single file
# 
# tripdata_df <- list_of_files %>% 
#   map_df(~read_csv(.x, col_types = "cfTTccccddddf"))
# tripdata_df
# 
# dim(tripdata_df)
# 
# tripdata_df
```

After import of 12 no. of `.csv` into a single R compatible data frame vector, we need to save it in `.rdata` format. There are several advantages of doing so:
1. It takes less than one-fourth of the original file size.
2. `.rdata` files can be imported easily into `R` Environment and they can be loaded instantly without a requirement of doing any data format conversions.
Now, this master data will be saved as `.rdata` file


```r
# # Save and .Rdata for saving data files ======
# 
# # Use "Save" and ".rdata" extension to reduce storage size of data file
# # efficient write function for csv but takes a fraction (1/4th) of space as compared
# # to write_csv function
# 

# save(tripdata_df, file = "data/master_data.rdata")
```

Finally, we are able to get our hands on a `.rdata` file that can be easily loaded into `R` environment, so from now on all the code chunks will be compiled and executed. First load `.rdata` file into the system.


```r
# Another advantage of .rdata file is that it can be easily loaded into R
# environment within seconds . This file can be carried anywhere in any other 
# R project, without the need of carrying original bulk spaced .csv files.
# load the .rdata file

load("data/master_data.rdata")

glimpse(tripdata_df)
```

```
## Rows: 3,489,748
## Columns: 13
## $ ride_id            <chr> "A847FADBBC638E45", "5405B80E996FF60D", "5DD24A79A4~
## $ rideable_type      <fct> docked_bike, docked_bike, docked_bike, docked_bike,~
## $ started_at         <dttm> 2020-04-26 17:45:14, 2020-04-17 17:08:54, 2020-04-~
## $ ended_at           <dttm> 2020-04-26 18:12:03, 2020-04-17 17:17:03, 2020-04-~
## $ start_station_name <chr> "Eckhart Park", "Drake Ave & Fullerton Ave", "McClu~
## $ start_station_id   <chr> "86", "503", "142", "216", "125", "173", "35", "434~
## $ end_station_name   <chr> "Lincoln Ave & Diversey Pkwy", "Kosciuszko Park", "~
## $ end_station_id     <chr> "152", "499", "255", "657", "323", "35", "635", "38~
## $ start_lat          <dbl> 41.8964, 41.9244, 41.8945, 41.9030, 41.8902, 41.896~
## $ start_lng          <dbl> -87.6610, -87.7154, -87.6179, -87.6975, -87.6262, -~
## $ end_lat            <dbl> 41.9322, 41.9306, 41.8679, 41.8992, 41.9695, 41.892~
## $ end_lng            <dbl> -87.6586, -87.7238, -87.6230, -87.6722, -87.6547, -~
## $ member_casual      <fct> member, member, member, member, casual, member, mem~
```

We just have to name the `.rdata` file in destination folder, it will create its `R` variable itself and will be ready to use in seconds. `glimps()' function is on

