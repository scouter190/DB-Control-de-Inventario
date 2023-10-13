--<<<<<<<<<<<<<CONSULTAS // PROCEDIMENTOS>>>>>>>>>>>>>>>

/*pa_ModificarRazonSocialProveedor: Modificar el nombre del proveedor dependiendo a su ID en caso la 
razón social pase a un cambio. Se visualizará el nombre anterior y el nombre actual de dicho proveedor*/

SELECT * FROM PROVEEDOR
GO

IF OBJECT_ID('pa_ModificarRazonSocialProveedor') IS NOT NULL
    DROP PROCEDURE pa_ModificarRazonSocialProveedor;
GO

CREATE PROCEDURE pa_ModificarRazonSocialProveedor
    @idProveedor CHAR(5),
    @nuevaRazonS VARCHAR(29)
AS
BEGIN
    DECLARE @razonSocialAnterior VARCHAR(29);

    SELECT @razonSocialAnterior = razonSocial
    FROM PROVEEDOR
    WHERE idProveedor = @idProveedor;

    IF @razonSocialAnterior IS NOT NULL
    BEGIN
        UPDATE PROVEEDOR
        SET razonSocial = @nuevaRazonS
        WHERE idProveedor = @idProveedor;

        IF @@ROWCOUNT > 0											 -- número de filas afectadas por la última instrucción SQL
        BEGIN
            PRINT 'Se ha modificado la razón social del proveedor:';
            PRINT 'ID Proveedor: ' + @idProveedor;
            PRINT 'Razón Social anterior: ' + @razonSocialAnterior;
            PRINT 'Nueva Razón Social: ' + @nuevaRazonS;
        END
        ELSE
            PRINT 'No se realizó ninguna modificación.';
    END
    ELSE
        PRINT 'No se encontró ningún proveedor con el ID especificado.';
END;
GO

EXECUTE pa_ModificarRazonSocialProveedor 'PV002', 'Kiola Designs';


/*pa_ProductosRecibidos: Consulta de artículos recibidos en determinada fecha por un 
proveedor específico, los cuales serán recibidos únicamente por el almacenero.*/


IF OBJECT_ID('pa_ListaProductosRecibidos') IS NOT NULL
	DROP PROC pa_ListaProductosRecibidos 
GO

CREATE PROCEDURE pa_ListaProductosRecibidos
(
    @fecha DATE,
    @idProveedor CHAR(5)
)
AS
BEGIN
    SELECT P.nombrePer AS ALMACENERO,I.nomItem AS PRODUCTO_RECIBIDO, I.descripcion AS DESCRIPCIÓN, @fecha AS FECHA, PR.razonSocial AS PROVEEDOR, 
	 PII.cantIngreso AS CANTIDAD_INGRESADA
		FROM PERSONAL P
		INNER JOIN PARTE_DE_INGRESO PI ON P.idPersonal = PI.idPersonal
		INNER JOIN PROVEEDOR PR ON PI.idProveedor = PR.idProveedor
		INNER JOIN PARTE_INGRESO_ITEM PII ON PI.nroParteI = PII.nroParteI
		INNER JOIN ITEM I ON PII.idItem = I.idItem 
		INNER JOIN TIPO_PERSONAL TP ON P.idTipo= TP.idTipo
			WHERE PI.FechaI = @fecha AND PR.idProveedor = @idProveedor AND TP.idTipo= 'T02'
END
GO

EXECUTE pa_ListaProductosRecibidos '2023-02-01', 'PV002' 


/*pa_ListaItemsProximosAgotarse: Ingreso de un número para obtener los ítems con stock menor o igual a 
cierto número para generar un reporte de ítems que están prontos a agotarse*/

IF OBJECT_ID('pa_ListaDeItemsProximosAgotarse') IS NOT NULL
    DROP PROCEDURE pa_ListaDeItemsProximosAgotarse;

GO
CREATE PROCEDURE pa_ListaDeItemsProximosAgotarse
    @num INT
AS
    SELECT CI.nombreCate AS CATEGORIA, I.idItem AS ID_ITEM, I.nomItem AS NOMBRE, I.descripcion AS DESCRIPCIÓN, PRO.razonSocial AS PROVEEDOR, I.stock AS STOCK_INICIAL,
           (SELECT SUM(cantIngreso) FROM PARTE_INGRESO_ITEM WHERE idItem = I.idItem) AS 'INGRESO TOTAL',
           (SELECT SUM(cantSalida) FROM PARTE_SALIDA_ITEM WHERE idItem = I.idItem) AS 'TOTAL SALIDA',
            I.stock + (SELECT SUM(cantIngreso) FROM PARTE_INGRESO_ITEM WHERE idItem = I.idItem)
                   - (SELECT SUM(cantSalida) FROM PARTE_SALIDA_ITEM WHERE idItem = I.idItem) AS 'STOCK ACTUAL'
    FROM ITEM I
    INNER JOIN CATEGORIA_ITEM CI ON I.idCategoria = CI.idCategoria
    INNER JOIN PARTE_DE_INGRESO PDI ON PDI.nroParteI = (SELECT nroParteI FROM PARTE_INGRESO_ITEM WHERE idItem = I.idItem)
    INNER JOIN PROVEEDOR PRO ON PRO.idProveedor = PDI.idProveedor
    GROUP BY CI.nombreCate, I.idItem, I.nomItem, I.descripcion, PRO.razonSocial, I.stock
    HAVING CI.nombreCate= 'Consumibles' AND (I.stock + (SELECT SUM(cantIngreso) FROM PARTE_INGRESO_ITEM WHERE idItem = I.idItem)
                    - (SELECT SUM(cantSalida) FROM PARTE_SALIDA_ITEM WHERE idItem = I.idItem)) <= @num 
GO

EXECUTE pa_ListaDeItemsProximosAgotarse 10


/*pa_ObtenerSalidasMecanico: Consulta la información de salidas hechas por únicamente el tipo 
de personal mecánico para una máquina en específco.*/

IF OBJECT_ID('pa_ListaSalidasMecanico') IS NOT NULL
	DROP PROC pa_ListaSalidasMecanico 
GO
CREATE PROCEDURE pa_ListaSalidasMecanico(
    @idMecanico CHAR(4),
    @idMaquina CHAR(4)
)
AS
BEGIN
    
    SELECT PS.nroParteS AS 'NRO PARTE', PS.FechaS AS FECHA, P.nombrePer AS PERSONAL , M.nombreMaq AS MAQUINA, PI.cantSalida AS CANTIDAD , I.nomItem AS ITEM
    FROM PARTE_SALIDA PS
    INNER JOIN PARTE_SALIDA_ITEM PI ON PS.nroParteS = PI.nroParteS
    INNER JOIN ITEM I ON PI.idItem = I.idItem 
	INNER JOIN PERSONAL P ON P.idPersonal = PS.idPersonal
	INNER JOIN MAQUINARIA M ON M.idMaquina = PS.idMaquina 
	INNER JOIN TIPO_PERSONAL TP ON P.idTipo= TP.idTipo
    WHERE PS.idPersonal = @idMecanico AND PS.idMaquina = @idMaquina AND TP.idTipo= 'T40'
END
GO
EXECUTE pa_ListaSalidasMecanico 'P002', 'M001'
go


/*pa_ListaMovimientoItems: Movimientos de ítems en un rango de fechas con el stock dentro del rango de fechas ingresadas.*/

IF OBJECT_ID('pa_ListaMovimientoItems') IS NOT NULL
	DROP PROC pa_ListaMovimientoItems 
GO
CREATE PROCEDURE pa_ListaMovimientoItems
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN

    SELECT I.idItem AS ID_ITEM, I.nomItem AS NOMBRE, PI.nroParteI AS PARTE_INGRESO, PI.FechaI AS FECHA_INGRESO, PS.nroParteS  AS PARTE_SALIDA,  PS.FechaS AS FECHA, PII.cantIngreso AS CANTIDAD_INGRESO,
	I.stock  AS STOCK_INICIAL, PSI.cantSalida AS CANTIDAD_SALIDAS, I.stock + SUM(PII.cantIngreso) - SUM(PSI.cantSalida) AS STOCK_DISPONIBLE
    FROM ITEM I
    INNER JOIN PARTE_INGRESO_ITEM PII ON I.idItem = PII.idItem
    INNER JOIN PARTE_DE_INGRESO PI ON PII.nroParteI = PI.nroParteI
                                   AND PI.FechaI BETWEEN @FechaInicio AND @FechaFin
    INNER JOIN PARTE_SALIDA_ITEM PSI ON I.idItem = PSI.idItem
    INNER JOIN PARTE_SALIDA PS ON PSI.nroParteS = PS.nroParteS
                                AND PS.FechaS BETWEEN @FechaInicio AND @FechaFin
    GROUP BY  I.idItem, I.nomItem, PI.nroParteI ,PI.FechaI, PS.nroParteS,PS.FechaS, PII.cantIngreso, I.stock, PSI.cantSalida
    ORDER BY stock_disponible ASC;
END
GO

EXECUTE pa_ListaMovimientoItems '20230103', '20230903'