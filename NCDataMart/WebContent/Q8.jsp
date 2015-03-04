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
            <li class="active"><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
          <h3 align="center">Fatalities of Vehicle and Age Range</h3>
          <br>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>
		  <div id="main" style="height:400px;"></div>


<!-- -----------Define a record class to store the results ---------------->
	<%!	public class AgeVehicleFatalityRecord {		
			String ageRange = null;		
			String vehicleType = null;
			String fatality = null;
			AgeVehicleFatalityRecord(String t1, String t2, String t3) {
				ageRange = t1;
				vehicleType = t2;	
				fatality = t3;
				
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
		String sql = "USE [CSIProject]  IF Object_id('Tempdb..#tempH') IS NOT NULL   	drop table #tempH ;  SELECT 	 	CASE  		WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Age_Range]) = 1 THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[PassengerDimension].[Age_Range],'NA')  	END AS AgeRange,	 	CASE  		WHEN GROUPING([CSIProject].[dbo].[VehicleDimension].[Vehicle_Type]) = 1 THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[VehicleDimension].[Vehicle_Type],'NA')  	END AS VehicleType,	 	COUNT ([Medical_Treatment]) AS Fatalities INTO #tempH		 FROM  	[CSIProject].[dbo].[Fact] JOIN 	[CSIProject].[dbo].[PassengerDimension] ON	 	[CSIProject].[dbo].[Fact].[Passenger_Key] = [CSIProject].[dbo].[PassengerDimension].[Passenger_Key] JOIN 	[CSIProject].[dbo].[VehicleDimension] ON	 	[CSIProject].[dbo].[Fact].[Vehicle_Key] = [CSIProject].[dbo].[VehicleDimension].[Vehicle_Key] WHERE [Medical_Treatment] = '3' GROUP BY 	[CSIProject].[dbo].[PassengerDimension].[Age_Range], 	[CSIProject].[dbo].[VehicleDimension].[Vehicle_Type]   SELECT  	CASE  		WHEN GROUPING(#tempH.AgeRange) = 1 THEN 'ALL' 		ELSE ISNULL(#tempH.AgeRange,'NA')  	END AS AgeRange, 	CASE  		WHEN GROUPING(CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000))) = 1 THEN 'ALL' 		ELSE ISNULL(CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000)),'NA')  	END AS VehicleType,	 	SUM(#tempH.Fatalities) AS Fatalities FROM 	#tempH JOIN 	[CSIProject].[dbo].[VehicleTypeDescription] ON 	#tempH.VehicleType = [CSIProject].[dbo].[VehicleTypeDescription].[Vehicle_Type] GROUP BY  	#tempH.AgeRange, 	CAST([CSIProject].[dbo].[VehicleTypeDescription].[Description] AS varchar(8000)) WITH CUBE	";						
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<AgeVehicleFatalityRecord> ageVehicleFatalityRecord = new ArrayList();		
		while (rs.next()) { 
			ageVehicleFatalityRecord.add(new AgeVehicleFatalityRecord(rs.getString(1),rs.getString(2),rs.getString(3)));	
		} 	
			rs.close();
			stmt.close();
			conn.close();
			

		
		
		int[] count = new int [19];
		
		int[][] typeAge = new int [19][12]; // 18 vehicle -12 ageRange
		
		for(int i = 0; i < 19; i++)
			count[i] = 0;
										
		for(int i = 0; i < ageVehicleFatalityRecord.size(); i++) {			
			if(!ageVehicleFatalityRecord.get(i).ageRange.contains("ALL"))
			{
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Bicycle")){
					typeAge[0][count[0]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Choice")){
					typeAge[1][count[1]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Data")){
					typeAge[2][count[2]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Farm")){
					typeAge[3][count[3]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Fire")){
					typeAge[4][count[4]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Light")){
					typeAge[5][count[5]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Motorcycle")){
					typeAge[6][count[6]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Off")){
					typeAge[7][count[7]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Other trucks")){
					typeAge[8][count[8]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Panel")){
					typeAge[9][count[9]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Purpose-built")){
					typeAge[10][count[10]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("tractor")){
					typeAge[11][count[11]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.equals("School bus")){
					typeAge[12][count[12]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Smaller")){
					typeAge[13][count[13]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Snowmobile")){
					typeAge[14][count[14]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Street")){
					typeAge[15][count[15]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Unit")){
					typeAge[16][count[16]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Unknown")){
					typeAge[17][count[17]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
				if(ageVehicleFatalityRecord.get(i).vehicleType.contains("Urban")){
					typeAge[18][count[18]++] = Integer.parseInt(ageVehicleFatalityRecord.get(i).fatality);
				}
			}
							
		}
//------ Lack Value Process	------
	// choice
		typeAge[1][11] = typeAge[1][10];	
		typeAge[1][10] = 0;	
	//	Farm equipment
		typeAge[3][11] = typeAge[3][10];
		typeAge[3][10] = 0;
	//  Fire engine
		typeAge[4][11] = typeAge[4][7];
		typeAge[4][7] = typeAge[4][8] = typeAge[4][9] = typeAge[4][10] = 0;
	//  offRoad
	    typeAge[7][11] = typeAge[7][10];
	    typeAge[7][10] = 0;
	//  purpose
		typeAge[10][11] = typeAge[10][10];
		typeAge[10][10] = 0;
	// School Bus
		typeAge[12][11] = typeAge[12][10];
		typeAge[12][10] = 0;
	// Smaller School Bus
		typeAge[13][11] = typeAge[13][9];
		typeAge[13][9] = typeAge[13][10] = 0;
	//	snowmobile
	    typeAge[14][11] = typeAge[14][9];
	    typeAge[14][9] = typeAge[14][10] = 0;
	    
	%>			
<!-- ----------------End of Sql--------------- -->     	        
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">VehicleType</th>
                  <th style="text-align: center;">AgeRange</th>
                  <th style="text-align: center;">Fatalities</th>        
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < ageVehicleFatalityRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=ageVehicleFatalityRecord.get(i).vehicleType %></td>
                  <td align = "center"><%=ageVehicleFatalityRecord.get(i).ageRange %></td>
                  <td align = "center"><%=ageVehicleFatalityRecord.get(i).fatality %></td>              
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
        <p>Report Category: Age and Gender</p>
        <p>Report Name: Fatalities of Vehicle and Age Range</p>
      </footer>     
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
	
		var myChart = echarts.init(document.getElementById('main'));   	  
         	var option = {
         		    title : {
         		        text: 'Fatalities',
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
         		            data:['(0-10]','(10-20]','(20-30]','(30-40]','(40-50]','(50-60]','(60-70]','(70-80]','(80-90]','(90-98]','[99-Above]','[NA]']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value'
         		        }
         		    ],
         		    series : [
                		 {
                		     name:'LightDutyVehicle',
                		     type:'line',
                		     data:<%=Arrays.toString(typeAge[5])%>,
                		     markPoint : {
               		          data : [
               		                    {type : 'max', name: 'max'},
               		                    {type : 'min', name: 'min'}
               		                ]
               		         },
                	   },
         		              
         		        {
         		            name:'Bicycle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[0])%>,
         		        },         		      
         		       {
         		            name:'FarmEquipment',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[3])%>,
         		        },
         		       {
         		            name:'FireEngine',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[4])%>,
         		        },

         		       {
         		            name:'Motorcycle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[6])%>,
         		        },
         		       {
         		            name:'OffRoadVehicle',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[7])%>,
         		        },
         		       {
         		            name:'Trucks&Vans<=4536Kg',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[8])%>,
         		        },
         		       {
         		            name:'Panel/Cargo Van<=4536Kg',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[9])%>,
         		        },
         		       {
         		            name:'Motohome',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[10])%>,
         		        },
         		       {
         		            name:'RoadTractor',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[11])%>,
         		        },
         		       {
         		            name:'SchoolBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[12])%>,
         		        },
         		       {
         		            name:'SmallerSchoolBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[13])%>,
         		        },
         		       {
         		            name:'Snowmobile',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[14])%>,
         		        },
         		       {
         		            name:'StreetCar',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[15])%>,
         		        },
         		       {
         		            name:'UnitTrucks>4536KG',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[16])%>,         		            
         		        },
         		       {
         		            name:'UrbanBus',
         		            type:'line',
         		            data:<%=Arrays.toString(typeAge[18])%>,       		            
         		        }
         		    ]
         		};
         		                            		                                      
        	myChart.setOption(option);
    </script>
	
</body>
</html> 