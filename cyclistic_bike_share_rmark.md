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


