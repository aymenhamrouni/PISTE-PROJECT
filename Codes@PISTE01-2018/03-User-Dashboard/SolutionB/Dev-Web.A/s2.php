<?php
$connect = mysqli_connect("localhost", "user", "password", "PISTE01B_2018");
$query = '
SELECT Temperature , 
UNIX_TIMESTAMP(CONCAT_WS(" ", Date, Time)) AS datetime 
FROM Agro_Environmental_Parameters WHERE `Sensor_ID`=3
ORDER BY Date DESC, Time DESC
';
$query1 = '
SELECT Humidity , 
UNIX_TIMESTAMP(CONCAT_WS(" ", Date, Time)) AS datetime 
FROM Agro_Environmental_Parameters WHERE `Sensor_ID`=3 AND `Humidity`<>0
ORDER BY Date DESC, Time DESC
';
$query2 = '
SELECT Luminosity , 
UNIX_TIMESTAMP(CONCAT_WS(" ", Date, Time)) AS datetime 
FROM Agro_Environmental_Parameters WHERE `Sensor_ID`=3 AND `Luminosity`<>0
ORDER BY Date DESC, Time DESC
';
$sql = "SELECT *  FROM `Agro_Environmental_Parameters` WHERE `Sensor_ID` = 3 ORDER BY ROW_ID DESC LIMIT 1";
/* $sql = "SELECT * FROM `Agro_Environmental_Parameters` WHERE `ID` = (SELECT max(ID) FROM `Agro_Environmental_Parameters` WHERE `Sensor_ID`=3)"; */
$result3 = mysqli_query($connect, $sql);
$result = mysqli_query($connect, $query);
$result1 = mysqli_query($connect, $query1);
$result2 = mysqli_query($connect, $query2);
$rows = array();
$table = array();
$table['cols'] = array(
 array(
  'label' => 'Date Time', 
  'type' => 'datetime'
 ),
 array(
  'label' => 'Temperature (en C)', 
  'type' => 'number'
 )
);
while($row = mysqli_fetch_array($result))
{
 $sub_array = array();
 $datetime = explode(".", $row["datetime"]);
 $sub_array[] =  array(
      "v" => 'Date(' . $datetime[0] . '000)'
     );
 $sub_array[] =  array(
      "v" => $row["Temperature"]
     );
 $rows[] =  array(
     "c" => $sub_array
    );
}
$table['rows'] = $rows;
$jsonTable = json_encode($table);

$rows = array();
$table1 = array();
$table1['cols'] = array(
 array(
  'label' => 'Date Time', 
  'type' => 'datetime'
 ),
 array(
  'label' => ' (humidity en %)', 
  'type' => 'number'
 )
);
while($row = mysqli_fetch_array($result1))
{
 $sub_array = array();
 $datetime = explode(".", $row["datetime"]);
 $sub_array[] =  array(
      "v" => 'Date(' . $datetime[0] . '000)'
     );
 $sub_array[] =  array(
      "v" => $row["Humidity"]
     );
 $rows[] =  array(
     "c" => $sub_array
    );
}
$table1['rows'] = $rows;
$jsonTable1 = json_encode($table1);

$rows = array();
$table2 = array();
$table2['cols'] = array(
 array(
  'label' => 'Date Time', 
  'type' => 'datetime'
 ),
 array(
  'label' => 'Luminosity (en %)', 
  'type' => 'number'
 )
);
while($row = mysqli_fetch_array($result2))
{
 $sub_array = array();
 $datetime = explode(".", $row["datetime"]);
 $sub_array[] =  array(
      "v" => 'Date(' . $datetime[0] . '000)'
     );
 $sub_array[] =  array(
      "v" => $row["Luminosity"]
     );
 $rows[] =  array(
     "c" => $sub_array
    );
}
$table2['rows'] = $rows;
$jsonTable2 = json_encode($table2);
?>

<html>
    <head>
        <title>IoT_Agro_Environnemental</title>
        <meta charset="utf-8" />
		<link rel="stylesheet" href="style.css">
		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <srehscript type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
  <script type="text/javascript">
   google.charts.load('current', {'packages':['corechart']});
   google.charts.setOnLoadCallback(drawChart);
   function drawChart()
   {
    var data = new google.visualization.DataTable(<?php echo $jsonTable; ?>);
	var data1 = new google.visualization.DataTable(<?php echo $jsonTable1; ?>);
	var data2 = new google.visualization.DataTable(<?php echo $jsonTable2; ?>);
    var options = {
     legend:{position:'bottom'},
     chartArea:{width:'95%', height:'65%'}
    };
    var chart = new google.visualization.LineChart(document.getElementById('line_chart'));
	chart.draw(data, options);
	var chart = new google.visualization.LineChart(document.getElementById('line_chart1'));
    chart.draw(data1, options);
	var chart = new google.visualization.LineChart(document.getElementById('line_chart2'));
    chart.draw(data2, options);
   }
  </script>
<style type="text/css">
#gauche {
   float:left;
   border:1px solid #DAA520;
   height:200px;
   width:40%; 
   
}
#droite {
   float:left;  
   margin-left:202px; 
   border:1px solid gray; 
   height:200px;
   width:40%; 
}
table {
    border-collapse: collapse;
}

table, th, td {
    border: 1px solid black;
}
th, td {
    padding: 25px;
    text-align: center;
    color: #f5f5f5;
}
tr:hover {background-color: #727472;}
</style>

    </head>
    <body>
        <ul id="menu">
			
			<li>
				<a href="#">Sensors</a>
					<ul>
						<li><a href="s1.php">Sensor1</a></li>
						<li><a href="s2.php">Sensor2</a></li>
					</ul>
			</li>
			<li>
				<a href="exp.php">Settings</a>
				
					<!--ul>
						<li><a href="exp.php">Export </a></li>
						<li><a href="del.php">Delete</a></li>

					</ul-->	
			</li>
            <li><a href="about.html">About Us</a></li>
            <li><a href="index.html">Home</a></li>
       
		</ul>
<h1><br/>Sensor 2<br/></h1>
<center>
	<div  id="gauche">
 			         <div id="line_chart" style=" width: 100%; height: 200px"></div> 
<br/><br/>
				 <div  id="line_chart1" style=" width: 100%; height: 200px"></div>
        </div>
<div id="droite">
				<div  id="line_chart2" style="width: 100%; height: 200px"></div>
 				<div class="table-responsive">  
   <center> <h2 align="center"> irrigation </h2><br /> </center>
    <table class="table table-bordered">
     	     <tr>  
     			<th>Current Temperature  </th>
			<th>Current Luminosity  </th>
			<th>Current Humidity  </th>
       			<th>Flow Rate(ml/min)</th>
       			<th>Delay (min)</th>
             </tr>
     <?php
     while($row = mysqli_fetch_array($result3))  
     {  
        echo '  
       <tr>  
<td>'.$row["Temperature"].'</td>
<td>'.$row["Luminosity"].'</td>
<td>'.$row["Humidity"].'</td> 
       <td>'.$row["Flow_Rate"].'</td>  
       <td>'.$row["Delay"].'</td>
       </tr>  
        ';  
     }
     ?>
    </table>
    <br />
   </div>  

	</div>
 
    <div>

</div>
			

	</center>
</body>	
	
    <script src="js/jquery-1.10.2.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/custom.js"></script>
	
</html>
