
import time
import MySQLdb


USERNAME ="PISTE01"
PASSWORD = "iot"
DBNAME = "PISTE01A_2018"
HOSTNAME = "ec2-35-180-47-85.eu-west-3.compute.amazonaws.com" 
 

 
file = open("input_data.txt","r+")

con = MySQLdb.connect(host = HOSTNAME ,user= USERNAME,passwd = PASSWORD ,db =  DBNAME, port = 3306)
con.autocommit = True
cursor = con.cursor()
print ("Connected to PISTE01A-2018 Database!")
count =1
while(True):
    con.commit()
    cursor = con.cursor()
    cursor.execute("SELECT Luminosity,Humidity,Temperature from Agro_Environmental_Parameters where Row_ID = %s", count)
    row = cursor.fetchone()
    print(count)
    print(row)
    if row is not None:
       file.write("%f "%float((row[2])))
       file.write(str(row[1])+" ")
       file.write(str(row[0])+"\n")
       count +=1
    if row is None: 
          print(count)
          print(row)
          time.sleep(10)


print("Access was successfull")
file.close()
cursor.close()
con.close()






 
