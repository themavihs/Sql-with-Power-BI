-- cleanse dim_datetable

SELECT [DateKey],
[FullDateAlternateKey] Date ,
[EnglishDayNameOfWeek] Day ,
[WeekNumberOfYear] WeekNo ,
[EnglishMonthName] Month ,
[MonthNumberOfYear] MonthNo ,
[CalendarQuarter] Quarter ,
[CalendarYear] Year
FROM [AdventureWorksDW2019].[dbo].[DimDate]
where CalendarYear >= 2019


-- clean dim_customer table

SELECT [CustomerKey] ,
[FirstName] ,
[LastName] ,
[FirstName] + ' ' + [LastName] FullName,
case [Gender] when 'M' then 'Male' when 'F' then 'Female' end Gender,
[DateFirstPurchase],
geo.city [Customer City]
FROM [AdventureWorksDW2019].[dbo].[DimCustomer] cus
left join dbo.DimGeography geo on geo.GeographyKey = cus.GeographyKey
order by CustomerKey


-- CLEAN product table

SELECT [ProductKey] ,
[ProductAlternateKey]  [Producte Code],
[EnglishProductName] [Product Name] ,
[Color] [Product Colour],
[Size] [Product Size] ,
[ProductLine] [Product Line],
[ModelName] [Model Name] ,
[EnglishDescription] [Product Description],
ISNULL ([Status], 'Outdated') [Product Status]
FROM [AdventureWorksDW2019].[dbo].[DimProduct] p
left join dbo.DimProductSubcategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
left join dbo.DimProductCategory pc on pc.ProductCategoryKey = ps.ProductCategoryKey
order by p.ProductKey asc


-- clearing of factinternetsales table

SELECT [ProductKey] ,
[OrderDateKey] ,
[DueDateKey] ,
[ShipDateKey] ,
[CustomerKey] ,
[SalesOrderNumber] ,
[SalesAmount] 
FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
where 
left (OrderDateKey,4) >= year(getdate()) -2
order by OrderDateKey