/*pa_ModificarRazonSocialProveedor: Modificar el nombre del proveedor dependiendo a su ID en caso la 
razón social pase a un cambio. Se visualizará el nombre anterior y el nombre actual de dicho proveedor*/

SELECT * FROM PROVEEDOR
GO

EXECUTE pa_ModificarRazonSocialProveedor 'PV002', 'Tools Mike';






























/*pa_ProductosRecibidos: Consulta de artículos recibidos en determinada fecha por un 
proveedor específico, los cuales serán recibidos únicamente por el almacenero.*/


EXECUTE pa_ListaProductosRecibidos '2023-02-01', 'PV002' 




















/*pa_ListaItemsProximosAgotarse: Ingreso de un número para obtener los ítems con stock menor o igual a 
cierto número para generar un reporte de ítems que están prontos a agotarse*/


EXECUTE pa_ListaDeItemsProximosAgotarse 10











/*pa_ObtenerSalidasMecanico: Consulta la información de salidas hechas por únicamente el tipo 
de personal mecánico para una máquina en específco.*/


EXECUTE pa_ListaSalidasMecanico 'P002', 'M001'
go







/*pa_ListaMovimientoItems: Movimientos de ítems en un rango de fechas con el stock dentro del rango de fechas ingresadas.*/

EXECUTE pa_ListaMovimientoItems '20230103', '20230903'