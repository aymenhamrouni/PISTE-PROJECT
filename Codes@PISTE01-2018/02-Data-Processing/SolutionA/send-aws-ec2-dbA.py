import serial
import datetime
import time
import mysql.connector



USERNAME ="PISTE01"
PASSWORD = "iot"
DBNAME = "PISTE01A_2018"
HOSTNAME = "ec2-35-180-47-85.eu-west-3.compute.amazonaws.com" 
 

con = mysql.connector.connect(host = HOSTNAME ,user= USERNAME,passwd = PASSWORD ,db =  DBNAME, port = 3306)
con.autocommit = True
cursor = con.cursor()
print ("Connected to PISTE01A-2018 Database!")
ser = serial.Serial('/dev/ttyUSB0' , 115200)


while True :
	data = ser.readline()

	if data:
		  
	      x = data.decode("utf-8").split(":")
	      ID = x[0]
	      HUM = x[1]
	      LUM = x[2]
	      TEMP = x[3]
	      now = datetime.datetime.now()
	      print(x[0])
	      print(HUM)
	      print(LUM)
	      print(x[3])
	      cursor.execute("INSERT INTO Agro_Environmental_Parameters(Sensor_ID,Luminosity,Humidity,Temperature,Time,Date) VALUES(%s,%s,%s,%s,%s,%s)" ,(ID,LUM,HUM,TEMP,time.strftime(r"%H:%M:%S", time.localtime()),time.strftime(r"%Y-%m-%d", time.localtime())))	
		

print ("Done !")
cursor.close()
con.close()

