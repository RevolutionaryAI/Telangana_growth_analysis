use tel_pro;
select * from fact_ts_ipass;
#1. How does the revenue generated from document registration vary across districts in Telangana? 
# List down the top 5 districts that showed the highest document registration revenue growth between FY 2019 and 2022. 
 select * from fact_stamps;
SELECT c.district,sum(b.documents_registered_rev) as total_doc_registered FROM dim_date a
JOIN fact_stamps b ON a.month = b.month
JOIN dim_districts c ON b.dist_code = c.dist_code
WHERE fiscal_year between 2019 and 2022
GROUP BY c.district
ORDER BY total_doc_registered desc limit 5;

#2. How does the revenue generated from document registration compare to the revenue generated from e-stamp challans across districts? 
#List down the top 5 districts where e-stamps revenue contributes significantly more to the revenue than the documents in FY 2022? 
SELECT c.district,SUM(b.estamps_challans_rev) AS total_estamps,SUM(b.documents_registered_rev) AS total_doc_registered FROM dim_date a
JOIN fact_stamps b ON a.month = b.month
JOIN dim_districts c ON b.dist_code = c.dist_code
WHERE fiscal_year = 2022
GROUP BY c.district
HAVING SUM(b.estamps_challans_rev) > SUM(b.documents_registered_rev)
ORDER BY total_doc_registered DESC
LIMIT 5;

#3. What would be counts of the e-Stamp challan and document registration for each fiscal year?
SELECT a.fiscal_year,SUM(b.estamps_challans_cnt) AS total_estamps_count,SUM(b.documents_registered_cnt) AS total_doc_registered_count FROM dim_date a
JOIN fact_stamps b ON a.month = b.month
JOIN dim_districts c ON b.dist_code = c.dist_code
GROUP BY a.fiscal_year
ORDER BY total_estamps_count DESC, total_doc_registered_count ASC;

#4. Categorize districts into three segments based on their stamp registration revenue generation during the fiscal year 2021 to 2022
with cte as (
	SELECT a.fiscal_year,c.district,SUM(b.documents_registered_rev) as total_doc_regis,SUM(b.estamps_challans_rev) as total_challans_rev FROM dim_date a
	JOIN fact_stamps b ON a.month = b.month
	JOIN dim_districts c ON b.dist_code = c.dist_code
    WHERE a.fiscal_year BETWEEN 2021 AND 2022
    group by c.district,a.fiscal_year
)
select district,total_doc_regis,total_challans_rev,
CASE
	WHEN total_doc_regis>500000000 THEN "High revenue" 
	WHEN total_challans_rev>5000000000 THEN "High revenue" 
	WHEN total_doc_regis>100000000 and total_doc_regis<=500000000 THEN "Medium revenue" 
	WHEN total_challans_rev>100000000 and total_challans_rev<=500000000 THEN "Medium revenue"
    ELSE "Low Revenue"
END AS Income_Segments
from cte;