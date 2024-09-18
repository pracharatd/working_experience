import pandas as pd
import re
import pyodbc
import os
import glob
from datetime import datetime

# Function to extract the portion between single quotes
def extract_value(value):
    if pd.isna(value):
        return value
    value = str(value)
    pattern = r"Target_Entity\s*=\s*'([^']*)'\s*AND"
    match = re.search(pattern, value, re.IGNORECASE)
    if match:
        return match.group(1).replace('.', '')
    else:
        return ''

# Function to normalize 'Target_Field_Name' by removing suffixes and converting to lowercase
def normalize_target_field_name(name):
    if pd.isna(name):
        return name
    name = str(name).strip().lower()
    return name

# Function to get the prefix before '_Master_Code' or '_Source_Code'
def get_prefix(name):
    if pd.isna(name):
        return name
    name = str(name).strip().lower()
    match = re.match(r'(.+?)_(master_code|source_code)$', name, re.IGNORECASE)
    if match:
        return match.group(1)
    return ''

# Function to clean transformations logic
def clean_before_extract_transformations_logic(value):
    if pd.isna(value):
        return value
    value = str(value)
    value = value.replace('"', '')
    value = value.replace('\n', ' ')
    value = value.replace('\r', '')
    value = value.replace('\t', ' ')
    value = re.sub(r'\s+', ' ', value)
    return value.strip()

# Function to clean transformations logic
def clean_transformations_logic(value):
    if pd.isna(value):
        return value
    return value.replace('.', '').replace(',', '').strip().lower()

# Function to query the database
def query_database(cursor, lookup_value):
    query = f"""
    SELECT COUNT(*) FROM (
        SELECT Target_Entity, COUNT(*) AS Count
        FROM intg_common.reference_cross_walk
        WHERE LOWER(Target_Entity) IN ('{lookup_value.lower()}')
        GROUP BY Target_Entity
    ) AS x
    """
    try:
        cursor.execute(query)
        result = cursor.fetchone()
        return result[0] if result else 0
    except pyodbc.Error as e:
        print(f"Database query error: {e}")
        return 0

# Define the required columns
required_columns = [
    'source system',
    'source schema',
    'source table name',
    'source field name',
    'transformations/logic',
    'target schema',
    'target table name',
    'target field name'
]

# Define the directory path
directory_path = "C:/Storage/4Personal/3VSCODE/1Target_Entity/STM"

# Establish the database connection once
server = 'aurora-dev-synapse.sql.azuresynapse.net'
database = 'aurorasqlpool'
username = 'Pracharat.Duangchai@sgi.sk.ca'
password = os.environ.get('SQL_PASSWORD')
driver = '{ODBC Driver 17 for SQL Server}'
connection_string = f'Driver={driver};Server={server};Database={database};Uid={username};Pwd={password};Encrypt=yes;Authentication=ActiveDirectoryInteractive'

try:
    conn = pyodbc.connect(connection_string)
    cursor = conn.cursor()
except pyodbc.Error as e:
    print(f"Database connection error: {e}")
    raise

# Process each Excel file in the directory
for file_path in glob.glob(os.path.join(directory_path, "*.xlsx")):
    print(f"Processing file: {file_path}")

    # Read the Excel file
    excel_file = pd.ExcelFile(file_path)

    # Initialize variables
    results_dict = {}
    found_column_indices = {}
    sheet_name_with_columns = None

    # Function to find column indices from the first few rows of a sheet
    def find_column_indices(sheet_name):
        df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
        
        # Combine multiple rows into one header
        header_rows = df.iloc[:2].fillna('')
        combined_headers = header_rows.apply(lambda row: ' '.join(row.astype(str).str.strip()), axis=0)
        combined_headers = combined_headers.str.strip().str.lower()

        # Find column indices
        indices = {}
        for col in required_columns:
            for idx, column in combined_headers.items():
                if col in column:
                    indices[col] = idx
                    break
        
        # Check if all required columns are found
        if len(indices) == len(required_columns):
            return indices
        return None

    # Check each sheet in the file
    for sheet_name in excel_file.sheet_names:
        if sheet_name.startswith('!'):
            print(f"Skipping sheet: {sheet_name}")
            continue

        # Find column indices for the current sheet
        found_column_indices = find_column_indices(sheet_name)
        
        if found_column_indices:
            sheet_name_with_columns = sheet_name
            break

    if not found_column_indices:
        print(f"None of the sheets in file '{file_path}' contain all required columns.")
        continue

    print(f"Found required columns in sheet: {sheet_name_with_columns} of file: {file_path}")
    print("Column indices:", found_column_indices)

    # Process each sheet
    for sheet_name in excel_file.sheet_names:
        if sheet_name.startswith('!'):
            continue
        
        print(f"Processing sheet: {sheet_name} in file: {file_path}")

        df = pd.read_excel(file_path, sheet_name=sheet_name, header=1)
        
        # Skip blank sheets
        if df.empty:
            print(f"Sheet '{sheet_name}' is blank or empty. Skipping.")
            continue
        
        for index, row in df.iterrows():
            try:
                source_system = row.iloc[found_column_indices.get('source system', -1)]
                source_schema = row.iloc[found_column_indices.get('source schema', -1)]
                source_table_name = row.iloc[found_column_indices.get('source table name', -1)]
                source_field_name = row.iloc[found_column_indices.get('source field name', -1)]
                transformations_logic = extract_value(clean_before_extract_transformations_logic(row.iloc[found_column_indices.get('transformations/logic', -1)]))
                target_schema = row.iloc[found_column_indices.get('target schema', -1)] if pd.notna(row.iloc[found_column_indices.get('target schema', -1)]) else None
                target_table_name = row.iloc[found_column_indices.get('target table name', -1)]
                target_field_name = row.iloc[found_column_indices.get('target field name', -1)]
                
                # Normalize Target_Field_Name
                normalized_target_field_name = normalize_target_field_name(target_field_name)

                # Ensure transformations_logic is a string for the .lower() method
                if isinstance(transformations_logic, str):
                    transformations_logic_lower = transformations_logic.lower()
                else:
                    transformations_logic_lower = ''
                
                # Apply the conditions
                if pd.notna(target_field_name):
                    if 'source_code' in normalized_target_field_name or (len(normalized_target_field_name) < 100 and 'master_code' in normalized_target_field_name and 'lookup' in transformations_logic_lower and transformations_logic_lower != ''):
                        entry = (sheet_name, source_system, source_schema, source_table_name, source_field_name, transformations_logic, target_schema, target_table_name, target_field_name)
                        prefix = get_prefix(normalized_target_field_name)
                        if sheet_name not in results_dict:
                            results_dict[sheet_name] = {}
                        if prefix not in results_dict[sheet_name]:
                            results_dict[sheet_name][prefix] = []
                        results_dict[sheet_name][prefix].append(entry)
            except Exception as e:
                print(f"Error processing row {index} in sheet '{sheet_name}' of file '{file_path}': {e}")

    # Process each prefix to determine Pass/Failed status
    for sheet_name, prefixes in results_dict.items():
        for prefix, entries in prefixes.items():
            lookup_value = None
            # Find the appropriate lookup_value
            for entry in entries:
                print(f"    {entry}")
                normalized_target_field_name = normalize_target_field_name(entry[8])
                if 'master_code' in normalized_target_field_name:
                    lookup_value = clean_transformations_logic(entry[5])
                    break
            
            # If a lookup_value was found, update entries and determine the status
            if lookup_value:
                count = query_database(cursor, lookup_value)
                status = 'Pass' if count > 0 else 'Failed'
                updated_entries = [(e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8], status) for e in entries]
                results_dict[sheet_name][prefix] = updated_entries
            else:
                # Mark all entries as 'Failed' if no lookup_value is found
                updated_entries = [(e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8], 'Failed') for e in entries]
                results_dict[sheet_name][prefix] = updated_entries

    # Initialize filtered results
    filtered_results_dict = {}

    # Filter out entries without Master_Code
    for sheet_name, prefixes in results_dict.items():
        filtered_results_dict[sheet_name] = {}
        
        for prefix, entries in prefixes.items():
            source_code_entries = [e for e in entries if 'source_code' in e[8].lower()]
            master_code_entries = [e for e in entries if 'master_code' in e[8].lower()]
            
            if source_code_entries and not master_code_entries:
                print(f"Removing entries with prefix '{prefix}' in sheet '{sheet_name}' because Master_Code is missing.")
                continue
            
            filtered_results_dict[sheet_name][prefix] = entries

    # Convert the filtered results_dict to a list of tuples
    filtered_results_list = []

    for sheet_name, prefixes in filtered_results_dict.items():
        for prefix, entries in prefixes.items():
            for entry in entries:
                filtered_results_list.append(entry)

    # Define the columns for the DataFrame
    columns = [
        'Sheet Name',
        'Source System',
        'Source Schema',
        'Source Table Name',
        'Source Field Name',
        'Transformations/Logic',
        'Target Schema',
        'Target Table Name',
        'Target Field Name',
        'Status'
    ]

    # Create a DataFrame from the filtered results list
    filtered_results_df = pd.DataFrame(filtered_results_list, columns=columns)

    # Get the current date and time
    current_date_time = datetime.now().strftime("%Y%m%d_%H%M%S")

    # Define the output CSV file path for the filtered results
    base_filename = os.path.splitext(os.path.basename(file_path))[0]
    result_path = "C:/Storage/4Personal/3VSCODE/1Target_Entity/Report"
    filtered_output_csv_path = os.path.join(result_path, f"{current_date_time}_{base_filename}_Master_Code_Validation.csv")

    # Export the filtered DataFrame to a CSV file
    filtered_results_df.to_csv(filtered_output_csv_path, index=False)

    print(f"Filtered results for file '{file_path}' have been exported to {filtered_output_csv_path}")

# Close the database connection
conn.close()
