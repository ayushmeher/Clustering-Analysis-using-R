library(dplyr)
library(tidyr)
library(readr)
library(plotrix)
library(purrr)
library(cluster)
library(gridExtra)
library(grid)
library(NbClust)
library(factoextra)
set.seed(123) #set.seed is a base function that it is able to generate particular seq of random number (every time you want) together other functions 

#Import the data and examine its structure to have a general feel of how the data is 
customer = read.csv('/Users/ayushmeher/R Prog/Project/Mall_Customers.csv')
customer
#EPLORATORY DATA ANALYSIS
#Let us explore the data further and see the variations in the columns. It is also a good practise to look 
# at the first and last few rows of the data.
str(customer)
summary(customer)
head(customer)
tail(customer)

# Now take the data exploration further by exploring the Gender column. We will visualize the column using
# barchart and pie chart

a = table(customer$Gender)
barplot(a, main = "Visualizing Gender Distribution",
        xlab = "Gender", ylab = "Gender Count",
        col = rainbow(2), legend = rownames(a))

# It can be observed from the barplot that females are more than male customers in this dataset.
# Let us create a pie chart to see what that will also tell us.

percent = round(a/sum(a)*100)
labs = paste(c('Female', 'Male'), ' ', percent, '%', sep = ' ')
pie3D(a, labels = labs, 
      main = 'Pie Chart showing the distribution of the Males and Females')

# It can be seen from the pie chart that indeed the females are the majority with 56% and the males 44%.

# Now we will also explore the Age column to see its distribution.
summary(customer$Age,)
hist(customer$Age, col = 'green',
     main = 'Histogram showing the Age distribution of customers',
     xlab = 'Age group', ylab = 'Count',
     labels = T)
boxplot(customer$Age,
        col="yellow",
        main="Boxplot for Descriptive Analysis of Age")
plot(density(customer$Age),
     col="yellow",
     main="Density Plot for Age",
     xlab="Age Class",
     ylab="Density")
polygon(density(customer$Age),
        col="blue")
#Now we can also visualize the income column to see its distribution
hist(customer$Annual.Income..k.., col = 'red',
     main = 'Graph showing the income distribution of customers',
     xlab = 'Income group', ylab = 'Frequency',
     labels = T)
boxplot(customer$Annual.Income..k..,
        col="green",
        main="Boxplot for Descriptive Analysis of Annual Income")
plot(density(customer$Annual.Income..k..),
     col="yellow",
     main="Density Plot for Annual Income",
     xlab="Annual Income Class",
     ylab="Density")
polygon(density(customer$Annual.Income..k..),
        col="blue")
#boxplot(customer[,3:5], col = 'red',
#    main = 'Graph showing the income distribution of customers',
#    xlab = 'Income group', ylab = 'Frequency',
#    labels = T)

#Analysing the spending score of customers

summary(customer$Spending.Score..1.100.)
boxplot(customer$Spending.Score..1.100.,
        horizontal=TRUE,
        col="red",
        main="BoxPlot for Descriptive Analysis of Spending Score")
hist(customer$Spending.Score..1.100., col = 'purple',
     main = 'Graph Showing the Spending score',
     xlab = 'Spending core group', ylab = 'Frequency',
     labels = T)
plot(density(customer$Spending.Score..1.100.),
     col="yellow",
     main="Density Plot for Spending score",
     xlab="Spending score Class",
     ylab="Density")
polygon(density(customer$Spending.Score..1.100.),
        col="blue")
#library(corrplot)
#corrplot(cor(customer[,3:5]), order="hclust")  
#library(gplots)
#library(RColorBrewer)
#heatmap.2(as.matrix(customer[,3:5]),col=brewer.pal(9, "GnBu"),
#          trace="none",key=FALSE, dend="none",
 #         main="\n\n\nBrand attributes")
# gender
gender01 = rep(NA, 200)
gender01[customer$Gender == "Male"] = 0
gender01[customer$Gender =="Female"] = 1
customer$Gender01=gender01
str(customer)
#CLUSTERING
#We will find the optimal number of clusters using methods; Elbow

# 1.Using the Elbow Method to determine the optimal number of clusters

#function to calculate the total intra cluster sim of squares
iss = function(k) {
  kmeans(customer[,3:6], k, iter.max = 100, nstart = 100, algorithm = 'Lloyd')$tot.withinss
}

k_values = 1:10

iss_values = map_dbl(k_values, iss)

plot(k_values, iss_values, type = 'b', pch = 19, frame = F,
     xlab = 'Number of Clusters(K)',
     ylab = 'Total intra-cluster sum of squares (iss)')

fviz_nbclust(customer[,3:6], kmeans, method = "wss")+geom_vline(xintercept = 4, linetype = 2)

# 2. Silhouette Method
#Here, we will try it for different values of k
#k=4
k4 = kmeans(customer[,3:6],4, iter.max = 100, nstart = 50, algorithm = 'Lloyd')
s4 = plot(silhouette(k4$cluster, dist(customer[,3:6], 'euclidean')))

#k=5
k5 = kmeans(customer[,3:6],5, iter.max = 100, nstart = 50, algorithm = 'Lloyd')
s5 = plot(silhouette(k5$cluster, dist(customer[,3:6], 'euclidean')))

#k=6
k6 = kmeans(customer[,3:6],6, iter.max = 100, nstart = 50, algorithm = 'Lloyd')
s6 = plot(silhouette(k6$cluster, dist(customer[,3:6], 'euclidean')))

#k=7
k7 = kmeans(customer[,3:6],7, iter.max = 100, nstart = 50, algorithm = 'Lloyd')
s7 = plot(silhouette(k7$cluster, dist(customer[,3:6], 'euclidean')))


#Now we determine the optimal number of clusters
fviz_nbclust(customer[,3:6], kmeans, method = 'silhouette')

#from the graph, it can be seen that the plot has a bend at 4, so we can choose that as the number of cluster
distance <- get_dist(customer[,3:5])
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))



#K=4
# Clustering with 4 groups
out = kmeans(customer[,-c(1,2)], centers=4)
# Assigned group numbers
head(out$cluster, n=10)
# adding group number
Seg_K4 = cbind(customer, out$cluster)
colnames(Seg_K4)[7] = "Group"
head(Seg_K4)
# average levels for each group
mean_K4 = aggregate(cbind(Age,Gender01, Annual.Income..k.., Spending.Score..1.100.)~
                      Group, Seg_K4, mean)
mean_K4

# color assignment
PtsColor = rep("",60)
PtsColor[Seg_K4$Group==1] = "red"
PtsColor[Seg_K4$Group==2] = "green"
PtsColor[Seg_K4$Group==3] = "blue"
PtsColor[Seg_K4$Group==4] = "black"
# scatterplot
plot(Seg_K4$Annual.Income..k.., Seg_K4$Spending.Score..1.100., col=PtsColor,main = "K=4", pch=20,xlab = "Annual.Income..k..", ylab = "Spending.Score..1.100.")

#K=5
# Clustering with 5 groups
out = kmeans(customer[,-c(1,2)], centers=5)
# Assigned group numbers
head(out$cluster, n=10)
# adding group number
Seg_K4 = cbind(customer, out$cluster)
colnames(Seg_K4)[7] = "Group"
head(Seg_K4)
# average levels for each group
mean_K4 = aggregate(cbind(Age,Gender01, Annual.Income..k.., Spending.Score..1.100.)~
                      Group, Seg_K4, mean)
mean_K4

# color assignment
PtsColor = rep("",60)
PtsColor[Seg_K4$Group==1] = "red"
PtsColor[Seg_K4$Group==2] = "green"
PtsColor[Seg_K4$Group==3] = "blue"
PtsColor[Seg_K4$Group==4] = "black"
PtsColor[Seg_K4$Group==5] = "purple"
# scatterplot
plot(Seg_K4$Annual.Income..k.., Seg_K4$Spending.Score..1.100., col=PtsColor, pch=20,main = "K=5",xlab = "Annual.Income..k..", ylab = "Spending.Score..1.100.")

#K=6
# Clustering with 6 groups
out = kmeans(customer[,-c(1,2)], centers=6)
# Assigned group numbers
head(out$cluster, n=10)
# adding group number
Seg_K4 = cbind(customer, out$cluster)
colnames(Seg_K4)[7] = "Group"
head(Seg_K4)
# average levels for each group
mean_K4 = aggregate(cbind(Age,Gender01, Annual.Income..k.., Spending.Score..1.100.)~
                      Group, Seg_K4, mean)
mean_K4

# color assignment
PtsColor = rep("",60)
PtsColor[Seg_K4$Group==1] = "red"
PtsColor[Seg_K4$Group==2] = "green"
PtsColor[Seg_K4$Group==3] = "blue"
PtsColor[Seg_K4$Group==4] = "black"
PtsColor[Seg_K4$Group==5] = "purple"
PtsColor[Seg_K4$Group==6] = "orange"

# scatterplot
plot(Seg_K4$Annual.Income..k.., Seg_K4$Spending.Score..1.100., col=PtsColor, pch=20,main = "K=6" ,xlab = "Annual.Income..k..", ylab = "Spending.Score..1.100.")
library(cluster)
clusplot(dat , dat$Group , color=as.factor(k6$cluster) , shade=TRUE , labels=6, lines=0,
         main="Model -based cluster plot")
# frequency
table(Seg_K4$Group)
table(Seg_K4$Group) / nrow(Seg_K4)
seg.summ <- function(data , groups) {
  aggregate(data , list(groups),function(x) mean(as.numeric(x)), drop = TRUE)}
seg.summ(Seg_K4 , Seg_K4$Group)


dat = Seg_K4[,c("Age","Gender01", "Annual.Income..k..", "Spending.Score..1.100.",
                "Group")]
seg.summ(dat , dat$Group)
boxplot(Seg_K4$Spending.Score..1.100. ~ out$cluster , ylab="Spending.Score..1.100", xlab="Cluster")

#visualizing the clusters

ggplot(customer, aes(Annual.Income..k.., Spending.Score..1.100.))+
  geom_point(stat = 'identity', aes(color = as.factor(k6$cluster))) +
  scale_color_discrete(name = ' ',
                       breaks = c('1','2','3','4','5','6'),
                       labels = c('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5', 
                                  'Cluster 6')) +
  ggtitle('Clusters of Mall Customers', subtitle = 'Using K-means Clustering')

#clustering using pca
kcols = function(vec){cols = rainbow(length(unique(vec)))
  return(cols[as.numeric(as.factor(vec))])}

#kmeans clusters
digcluster = k6$cluster; dignm = as.character(digcluster);

plot(pc_clust$x[,1:2], col=kcols(digcluster), pch=19, xlab = 'K-means', ylab = 'Classes')
legend('bottomleft', unique(dignm), fill = unique(kcols(digcluster)))
library("scatterplot3d")
with(customer[,3:6], scatterplot3d(Age,Spending.Score..1.100., Annual.Income..k.., type = "p", color = as.factor(k6$cluster)))

cluster_6 <-kmeans(customer[,3:6], 6)
results <- cbind(customer,cluster_6$cluster)
results
#5 clusters are observed

#High Spending Score, with lower Annual Income
#High Spending Score, with higher Annual Income
#Medium Spending Score with medium Annual Income
#Low Spending Score with lower Annual Income
#Low Spending Score with higher Annual Incom



#Cluster 4 and 1. Customers with medium PCA1 and medium PCA2 score

#Cluster 6. Customers with high PCA2 and low PCA1

#Cluster 5. Customers with medium PCA1 and low PCA2 score

#Cluster 3. Customers with high PCA1 income and high PCA2

#Cluster 2. Customers with hiht PCA2 but medium annual spend

#Clustering also helps to better understand the variables to make better decisions. In our case, there are high levels of income. A more strategic and targeted marketing approach could lift their interest and make them become higher spenders. The focus should also be on the "loyal" customers and maintain their satisfaction.







