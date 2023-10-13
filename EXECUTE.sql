/*pa_ModificarRazonSocialProveedor: Modificar el nombre del proveedor dependiendo a su ID en caso la 
raz�n social pase a un cambio. Se visualizar� el nombre anterior y el nombre actual de dicho proveedor*/

SELECT * FROM PROVEEDOR
GO

EXECUTE pa_ModificarRazonSocialProveedor 'PV002', 'Tools Mike';






























/*pa_ProductosRecibidos: Consulta de art�culos recibidos en determinada fecha por un 
proveedor espec�fico, los cuales ser�n recibidos �nicamente por el almacenero.*/


EXECUTE pa_ListaProductosRecibidos '2023-02-01', 'PV002' 




















/*pa_ListaItemsProximosAgotarse: Ingreso de un n�mero para obtener los �tems con stock menor o igual a 
cierto n�mero para generar un reporte de �tems que est�n prontos a agotarse*/


EXECUTE pa_ListaDeItemsProximosAgotarse 10











/*pa_ObtenerSalidasMecanico: Consulta la informaci�n de salidas hechas por �nicamente el tipo 
de personal mec�nico para una m�quina en espec�fco.*/


EXECUTE pa_ListaSalidasMecanico 'P002', 'M001'
go







/*pa_ListaMovimientoItems: Movimientos de �tems en un rango de fechas con el stock dentro del rango de fechas ingresadas.*/

EXECUTE pa_ListaMovimientoItems '20230103', '20230903'