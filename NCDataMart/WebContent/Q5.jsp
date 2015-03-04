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
            <li class="active"><a href="Q5.jsp">Collision Severity Record</a></li>
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
        
           <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
           <h3 align="center">Collision Severity Record</h3>
           <br>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">          
          </div>
			<div id="main" style="height:400px;"></div>


<!-- -----------Define a record class to store the results ---------------->
	<%!	public class SeverityRecord {	
			String year = null;
			String severity = null;
			String totalCollisions = null;	
			SeverityRecord(String y, String s, String t) {
				year = y;
				severity = s;
				totalCollisions = t;
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
		
		String sql = "USE [CSIProject]  IF Object_id('Tempdb..#tempE') IS NOT NULL drop table #tempE ; SELECT [CSIProject].[dbo].[CollisionDateDimension].[CalendarYear], [CSIProject].[dbo].[Fact].[Collision_Severity], COUNT([Collision_Severity]) AS Collision_Numbers INTO #tempE FROM [CSIProject].[dbo].[Fact] JOIN  [CSIProject].[dbo].[CollisionDateDimension] ON [CSIProject].[dbo].[Fact].[Date_Key] = [CSIProject].[dbo].[CollisionDateDimension].[Date_Key] GROUP BY  [CSIProject].[dbo].[Fact].[Collision_Severity], [CSIProject].[dbo].[CollisionDateDimension].[CalendarYear]   SELECT CASE WHEN GROUPING([#tempE].[CalendarYear]) = 1 THEN 'ALL' 	ELSE ISNULL([#tempE].[CalendarYear], 'NA') END AS CalendarYear, CASE WHEN GROUPING(CAST([CollisionSeverityDescription].[Description] as varchar(8000)) ) = 1 Then 'ALL' ELSE ISNULL(CAST([CollisionSeverityDescription].[Description] as varchar(8000)), 'NA') END AS CollisionSeverity, SUM(CAST(#tempE.Collision_Numbers AS INT))AS CollisionNumbers FROM #tempE	 JOIN  [CollisionSeverityDescription] ON #tempE.[Collision_Severity] = [CollisionSeverityDescription].[Collision_Severity] GROUP BY #tempE.[CalendarYear], CAST([CollisionSeverityDescription].[Description] as varchar(8000)) WITH CUBE  ";
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<SeverityRecord> weatherRecord = new ArrayList();
		while (rs.next()) { 
			weatherRecord.add(new SeverityRecord(rs.getString(1),rs.getString(2),rs.getString(3)));
		} 
		int[] totalCollisions_fatality = new int[13];	
		int[] totalCollisions_nonFatality = new int[13];
		for(int i = 0; i < weatherRecord.size(); i++)
			{				
				if(i<13)
					totalCollisions_fatality[i] = Integer.parseInt(weatherRecord.get(i).totalCollisions);	
				if(i>=14 && i<27)
					totalCollisions_nonFatality[i-14] = Integer.parseInt(weatherRecord.get(i).totalCollisions);
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
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">CollisionSeverity</th>   
                  <th style="text-align: center;">Collisions</th>                   
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < weatherRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=weatherRecord.get(i).year %></td>
                  <td align = "center"><%=weatherRecord.get(i).severity %></td>
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
        <p>Report Name: Collision Severity Record</p>
      </footer>
      
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
        	var myChart = echarts.init(document.getElementById('main'));
        	var collisionSum_fatality  = <%=Arrays.toString(totalCollisions_fatality)%>;
        	var collisionSum_nonFatality  = <%=Arrays.toString(totalCollisions_nonFatality)%>;
           
         	var option = {
        		    title : {
        		        text: 'CollisionNumber',
        		        subtext: ''
        		    },
        		    tooltip : {
        		        trigger: 'axis'
        		    },
        		    legend: {
        		        data:['Fatality','NoFatality']    		    	
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
        		            data : ['1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011']
        		        }
        		    ],
        		    yAxis : [
        		        {
        		            type : 'value'
        		        }
        		    ],
        		    series : [
        		        {
        		            name:'Fatality',
        		            type:'bar',
        		            data:collisionSum_fatality,
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
        		        	 name:'NoFatality',
         		            type:'bar',
         		            data:collisionSum_nonFatality,
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