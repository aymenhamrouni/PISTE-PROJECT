#  Data processing and exploration : Solution A



## File list
| File | Function |  
| :--- | :--- |
| send-aws-ec2-dbA.py      | <ul><li> Send received data (packet) at the sink to the serial port USB </li> <li> Retrieve agro_environmental parameter fields Retrieve agro_environmental parameters : Temperature, Humidity, Luminosity </li> <li>Connect to the database PISTE01A_2018 </li> <li> Store the retrieved data in the  Agro_Environmental_Parameters table  </li></ul>      |
| read-aws-ec2-dbA.py     | <ul><li> Connect to the database PISTE01A_2018</li>  <li> Read the three parameters : Temperature, Humidity ad  Luminosity from  Agro_Environmental_Parameters table </li> <li> Write the three parameters to the file : inputs_data.txt  </li></ul>  |
 | fuzzy-logic.R       | <ul><li> Apply data fusion on input parameters : (Temperature, Humidity, Luminosity) and determine two irrigation parameters : (Flow_Rate and Delay)</li> <li> Use input file : input_data.txt <li> Generate output file : output_data.txt</li> </ul>   |
|appdesign.m | Matlab version of the Fuzzy Logic algorithm  |
| input_data.txt      |  Input file to the fuzzy-logic.R script : contains data (Temperature, Humidity, Luminosity)    |
| output_data.txt      | Output file of the fuzzy-logic.R script : contains generated data (Flow_Rate and Delay )      |  
| write-aws-ec2-dbA.py      | <ul><li> Connect to the database PISTE01A_2018</li>  <li> Update the Agro_Environmental_Parameters table  by adding data from output_data.txt file : Flow_Rate and Delay  </li>  </ul> |
| Agro_Environmental_Parameters.sql  | SQL table, contains all agro_environmental parameters : Temperature, Humidity, Luminosity, Flow_Rate and Delay

### Database access parameters
| User | PISTE01 |  
| :--- | :--- |
| Password      | iot      |
| Database     | PISTE01A_2018      |
| Table  (Read and Write / Update)  |   Agro_Environmental_Parameters


## Executing programs

1.  Run send-aws-ec2-dbA.py in terminal (Gateway)

 `python send-aws-ec2-dbA.py`

2.  Run read-aws-ec2-dbA.py in terminal (EC2 instance)

 `python read-aws-ec2-dbA.py`

3.  Run fuzzy-logic.R on R/RStudio (EC2 instance)

4. Run write-aws-ec2-dbA.py in terminal (EC2 instance)

 `python write-aws-ec2-dbA.py`
