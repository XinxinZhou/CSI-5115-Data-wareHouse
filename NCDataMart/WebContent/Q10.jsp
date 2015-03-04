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
            <li class="active"><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
          <h3 align="center">Accident Frequency With Different Road Conditions</h3>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>
		 <br>


<!-- -----------Define a record class to store the results ---------------->
	<%!	public class Cube{		
			String roadwayConfiguration = null;		
			String roadSurface = null;
			String roadAlignment = null;
			String accidentSum = null;
			String accidentPercentage = null;
			Cube(String t1, String t2, String t3, String t4, String t5) {
				roadwayConfiguration = t1;
				roadSurface = t2;	
				roadAlignment = t3;
				accidentSum = t4;
				accidentPercentage = t5;				
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
		String sql = "USE [CSIProject]  IF Object_id('Tempdb..#tempJ') IS NOT NULL   	drop table #tempJ ;  SELECT 	 	[CSIProject].[dbo].[CollisionDimension].Roadway_Configuration, 	[CSIProject].[dbo].[CollisionDimension].Road_Surface, 	[CSIProject].[dbo].[CollisionDimension].Road_Alignment, 	COUNT ([CSIProject].[dbo].[Fact].[Collision_Key]) AS AccidentSum, 	CAST(ROUND(CAST(COUNT ([CSIProject].[dbo].[Fact].[Collision_Key]) AS FLOAT)/4900590, 6) AS NUMERIC(8,6))AS AccidentPercentage	 INTO #tempJ  FROM  	[CSIProject].[dbo].[Fact]  JOIN  	[CSIProject].[dbo].[CollisionDimension] ON 	[CSIProject].[dbo].[Fact].[Collision_Key] = [CSIProject].[dbo].[CollisionDimension].[Collision_Key]  GROUP BY	 	[CSIProject].[dbo].[CollisionDimension].Road_Alignment, 	[CSIProject].[dbo].[CollisionDimension].Road_Surface, 	[CSIProject].[dbo].[CollisionDimension].Roadway_Configuration  	  SELECT  	CASE  		WHEN GROUPING(CAST([CSIProject].[dbo].[RoadwayConfigurationDescription].[Description] AS VARCHAR(8000))) = 1  			THEN 'ALL' 		ELSE ISNULL(CAST([CSIProject].[dbo].[RoadwayConfigurationDescription].[Description] AS VARCHAR(8000)),'NA')  	END AS RoadwayConfiguration, 	 	CASE  		WHEN GROUPING(CAST([CSIProject].[dbo].[RoadSurfaceDescription].[Description] AS varchar(8000))) = 1 THEN 'ALL' 		ELSE ISNULL(CAST([CSIProject].[dbo].[RoadSurfaceDescription].[Description] AS varchar(8000)),'NA')  	END AS RoadSurface,		 	 	CASE  		WHEN GROUPING(CAST([CSIProject].[dbo].[RoadAlignmentDescription].[Description] AS varchar(8000))) = 1 THEN 'ALL' 		ELSE ISNULL(CAST([CSIProject].[dbo].[RoadAlignmentDescription].[Description] AS varchar(8000)),'NA')  	END AS RoadAlignment,		 	 	SUM(#tempJ.AccidentSum) AS AccidentSum, 	CAST(CAST(SUM(#tempJ.AccidentPercentage)*100 AS NUMERIC(6,4)) AS VARCHAR(100)) + '%' AS AccidentPercentage FROM 	#tempJ   JOIN  	[CSIProject].[dbo].[RoadwayConfigurationDescription] ON  	#tempJ.Roadway_Configuration = [CSIProject].[dbo].[RoadwayConfigurationDescription].[Roadway_Configuration]  JOIN 	[CSIProject].[dbo].[RoadSurfaceDescription] ON 	#tempJ.Road_Surface = [CSIProject].[dbo].[RoadSurfaceDescription].[Road_Surface] JOIN 	[CSIProject].[dbo].[RoadAlignmentDescription] ON  	#tempJ.Road_Alignment = [CSIProject].[dbo].[RoadAlignmentDescription].Road_Alignment  GROUP BY  	CAST([CSIProject].[dbo].[RoadAlignmentDescription].[Description] AS varchar(8000)), 	CAST([CSIProject].[dbo].[RoadSurfaceDescription].[Description] AS varchar(8000)), 	CAST([CSIProject].[dbo].[RoadwayConfigurationDescription].[Description] AS VARCHAR(8000)) WITH CUBE";						
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<Cube> cube = new ArrayList();		
		while (rs.next()) { 
			cube.add(new Cube(rs.getString(1),rs.getString(2),rs.getString(3),rs.getString(4),rs.getString(5)));	
		} 	
			rs.close();
			stmt.close();
			conn.close();
		
	

	    
	%>	
	
	
<!-- ----------------End of Sql--------------- -->     
	
         
          <div class="table-responsive">
          
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Roadway Configuration</th>
                  <th style="text-align: center;">Road Surface</th>
                  <th style="text-align: center;">Road Alignment</th>    
                  <th style="text-align: center;">Frequency</th>    
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < cube.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=cube.get(i).roadwayConfiguration %></td>
                  <td align = "center"><%=cube.get(i).roadSurface %></td>
                  <td align = "center"><%=cube.get(i).roadAlignment %></td>     
                  <td align = "center"><%=cube.get(i).accidentPercentage %></td>          
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
          </div><!-- table container end -->
          <p>*Data element is not applicable - eg:"dummy" vehicle record created for the pedestrian</p>
           
        <!--   <h2 class="sub-header">Vehicle Type Contrast</h2>
		  <div id="main" style="height:400px;"></div>
          --> 
        </div><!-- main content end -->
        
      </div> 
      
      <hr>
      <footer class="footer" style="text-align: right;">
      	<p>Source: National Collision Data Mart</p>
        <p>Report Category: Road and Vehicle</p>
        <p>Report Name: Accident Frequency With Different Road Conditions</p>
      </footer>
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
	
		var myChart = echarts.init(document.getElementById('main'));   	          	         		                            		                                      
       //myChart.setOption(option);
    </script>
	
</body>
</html> 