/*Crear la tabla dep (DEPARTAMENTO)*/
create table dep (
   cod_dep number(3),
   nombre varchar2(15) not null,
   loc varchar2(10),
   constraint dep_pk primary key (cod_dep),
   constraint dep_loc check 
              (loc in ('Valladolid', 'Boecillo', 'Cigales'))
);

/*Crear la tabla emp (EMPLEADOS)*/
create table emp (
   cod_emp number(3),
   nombre varchar2(10) not null,
   oficio varchar2(11),
   jefe number(3),
   fecha_alta date,
   salario number(5),
   comision number(10),
   cod_dep number(3),
   constraint emp_pk primary key (cod_emp),
   constraint emp_fk foreign key (cod_dep) references dep(cod_dep)
              on delete cascade,
   constraint emp_ck check (salario > 0)
);

/* Insertar filas en la tabla dep (DEPARTAMENTO) */
insert into dep values (100,'Administracion','Valladolid');
insert into dep values (200,'I+D','Boecillo');
insert into dep values (300,'Produccion','Cigales')

/* Insertar filas en la tabla emp (EMPLEADOS) */

insert into emp values 
       (101,'Cano','Presidente',null,'3-FEB-96',45000,null,100);
insert into emp values
       (102,'Roncal','Director',101,'3-FEB-96',35000,null,100);
insert into emp values
       (103,'Rueda','Secretario',102,'17-MAR-96',1750,null,100);
insert into emp values
       (104,'Martin','Contable',102,'17-MAR-96',2350,null,100);
insert into emp values
       (105,'Sanz','Comercial',101,'17-MAR-96',1500,10,100);
insert into emp values
       (106,'Lopez','Comercial',101,'21-MAR-96',1500,15,100);
insert into emp values
       (201,'Perez','Director',101,'4-JUN-96',35000,null,200);
insert into emp values
       (202,'Sastre','Analista',201,'8-JUN-96',300000,null,200);
insert into emp values
       (203,'Garcia','Programador',202,'8-JUN-96',22500,null,200);
insert into emp values
       (204,'Mateo','Programador',202,'8-JUN-96',20000,null,200);
insert into emp values
       (301,'Yuste','Director',101,'3-OCT-96',35000,null,300);
insert into emp values
       (302,'Recio','Analista',301,'4-FEB-97',30000,null,300);
insert into emp values
       (303,'Garcia','Programador',302,'4-FEB-97',21000,null,300);
insert into emp values
       (304,'Santana','Programador',302,'4-FEB-97',20000,null,300);

/* Relizar modificaciones en la tabla emp (EMPLEADOS 301 los modificamos su salario 40000)*/

UPDATE emp
SET salario = 40000
WHERE cod_emp = 301; (no)

/* Relizar modificaciones en la tabla emp (EMPLEADOS 105 modificacion del salario y la comision)*/
UPDATE emp
SET salario = 1500, comision = 10  (si)
WHERE cod_emp = 105;

/* Quiero eliminar ah dos empleados (un programador (204) y un analista(302))dentro de la  tabla emp(EMPLEADOS) */
DELETE FROM emp
WHERE cod_emp = 204;

DELETE FROM emp
WHERE cod_emp = 302;

/* Relizar MERGE creando una tabla bonuses */
CREATE TABLE bonuses
( cod_emp number(3), 
bonus NUMBER(8,2) DEFAULT 0);

INSERT INTO bonuses(cod_emp)
(SELECT cod_emp FROM emp
WHERE salario > 100000);

MERGE INTO bonuses b
USING emp e
ON (b.cod_emp = e.cod_emp)
WHEN MATCHED THEN 
UPDATE SET b.bonus = e.salario * .05;       

/* Mostrar todas las  tabla que tenemos hasta hora creadas */
 select table_name from user_tables;

/* Creando un alias de columna*/
select nombre "Departamento", loc "Est� en" from dep;

/* Usando la cl�usula INTO */
/* Para ver el oficio de la persona seg�n el nombre que corresponde) */
SET SERVEROUTPUT ON;
DECLARE
v_emp_nombre emp.oficio%TYPE;
BEGIN
SELECT oficio
INTO v_emp_nombre
FROM emp
WHERE cod_emp = 104; 
DBMS_OUTPUT.PUT_LINE('Su Oficio es: ' || v_emp_nombre);
END;

/* Usando la cl�usula FRON */
/*se puede asociar un alias a las tablas para abreviar los nombres de las tabla*/
select d.nombre from dep d;

/* Usando la cl�usula ORDER BY*/
/* Para ordenaci�n es ascendente los nombre de los empleados con sus respectivos salarios */
select nombre, salario from emp order by salario desc, nombre;

/* Usando la cl�usula DISTINCT*/
/* Para eliminar las filas con los oficios duplicadas */
select oficio from emp;
select distinct oficio from emp;

/* Usando la cl�usula GROUP BY */
/* Para realizar un agrupamiento que actue sobre los diverso Oficios */
select count(nombre), oficio from emp group by oficio;

/* Extraer informacion de varias columnas*/
select oficio from emp;

/* Recupear datos mediante SELECT  */
SET SERVEROUTPUT ON;
DECLARE 
v_sum_salario NUMBER(5); 
v_deptno number(3) := 3; 
BEGIN
SELECT SUM(salario ) -- group function
INTO v_sum_salario FROM emp
WHERE cod_dep = v_deptno;
DBMS_OUTPUT.PUT_LINE('Dep #3 Salario Total: ' || v_sum_salario);
END;

/* Crear la tabla res (RESULTADO) */
/* Luego ejecuta un bloque PL / SQL� Determine qu� valor se inserta en RESULTADOS  */
CREATE TABLE res (num_rows NUMBER(4));
BEGIN
UPDATE copy_emp
SET salario = salario + 100
WHERE job_id = 'ST_CLERK';
INSERT INTO res (num_rows)
VALUES (SQL%ROWCOUNT);
END;
  
/*  INSERTAR el sigiuete valor en la tabla RESULTADOS */
SET SERVEROUTPUT ON;
DECLARE
v_rowcount INTEGER; 
BEGIN
UPDATE copy_emp 
SET salario = salario + 100 
WHERE job_id = 'ST_CLERK';
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows in COPY_EMPupdated.');
v_rowcount := SQL%ROWCOUNT; 
INSERT INTO res (num_rows) 
VALUES (v_rowcount);
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows in res updated.');
END

