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
            <li  class="active"><a href="Q3.jsp">CollisionOfDifferentAccidentTypes</a></li>
            <li><a href="Q4.jsp">Collision Of Specific Weather</a></li>
            <li><a href="Q5.jsp">Collision Severity Record</a></li>
            <li><a href="Q6.jsp">Collision Of Age And Gender</a></li>
            <li><a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">               
          <h2 class="page-header" align="center">Collision Accident Analytic Report</h2>
          <h3 align="center">Collision of Different Accident Types</h3>
         
                   
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>
 		  
		  <div id="main" style="height:600px; padding-left: 200px;"></div>

<!-- -----------Define a record class to store the results ---------------->
	<%!	public class AccidentTypeRecord {		
			String type = null;		
			String totalCollisions = null;
			AccidentTypeRecord(String t1, String t2) {
				type = t1;
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
		
		String sql = "USE [CSIProject] IF Object_id('Tempdb..#temp') IS NOT NULL drop table #temp ;SELECT	[CSIProject].[dbo].[CollisionDimension].[Collision_Configuration], COUNT(Number_Of_Vehicles) AS TotalCollisions  into #temp FROM [CSIProject].[dbo].[Fact] JOIN  [CSIProject].[dbo].[CollisionDimension] ON [Fact].[Collision_Key] = [CollisionDimension].[Collision_Key] Group By [CSIProject].[dbo].[CollisionDimension].[Collision_Configuration] Select DISTINCT CASE WHEN GROUPING(CAST([Description] as varchar(8000))) = 1 THEN 'ALL'	ELSE ISNULL(CAST([Description] as varchar(8000)),'NA')	END AS 'Type of accident',	sum(#temp.TotalCollisions) AS TotalCollisions from [CSIProject].[dbo].[CollisionConfigurationDescription] JOIN #temp ON #temp.[Collision_Configuration] = [CSIProject].[dbo].[CollisionConfigurationDescription].[Collision_Configuration] GROUP BY CAST([Description] as varchar(8000)), #temp.TotalCollisions WITH ROLLUP ORDER BY TotalCollisions"; 
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<AccidentTypeRecord> typeRecord = new ArrayList();
		while (rs.next()) { 
			typeRecord.add(new AccidentTypeRecord(rs.getString(1),rs.getString(2)));	
		} 	
			rs.close();
			stmt.close();
			conn.close();
		int[] collisions= new int [typeRecord.size()];
		String accidentTypes = "";
		
		for(int i = 0; i < typeRecord.size(); i++) {
			if(i < typeRecord.size()-1)
				accidentTypes += typeRecord.get(i).type + ",";
			else 
				accidentTypes += typeRecord.get(i).type;
			
			collisions[i] = Integer.parseInt(typeRecord.get(i).totalCollisions);
		}
	%>	
<!-- ----------------End of Sql--------------- -->     
	
         
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">AccidentTypes</th>
                  <th style="text-align: center;">Collisions</th>        
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < typeRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=typeRecord.get(i).type %></td>
                  <td align = "center"><%=typeRecord.get(i).totalCollisions %></td>              
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
        <p>Report Name: Collision of Different Accident Types</p>
      </footer>
      
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
		var collisionInScript = <%=Arrays.toString(collisions)%> ;   
		var typeInScript = <%= "'"+accidentTypes+"'"%> ; 	
		var myChart = echarts.init(document.getElementById('main'));   
		  
         	var option = {
         		    title : {
         		        text: '',
         		        subtext: ''
         		    },
         		    tooltip : {
         		        trigger: 'item',
         		        formatter: "{a} <br/>{b} : {c}%"
         		    },
         		    toolbox: {
         		        show : true,
         		        feature : {
         		            mark : {show: true},
         		            dataView : {show: true, readOnly: false},
         		            restore : {show: true},
         		            saveAsImage : {show: true}
         		        }
         		    },
         		    legend: {
         		        data : []
         		    },
         		    calculable : true,
         		    series : [
         		        {
         		            name:'',
         		            type:'funnel',
         		            width: '60%',
         		            data:[   
         		             	{value:<%=Float.parseFloat(typeRecord.get(20).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(20).type+"'"%>},  
         		               	{value:<%=Float.parseFloat(typeRecord.get(19).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(19).type+"'"%>},
         		              	{value:<%=Float.parseFloat(typeRecord.get(18).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(18).type+"'"%>},
         		             	{value:<%=Float.parseFloat(typeRecord.get(17).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(17).type+"'"%>},
         		            	{value:<%=Float.parseFloat(typeRecord.get(16).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(16).type+"'"%>},
         		           		{value:<%=Float.parseFloat(typeRecord.get(15).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(15).type+"'"%>},
         		          		{value:<%=Float.parseFloat(typeRecord.get(14).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(14).type+"'"%>},
         		         		{value:<%=Float.parseFloat(typeRecord.get(13).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(13).type+"'"%>},
         		        		{value:<%=Float.parseFloat(typeRecord.get(12).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(12).type+"'"%>},
         		       			{value:<%=Float.parseFloat(typeRecord.get(11).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(11).type+"'"%>},
         		      			{value:<%=Float.parseFloat(typeRecord.get(10).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(10).type+"'"%>},
         		     			{value:<%=Float.parseFloat(typeRecord.get(9).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(9).type+"'"%>},
         		    			{value:<%=Float.parseFloat(typeRecord.get(8).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(8).type+"'"%>},
         		   				{value:<%=Float.parseFloat(typeRecord.get(7).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(7).type+"'"%>},
         		  				{value:<%=Float.parseFloat(typeRecord.get(6).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(6).type+"'"%>},
         						{value:<%=Float.parseFloat(typeRecord.get(5).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(5).type+"'"%>},
         						{value:<%=Float.parseFloat(typeRecord.get(4).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(4).type+"'"%>},
         						{value:<%=Float.parseFloat(typeRecord.get(3).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(3).type+"'"%>},
         						{value:<%=Float.parseFloat(typeRecord.get(2).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(2).type+"'"%>},
         						{value:<%=Float.parseFloat(typeRecord.get(1).totalCollisions)/49005.90%>, name:<%="'"+typeRecord.get(1).type+"'"%>}
         		            ]
         		        }       		        
         		    ]
         		};         		                                      
        	myChart.setOption(option);
    </script>
	
</body>
</html> 