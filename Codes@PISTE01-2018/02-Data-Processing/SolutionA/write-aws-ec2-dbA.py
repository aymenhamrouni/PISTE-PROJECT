import mysql.connector
import time

USERNAME ="PISTE01"
PASSWORD = "iot"
DBNAME = "PISTE01A_2018"
HOSTNAME =  "ec2-35-180-47-85.eu-west-3.compute.amazonaws.com" 

#_____Function to test the end of the file, if line is added?___________________#
def follow(thefile):
    thefile.seek(0,2)
    while True:
        line = thefile.readline()
        if not line:
            time.sleep(5)
            continue
        yield line
#____________________________________________________________________________#
 

con = mysql.connector.connect(host = HOSTNAME ,user= USERNAME,passwd = PASSWORD ,db =  DBNAME, port = 3306)
con.autocommit = True
cursor = con.cursor() 
print ("Connected to PISTE01A-2018 Database!")
file_in = open("output_data.txt","r")
print "Name of the file: ", file_in.name
count =1
for line in file_in:
    fields = line.split(" ")
    a=float(fields[0])
    b=float(fields[1])
    cursor.execute("UPDATE Agro_Environmental_Parameters SET Delay='%f', Flow_Rate ='%f' WHERE ROW_ID='%d'"%(a,b, count))
    count = count +1
file_in.close()
while True:
    file_in = open("output_data.txt","r")
    loglines =follow(file_in)
    for line in loglines:
        if line.strip()  != " ":
            fields = line.split(" ")
            a=fields[0]
            b=fields[1]
            cursor.execute("UPDATE Agro_Environmental_Parameters SET Delay='%f', Flow_Rate ='%f' WHERE ROW_ID='%d'"%(a,b, count))
            count = count +1
            print(count)


file_in.close()














    

    


