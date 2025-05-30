/*PRACTICA 2
--PLANES DE EJECUCION
*/

--Crear las copias de las tablas 
create database practicaPE 
use practicaPE
--a
select * into order_hearder 
from AdventureWorks2022.Sales.SalesOrderHeader
--b
select * into order_detail
from AdventureWorks2022.Sales.SalesOrderDetail
--c
select CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate
into  customers
from AdventureWorks2022.Sales.Customer;
--e
select * into territory 
from AdventureWorks2022.Sales.SalesTerritory
--f 
select * into products 
from AdventureWorks2022.Production.Product
--g 
select * into products_category 
from AdventureWorks2022.Production.ProductCategory
--h 
select * into products_Sub_Category  
from AdventureWorks2022.Production.ProductSubcategory
--i
select  BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix,
       EmailPromotion, rowguid, ModifiedDate
into person
from AdventureWorks2022.Person.Person;



--listar el producto mas vendido de cada una de las categorias registradas en la base de datos:
SELECT 
    pc.Name AS Categoria,
    p.Name AS Producto,
    SUM(od.OrderQty) AS CantidadVendida
FROM order_detail od
JOIN products p ON od.ProductID = p.ProductID
JOIN products_Sub_Category psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN products_category pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.ProductCategoryID, pc.Name, p.ProductID, p.Name
HAVING SUM(od.OrderQty) = (
    SELECT MAX(VentasPorProducto.TotalVendido)
    FROM (
        SELECT 
            SUM(od2.OrderQty) AS TotalVendido
        FROM order_detail od2
        JOIN products p2 ON od2.ProductID = p2.ProductID
        JOIN products_Sub_Category psc2 ON p2.ProductSubcategoryID = psc2.ProductSubcategoryID
        WHERE psc2.ProductCategoryID = pc.ProductCategoryID
        GROUP BY od2.ProductID
    ) AS VentasPorProducto
);



--listar el nombre de los clientes con mas ordenes por cada uno de los territorios registrados en la base de datos
SELECT 
    t.Name AS Territorio,
    p.FirstName + ' ' + p.LastName AS Cliente,
    COUNT(oh.SalesOrderID) AS TotalOrdenes
FROM order_hearder oh
JOIN customers c ON oh.CustomerID = c.CustomerID
JOIN person p ON c.PersonID = p.BusinessEntityID
JOIN territory t ON c.TerritoryID = t.TerritoryID
GROUP BY c.TerritoryID, t.Name, c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(oh.SalesOrderID) = (
    SELECT MAX(OrdenesPorCliente.TotalOrdenes)
    FROM (
        SELECT COUNT(oh2.SalesOrderID) AS TotalOrdenes
        FROM order_hearder oh2
        JOIN customers c2 ON oh2.CustomerID = c2.CustomerID
        WHERE c2.TerritoryID = c.TerritoryID
        GROUP BY oh2.CustomerID
    ) AS OrdenesPorCliente
);

SELECT 
    t.Name AS Territorio,
    p.FirstName + ' ' + p.LastName AS Cliente,
    COUNT(oh.SalesOrderID) AS TotalOrdenes
FROM order_hearder oh
JOIN customers c ON oh.CustomerID = c.CustomerID
JOIN person p ON c.PersonID = p.BusinessEntityID
JOIN territory t ON c.TerritoryID = t.TerritoryID
GROUP BY c.TerritoryID, t.Name, c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(oh.SalesOrderID) = (
    SELECT MAX(OrdenesPorCliente.TotalOrdenes)
    FROM (
        SELECT COUNT(oh2.SalesOrderID) AS TotalOrdenes
        FROM order_hearder oh2
        JOIN customers c2 ON oh2.CustomerID = c2.CustomerID
        WHERE c2.TerritoryID = c.TerritoryID
        GROUP BY oh2.CustomerID
    ) AS OrdenesPorCliente
)
ORDER BY t.Name ASC, Cliente ASC;







--listar los datos generales de las ordenes que tengan al menos los mismos productos de la orden con salesorderid=43676

Select distinct salesorderid, ProductID, ModifiedDate, orderqty
From order_detail as od
Where not exists(
Select *
From (
	Select productid
	From order_detail
	Where salesorderid=43676 
	) as p
Where not exists(
	Select *
	From order_Detail as Od2
	Where(od.SalesOrderID = od2.SalesOrderID) AND (od2.ProductID = p.ProductID)	)
	)



	SELECT DISTINCT ProductID
	FROM order_detail
WHERE SalesOrderID = 43676;
