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
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li class="active"><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
          <h2 align="center"> Number of Vehicles in Collision of Different Day of Week</h2>
          <br>
		  <br>       
          <div id="main" style="height:400px;"></div>
          
          <hr><h2 align="center"><b>Monthly</b> Number of Vehicles in Collision</h2>
          <br>
		  <div id ="rollUp" style="height:400px;"></div>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>


<!-- -----------Define a record class to store the results ---------------->
	<%!	public class MonthDayRedord{		
			String month = null;		
			String day = null;
			String vehicleNum = null;
			MonthDayRedord(String t1, String t2, String t3) {
				month = t1;
				day = t2;	
				vehicleNum = t3;						
			}
		}
	
		public class MonthWeatherRedord{		
			String month = null;					
			String vehicleNum = null;
			String dailyTemperature = null;
			String visibilityOneToNine = null;			
			String visibilityOne = null;
			String precipitation = null;
			String rainfall = null;
			String snowfall = null;			
			MonthWeatherRedord(String t1, String t2, String t3,String t4,String t5,String t6,String t7,String t8) {
				month = t1;
				vehicleNum = t2;						
				dailyTemperature = t3;
				visibilityOneToNine = t4;			
				visibilityOne = t5;
				precipitation = t6;
				rainfall = t7;
				snowfall = t8;		
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
		
		String city =  request.getParameter("City");
		if (city == null) city = "Ottawa";
				
		String sql = "USE [CSIProject]  IF Object_id('Tempdb..#tempK') IS NOT NULL   	drop table #tempK ;  SELECT 	DISTINCT 	CASE  		WHEN GROUPING([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear]) = 1  			THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear],'NA')  	END AS [MonthOfYear], 	 	CASE  		WHEN GROUPING([CSIProject].[dbo].[CollisionDateDimension].[DayOfWeek]) = 1  			THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[CollisionDateDimension].[DayOfWeek],'NA')  	END AS [DayOfWeek], 	 	SUM( 		CASE  			WHEN  				[CSIProject].[dbo].[Fact].[Number_Of_Vehicles] <> 'UU' 			THEN  				CAST([CSIProject].[dbo].[Fact].[Number_Of_Vehicles] AS INT)			 			END 		) 	 AS [Number_Of_Vehicles] FROM  	[CSIProject].[dbo].[Fact] JOIN 	[CSIProject].[dbo].[CollisionDateDimension] ON 	[CSIProject].[dbo].[Fact].[Date_Key] = [CSIProject].[dbo].[CollisionDateDimension].[Date_Key]  GROUP BY 	[CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear], 	[CSIProject].[dbo].[CollisionDateDimension].[DayOfWeek]	 WITH CUBE";						
		String sqlRollUp = "USE [CSIProject]  IF Object_id('Tempdb..#tempK') IS NOT NULL   	drop table #tempK ; SELECT 	DISTINCT 	CASE  		WHEN GROUPING([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear]) = 1  			THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear],'NA')  	END AS [MonthOfYear], 	SUM( 		CASE  			WHEN  				[CSIProject].[dbo].[Fact].[Number_Of_Vehicles] <> 'UU' 			THEN  				CAST([CSIProject].[dbo].[Fact].[Number_Of_Vehicles] AS INT)			 			END 		) 	 AS [Number_Of_Vehicles] INTO #tempK	  FROM  	[CSIProject].[dbo].[Fact] JOIN 	[CSIProject].[dbo].[CollisionDateDimension] ON 	[CSIProject].[dbo].[Fact].[Date_Key] = [CSIProject].[dbo].[CollisionDateDimension].[Date_Key] GROUP BY 	[CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear] WITH CUBE   SELECT 	DISTINCT 	#tempK.[MonthOfYear], 	#tempK.[Number_Of_Vehicles], 	[dbo].["+city+"WeatherDimension].[Daily Average Temperature], 	[dbo].["+city+"WeatherDimension].[Visibility (hours with) 1 to 9 km], 	[dbo].["+city+"WeatherDimension].[Visibility (hours with) < 1 km], 	[dbo].["+city+"WeatherDimension].[Days with Precipitation >  10 mm], 	[dbo].["+city+"WeatherDimension].[Days with Rainfall >  10 mm], 	[dbo].["+city+"WeatherDimension].[Days With Snowfall >  10 cm] From  	#tempK JOIN 	[dbo].["+city+"WeatherDimension] ON 	#tempK.[MonthOfYear] = [dbo].["+city+"WeatherDimension].[Month]" ;
		//String sqlRollUp = "USE [CSIProject]  IF Object_id('Tempdb..#tempK') IS NOT NULL   	drop table #tempK ; SELECT 	DISTINCT 	CASE  		WHEN GROUPING([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear]) = 1  			THEN 'ALL' 		ELSE ISNULL([CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear],'NA')  	END AS [MonthOfYear], 	SUM( 		CASE  			WHEN  				[CSIProject].[dbo].[Fact].[Number_Of_Vehicles] <> 'UU' 			THEN  				CAST([CSIProject].[dbo].[Fact].[Number_Of_Vehicles] AS INT)			 			END 		) 	 AS [Number_Of_Vehicles] INTO #tempK	  FROM  	[CSIProject].[dbo].[Fact] JOIN 	[CSIProject].[dbo].[CollisionDateDimension] ON 	[CSIProject].[dbo].[Fact].[Date_Key] = [CSIProject].[dbo].[CollisionDateDimension].[Date_Key] GROUP BY 	[CSIProject].[dbo].[CollisionDateDimension].[MonthOfYear] WITH CUBE   SELECT 	DISTINCT 	#tempK.[MonthOfYear], 	#tempK.[Number_Of_Vehicles], 	[dbo].[OttawaWeatherDimension].[Daily Average Temperature], 	[dbo].[OttawaWeatherDimension].[Visibility (hours with) 1 to 9 km], 	[dbo].[OttawaWeatherDimension].[Visibility (hours with) < 1 km], 	[dbo].[OttawaWeatherDimension].[Days with Precipitation >  10 mm], 	[dbo].[OttawaWeatherDimension].[Days with Rainfall >  10 mm], 	[dbo].[OttawaWeatherDimension].[Days With Snowfall >  10 cm] From  	#tempK JOIN 	[dbo].[OttawaWeatherDimension] ON 	#tempK.[MonthOfYear] = [dbo].[OttawaWeatherDimension].[Month]";
		
		
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<MonthDayRedord> monthDayRecord = new ArrayList();		
		
		while (rs.next()) { 
			monthDayRecord.add(new MonthDayRedord(rs.getString(1),rs.getString(2),rs.getString(3)));	
		}		
		
		ResultSet rsWeather = stmt.executeQuery(sqlRollUp);		
		ArrayList<MonthWeatherRedord> monthWeatherRedord = new ArrayList();	
		while (rsWeather.next()) { 
			monthWeatherRedord.add(new MonthWeatherRedord(rsWeather.getString(1),rsWeather.getString(2),rsWeather.getString(3),rsWeather.getString(4),rsWeather.getString(5),rsWeather.getString(6),rsWeather.getString(7),rsWeather.getString(8)));	
		}
			rsWeather.close();
			rs.close();
			stmt.close();
			conn.close();
		
		int[] vehicleNumByMonth = new int [12];
		int count = 0;
		for(int i = 0; i < monthDayRecord.size(); i++) 
       	{
			if(count>11) break;
     	 	if(monthDayRecord.get(i).day.contains("ALL"))       
          		vehicleNumByMonth[count++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);                                       	  
        }  
		
		int [][] vehicleNumByDay = new int[7][12];
		int counts[] = new int[7];
		for (int i = 0; i < 7; i++) 
			counts[i] = 0;
			
		for(int i = 0; i < monthDayRecord.size(); i++) 
       	{
			if(!monthDayRecord.get(i).month.contains("U") && !monthDayRecord.get(i).month.contains("ALL")) {
				if(monthDayRecord.get(i).day.contains("1"))
					vehicleNumByDay[0][counts[0]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("2"))
					vehicleNumByDay[1][counts[1]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("3"))
					vehicleNumByDay[2][counts[2]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("4"))
					vehicleNumByDay[3][counts[3]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("5"))
					vehicleNumByDay[4][counts[4]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("6"))
					vehicleNumByDay[5][counts[5]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
				if(monthDayRecord.get(i).day.contains("7"))
					vehicleNumByDay[6][counts[6]++] = Integer.parseInt(monthDayRecord.get(i).vehicleNum);
			}			     		                                     	  
        }  
		
	%>	
	
	
<!-- ----------------End of Sql--------------- -->     
	
         
          <h2 class="sub-header" align = "center">Monthly Number of Vehicles in Collision with Weather of <%=city %></h2>         
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">
            <form action = "Q11.jsp" method = "post">
               <select id="City" name ="City" style="height: 30px; margin-right: 20px">
                <option value ="Ottawa">Ottawa</option>
                <option value ="Vancouver">Vancouver</option>
                <option value ="Halifax">Halifax</option>                               
             </select>                                 
              <input class="btn btn-success btn-sm" type="submit" value="Confirm" >
            </form>
            <br>
          </div>
          
           <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Month</th>              
                  <th style="text-align: center;">Number of Vehicles</th>    
                  <th style="text-align: center;">Daily Average Temperature (&#176;C)</th>
                  <th style="text-align: center;">Visibility (hours with) 1 to 9 km</th>
                  <th style="text-align: center;">Visibility (hours with) < 1 km</th>
                  <th style="text-align: center;">Days with Precipitation >  10 mm</th>
                  <th style="text-align: center;">Days with Rainfall >  10 mm</th>
                  <th style="text-align: center;">Days With Snowfall >  10 cm</th>
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < monthWeatherRedord.size(); i++) 
              	{           	  
              %>
                <tr>
                  <td align = "center"><%=monthWeatherRedord.get(i).month%></td>              
                  <td align = "center"><%=monthWeatherRedord.get(i).vehicleNum %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).dailyTemperature %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).visibilityOneToNine %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).visibilityOne %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).precipitation %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).rainfall %></td>
                  <td align = "center"><%=monthWeatherRedord.get(i).snowfall %></td>                     
                </tr>   
               <%  
				}  
              %>
              </tbody>
            </table>
          </div>
          
            <h2 class="sub-header" align="center"> Number of Vehicles in Collision of Different Day of Week </h2>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Month</th>
                  <th style="text-align: center;">Day of Week</th>
                  <th style="text-align: center;">Number of Vehicles</th>        
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < monthDayRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=monthDayRecord.get(i).month%></td>
                  <td align = "center"><%=monthDayRecord.get(i).day %></td>
                  <td align = "center"><%=monthDayRecord.get(i).vehicleNum %></td>                       
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
          </div><!-- table container end -->
          <p>*UU - Unknown</p>
          <p>*U - Unknown</p>   
		 
          
        </div><!-- main content end -->
        
      </div>
      
      <hr>
      
      <footer class="footer" style="text-align: right;">
      	<p>Source: National Collision Data Mart</p>
        <p>Report Category: Road and Vehicle</p>
        <p>Report Name: Number of Vehicles in Collision of Different Day of Week</p>
      </footer>
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
		var myChart = echarts.init(document.getElementById('main')); 
		var vehicleNumByMonthJS = <%=Arrays.toString(vehicleNumByMonth)%>;
     	var option = {
    		    title : {
    		        text: 'Vehicle Number By Day',
    		        subtext: ''
    		    },
    		    tooltip : {
    		        trigger: 'axis'
    		    },
    		    legend: {
    		        data:['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
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
    		            data : ['January','February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    		        }
    		    ],
    		    yAxis : [
    		        {
    		            type : 'value'
    		        }
    		    ],
    		    series : [
    		        {
    		            name:'Monday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[0])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		           
    		        },
    		        {
    		            name:'Tuesday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[1])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },

    		        },
    		        {
    		            name:'Wednesday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[2])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            
    		        },
    		        {
    		            name:'Thursday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[3])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            markLine : {
    		                data : [
    		                    {type : 'average', name: 'Average'}
    		                ]
    		            }
    		        },
    		        {
    		            name:'Friday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[4])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            markLine : {
    		                data : [
    		                    {type : 'average', name: 'Average'}
    		                ]
    		            }
    		        },
    		        {
    		            name:'Saturday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[5])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            
    		        },
    		        {
    		            name:'Sunday',
    		            type:'line',
    		            data:<%=Arrays.toString(vehicleNumByDay[6])%>,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            markLine : {
    		                data : [
    		                    {type : 'average', name: 'Average'}
    		                ]
    		            }
    		        }
    		        
    		    ]
    		}; 
       myChart.setOption(option);
    </script>
    
	<script>
		var myChart2 = echarts.init(document.getElementById('rollUp')); 
		var vehicleNumByMonthJS = <%=Arrays.toString(vehicleNumByMonth)%>;
     	var option2 = {
    		    title : {
    		        text: 'Vehicle Number By Month',
    		        subtext: ''
    		    },
    		    tooltip : {
    		        trigger: 'axis'
    		    },
    		    legend: {
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
    		            data : ['January','February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    		        }
    		    ],
    		    yAxis : [
    		        {
    		            type : 'value'
    		        }
    		    ],
    		    series : [
    		        {
    		            name:'Collisions',
    		            type:'bar',
    		            data:vehicleNumByMonthJS,
    		            markPoint : {
    		                data : [
    		                    {type : 'max', name: 'Max'},
    		                    {type : 'min', name: 'Min'}
    		                ]
    		            },
    		            markLine : {
    		                data : [
    		                    {type : 'average', name: 'Average'}
    		                ]
    		            }
    		        }
    		    ]
    		}; 
       myChart2.setOption(option2);
    </script>
</body>
</html> 