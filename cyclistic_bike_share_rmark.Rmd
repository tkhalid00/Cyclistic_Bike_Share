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
  
\* Casual riders, and\
\* Members
  
Members category is more profitable and it will lead to future growth of the company. For the purpose, marketing manger wants to get aware of major trends for these two classes in order to devise a comprehensive marketing strategy to shift more and more casual riders to members category. A junior data analyst's task is to identify these trends and communicate to the marketing manager in an effective way so that he can build an effective campaign.

# Step-1 - Ask - Define the Business Task

The business task at hand is to increase the number of riders in **Members** category. Following is the business task statement:\
>To find a comprehensive strategy to convert casual riders to members category in order to maximize the prospects of long term growth and profitability of the Cyclistics.

# Step-2 - Prepare - Check the Authenticity and Reliability of Data
In order assess the data, it needs to be looked at. Although, the tool for analysis will be decided in next stage, but before going there, we have to make sure that this data is reliable enough that it has the worth to be analyzed further. We need to check the data for following parameters:
1. 
