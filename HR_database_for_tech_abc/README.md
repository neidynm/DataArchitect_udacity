# SQL Database Project for Tech ABC Corp

## Business Requirement

Tech ABC Corp experienced explosive growth with their new AI-powered video game console, expanding from 10 to 200 employees across 5 locations in under a year. The HR department, still using spreadsheets to manage employee information, is struggling to keep up with this rapid growth. As the new data architect, your task is to design and build a database capable of efficiently managing their employee information.

## Dataset

The project uses an HR dataset provided as an Excel workbook:
- 206 records
- 11 columns
- Human-readable format
- Non-normalized data

The dataset includes the following information for Tech ABC Corp employees:
- Names
- Job titles
- Departments
- Manager names
- Hire dates
- Start dates
- End dates
- Work locations
- Salaries

## IT Department Best Practices

This project adheres to the IT Department's Best Practices for databases. Refer to the Best Practices document for detailed guidelines.

## Files

1. `StageTableLoad.sql`: Information from the old database
2. `sql_first_load.sql`: Initial database setup script
3. `crude_queries.sql`: Various SQL queries and operations

## Database Structure

The final database consists of the following main tables:

- Employee
- Employment_history
- Position
- Salary
- Department
- Education_lvl
- Location
- City
- State

## Setup

To set up the database:

1. Run the`StageTableLoad.sql` script to load data from previous system
2. Run the `sql_first_load.sql` script to create the tables and load initial data.
3. Use the queries in `crude_queries.sql` for various operations and data retrieval.

## Features

- Employee information management
- Job history tracking
- Department and position management
- Salary information (with restricted access)
- Location and address tracking
- Education level recording

## Key Queries and Operations

- Retrieving employee lists with job titles and departments
- Inserting and updating job titles
- Counting employees in each department
- Creating views for comprehensive employee data
- Stored procedure for retrieving employee job history
- User access management (including restricted salary data access)

## Usage

1. Load the data from previous systema

   ```
   psql -d your_database_name -f StageTableLoad.sql
   ```
2. Execute the setup script:
   ```
   psql -d your_database_name -f sql_first_load.sql
   ```

3. Run individual queries from `crude_queries.sql` as needed.

## Security

- The script includes creation of a non-management user (NoMgr) with restricted access to salary data.

## Maintenance

Regular backups and updates to the data structure should be performed as needed. Ensure to test any changes in a non-production environment before applying to the live database.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the [MIT License](LICENSE.md) - see the LICENSE.md file for details.