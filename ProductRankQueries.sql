-- Sales and product analysis portfolio project

/*	-- Scenario --- Study our best customers sales and best products

	Online business has a lot of customers and products.
	
	This scenario returns a list of Products ranked within there Product Category by sales
	for the month of December 2013

	The information required is contained within 4 tables. 
	The query is completed using two methods:
	-Cross Apply  
	-Multiple table join
  
  
  *******************************************************************************************************

  Def:  Returns the rank of each row within the partition of a result set. 
		The rank of a row is one plus the number of ranks that come before the row in question
		Note: Where value is the same across rows int the group , then a rank can tie
The following code was developed using SQL Server 2014
The scenerio comes from Paul Scothford's SQL Masterclass course for Udemy.com

*/

-- Using a cross apply

use [Chapter 3 - Sales (Keyed) ];

select 
prod.ProductName,
catnames.ProductCategoryName,
sum(os.SalesAmount) as MthSales,
RANK() OVER (PARTITION by [ProductCategoryName] ORDER BY sum([SalesAmount]) DESC) as CustomerRank

from [dbo].[Product] prod inner join
[dbo].[OnlineSales] os on prod.ProductKey = os.Productkey and
os.OrderDate between '2013-12-1' and '2013-12-31' 

cross apply (

select prodsub.ProductSubcategoryName,prodcat.ProductCategoryName

from [dbo].[ProductCategory] prodcat inner join 
[dbo].[ProductSubcategory] prodsub on prodcat.ProductCategoryKey= prodsub.ProductCategoryKey 
where prod.ProductSubcategoryKey = prodsub.ProductSubcategoryKey

) as catnames

group by
ProductCategoryName,
ProductName

order by
ProductCategoryName




-- Using Multiple table join
select 
prod.ProductName,
pc.ProductCategoryName,
sum(os.SalesAmount) as MthSales,
RANK() OVER (PARTITION by [ProductCategoryName] ORDER BY sum([SalesAmount]) DESC) as CustomerRank

from [dbo].[Product] prod inner join
[dbo].[OnlineSales] os on prod.ProductKey = os.Productkey and
os.OrderDate between '2013-12-1' and '2013-12-31'  inner join
[dbo].[ProductSubcategory] psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey inner join
		[dbo].[ProductCategory] pc on psc.ProductCategoryKey = pc.ProductCategoryKey

group by
ProductCategoryName,
ProductName

order by
ProductCategoryName
