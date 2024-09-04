-- SELECT provider_ccn, count(*)
-- FROM hospital_bed_prep
-- where nth_row = 1
-- group by provider_ccn
-- order by count(*) desc

-- SELECT * FROM "Hospital_data"."Hospital_data".HCAHPS_data

create table "Hospital_data"."Hospital_data".Tableau_file as
with hospital_bed_prep AS
(
SELECT 
	ROW_NUMBER() OVER(PARTITION BY provider_ccn ORDER BY to_date(fiscal_year_end_date,'MM/DD/YYYY') desc) AS NTH_ROW,
	hospital_name,
	number_of_beds,
	lpad(cast(provider_ccn as text),6,'0') as provider_ccn,
	to_date(fiscal_year_begin_date,'MM/DD/YYYY') AS fiscal_year_begin_date,
	to_date(fiscal_year_end_date,'MM/DD/YYYY') AS fiscal_year_end_date
FROM "Hospital_data"."Hospital_data".hospital_beds
)
SELECT hcahps.*,
	lpad(cast(facility_id as text),6,'0') as provider_ccn,
	to_date(start_date,'MM/DD/YYYY') AS start_date_converted,
	to_date(end_date,'MM/DD/YYYY') AS end_date_converted,
	beds.number_of_beds,
	beds.fiscal_year_begin_date,
	beds.fiscal_year_end_date
FROM "Hospital_data"."Hospital_data".HCAHPS_data as hcahps
left join hospital_bed_prep as beds 
ON lpad(cast(facility_id as text),6,'0') = beds.provider_ccn 
	AND beds.nth_row = 1
