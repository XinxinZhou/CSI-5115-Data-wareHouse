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
            <li class="active"><a href="Q4.jsp">Collision Of Specific Weather</a></li>
            <li><a href="Q5.jsp">Collision Severity Record</a></li>
            <li><a href="Q6.jsp">Collision Of Age And Gender</a></li>
            <li><a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        
<!-- -----------Define a record class to store the results ---------------->
	<%!	public class WeatherTypeRecord {		
			String accidentType = null;
			String totalCollisions = null;	
			WeatherTypeRecord(String t1, String t2) {
				accidentType = t1;
				totalCollisions = t2;
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
		String weather = request.getParameter("Weather");
		if(weather == null) weather = "Clear and sunny";
		String sql = "USE [CSIProject] IF Object_id('Tempdb/..#temp') IS NOT NULL drop table #temp ; SELECT [CSIProject].[dbo].[CollisionDimension].[Collision_Configuration], 	COUNT(Number_Of_Vehicles) AS TotalCollisions  into #temp FROM [CSIProject].[dbo].[Fact] JOIN [CSIProject].[dbo].[CollisionDimension] ON [Fact].[Collision_Key] = [CollisionDimension].[Collision_Key] JOIN [CSIProject].[dbo].[WeatherConditionsDescription] ON [CollisionDimension].Weather_Conditions = [WeatherConditionsDescription].Weather_Conditions Where [WeatherConditionsDescription].Description like '" + weather + "' Group By [CSIProject].[dbo].[CollisionDimension].[Collision_Configuration]  Select DISTINCT 	CASE 	WHEN GROUPING(CAST([Description] as varchar(8000))) = 1 Then 'ALL' 	ELSE ISNULL(CAST([Description] as varchar(8000)), 'NA') END AS 'Type of accident', 	sum(#temp.TotalCollisions) AS TotalCollisions from [CSIProject].[dbo].[CollisionConfigurationDescription] JOIN #temp ON 	#temp.[Collision_Configuration] = [CSIProject].[dbo].[CollisionConfigurationDescription].[Collision_Configuration] GROUP BY CAST([Description] as varchar(8000)) WITH ROLLUP ORDER BY [TotalCollisions] ";
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<WeatherTypeRecord> weatherRecord = new ArrayList();
		while (rs.next()) { 
	%>
			<% 
			weatherRecord.add(new WeatherTypeRecord(rs.getString(1),rs.getString(2)));
			%>
	
		<% } %>
		
		<%
			int[] totalCollisions = new int[weatherRecord.size()];
		
			for(int i = 0; i < weatherRecord.size(); i++)
			{
				totalCollisions[i] = Integer.parseInt(weatherRecord.get(i).totalCollisions);
				
		%>					
		<%
			}
		%>				
		<%
			rs.close();
			stmt.close();
			conn.close();
		%>	
<!-- ----------------End of Sql--------------- -->    
               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h2 class="page-header" align="center">Collision Accident Analytic Report</h2>          
          <h3 align="center">Collision of Weather: <%=weather%></h3>		          
          <br>
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">
            <form action = "Q4.jsp" method = "post">
              <select id="Weather" name ="Weather" style="height: 30px; margin-right: 20px">
                <option value ="Clear and sunny">Clear and Sunny</option>
                <option value ="Overcast, cloudy but no precipitation">Overcast, cloudy but no precipitation</option>
                <option value="Raining">Raining</option>
                <option value="Snowing, not including drifting snow">Snowing, not including drifting snow</option>
                <option value="Freezing rain, sleet, hail">Freezing rain, sleet, hail</option>
                <option value="Visibility limitation">Visibility limitation(drifting snow, fog, smog, dust, smoke, mist) </option>
                <option value="Strong wind">Strong wind</option>
              </select>
              <input class="btn btn-success btn-sm" type="submit" value="Confirm" >
            </form>
          </div>
		  <br>
		<div id="main" style="height:400px;"></div>
	
         <h2 class="sub-header"></h2>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">AccidentType</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < weatherRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=weatherRecord.get(i).accidentType %></td>
                  <td align = "center"><%=weatherRecord.get(i).totalCollisions%></td>               
                </tr>   
               <% 
                }  
              %>
              </tbody>
            </table>
          </div><!-- table container end -->
          

          
        </div><!-- main content end -->
        
      </div>
      
      <hr>
      
      <footer class="footer" style="text-align: right;">
      	<p>Source: National Collision Data Mart</p>
        <p>Report Category: Collision and Accident</p>
        <p>Report Name: Collision of Weather: <%=weather%></p>
      </footer>
      
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
        	var myChart = echarts.init(document.getElementById('main'));
        	var collisionSum  = <%=Arrays.toString(totalCollisions)%>;
            collisionSum.pop();
         	var option = {
        		    title : {
        		        text: 'CollisionNumber',
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
        		            data : [
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(0).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(1).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(2).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(3).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(4).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(5).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(6).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(7).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(8).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(9).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(10).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(11).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(12).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(13).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(14).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(15).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(16).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(17).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(18).accidentType+"'":'-'%>,
										<%=weatherRecord.size()>0?"'"+weatherRecord.get(19).accidentType+"'":'-'%>
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
        		            name:'Collisions',
        		            type:'bar',
        		            data:collisionSum,
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
	
</body>
</html>