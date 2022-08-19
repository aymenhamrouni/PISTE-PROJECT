#  Data processing and exploration : Solution B


## File list
| File | Function |  
| :--- | :--- |
| send-aws-ec2-dbB.py      | <ul><li> Send received data (packet) at the sink to the serial port USB </li> <li> Retrieve agro_environmental parameters : Temperature, Humidity, Luminosity </li> <li>Connect to the database PISTE01B_2018 </li> <li> Store the retrieved data in the Sensor_Data table  </li></ul>      |
| data_processing.R       | <ul><li> Connect to the database PISTE01B_2018  </li> <li>  Read the three parameters : Temperature, Humidity, Luminosity  from Sensor_Data table  </li><li> Apply data fusion and determine two irrigation parameters : Flow_Rate and Delay  </li> <li> Write all agro-evironmental parameters to a new table : Agro_Environmental_Parameters </li> </ul> |
| Sensor_Data.sql     | SQL table, contains three parameters : Temperature, Humidity, Luminosity     |
| Agro_Environmental_Parameters.sql  |     SQL table, contains all agro_environmental parameters : Temperature, Humidity, Luminosity, Flow_Rate and Delay

### Database access parameters
| User | PISTE01 |  
| :--- | :--- |
| Password      | iot      |
| Database     | PISTE01B_2018      |
| Table (Read)    | Sensor_Data     |
| Table  (Write)  |   Agro_Environmental_Parameters


## Executing programs

1.  Run send-aws-ec2-dbA.py in terminal (Gateway)

 `python send-aws-ec2-dbB.py`

2.  Run data_processing.R on R/RStudio (EC2 instance)

    - From RStudio console
  <br>  `source('data_processing.R')`  </br>

  - From Command Line  
<br>  ` Rscript  data_processing.R ` </br>
