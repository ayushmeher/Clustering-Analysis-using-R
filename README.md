Mall Customer Segmentation Using K-Means Clustering in R
Overview

This project focuses on the segmentation of mall customers using various clustering techniques. The analysis is performed using R and leverages multiple libraries for data manipulation, visualization, and clustering. The main objective is to group customers based on their spending habits, age, and annual income using K-Means Clustering.
Libraries Used

    dplyr: For data manipulation and transformation.
    tidyr: For data tidying and reshaping.
    readr: For reading in datasets.
    plotrix: For creating advanced charts (e.g., 3D pie charts).
    purrr: For functional programming, used for mapping functions across data.
    cluster: For clustering and generating silhouette plots.
    gridExtra, grid: For arranging multiple grid-based plots.
    NbClust: For determining the optimal number of clusters.
    factoextra: For visualizing clustering results.

Data

The dataset contains information on mall customers and includes the following columns:

    CustomerID: Unique identifier for each customer.
    Gender: Gender of the customer (Male/Female).
    Age: Age of the customer.
    Annual Income (k$): Annual income of the customer in thousands.
    Spending Score (1-100): Customer's spending score, where 1 means the least spending and 100 means the highest spending.

The dataset is imported from a CSV file (Mall_Customers.csv).
Steps Involved
1. Data Import and Exploration

We begin by loading the data using the read.csv function and performing an initial exploration using:

    str() to inspect the structure of the data.
    summary() for descriptive statistics.
    head() and tail() to view the first and last few rows.

2. Exploratory Data Analysis (EDA)

Visualizations help understand the distribution of key variables:

    Gender Distribution: Bar plot and pie chart are used to show the gender distribution.
    Age Distribution: Histogram, boxplot, and density plot provide insights into the age distribution.
    Income Distribution: Similar plots are used to explore annual income.
    Spending Score Analysis: Descriptive statistics and visualizations (boxplot, histogram, density plot) are created for the spending score.

3. Feature Engineering

A new column, Gender01, is created to convert gender into a numeric binary variable (0 for male, 1 for female) for clustering.
4. Clustering Analysis

We apply K-Means clustering to segment customers based on the following features:

    Age
    Annual Income
    Spending Score

Methods Used for Optimal Clusters:

    Elbow Method: Plots total intra-cluster sum of squares to determine the optimal number of clusters.
    Silhouette Method: Evaluates how well clusters are separated using silhouette scores.
    NbClust: Used to further assess the optimal number of clusters using different clustering criteria.

5. K-Means Clustering

We perform K-Means clustering for 4, 5, and 6 clusters. For each k, we:

    Generate silhouette plots to visualize cluster separation.
    Visualize clusters using scatter plots (colored by cluster).
    Analyze cluster centroids and customer characteristics in each group.

6. PCA for Visualization

We use Principal Component Analysis (PCA) for visualizing the high-dimensional data in 2D space. Clusters are visualized in this reduced space to observe the separation between groups.
7. Results and Conclusions

The clustering analysis reveals distinct customer segments based on age, income, and spending score, providing insights into different shopping behaviors. The results can guide marketing strategies tailored to each group.
Visualization

The project includes visualizations such as:

    Bar plots and pie charts for categorical variable analysis (e.g., gender distribution).
    Histograms, density plots, and boxplots for numerical data (age, income, spending score).
    Scatter plots and PCA-based plots to visualize customer clusters.
