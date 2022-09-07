from openpyxl import Workbook
import pyodbc as odbc

#DATABASE
conn_string = f"""
    Driver={{{'SQL Server'}}};
    Server={'wuttbestpracticesql.database.windows.net'};
    Database={'bestsqlwutt'};
    Trust_Connection=yes;
    uid=pracharat.d;
    pwd=Best0681;
"""
conn = odbc.connect(conn_string)

sql = '''
        SELECT *
        From Table_1;
'''

cursor = conn.cursor()
cursor.execute(sql)
products = cursor.fetchall()

#EXCEL
headers = ['ID','Title','Price','Is_Necessary','TIMESTAMP']
wb = Workbook()
sheet = wb.active
sheet.append(headers)

for p in products:
    sheet.append(list(p))

wb.save(filename = 'exported sql.xlsx')