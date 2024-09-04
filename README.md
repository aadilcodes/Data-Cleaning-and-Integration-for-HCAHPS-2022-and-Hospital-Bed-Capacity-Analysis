# Data Cleaning-and-Integration-for-HCAHPS-2022-and-Hospital-Bed-Capacity-Analysis
Comprehensive Data Cleaning and Integration for HCAHPS 2022 and Hospital Bed Capacity Analysis

## Introduction

This project focused on cleaning and integrating two essential datasets: the 2022 Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey results and hospital bed capacity data. The goal was to prepare the data for advanced analysis and visualization in a dashboard, providing deeper insights into hospital performance and capacity utilization.

## Datasets Used

- **HCAHPS 2022 Data**: Detailed survey results reflecting patient satisfaction across various dimensions such as communication with nurses and doctors, respect, and overall quality of care.
- **Hospital Bed Capacity Data**: Data indicating the number of beds available in different hospitals, along with the fiscal year start and end dates.

## Data Cleaning Process

To ensure the datasets were accurate, consistent, and ready for analysis, the following steps were performed using SQL:

### 1. Loading and Inspecting the Data

- Imported the HCAHPS and hospital bed datasets into SQL tables for analysis.
- Conducted an initial inspection to identify any missing, inconsistent, or incorrect data, particularly focusing on date fields and numeric columns.

### 2. Standardizing Key Fields

**Provider CCN and Facility ID**: Utilized the `LPAD` function to ensure that both the Provider CCN and Facility ID were standardized to a six-digit format, which was crucial for consistent data merging.

```sql
lpad(cast(provider_ccn as text),6,'0') as provider_ccn
```
### 3. Fixing Date Formats

Conversion to SQL Date Format: Both datasets contained date fields in ```MM/DD/YYYY``` format, which needed to be converted to SQL’s date format for accurate date-based operations. This was accomplished using the ```TO_DATE()``` function.

- #### Example Conversion

- The ```Start Date, End Date, Fiscal Year Begin Date, and Fiscal Year End Date``` fields were converted using the following SQL code:
  ```sql
  to_date(start_date,'MM/DD/YYYY') AS start_date_converted,
  to_date(end_date,'MM/DD/YYYY') AS end_date_converted,
  to_date(fiscal_year_begin_date,'MM/DD/YYYY') AS fiscal_year_begin_date,
  to_date(fiscal_year_end_date,'MM/DD/YYYY') AS fiscal_year_end_date

  ```

### 4. Handling Duplicate Entries:

**Identifying the Most Recent Data**: In cases where multiple records existed for the same ```Provider CCN```, I used the ```ROW_NUMBER()``` function combined with ```PARTITION BY``` and ```ORDER BY``` clauses to identify and retain the most recent records. This was essential for maintaining data integrity, especially for the hospital bed capacity data.

```sql 
ROW_NUMBER() OVER(PARTITION BY provider_ccn ORDER BY to_date(fiscal_year_end_date,'MM/DD/YYYY') desc) AS NTH_ROW
```
Filtering the Most Recent Records: Only the most recent record for each provider was selected for further analysis by filtering on NTH_ROW = 1.

### 5. Joining the Datasets:

**Data Integration**: The HCAHPS dataset was joined with the cleaned hospital bed data using a left join on the standardized ```Provider CCN``` field. This ensured that all relevant hospital performance data was enriched with the corresponding hospital bed information.

```sql
FROM "Hospital_data"."Hospital_data".HCAHPS_data as hcahps
LEFT JOIN hospital_bed_prep as beds 
ON lpad(cast(facility_id as text),6,'0') = beds.provider_ccn 
AND beds.nth_row = 1
```
### 6. Exporting for Dashboard Creation

The final, cleaned, and integrated dataset was exported as a CSV file, ready for visualization and further analysis in Tableau. This dataset will allow for comprehensive dashboarding, enabling stakeholders to gain insights into hospital performance metrics alongside their capacity.

## Summary 
Through meticulous data cleaning and integration, I prepared a comprehensive dataset combining HCAHPS 2022 survey results with hospital bed capacity data. By fixing date formats, standardizing key fields, and addressing duplicates, I ensured the data was accurate and consistent. This dataset is now ready for advanced analysis and visualization, facilitating a deeper understanding of hospital performance and resource allocation.
