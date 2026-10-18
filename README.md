# Mamaearth Returns & Growth Intelligence Pipeline
Capstone Project — Data Analytics with AI & GenAI Program: E&ICT Academy, IIT Roorkee, Author: Riddhi Shinde

An end-to-end data analytics project integrating SQL, Python, data visualization and Generative AI to analyze retail revenue, product returns, customer behavior and business growth opportunities.

## Project Overview

Mamaearth Growth Analytics is a data analytics project focused on analyzing order revenue, customer behavior, payment methods, product performance, and return patterns. The project uses MySQL for database reporting, Python for data cleaning and exploratory data analysis (EDA), visualizations for communicating insights, and Gemini or an offline fallback to generate a business narrative.

The objective is to identify data-quality issues, understand revenue trends, highlight high-risk customer segments, and provide actionable recommendations for business and operations teams.

## Repository Structure
Mamaearth-Growth-Analytics/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
│
├── sql/
│   ├── schema.sql
│   ├── seed_data.sql
│   └── reports.sql
│
├── analysis/
│   ├── clean_and_eda.py
│   └── visualize.py
│
├── charts/
│   ├── return_rate_by_payment.png
│   └── monthly_revenue_trend.png
│
├── narrator/
│   ├── findings.json
│   ├── generate_narrative.py
│   └── sample_output.txt
│
└── README.md

## Project Workflow

The project follows this sequence:

**SQL Database Setup → SQL Reports → Data Cleaning and EDA → Findings Generation → Visualizations → SCR Narrative Generation**

## Step 1: Set Up the Database and Run SQL Reports

Use MySQL Server and MySQL Workbench to execute the SQL scripts in the following order.

### 1.1 Create the database schema

1. Open MySQL Workbench and connect to your MySQL Server.
2. Open `sql/schema.sql`.
3. Execute the script to create the database tables and schema.
4. Select the appropriate database if it is not selected automatically.

### 1.2 Insert the seed data

1. Open `sql/seed_data.sql`.
2. Execute the script to populate the tables with the provided sample data.
3. Verify that the records have been inserted successfully.

### 1.3 Run the SQL reports

1. Open `sql/reports.sql`.
2. Execute the report queries after the schema and seed data have been loaded.
3. Review the resulting reports and use them to understand the dataset before proceeding with Python analysis.

**Execution order:**

1. `sql/schema.sql`
2. `sql/seed_data.sql`
3. `sql/reports.sql`

Run all three scripts against the same database.

## Step 2: Run Data Cleaning, EDA, and Visualizations

Complete the Python analysis steps in the following order.

### 2.1 Run data cleaning and EDA

From the project root, run:

```bash
python analysis/clean_and_eda.py
```

This script performs data cleaning and exploratory analysis, including duplicate handling, missing-value treatment, payment-method normalization, outlier detection, revenue reconciliation, and return-rate analysis.

The verified findings include:

- Raw order lines: 180
- Deduplicated order records: 175
- Cleaned total revenue: ₹97,358.30
- Raw total revenue: ₹99,860.20
- Duplicate reconciliation difference: ₹2,501.90
- COD return rate: 44.4%
- CARD return rate: 14.7%
- UPI return rate: 18.9%
- Highest-risk segment: COD orders in Tier-2 cities, with a 54.5% return rate
- Corrected peak revenue month: March 2026, with revenue of ₹20,318.90

The revenue reconciliation difference of ₹2,501.90 is attributable to the five duplicate order records removed during cleaning. Missing-value imputation does not change the total revenue.

The analysis also identifies two quantity outliers, with quantities of 25 and 30. These outliers inflate January's apparent revenue from ₹11,637.10 to ₹29,582.10. After correcting for the outliers, March is the verified peak revenue month.

### 2.2 Generate the verified findings

Task 5 of Part 2 generates the file:

`narrator/findings.json`

This JSON file contains the verified numerical findings used by the narrative generator. It must be generated from the analysis results rather than manually populated.

Complete Task 5 of Part 2 and confirm that `narrator/findings.json` exists before running the narrative generator.

### 2.3 Generate visualizations

After running the cleaning and EDA script, execute:

```bash
python analysis/visualize.py
```

This script generates visualizations from the analysis results, including:

- `return_rate_by_payment.png` — compares return rates across payment methods.
- `monthly_revenue_trend.png` — displays the corrected monthly revenue trend.

The visualizations help communicate payment-related return risks and the corrected monthly revenue peak.

## Step 3: Generate the SCR Business Narrative

The narrative generator reads the verified findings from `narrator/findings.json` and produces a Situation–Complication–Resolution (SCR) report.

The report contains three sections:

- **Situation:** Summarizes revenue performance and the overall business situation.
- **Complication:** Highlights data-quality issues, return-rate risks, and revenue distortion caused by outliers.
- **Resolution:** Recommends actions based on the verified findings.

Run the generator from the project root:

```bash
python narrator/generate_narrative.py
```

### Option A: Run with a Gemini API key

The Gemini-powered path requires a valid API key and the `google-genai` Python package.

Install the package if it is not already installed:

```bash
python -m pip install google-genai
```

Obtain an API key through Google AI Studio, subject to the availability and terms of the service.

Set the `GEMINI_API_KEY` environment variable before running the script.

**Windows PowerShell:**

```powershell
$env:GEMINI_API_KEY = "YOUR_GEMINI_API_KEY"
python narrator/generate_narrative.py
```

**Windows Command Prompt:**

```cmd
set GEMINI_API_KEY=YOUR_GEMINI_API_KEY
python narrator/generate_narrative.py
```

**macOS or Linux:**

```bash
export GEMINI_API_KEY="YOUR_GEMINI_API_KEY"
python narrator/generate_narrative.py
```

Replace `YOUR_GEMINI_API_KEY` with your actual API key. Keep the key private and never commit it to the repository.

When the API request succeeds, the script generates a narrative using Gemini and validates its numerical findings before accepting the output.

### Option B: Run without a Gemini API key

The project also supports an offline mode that does not require a Gemini API key or make a Gemini API call.

To run without a key, ensure that `GEMINI_API_KEY` is unset in the current terminal session.

**Windows PowerShell:**

```powershell
Remove-Item Env:GEMINI_API_KEY -ErrorAction SilentlyContinue
python narrator/generate_narrative.py
```

**Windows Command Prompt:**

```cmd
set GEMINI_API_KEY=
python narrator/generate_narrative.py
```

**macOS or Linux:**

```bash
unset GEMINI_API_KEY
python narrator/generate_narrative.py
```

When the API key is unavailable, the script automatically uses the deterministic offline narrative generator.

The offline fallback is also used if the Gemini request fails, times out, returns an empty response, or generates a narrative that fails numerical validation.

### Numerical validation

The script checks the generated narrative against the verified findings, including:

| Finding | Expected value |
|---|---:|
| Cleaned total revenue | ₹97,358.30 |
| COD return rate | 44.4% |
| COD + Tier-2 return rate | 54.5% |
| Duplicate reconciliation difference | ₹2,501.90 |
| March peak revenue | ₹20,318.90 |

The validation output displays each expected value and whether the narrative passed the corresponding check.

### Generated output

The final accepted narrative is saved to:

`narrator/sample_output.txt`

The file contains the Gemini-generated narrative when it passes validation, or the offline narrative when the fallback is used.

## Reproduction Checklist

To reproduce the project results from the beginning, follow these steps in order:

1. Execute `sql/schema.sql` in MySQL Workbench.
2. Execute `sql/seed_data.sql` against the same database.
3. Execute `sql/reports.sql` and review the SQL reports.
4. Run `analysis/clean_and_eda.py`.
5. Complete Task 5 of Part 2 to generate `narrator/findings.json`.
6. Run `analysis/visualize.py` to generate the charts.
7. Run `narrator/generate_narrative.py` with a Gemini API key or without one to use offline mode.
8. Review the numerical validation results and the final narrative in `narrator/sample_output.txt`.

Following this sequence ensures that the SQL reports, cleaned analysis, visualizations, verified findings, and business narrative are generated in the correct order.

## Security and Reproducibility
- Never commit API keys, passwords, or credentials to GitHub.
- Use the `GEMINI_API_KEY` environment variable rather than hardcoding the key in Python files.
- Generate `narrator/findings.json` from the analysis workflow so the narrative uses verified results.
- Run the SQL scripts in the documented order against the same database.
- The offline narrative path allows the project to run without Gemini API access.
