<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset=ISO-8859-1" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>National Collisions Data Mart</title>
<!-- Bootstrap core CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="css/dashboard.css" rel="stylesheet">
<style>
.table-responsive {
	min-height: 250px;
	overflow-y: auto;
	max-height: 400px;
}
</style>
</head>
<body> 

<!-- Navigation bar fixed on top -->
  <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="BIPortal.jsp">National Collisions Data Mart</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
          </ul>
        </div>
      </div>
    </nav><!-- Navigation bar end -->
    
     <!-- Main container -->
    <div class="container-fluid">
      <div class="row">
      
        <div class="col-sm-3 col-md-2 sidebar"><!-- sidebar -->
          <ul class="nav nav-sidebar">
            <li><a href="Q1.jsp">Collision Of Specific Month</a></li>
            <li><a href="Q2.jsp">Explore Data Of Date Hierarchy</a></li>
            <li><a href="Q3.jsp">CollisionOfDifferentAccidentTypes</a></li>
            <li><a href="Q4.jsp">Collision Of Specific Weather</a></li>
            <li><a href="Q5.jsp">Collision Severity Record</a></li>
            <li><a href="Q6.jsp">Collision Of Age And Gender</a></li>
            <li><a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li class="active"><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
         <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
          <h3 align="center">Vehicle Contrast by Accident Types</h3>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>
          
		  <div id="main" style="height:400px;"></div>


<!-- -----------Define a record class to store the results ---------------->
	<%!	public class TypeVehicleRecord {		
			String collisionConfiguration = null;		
			String vehicleType = null;
			String accidentSum = null;
			TypeVehicleRecord(String t1, String t2, String t3) {
				collisionConfiguration = t1;
				vehicleType = t2;	
				accidentSum = t3;
				
			}
		}	
	%>
<!-- CONNECTION, SQL -->
	<% Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();
		String url = "jdbc:sqlserver://localhost:1433;DatabaseName=CSIProject";
		String username = "root";
		String password = "root";
		Connection conn =  DriverManager.getConnection(url,username,password);
		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);		
		String sql = "USE [CSIProject] IF Object_id('Tempdb..#tempI') IS NOT NULL drop table #tempI ; SELECT [CSIProject].[dbo].[CollisionDimension].[Collision_Configuration], CASE WHEN GROUPING([CSIProject].[dbo].[VehicleDimension].[Vehicle_Type]) = 1 THEN 'ALL' ELSE ISNULL([CSIProject].[dbo].[VehicleDimension].[Vehicle_Type],'NA') END AS VehicleType, COUNT ([CSIProject].[dbo].[Fact].[Vehicle_Key]) AS AccidentSum INTO #tempI FROM [CSIProject].[dbo].[Fact] JOIN [CSIProject].[dbo].[VehicleDimension] ON [CSIProject].[dbo].[Fact].[Vehicle_Key] = [CSIProject].[dbo].[VehicleDimension].[Vehicle_Key] JOIN [CSIProject].[dbo].[CollisionDimension] ON [CSIProject].[dbo].[Fact].[Collision_Key] = [CSIProject].[dbo].[CollisionDimension].[Collision_Key] GROUP BY [CSIProject].[dbo].[CollisionDimension].[Collision_Configuration], [CSIProject].[dbo].[VehicleDimension].[Vehicle_Type] SELECT CASE WHEN GROUPING(CAST([CSIProject].[dbo].[CollisionConfigurationDescription].[Description] AS VARCHAR(8000))) = 1 THEN 'ALL' ELSE ISNULL(CAST([CSIProject].[dbo].[CollisionConfigurationDescription].[Description] AS VARCHAR(8000)),'NA') END AS CollisionConfiguration, CASE WHEN GROUPING(CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000))) = 1 THEN 'ALL' ELSE ISNULL(CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000)),'NA') END AS VehicleType, SUM(#tempI.AccidentSum) AS AccidentSum FROM #tempI JOIN [CSIProject].[dbo].[VehicleTypeDescription] ON #tempI.VehicleType = [CSIProject].[dbo].[VehicleTypeDescription].[Vehicle_Type] JOIN [CSIProject].[dbo].[CollisionConfigurationDescription] ON #tempI.Collision_Configuration = [CSIProject].[dbo].[CollisionConfigurationDescription].[Collision_Configuration] GROUP BY CAST([CSIProject].[dbo].[CollisionConfigurationDescription].[Description] AS VARCHAR(8000)), CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000)) WITH CUBE ";						
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<TypeVehicleRecord> typeVehicleRecord = new ArrayList();		
		while (rs.next()) { 
			typeVehicleRecord.add(new TypeVehicleRecord(rs.getString(1),rs.getString(2),rs.getString(3)));	
		} 	
			rs.close();
			stmt.close();
			conn.close();
			
		int[] count = new int [19];
		
		int[][] typeVehicle = new int [19][20]; // 19 vehicle - 20 acident type
		
		for(int i = 0; i < 19; i++)
			count[i] = 0;
		
		for(int i = 0; i < typeVehicleRecord.size(); i++) {			
			if(!typeVehicleRecord.get(i).collisionConfiguration.contains("ALL"))
			{
				if(typeVehicleRecord.get(i).vehicleType.contains("Bicycle")){
					typeVehicle[0][count[0]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Choice")){
					typeVehicle[1][count[1]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Data")){
					typeVehicle[2][count[2]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Farm")){
					typeVehicle[3][count[3]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Fire")){
					typeVehicle[4][count[4]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Light")){
					typeVehicle[5][count[5]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Motorcycle")){
					typeVehicle[6][count[6]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Off")){
					typeVehicle[7][count[7]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Other trucks")){
					typeVehicle[8][count[8]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Panel")){
					typeVehicle[9][count[9]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Purpose-built")){
					typeVehicle[10][count[10]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("tractor")){
					typeVehicle[11][count[11]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.equals("School bus")){
					typeVehicle[12][count[12]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Smaller")){
					typeVehicle[13][count[13]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Snowmobile")){
					typeVehicle[14][count[14]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Street")){
					typeVehicle[15][count[15]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Unit")){
					typeVehicle[16][count[16]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Unknown")){
					typeVehicle[17][count[17]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
				if(typeVehicleRecord.get(i).vehicleType.contains("Urban")){
					typeVehicle[18][count[18]++] = Integer.parseInt(typeVehicleRecord.get(i).accidentSum);
				}
			}
							
		}
		
		
		
		
							
		
		
		
	
//------ Lack Value Process	------
	// choice
	//	typeVehicle[1][11] = typeVehicle[1][10];	
	//	typeVehicle[1][10] = 0;	
	//	Farm equipment
	//  typeVehicle[3][11] = typeVehicle[3][10];
	//	typeVehicle[3][10] = 0;
	//  Fire engine
		typeVehicle[4][19] = typeVehicle[4][15]; 
		typeVehicle[4][18] = typeVehicle[4][14];
		typeVehicle[4][17] = 0;
		typeVehicle[4][16] = 0;
		typeVehicle[4][15] = typeVehicle[4][13];
		typeVehicle[4][14] = typeVehicle[4][12];
		typeVehicle[4][13] = typeVehicle[4][11];
		typeVehicle[4][12] = typeVehicle[4][10];
		typeVehicle[4][11] = typeVehicle[4][10] = 0;
						
		
	//	moto home
		typeVehicle[10][19] = typeVehicle[10][18];
		typeVehicle[10][18] = typeVehicle[10][17];
		typeVehicle[10][17] = 0;
		
	// Smaller School Bus
		typeVehicle[13][19] = typeVehicle[13][15];
		typeVehicle[13][18] = typeVehicle[13][14];
		typeVehicle[13][17] = 0;
		typeVehicle[13][16] = 0;
		typeVehicle[13][15] = typeVehicle[13][13] ;
		typeVehicle[13][14] = typeVehicle[13][12] ;
		typeVehicle[13][13] = typeVehicle[13][11] ;
		typeVehicle[13][12] = typeVehicle[13][10] ;
		typeVehicle[13][11] = 0 ;
		typeVehicle[13][10] = typeVehicle[13][9]  ;
		typeVehicle[13][9] = typeVehicle[13][8]  ;
		typeVehicle[13][8] = typeVehicle[13][7]  ;
		typeVehicle[13][7] = typeVehicle[13][6]  ;
		typeVehicle[13][6] = typeVehicle[13][5]  ;
		typeVehicle[13][5] = typeVehicle[13][4]  ;
		typeVehicle[13][4] = typeVehicle[13][3]  ;
		typeVehicle[13][3] = typeVehicle[13][2]  ;
		typeVehicle[13][2] = typeVehicle[13][1]  ;
		typeVehicle[13][1] = 0  ;
		

	//	streetCar
	    typeVehicle[15][19] = 0;
	    typeVehicle[15][18] = typeVehicle[15][10];
	    typeVehicle[15][17] = 0;
	    typeVehicle[15][16] = typeVehicle[15][9];
	    typeVehicle[15][15] = typeVehicle[15][8];
	    typeVehicle[15][14] = typeVehicle[15][7];
	    typeVehicle[15][13] = 0;
	    typeVehicle[15][12] = 0;
	    typeVehicle[15][11] = typeVehicle[15][10]= typeVehicle[15][9] = 0;
	    typeVehicle[15][8] = typeVehicle[15][6];
	    typeVehicle[15][7] = typeVehicle[15][5];
	    typeVehicle[15][5] = typeVehicle[15][3];
	    typeVehicle[15][4] = typeVehicle[15][2];
	    typeVehicle[15][3] = 0;
	    typeVehicle[15][2] = typeVehicle[15][1];
	    typeVehicle[15][1] = 0;
	    
	%>	
	
	
<!-- ----------------End of Sql--------------- -->     
	
         
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">VehicleType</th>
                  <th style="text-align: center;">AccidentType</th>
                  <th style="text-align: center;">Collisions</th>        
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < typeVehicleRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=typeVehicleRecord.get(i).vehicleType %></td>
                  <td align = "center"><%=typeVehicleRecord.get(i).collisionConfiguration %></td>
                  <td align = "center"><%=typeVehicleRecord.get(i).accidentSum %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
          </div><!-- table container end -->
          <p>*Data element is not applicable - eg:"dummy" vehicle record created for the pedestrian</p>
           

          
        </div><!-- main content end -->
        
      </div>
      
      <hr>
      <footer class="footer" style="text-align: right;">
      	<p>Source: National Collision Data Mart</p>
        <p>Report Category: Road and Vehicle</p>
        <p>Report Name: Vehicle Contrast by Accident Types</p>
      </footer>   
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
	
		var myChart = echarts.init(document.getElementById('main'));   	  
         	var option = {
         		    title : {
         		        text:'Collisions',
         		        subtext: ''
         		    },
         		    tooltip : {
         		        trigger: 'axis'
         		    },
         		    legend: {	    	 
         		    	 y : 'bottom',        		    	 
  //       		        data:['LightDuty','Bicycle','FarmEquipment','FireEngine','Motorcycle','OffRoad','truck&Van','PanelVan','Motorhome','RoadTractor','SchoolBus','SmallSchBus','Snowmobile','StreetCar','UnitTruck','UrbanBus']     		 
   						data:[]
         		    },
         		    toolbox: {
         		        show : true,
         		        feature : {
         		            mark : {show: true},
         		            dataView : {show: true, readOnly: false},
         		            magicType : {show: true, type: ['line', 'bar']},
         		            restore : {show: true},
         		            saveAsImage : {show: true}
         		        }
         		    },
         		    calculable : true,
         		    xAxis : [
         		        {        		        	
         		            type : 'category',         		            
         		            data:['[Any other single vehicle collision configuration]',                             //1
         		                  '[Any other two vehicle - same direction of travel configuration]',               //2
         		                  '[Any other two-vehicle - different direction of travel configuration]',          //3
         		                  '[Approaching side-swipe]',														//4
         		                  '[Choice is other than the preceding values]',									//5
         		                  '[Head-on collision]',															//6
         		                  '[Hit a moving object]',															//7
         		                  '[Hit a parked motor vehicle]',													//8
         		                  '[Hit a stationary object]',														//9
         		                  '[Left turn across opposing traffic]',											//10
         		                  '[One vehicle passing to the left of the other, or left turn conflict]',			//11
         		                  '[One vehicle passing to the right of the other, or right turn conflict]',		//12
         		                  '[Ran off left shoulder]',														//13
         		                  '[Ran off right shoulder]',														//14
         		                  '[Rear-end collision]',														 	//15
         		                  '[Right angle collision]',														//16
         		                  '[Right turn, including turning conflicts]',										//17
         		                  '[Rollover on roadway]',															//18
         		                  '[Side swipe]',																	//19
         		                  '[Unknown]'																		//20     	                  
         		                  ]
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value'
         		        }
         		    ],
         		    series : [        		              
         		        {
         		            name:'Bicycle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[0])%>,
         		        },         		      
         		       {
         		            name:'FarmEquipment',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[3])%>,
         		        },
         		       {
         		            name:'FireEngine',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[4])%>,
         		        },
         		        
         		       {
               		     name:'LightDutyVehicle',
               		     type:'line',
               		     data:<%=Arrays.toString(typeVehicle[5])%>,
               		     markPoint : {
              		          data : [
              		                    {type : 'max', name: 'max'},
              		                    {type : 'min', name: 'min'}
              		                ]
              		         },
               	   },

         		       {
         		            name:'Motorcycle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[6])%>,
         		        },
         		       {
         		            name:'OffRoadVehicle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[7])%>,
         		        },
         		       {
         		            name:'Trucks&Vans<=4536Kg',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[8])%>,
         		        },
         		       {
         		            name:'Panel/Cargo Van<=4536Kg',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[9])%>,
         		        },
         		       {
         		            name:'Purpose-built Motohome',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[10])%>,
         		        },
         		       {
         		            name:'RoadTractor',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[11])%>,
         		        },
         		       {
         		            name:'SchoolBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[12])%>,
         		        },
         		       {
         		            name:'SmallerSchoolBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[13])%>,
         		        },
         		       {
         		            name:'Snowmobile',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[14])%>,
         		        },
         		       {
         		            name:'StreetCar',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[15])%>,
         		        },
         		       {
         		            name:'UnitTrucks>4536KG',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[16])%>,         		            
         		        },
         		       {
         		            name:'UrbanBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeVehicle[18])%>,       		            
         		        }
         		    ]
         		};
         		                            		                                      
        	myChart.setOption(option);
    </script>
	
</body>
</html> 