from openpyxl import Workbook
workbook1 = Workbook()
sheet = workbook1.active
sheet["A1"] = 'hello'
sheet["B1"] = 'World'
workbook1.save(filename='helloworld.xlsx')

sheet2 = workbook1.active
sheet2["A1"] = " HELLO"
sheet2["B1"] = "WORLD"
workbook1.save(filename='helloworld.xlsx')
