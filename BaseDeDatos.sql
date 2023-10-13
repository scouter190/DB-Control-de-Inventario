USE MASTER 
GO

IF DB_ID ('BD_INVENTARIO_TRANSPORTES_CEDAR') IS NOT NULL
DROP DATABASE BD_INVENTARIO_TRANSPORTES_CEDAR
GO 

CREATE DATABASE BD_INVENTARIO_TRANSPORTES_CEDAR
GO

USE BD_INVENTARIO_TRANSPORTES_CEDAR 
GO 

IF OBJECT_ID ('TIPO_PERSONAL') IS NOT NULL 
	DROP TABLE TIPO_PERSONAL
GO

CREATE TABLE TIPO_PERSONAL (

	idTipo	CHAR(3) PRIMARY KEY CHECK(idTipo LIKE 'T[0-9][0-9]'),
	nomTipo VARCHAR(20) NOT NULL,
)
GO

IF OBJECT_ID ('PERSONAL') IS NOT NULL 
	DROP TABLE PERSONAL
GO

CREATE TABLE PERSONAL(

	idPersonal		CHAR(4)		PRIMARY KEY CHECK(idPersonal LIKE 'P[0-9][0-9][0-9]'),
	idTipo			CHAR(3)		FOREIGN KEY REFERENCES TIPO_PERSONAL,
	dni				CHAR (8)	UNIQUE,
	nombrePer		VARCHAR(20) NOT NULL,
	ApellidosPer	VARCHAR(20)	NOT NULL,
	sexo			CHAR(1)		NOT NULL  CHECK(sexo IN ('M','F')),
	fechaNac		DATE		NOT NULL,
	telefono		CHAR(9)

)
GO

IF OBJECT_ID ('PROVEEDOR') IS NOT NULL 
	DROP TABLE PROVEEDOR
GO

CREATE TABLE PROVEEDOR(
	
	idProveedor		CHAR(5) PRIMARY KEY CHECK(idProveedor LIKE 'PV[0-9][0-9][0-9]'),
	ruc				CHAR(11)	NOT NULL,
	razonSocial		VARCHAR(29)	NOT NULL
)
GO


IF OBJECT_ID ('PARTE_DE_INGRESO') IS NOT NULL 
	DROP TABLE PARTE_DE_INGRESO
GO

CREATE TABLE PARTE_DE_INGRESO(
	nroParteI CHAR(6) PRIMARY KEY CHECK(nroParteI LIKE 'E[0-9][0-9][0-9][0-9][0-9]'),
	FechaI		DATE	NOT NULL,
	idProveedor	CHAR(5) FOREIGN KEY REFERENCES PROVEEDOR,
	idPersonal	CHAR(4) FOREIGN KEY REFERENCES PERSONAL
)
GO


IF OBJECT_ID ('ANAQUEL') IS NOT NULL 
	DROP TABLE ANAQUEL
GO

CREATE TABLE ANAQUEL(

	idAnaquel CHAR(4) PRIMARY KEY CHECK(idAnaquel LIKE 'A[0-9][0-9][0-9]')

)
GO
IF OBJECT_ID ('UNIDAD_MEDIDA') IS NOT NULL 
	DROP TABLE UNIDAD_MEDIDA
GO

CREATE TABLE UNIDAD_MEDIDA(
	idUniMedida CHAR(4)		PRIMARY KEY CHECK(idUniMedida LIKE 'U[0-9][0-9][0-9]'),
	nomUniMedida VARCHAR(30)NOT NULL
)
GO
IF OBJECT_ID ('CATEGORIA_ITEM') IS NOT NULL 
	DROP TABLE CATEGORIA_ITEM
GO

CREATE TABLE CATEGORIA_ITEM(
	idCategoria CHAR (4)   PRIMARY KEY CHECK(idCategoria LIKE 'C[0-9][0-9][0-9]'),
	nombreCate VARCHAR(20) NOT NULL
)
GO
IF OBJECT_ID ('ITEM') IS NOT NULL 
	DROP TABLE ITEM
GO

CREATE TABLE ITEM(

	idItem			CHAR(4)		PRIMARY KEY CHECK(idItem LIKE 'I[0-9][0-9][0-9]'),
	nomItem			VARCHAR(50)	NOT NULL,
	descripcion		VARCHAR(100)NOT NULL,
	stock			INT			NOT NULL,
	idUniMedida		CHAR(4)		FOREIGN KEY REFERENCES UNIDAD_MEDIDA,
	idAnaquel		CHAR(4)		FOREIGN KEY REFERENCES ANAQUEL,
	idCategoria		CHAR(4)		FOREIGN KEY REFERENCES CATEGORIA_ITEM
	
)
GO


IF OBJECT_ID ('PARTE_INGRESO_ITEM') IS NOT NULL 
	DROP TABLE PARTE_INGRESO_ITEM
GO

CREATE TABLE PARTE_INGRESO_ITEM(
	
	nroParteI		CHAR(6) FOREIGN KEY REFERENCES PARTE_DE_INGRESO,
	idItem			CHAR(4) FOREIGN KEY REFERENCES ITEM,
	cantIngreso		INT		NOT NULL,
	PRIMARY KEY(nroParteI,idItem)
)
GO


IF OBJECT_ID ('MAQUINARIA') IS NOT NULL 
	DROP TABLE MAQUINARIA
GO

CREATE TABLE MAQUINARIA(

	idMaquina			CHAR(4)		PRIMARY KEY CHECK(idMaquina LIKE 'M[0-9][0-9][0-9]'),
	nombreMaq			VARCHAR(20)	NOT NULL,
	Estado				CHAR(1)		NOT NULL CHECK(Estado IN ('A','M','D')),
	kilometrajeInicial	INT			NOT NULL
)
GO



IF OBJECT_ID ('PARTE_SALIDA') IS NOT NULL 
	DROP TABLE PARTE_SALIDA
GO

CREATE TABLE PARTE_SALIDA(

	nroParteS CHAR(6) PRIMARY KEY CHECK(nroParteS LIKE 'S[0-9][0-9][0-9][0-9][0-9]'),
	FechaS		DATE	NOT NULL,
	idPersonal	CHAR(4)	FOREIGN KEY REFERENCES PERSONAL,
	idMaquina	CHAR(4) FOREIGN KEY REFERENCES MAQUINARIA
)
GO


IF OBJECT_ID ('PARTE_SALIDA_ITEM') IS NOT NULL 
	DROP TABLE PARTE_SALIDA_ITEM
GO

CREATE TABLE PARTE_SALIDA_ITEM(
	
	nroParteS	CHAR(6) FOREIGN KEY REFERENCES PARTE_SALIDA,
	idItem		CHAR(4)	FOREIGN KEY REFERENCES ITEM,
	cantSalida	INT	NOT NULL,
	PRIMARY KEY(nroParteS,idItem)
)
GO




--REGISTROS--

INSERT INTO TIPO_PERSONAL VALUES ('T02','Almacenero'),
								 ('T40','Mecanico')
GO

SELECT * FROM TIPO_PERSONAL

INSERT INTO PERSONAL VALUES	('P001', 'T02', '12345678', 'Juan', 'Pérez', 'M', '1990-01-01', '923456789'),
							('P002', 'T40', '23456789', 'María', 'López', 'F', '1992-03-15', '934507890'),
							('P003', 'T02', '34567890', 'Carlos', 'González', 'M', '1988-06-20', '945008901'),
							('P004', 'T02','45678901', 'Laura', 'Rodríguez', 'F', '1995-09-10', '956339012'),
							('P005', 'T40','56789012', 'Luis', 'Martínez', 'M', '1991-12-05', '967890123'),
							('P006', 'T02','12348678', 'Maurio', 'Gómez', 'M', '1990-06-15', '987654321'),
							('P007', 'T40','88254321', 'Kristel', 'López', 'F', '1995-09-22', '923975789'),
							('P008', 'T02','23424379', 'Pedro', 'Sánchez', 'M', '1988-04-10', '944654321'),
							('P009', 'T40','07765432', 'Mercedes', 'Fernández', 'F', '1992-12-01', '929786789'),
							('P010', 'T02','19267890', 'Tito', 'Martínez', 'M', '1997-07-18', '987659551')
GO

select*from personal
delete from proveedor

INSERT INTO PROVEEDOR VALUES ('PV001', '12345678901', 'Herramex'),
							 ('PV002', '23423259012', 'ToolMaster'),
							 ('PV003', '34567890123', 'ProHerra'),
							 ('PV004', '76978901234', 'MegaTools'),
							 ('PV005', '56789012345', 'PowerTech Supplies'),
							 ('PV006', '99545678901', 'PrimeTool Solutions'),
							 ('PV007', '98765432209', 'ToolZone Distributors'),
							 ('PV008', '23419889012', 'ProCraft'),
							 ('PV009', '96674321098', 'ToolTech Industries'),
							 ('PV010', '30067890123', 'PrecisionTool')


GO

Select * from proveedor

INSERT INTO PARTE_DE_INGRESO VALUES ('E00001', '2023-01-01', 'PV001', 'P001'),
									('E00002', '2023-02-01', 'PV002', 'P010'),
									('E00003', '2023-03-01', 'PV003', 'P003'),
									('E00004', '2023-04-01', 'PV004', 'P003'),
									('E00005', '2023-05-01', 'PV005', 'P001'),
									('E00006', '2023-06-01', 'PV006', 'P001'),
									('E00007', '2023-06-02', 'PV007', 'P010'),
									('E00008', '2023-06-03', 'PV008', 'P008'),
									('E00009', '2023-06-04', 'PV009', 'P001'),
									('E00010', '2023-06-05', 'PV010', 'P010')
GO

select * from parte_de_ingreso

INSERT INTO ANAQUEL VALUES  ('A001'),
							('A002'),
							('A003'),
							('A004'),
							('A005'),
							('A006'),
							('A007'),
							('A008'),
							('A009'),
							('A010')
GO
Select * from anaquel

INSERT INTO  UNIDAD_MEDIDA VALUES  ('U001', 'Unidad'),
								   ('U002', 'Kilogramo'),
								   ('U003', 'Metro'),
								   ('U004', 'Litros'),
								   ('U005', 'Caja'),
								   ('U006', 'Centímetro')
								   
GO

select *from unidad_medida

INSERT INTO CATEGORIA_ITEM VALUES   ('C001', 'Electrónicos'),
								    ('C002', 'Consumibles'),
								    ('C003', 'Herramientas'),
								    ('C004', 'Medibles'),
								    ('C005', 'Repuestos'),
									('C006', 'EPP')

								
								    
GO

select*from CATEGORIA_ITEM
select*from item


INSERT INTO ITEM VALUES ('I301', 'Llave ajustable', 'Llave Universal Wrench Acero Herramienta Tuercas',10,'U001','A001', 'C003'),
						('I402', 'Taladro', 'Taladro percutor atornillador eléctrico de 13mm Makita HP1630K 710W',5,'U001', 'A002', 'C001'),
						('I023', 'Gato hidráulico', 'Gato Lagarto Hidráulica Pesada 3 Tn Doble Pistón Taller Uyus',12, 'U001', 'A003', 'C003'),
				   	    ('I504', 'Válvula piloto', 'Válvula Piloto Komatsu', 20,'U001', 'A004', 'C005'),
						('I755', 'Compresor de aire', 'Compresor de aire eléctrico Truper COMP-50LT monofásico 50L 2.5hp 127V 60Hz',3, 'U001', 'A005', 'C003'),
						('I966', 'Aceite Compresor', 'Aceite De Compresor De Piston Ingersoll Rand All Season',5, 'U004', 'A006', 'C002'),
						('I237', 'Multímetro automotriz', 'Multimetro Digital Profesional Truper (automotriz) Mut-105',5, 'U001', 'A007', 'C003'),
						('I894', 'Llaves de impacto', 'DTW1001: LLAVE DE IMPACTO 3/4″ INALÁMBRICO 18V LXT BL MOTOR / 1050 Nm',23, 'U001', 'A008', 'C001'),
						('I284', 'Lija', 'Disco de Lija Seco Multi-Air Cyclonic A975',40, 'U001', 'A009', 'C003'),
						('I935', 'Barra de Silicona','BARRAS DE SILICONA 1KG 300 X 1.2 MM',50,'U001', 'A010', 'C002'),
						('I164', 'Higrómetros',' higrómetros sensores ópticos de espejo refrigerado',20,'U001', 'A010', 'C004'),
						('I234', 'Tapones auditivos', '3M™ Tapones Auditivos de Espuma 1110 con Cordón',10, 'U001', 'A005', 'C006'),
						('I754', 'Manguera', 'Manguera para recirculación de refrigerante hacia el radiador',27, 'U001', 'A004', 'C002'),
						('I463', 'Cubierta', 'Cubierta protectora de unidad de control',24, 'U001', 'A006', 'C002'),
						('I765', 'Kit de anillos para pistón', 'Set de anillos para pistón de motor',6, 'U005', 'A002', 'C002'),
						('I865', 'Grupo filtro aire primario y secundario ', 'Filtro aire primario y secundario Komatsu',27, 'U001', 'A001', 'C002'),
						('I954', 'Traje de protección', 'Traje de Protección Desechable 3M™ 4540',20, 'U001', 'A005', 'C005'),
						('I947', 'Filtros de combustible', 'Filtro de combustible Olimpic',30, 'U001', 'A002', 'C002'),
						('I246', 'Martillo hidráulico', 'Martillo JTHB Komatsu', 8,'U001', 'A010', 'C001'),
						('I738', 'Abrazadera', 'Abrazadera 6217-71-5761 Komatsu', 13,'U001', 'A003', 'C002'),
						('I748', 'Sello filtro aceite hidraulico', 'Filtro aceite hidráulico Komatsu',25, 'U001', 'A002', 'C002'),
						('I829', 'Aceite hidráulico', 'Martillo JTHB Komatsu',15, 'U004', 'A002', 'C003')
GO
Select * from item

INSERT INTO PARTE_INGRESO_ITEM VALUES   ('E00001', 'I284', 5),
										('E00002', 'I865', 10),
										('E00005', 'I246', 8),
										('E00004', 'I966', 15),
										('E00003', 'I748', 20),
										('E00006', 'I504', 5),
										('E00007', 'I765', 8),
										('E00008', 'I301', 10),
										('E00009', 'I947', 3),
										('E00010', 'I954', 6)
GO

select * from PARTE_INGRESO_ITEM

INSERT INTO MAQUINARIA VALUES   ('M001', 'Caterpillar D9', 'A', 10000),
								('M002', 'Komatsu PC200', 'M', 20000),
								('M003', 'Volvo EC210', 'M', 15000),
								('M004', 'Hitachi ZX350', 'A', 18000),
								('M005', 'Liebherr R950', 'M', 22000),
								('M006', 'John Deere 850', 'A', 500),
								('M007', 'Doosan DX225', 'M', 800),
								('M008', 'Case CX240', 'A', 250),
								('M009', 'JCB 3CX', 'D', 1200),
								('M010', 'Bobcat S650', 'A', 900)
GO
Select*from maquinaria

INSERT INTO PARTE_SALIDA VALUES ('S00001', '2023-01-05', 'P002', 'M001'),
								('S00002', '2023-02-10', 'P002', 'M002'),
								('S00003', '2023-03-15', 'P002', 'M003'),
								('S00004', '2023-04-20', 'P005', 'M004'),
								('S00005', '2023-05-25', 'P010', 'M005'),
								('S00006', '2023-06-06', 'P005', 'M006'),
								('S00007', '2023-06-07', 'P007', 'M007'),
								('S00008', '2023-06-08', 'P002', 'M008'),
								('S00009', '2023-06-09', 'P002', 'M009'),
								('S00010', '2023-06-10', 'P010', 'M010'),
								('S00011', '2023-10-05', 'P002', 'M001'),
								('S00012', '2023-12-10', 'P002', 'M002'),
								('S00013', '2023-07-25', 'P002', 'M003'),
								('S00014', '2023-04-12', 'P005', 'M004'),
								('S00015', '2023-06-30', 'P010', 'M005')
select * from  PARTE_SALIDA

INSERT INTO PARTE_SALIDA_ITEM VALUES	('S00001', 'I754', 2),
										('S00001', 'I865', 1),
										('S00002', 'I765', 4),
										('S00002', 'I246', 4),
										('S00002', 'I947', 2),
										('S00003', 'I234', 3),
										('S00003', 'I829', 1),
										('S00004', 'I865', 5),
										('S00004', 'I954', 1),
										('S00005', 'I246', 3),
										('S00005', 'I738', 2),
										('S00006', 'I829', 3),
										('S00006', 'I284', 8),
										('S00007', 'I748', 2),
										('S00008', 'I463', 3),
										('S00008', 'I246', 1),
										('S00008', 'I284', 5),
										('S00009', 'I954', 1),
										('S00010', 'I738', 2),
										('S00011', 'I765', 1),
										('S00015', 'I284', 6),
										('S00012', 'I246', 3),
										('S00014', 'I738', 2),
										('S00013', 'I829', 3)
GO

select*from PARTE_SALIDA_ITEM