<?php
$connect = mysqli_connect("localhost", "user", "password", "PISTE01B_2018");
$sql = "SELECT * FROM `Agro_Environmental_Parameters` WHERE 1";  
$result = mysqli_query($connect, $sql);
?>
<html>  
 <head>  
  <title>Settings</title>  
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />  
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>  
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>  
 </head>  
 <body>  
  <div class="container">  
   <br />  
   <br />  
   <br />  
   <div class="table-responsive">  
    <h2 align="center">Export && Delete data </h2><br /> 
    <table class="table table-bordered">
     	     <tr>  
     			<th>Sensor_ID</th>  
      			<th>Luminosity</th>  
       			<th>Humidity</th>  
       			<th>Temperature</th>
			<th>Date</th>
       			<th>Time</th>
			<th>Flow_Rate</th>
			<th>Delay</th>
             </tr>
     <?php
     while($row = mysqli_fetch_array($result))  
     {  
        echo '  
       <tr>  
       <td>'.$row["Sensor_ID"].'</td>  
       <td>'.$row["Luminosity"].'</td>  
       <td>'.$row["Humidity"].'</td>  
       <td>'.$row["Temperature"].'</td>  
       <td>'.$row["sensors_data_time"].'</td>
       <td>'.$row["Date"].'</td>
       <td>'.$row["Flow_Rate"].'</td> 
       <td>'.$row["Delay"].'</td>
       </tr>  
        ';  
     }
     ?>
    </table>
    <br />
<center>
    <form method="post" action="export.php">
     <input type="submit" name="export" class="btn btn-success" value="Export" />
    </form>
    <form method="post" action="del.php">
     <input type="submit" name="delete" class="btn btn-success" value="Delete" />
    </form>
</center>
   </div>  
  </div>  
 </body>  
</html>
