/*- 
SPRINT 2: BDD relacionals i introducció a SQL

Paula Arnas - paularant@gmail.com


Exercici 2
Utilitzant JOIN realitzaràs les següents consultes:*/

# Llistat dels països que estan fent compres.

SELECT DISTINCT country
FROM company
WHERE id IN (SELECT company_id
					FROM transaction
                    WHERE declined = 0)
ORDER BY country;




# Des de quants països es realitzen les compres.

SELECT COUNT(DISTINCT country) as "Països compres"
FROM company
WHERE id IN (SELECT company_id
					FROM transaction
                    WHERE declined = 0)
ORDER BY country;


# Identifica la companyia amb la mitjana més gran de vendes.

SELECT company.company_name as Nom_empresa, ROUND (AVG(transaction.amount), 2) as Mitjana_vendes
FROM company
JOIN transaction ON
company.id = transaction.company_id
WHERE transaction.declined = 0
GROUP BY Nom_empresa
ORDER BY Mitjana_vendes desc
LIMIT 1;


/*- Exercici 3
Utilitzant només subconsultes (sense utilitzar JOIN):*/

# Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction
WHERE company_id IN (SELECT id
					FROM company
					WHERE country = "Germany");
                    
                    
# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
                    
SELECT DISTINCT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (SELECT ROUND(AVG(amount), 2)
                    FROM transaction));
                    


# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT *
FROM company
WHERE id NOT IN (SELECT DISTINCT company_id
						FROM transaction
                        WHERE declined = 0);
                        
                        
                        
                        

/*Nivell 2
#Ex.1 Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.*/

SELECT DATE(timestamp) AS dia_transacció, SUM(amount) as import_total
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY import_total desc
LIMIT 5;

#Ex.2 Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country, ROUND(AVG(transaction.amount), 2) as mitjana_vendes
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.declined = 0
GROUP BY company.country
ORDER BY mitjana_vendes desc;

            
/*Exercici 3
En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/

# Mostra el llistat aplicant JOIN i subconsultes.

SELECT *
FROM transaction
JOIN company
ON transaction.company_id = company.id
WHERE country = (SELECT country
				FROM company
				WHERE company_name = "Non Institute");


# Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction
WHERE company_id IN (SELECT id
					FROM company
					WHERE country = (SELECT country
					FROM company
					WHERE company_name = 'Non Institute'));
                    
                

/* Nivell 3 - Exercici 1
Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros 
i en alguna d'aquestes dates: 
29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.*/

SELECT company.company_name, company.phone, company.country, DATE(transaction.timestamp) as data, transaction.amount
FROM transaction 
JOIN company 
ON company.id = transaction.company_id
WHERE DATE(timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13')
AND amount BETWEEN 100 AND 200
AND declined = 0
ORDER BY transaction.amount desc;

/*Exercici 2
Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.*/

SELECT  company.company_name, COUNT(*) AS Total_transaccions,
    CASE 
        WHEN COUNT(*) >= 4 THEN 'Més de 4 transaccions'
        ELSE 'Menys de 4 transaccions'
    END AS Núm_transaccions
FROM transaction
JOIN company
ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY Total_transaccions;


 