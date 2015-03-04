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
            <li class="active"><a href="Q1.jsp">Collision Of Specific Month</a></li>
            <li><a href="Q2.jsp">Explore Data Of Date Hierarchy</a></li>
            <li><a href="Q3.jsp">CollisionOfDifferentAccidentTypes</a></li>
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
        
<!-- -----------Define a record class to store the results ---------------->
	<%!	public class SpecificMonthRecord {		
			String year = null;
			String totalCollisions = null;	
			SpecificMonthRecord(String y, String t) {
				year = y;
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
		String month = request.getParameter("Month");
		if(month == null) month = "January";
		String sql = "Select CASE WHEN GROUPING([CollisionDateDimension].CalendarYear) = 1 THEN 'ALL' ELSE ISNULL([CollisionDateDimension].CalendarYear,'NA') END AS CalendarYear,COUNT([CSIProject].[dbo].[Fact].Date_Key) AS TotalCollisions from [CSIProject].[dbo].[Fact] JOIN [CollisionDateDimension] ON [CSIProject].[dbo].[Fact].Date_Key = [CollisionDateDimension].Date_Key WHERE [CollisionDateDimension].MonthName = '" + month + "' GROUP BY [CollisionDateDimension].CalendarYear WITH CUBE";
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<SpecificMonthRecord> monthRecord = new ArrayList();
		while (rs.next()) { 
	%>
			<% 
				monthRecord.add(new SpecificMonthRecord(rs.getString(1),rs.getString(2)));
			%>
	
		<% } %>
		
		<%
			int[] totalCollisions = new int[monthRecord.size()];
		
			for(int i = 0; i < monthRecord.size(); i++)
			{
				totalCollisions[i] = Integer.parseInt(monthRecord.get(i).totalCollisions);
				
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
          <h3 align="center">Collision Number in <%=month%> in Previous 13 Years</h3>
          <br>
          
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">
            <form action = "Q1.jsp" method = "post">
              <select id="Month" name ="Month" style="height: 30px; margin-right: 20px">
                <option value ="January">January</option>
                <option value ="February">February</option>
                <option value="March">March</option>
                <option value="April">April</option>
                <option value="May">May</option>
                <option value="June">June</option>
                <option value="July">July</option>
                <option value="August">August</option>
                <option value="September">September</option>
                <option value="October">October</option>
                <option value="November">November</option>
                <option value="December">December</option>
              </select>
              <input class="btn btn-success btn-sm" type="submit" value="Confirm" >
            </form>
            <br>
          </div>
          	<div id="main" style="height:400px;"></div>

          <div class="table-responsive">
            <table class="table table-striped">
              <thead >
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < monthRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=monthRecord.get(i).year %></td>
                  <td align = "center"><%=monthRecord.get(i).totalCollisions%></td>               
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
        <p>Report Name: Collision Number in <%=month%> in Previous 13 Years</p>
      </footer>
      
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
        	var myChart = echarts.init(document.getElementById('main'));
        	var collisionSum  = <%=Arrays.toString(totalCollisions)%>;
            collisionSum.pop();
         	var option = {
        		    title : {
        		        text: '',
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