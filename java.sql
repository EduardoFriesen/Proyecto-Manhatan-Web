SELECT * FROM BD1_2022.tabla;

#Modifica el valor de la comlumna texto para la primera fila (id=1)
UPDATE tabla SET texto='A' WHERE ID=1 OR ID=5;

#Operadores de comparacion
# = igual
# <> distinto
# <= menor o igual
# >= mayor o igual
# < menor
# > mayor

#Operadores Logicos
# AND 
# OR
# NOT

DELETE FROM tabla  WHERE id>=4;

SELECT * FROM clientes WHERE idzona=5;

SELECT clientes, idzona, idcliente*10 AS idcliente_nuevo FROM clientes WHERE idzona=5;
SELECT 1+1,now,user();

SELECT * FROM zonas;

SELECT * FROM clientes;

SELECT c.cliente, z.zona from clientes c, zonas z 
WHERE c.idZona=z.idZona;

SELECT p.producto, p.precio, r.rubro, pr.proveedor 
FROM productos p, rubros r, proveedores pr
WHERE p.idRubro=r.idRubro AND p.idProveedor=pr.idProveedor
	AND p.precio>=200 AND p.precio<=300
ORDER BY r.rubro, p.precio DESC;

#1.Clientes inhabilitados, ordenados alfabéticamente [Cliente, Zona]

SELECT c.cliente, z.zona
FROM clientes c, zonas z
WHERE c.cuentaHabilitada=0
AND c.idZona=z.idZona
ORDER BY c.cliente; 

#2.Zonas cuyo nombre contenga el digito 9, ordenadas alfabéticamente descendente. [Zona]

SELECT z.zona
FROM zonas z
WHERE z.zona LIKE '%9%'
ORDER BY z.zona;

#3.Clientes cuyo nombre termine con el digito 7. [Cliente, Zona]

SELECT c.cliente, z.zona
FROM clientes c, zonas z
WHERE c.idZona=z.idZona LIKE '7%';

#4.Productos en cuyo nombre se encuentre el digito 3, en cualquier parte. [Producto]

SELECT p.Producto
FROM productos p
WHERE p.Producto LIKE '%3%';

#5.Facturas anuladas en el año 2006, ordenadas por fecha [Nº de Factura, Fecha, Cliente, Zona, Vendedor]

SELECT 
    fc.numero, fc.fecha, c.cliente, z.zona, v.vendedor
FROM
	facturacabecera fc,
    clientes c,
    zonas z,
    vendedores v
WHERE
    fc.idCliente = c.idCliente
        AND c.idZona = z.idZona
        AND fc.idVendedor = v.idVendedor
        AND fc.anulada = 1
        #AND fc.fecha>='2008-01-01' AND fc.fecha<='2008-12-31'
        #AND dc.fecha between '2008-01-01' AND '2008-12-31'
        AND YEAR(fc.fecha) = 2008;
        
SELECT * FROM productos ORDER BY precio DESC LIMIT 1; 
#LIMIT limita la cantidad de filas. Cuando pongo 2 numeros ej(LIMIT 2,2) muestra desde y cuantos

#count cuenta filas
#sum trabaja con valores numericos
#avg trabaja con valores numericos
#min trabaja con valores numericos
#max trabaja con valores numericos

SELECT COUNT(*) FROM clientes;# * contame todo
SELECT COUNT(idCliente) FROM clientes;# con COUNT("Nombre de columna") no cuenta los valores nulos
SELECT COUNT(distinct idZonas) FROM clientes;# con COUNT(distinct idZonas) cuentas los valores diferentes

SELECT SUM(precio) FROM productos;
SELECT SUM(precio*0.1) FROM productos;# suma el 10% del valor

SELECT AVG(precio) FROM productos;# promedio de precios

SELECT MIN(precio) FROM productos;# minimo de precios
SELECT MAX(precio) FROM productos;# maximo precio 
SELECT MIN(fecha) FROM facturacabecera;# minimo de fechas
SELECT MAX(fecha) FROM facturacabecera;# maximo de fechas

SELECT * FROM (SELECT * FROM clientes) variable; #cuando hacemos SELECT anidado debemos darle un nombre en este caso variable
SELECT producto,precio, (SELECT MAX(precio*0.9) FROM productos) FROM productos
WHERE precio > (SELECT max(precio*0.9) FROM productos);

#Los 4 Vendedores que tengan mayor comisión. [Vendedor, comisión]

SELECT * FROM vendedores ORDER BY comision DESC LIMIT 4; 

#Lista de precios conteniendo 4 columnas: 1) precio base, 2) precio base + 10%, 3) precio base + 30%, 4) precio base + 40%.
#La lista debe estar ordenada por rubro y producto. [Rubro, Producto, PrecioBase, PrecioMayorista, PrecioConDescuento, PrecioPublico]

SELECT r.Rubro, p.Producto, p.precio PrecioBase,
p.precio + (p.precio*0.10) PrecioMayorista,
p.precio + (p.precio*0.30) PrecioConDescuento,
p.precio + (p.precio*0.40) PrecioPublico
from rubros r, productos p
WHERE r.idRubro=p.idRubro ORDER BY Producto DESC;

#8.Lista de los 8 Productos más caros, ordenados alfabéticamente [Producto, Proveedor, Rubro, Precio]

SELECT * FROM
    (SELECT 
        p.producto, p.precio, r.Rubro, pr.Proveedor
    FROM
        productos p, rubros r, proveedores pr
    WHERE
        p.idRubro = r.idRubro
            AND p.idProveedor = pr.idProveedor
    ORDER BY precio DESC
    LIMIT 8) a
ORDER BY a.Producto DESC;

#9.Lista de Productos de los Rubros 2,5,8,16 y 18 con un 15% de aumento, ordenados alfabéticamente [Producto, Proveedor, Rubro, Precio con un 15%]

SELECT 
    *
FROM
    (SELECT 
        p.producto,
            pr.Proveedor,
            r.Rubro,
            p.precio,
            p.precio + (p.precio * 0.15) precioAumentado
    FROM
        productos p, proveedores pr, rubros r
    WHERE
        r.idRubro = p.idRubro
            AND p.idProveedor = pr.idProveedor
            AND (p.idRubro = 2 OR p.idRubro = 5
            OR p.idRubro = 8
            OR p.idRubro = 16
            OR p.idRubro = 18)) a
ORDER BY a.Producto DESC;

select distinct idZona from clientes; #
select distinct year(fecha) from facturacabecera; #muestra los valores diferentes


#10.Lista de los productos cuyo precio supere el promedio de precio de todos los productos. [Producto, Precio]

SELECT 
p.Producto, p.precio
FROM
    productos p
WHERE
    p.precio > (SELECT 
            AVG(precio)
        FROM
            productos);

#productos que nunca se vendieron en junio 2008

SELECT 
    *
FROM
    productos
WHERE
    idProducto NOT IN (SELECT DISTINCT
            fd.idProducto
        FROM
            facturacabecera fc,
            facturadetalle fd
        WHERE
            fc.idFactura = fd.idFactura
                AND fc.anulada = 0
                AND YEAR(fc.fecha) = 2008
                AND MONTH(fc.fecha) = 6);
                
SELECT 
    *
FROM
    productos
WHERE
    idProducto NOT IN (SELECT DISTINCT
            fd.idProducto
        FROM
            facturacabecera fc
                INNER JOIN
            facturadetalle fd ON fc.idFactura = fd.idFactura
        WHERE
            fc.anulada = 0
				AND YEAR(fc.fecha) = 2008
                AND MONTH(fc.fecha) = 6);
                
#11.Cantidad de clientes con la cuenta habilitada. [Cantidad]

SELECT COUNT(*) FROM clientes where clientes.cuentaHabilitada = 1;

#12.Proveedores que nunca proveyeron Productos, ordenados alfabéticamente [Proveedor]

SELECT 
    Proveedor
FROM
    proveedores
WHERE
    idProveedor NOT IN (SELECT
            pr.idProveedor
        FROM
            proveedores pr
                INNER JOIN
            productos p ON p.idProveedor = pr.idProveedor);

#13.Cantidad de Productos por Rubro y precio promedio, ordenados alfabéticamente [Rubro, Cantidad de Productos, Precio Promedio]

SELECT 
    idRubro, COUNT(*), AVG(precio)
FROM
    productos p
GROUP BY idRubro ORDER BY idRubro;

#14.Todas las Facturas emitidas en el 1er Trimestre año 2006, ordenadas alfabéticamente [Nº de Factura, Fecha, Cliente, Vendedor, Total]

SELECT year(fc.fecha), fc.numero, fc.fecha, c.Cliente, v.Vendedor, (fd.cantidad * p.precio) total
FROM facturacabecera fc INNER JOIN facturadetalle fd
	ON fc.idFactura=fd.idFactura INNER JOIN productos p
	ON fd.idProducto = p.idProducto INNER JOIN vendedores v
    ON fc.idVendedor = v.idVendedor INNER JOIN clientes c 
    ON fc.idCliente = c.idCliente
WHERE fc.anulada=0
AND YEAR(fc.fecha) = 2008
ORDER BY fc.numero;

#15.Detalle de la Factura 12, ordenada por Producto [Nº de Factura, Fecha, Cliente, Vendedor, Rubro, Proveedor, Producto, Cantidad, Precio, Subtotal]

SELECT 
    SUM(subtotal)
FROM
    (SELECT 
        fc.numero,
            fc.fecha,
            c.cliente,
            v.vendedor,
            r.rubro,
            pr.proveedor,
            p.producto,
            fd.cantidad,
            p.precio,
            fd.cantidad * p.precio AS subtotal
    FROM
        facturacabecera fc
    INNER JOIN facturadetalle fd ON fc.idFactura = fd.idFactura
    INNER JOIN clientes c ON fc.idCliente = c.idCliente
    INNER JOIN vendedores v ON fc.idVendedor = v.idVendedor
    INNER JOIN productos p ON fd.idProducto = p.idProducto
    INNER JOIN rubros r ON p.idRubro = r.idRubro
    INNER JOIN proveedores pr ON p.idProveedor = pr.idProveedor
    WHERE
        fc.numero = 12) a;
        
#16.Importe Total facturado por Cliente hasta el 06/03/2014, ordenado por importe descendente [Cliente, Importe facturado]

    
#AGRUPACION 

SELECT 
    idRubro, COUNT(*), AVG(precio), MIN(precio), MAX(precio), group_concat(precio)
FROM
    productos
GROUP BY idRubro;

SELECT year(fc.fecha), sum(fd.cantidad * p.precio) total
FROM facturacabecera fc INNER JOIN facturadetalle fd
	ON fc.idFactura=fd.idFactura INNER JOIN productos p
	ON fd.idProducto = p.idProducto
WHERE fc.anulada=0
GROUP BY YEAR(fc.fecha);








    








