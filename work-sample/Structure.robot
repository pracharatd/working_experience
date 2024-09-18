*** Settings ***
Documentation       Database Testing in Robot Framework

Library             DatabaseLibrary
Library             OperatingSystem
Library             Selenium2Library
Library             Collections
Library             BuiltIn
Library             ExcelLibrary
Library             ../Resources/helpers.py
Library             ../Resources/excel.py

Suite Teardown      Robot disconnect from Database


*** Test Cases ***
TestCase1 compare source and target
    [Tags]    compare source and target
# 1.
    Connect to Azure Database

# 2. Input source from excel
    # Open excel file and execute query
    # Open excel file and compare result
    Open excel and validate


*** Keywords ***
Robot disconnect from Database
    Log to console    \n ----------Disonnecting from Database
    DatabaseLibrary.disconnect from database
    Log to console    \n ----------Database is disconnected!

Connect to Azure Database
    Log to console    \n ----------Connecting to AZURE Database
    ${ODBC_ConnectionString}    Set Variable
    ...    "Driver={ODBC Driver 17 for SQL Server};Server=aurora-tst-synapse.sql.azuresynapse.net;Database=aurorasqlpool;Uid=Sudchaya.Somniyarm@sgi.sk.ca;Pwd=xxxx;Encrypt=yes;Authentication=ActiveDirectoryInteractive"
    DatabaseLibrary.Connect To Database Using Custom Params    pyodbc    ${ODBC_ConnectionString}
    Log to console    \n ----------AZURE Database Connection is established successfully!

Open excel and validate
    ExcelLibrary.Open Excel Document    filename=Datatype.xlsx    doc_id=doc1
    ${total_count}    Evaluate    0
    FOR    ${script_count}    IN RANGE    2
        ${excel_row}    Evaluate    ${total_count}+2
        Log    ${excel_row}

        ${query_excel_1}    ExcelLibrary.Read Excel Cell    ${excel_row}    1    Sheet1
        ${result_1}    DatabaseLibrary.Query    ${query_excel_1}
        ${count_row}    DatabaseLibrary.Row Count    ${query_excel_1}
        Log many    ${result_1}
        Log    ${result_1[0][0]}
        ${row_addvalue}    Evaluate    0
        FOR    ${k}    IN RANGE    ${count_row}
            ${temp_addvalue_1}    Evaluate    0
            ${temp_addvalue_2}    Evaluate    ${temp_addvalue_1}+1
            ${row_excel}    Evaluate     ${row_addvalue}+${total_count}+2
            Add Value    Datatype.xlsx    B${row_excel}    ${result_1[${row_addvalue}][${temp_addvalue_1}]}
            Add Value    Datatype.xlsx    C${row_excel}    ${result_1[${row_addvalue}][${temp_addvalue_2}]}

            log    ${result_1[${row_addvalue}][${temp_addvalue_1}]}
            Log    ${result_1[${row_addvalue}][${temp_addvalue_2}]}

            ${column_actual_result}    ExcelLibrary.Read Excel Cell    ${row_excel}    2    Sheet1
            ${column_expected_result}    ExcelLibrary.Read Excel Cell    ${row_excel}    4    Sheet1
            Log    ${column_actual_result}
            Log    ${column_expected_result}

            ${dtype_actual_result}    ExcelLibrary.Read Excel Cell    ${row_excel}    3    Sheet1
            ${dtype_expected_result}    ExcelLibrary.Read Excel Cell    ${row_excel}    5    Sheet1
            Log    ${dtype_actual_result}
            Log    ${dtype_expected_result}

            # IF    '${column_actual_result}'=='${column_expected_result}'
            #     IF    '${dtype_actual_result}'=='${dtype_expected_result}'
            #         Add Value    Datatype.xlsx    F${row_excel}    PASS
            #     ELSE
            #         Add Value    Datatype.xlsx    F${row_excel}    FAILED
            #     END
            # ELSE
            #     Add Value    Datatype.xlsx    F${row_excel}    FAILED
            # END
            ${row_addvalue}    Evaluate    ${row_addvalue}+1
        END
        ${total_count}    Evaluate    ${total_count}+${count_row}
    END
