![](http://c4.staticflickr.com/8/7588/16579652848_c702a4e2c9_b.jpg)

![](http://c1.staticflickr.com/9/8647/16144918144_6edf38caa0_b.jpg)

![](http://c2.staticflickr.com/8/7640/16581082169_564f90d82a_b.jpg)

![](http://c2.staticflickr.com/8/7286/16559955627_62e5cc8576_b.jpg)

![](http://c1.staticflickr.com/9/8671/16559955487_af3836da30_b.jpg)

***

## GUI Implementation

* Technology: JSP, HTML, CSS, JavaScript
* Environment: Eclipse.
* Front-end framework: Bootstrap.
* Data visualization: E-chart JavaScript plugin
* Description:
* We apply Bootstrap to establish our HTML based GUI framework. Besides, JSP is employed to retrieve data from SQL server and populate the data to GUI. In addition, we use E-chart, a JavaScript plugin to implement interactive data visualization.


## High-Level Data Staging Plan

![](http://c1.staticflickr.com/9/8619/16508618617_ec4e655c2c_c.jpg)


***

## Summary of ETL Process

National Collision Dimensions
* Import the source data into SQL Server 2008 as data staging table.
* Create new tables for target dimension tables [Collision, Vehicle and Passenger].
* Extract the data from data staging table and remove the duplicate data and load into target dimension tables.
* Generate Surrogate keys for dimension tables [Collision, Vehicle and Passenger].
* Perform Null value processing.
* Create lookup table, consisting of the descriptions for metadata.


Date Dimension
* Load the Kimball date data (2000-2020) into SQL Server 2008 as date staging table.
* Insert the Date data of the year 1999 into the date staging table.
* Modify the date staging table, remove the date of month column and remove duplicate rows by detecting duplicates in day of week.
* Create target date dimension table and load the data.
* Generate Surrogate keys and replace the natural keys.


Weather Dimension
* Load the weather data (Ottawa, Vancouver and Halifax) into SQL Server 2008 as weather dimension table.
* Generate Surrogate keys and process Null value.


Collision Fact Table
* Load the source data into SQL Server 2008 as staging table.
* Generate Natural keys.
* Create Surrogate key mapping tables.
* Remove irrelevant columns.
* Replace the natural key with surrogate key using mapping table.
* Load the data into target fact table.


***

## Application Template Design

 ![](http://c1.staticflickr.com/9/8617/16528658240_ffdfbe6a06_n.jpg)


***

## Application Navigation Framework

![](http://c1.staticflickr.com/9/8619/16093771304_2401178c12_b.jpg)



