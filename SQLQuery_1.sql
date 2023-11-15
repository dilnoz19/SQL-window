SELECT * from AdventureWorks2019.Person.Person
--Exercise 1
SELECT p.FirstName, p.LastName, e.JobTitle, Rate, AVG(Rate) OVER() AS AverageRate
FROM AdventureWorks2019.Person.Person AS p 
JOIN AdventureWorks2019.HumanResources.Employee AS e 
ON p.BusinessEntityID = e.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS eph
ON e.BusinessEntityID = eph.BusinessEntityID

--Exercise 2
SELECT 
p.FirstName, 
p.LastName, 
e.JobTitle, 
eph.Rate, 
AVG(eph.Rate) OVER() AS AverageRate, 
MaximumRate = Max(eph.Rate) OVER()
FROM AdventureWorks2019.Person.Person AS p 
JOIN AdventureWorks2019.HumanResources.Employee AS e 
ON p.BusinessEntityID = e.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS eph
ON e.BusinessEntityID = eph.BusinessEntityID

--Exercise 3
SELECT 
p.FirstName, 
p.LastName, 
e.JobTitle, 
eph.Rate, 
AverageRate = AVG(eph.Rate) OVER(), 
MaximumRate = Max(eph.Rate) OVER(),
DiffFromAvgRate = eph.Rate - AVG(eph.Rate) OVER()
FROM AdventureWorks2019.Person.Person AS p 
JOIN AdventureWorks2019.HumanResources.Employee AS e 
ON p.BusinessEntityID = e.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS eph
ON e.BusinessEntityID = eph.BusinessEntityID

--Exercise 4
SELECT 
p.FirstName, 
p.LastName, 
e.JobTitle, 
eph.Rate, 
AverageRate = AVG(eph.Rate) OVER(), 
MaximumRate = Max(eph.Rate) OVER(),
DiffFromAvgRate = eph.Rate - AVG(eph.Rate) OVER(),
PercentofMaxRate = (eph.Rate/MAX(eph.Rate)OVER())*100 
FROM AdventureWorks2019.Person.Person AS p 
JOIN AdventureWorks2019.HumanResources.Employee AS e 
ON p.BusinessEntityID = e.BusinessEntityID
JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS eph
ON e.BusinessEntityID = eph.BusinessEntityID

--Sum of line totals, grouped by ProductID and OrderQty, in an aggregate query
SELECT 
productID,
OrderQty,
LineTotal = SUM(LineTotal)
FROM AdventureWorks2019.Sales.SalesOrderDetail
GROUP BY 
ProductID,
OrderQty
ORDER BY 1,2

--Sum of line totals via OVER
SELECT TOP 100
productID,
SalesOrderID,
SalesOrderDetailID,
OrderQty,
UnitPrice, 
unitPriceDiscount,
LineTotal,
ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY productID, OrderQty)
FROM AdventureWorks2019.Sales.SalesOrderDetail
ORDER BY ProductID, OrderQty DESC

--Exercise 01
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name 
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 02
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
AvgPriceByCategory = AVG(p.ListPrice) OVER(PARTITION BY c.Name)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 03
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
AvgPriceByCategory = AVG(p.ListPrice) OVER(PARTITION BY c.Name),
AvgPriceByCategoryAndSubcategory = AVG(p.ListPrice) OVER(PARTITION BY c.Name, s.Name)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 04
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
AvgPriceByCategory = AVG(p.ListPrice) OVER(PARTITION BY c.Name),
AvgPriceByCategoryAndSubcategory = AVG(p.ListPrice) OVER(PARTITION BY c.Name, s.Name),
ProductVsCategoryDelta = p.ListPrice - AVG(p.ListPrice) OVER(PARTITION BY c.Name)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--CTE
SELECT
*
FROM(
SELECT 
    OrderDate,
    TotalDue,
    OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
    OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader)
X WHERE OrderRank <=10

--Row Number
SELECT 
SalesOrderID,
SalesOrderDetailID,
LineTotal,
SalesOrderIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID)
FROM AdventureWorks2019.Sales.SalesOrderDetail
ORDER BY SalesOrderID

SELECT 
SalesOrderID,
SalesOrderDetailID,
LineTotal,
SalesOrderIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),
Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC) 
FROM AdventureWorks2019.Sales.SalesOrderDetail
ORDER BY SalesOrderID

--Row number Exercise 2
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(PARTITION BY s.Name ORDER BY p.ListPrice DESC)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID
ORDER BY s.Name

SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  [Price Rank] = ROW_NUMBER() OVER(ORDER BY A.ListPrice DESC)

FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID

--Exercise 3
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC)

FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 4

SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC)

FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 4
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Top 5 Price In Category] = (CASE
When ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC) <= 5 THEN 'Yes'
ELSE 'No'
END)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Rank and Dense Rank
SELECT 
SalesOrderID,
SalesOrderDetailID,
LineTotal,
SalesOrderIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),

Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
RankingWithRank = Rank() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
RankingWithDense_Rank = Dense_Rank() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)  

FROM AdventureWorks2019.Sales.SalesOrderDetail
ORDER BY SalesOrderID

--Exercise 1
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Category Price Rank With Rank] = Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 2
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Category Price Rank With Rank] = Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Category Price Rank With Dense Rank] = Dense_Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Top 5 Price In Category] = (CASE
When ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC) <= 5 THEN 'Yes'
ELSE 'No'
END)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Exercise 3
SELECT 
ProductName = p.Name,
p.ListPrice,
ProductSubcategory = s.Name,
ProductCategory = c.Name, 
PriceRank = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Category Price Rank With Rank] = Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Category Price Rank With Dense Rank] = Dense_Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC),
[Top 5 Price In Category] = (CASE
When Dense_Rank() OVER(PARTITION BY c.Name ORDER BY p.ListPrice DESC) <= 5 THEN 'Yes'
ELSE 'No'
END)
FROM AdventureWorks2019.Production.Product AS p 
JOIN AdventureWorks2019.Production.ProductSubcategory AS s 
ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN AdventureWorks2019.Production.ProductCategory AS c 
ON s.ProductCategoryID = c.ProductCategoryID

--Lead and Lag
SELECT
      SalesOrderID,
      OrderDate, 
      CustomerID, 
      TotalDue, 
      [NextTotalDue] = LEAD(TotalDue,1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID),
      PrevTotalDue = LAG(TotalDue,1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)
FROM AdventureWorks2019.Sales.SalesOrderHeader
ORDER BY CustomerID, SalesOrderID

--Exercise 1
SELECT
       A.PurchaseOrderID,
       A.OrderDate,
       A.TotalDue,
       VendorName = B.Name
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader AS A
JOIN AdventureWorks2019.Purchasing.Vendor AS B 
ON A.VendorID = B.BusinessEntityID

WHERE YEAR(A.OrderDate) >= '2013' AND 
      A.TotalDue > '500'

--Exercise 2
SELECT
       A.PurchaseOrderID,
       A.OrderDate,
       A.TotalDue,
       VendorName = B.Name,
       PrevOrderFromVendorAmt = LAG(A.TotalDue,1) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader AS A
JOIN AdventureWorks2019.Purchasing.Vendor AS B 
ON A.VendorID = B.BusinessEntityID

WHERE YEAR(A.OrderDate) >= '2013' AND 
      A.TotalDue > '500'
ORDER BY 
  A.VendorID,
  A.OrderDate

--Exercise 3
SELECT
       A.PurchaseOrderID,
       A.OrderDate,
       A.TotalDue,
       VendorName = B.Name,
       PrevOrderFromVendorAmt = LAG(A.TotalDue,1) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate),
       NextOrderByEmployeeVendor = LEAD(B.Name) OVER(PARTITION BY A.EmployeeID ORDER By A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader AS A
JOIN AdventureWorks2019.Purchasing.Vendor AS B 
ON A.VendorID = B.BusinessEntityID

WHERE YEAR(A.OrderDate) >= '2013' AND 
      A.TotalDue > '500'
ORDER BY 
  A.EmployeeID,
  A.OrderDate

--Exercise 4
SELECT
       A.PurchaseOrderID,
       A.OrderDate,
       A.TotalDue,
       VendorName = B.Name,
       PrevOrderFromVendorAmt = LAG(A.TotalDue,1) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate),
       NextOrderByEmployeeVendor = LEAD(B.Name) OVER(PARTITION BY A.EmployeeID ORDER By A.OrderDate),
       Next2OrderByEmployeeVendor = LEAD(B.Name,2) OVER(PARTITION BY A.EmployeeID ORDER By A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader AS A
JOIN AdventureWorks2019.Purchasing.Vendor AS B 
ON A.VendorID = B.BusinessEntityID

WHERE YEAR(A.OrderDate) >= '2013' AND 
      A.TotalDue > '500'
ORDER BY 
  A.EmployeeID,
  A.OrderDate


