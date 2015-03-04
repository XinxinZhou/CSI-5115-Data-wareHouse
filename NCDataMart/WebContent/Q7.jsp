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
            <li><a href="Q4.jsp">Collision Of Specific Weather</a></li>
            <li><a href="Q5.jsp">Collision Severity Record</a></li>
            <li><a href="Q6.jsp">Collision Of Age And Gender</a></li>
            <li class="active"><a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h1 class="page-header" align="center">Collision Accident Analytic Report</h1>
          <h3 align="center">Fatalities of Age Range</h3>
           <br>
           
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">           
          </div>



<!-- -----------Define a record class to store the results ---------------->
	<%!	public class AgeFatalityRecord {		
			String ageRange = null;		
			String fatality = null;
			AgeFatalityRecord(String t1, String t2) {
				ageRange = t1;
				fatality = t2;				
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
		String sql = "USE [CSIProject] SELECT CASE WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Age_Range]) = 1 THEN 'ALL' 	ELSE ISNULL([CSIProject].[dbo].[PassengerDimension].[Age_Range],'NA') END AS AgeRange, COUNT ([Medical_Treatment]) AS Fatalities 	 FROM [CSIProject].[dbo].[Fact] JOIN [CSIProject].[dbo].[PassengerDimension] ON	 [CSIProject].[dbo].[Fact].[Passenger_Key] = [CSIProject].[dbo].[PassengerDimension].[Passenger_Key] WHERE [CSIProject].[dbo].[Fact].[Medical_Treatment] = '3' GROUP BY [CSIProject].[dbo].[PassengerDimension].[Age_Range] WITH ROLLUP";				
		ResultSet rs = stmt.executeQuery(sql);
		ArrayList<AgeFatalityRecord> ageFatalityRecord = new ArrayList();		
		while (rs.next()) { 
			ageFatalityRecord.add(new AgeFatalityRecord(rs.getString(1),rs.getString(2)));	
		} 	
			rs.close();
			stmt.close();
			conn.close();
		int[] fatality= new int [ageFatalityRecord.size()];			
		for(int i = 0; i < ageFatalityRecord.size(); i++) {			
			fatality[i] = Integer.parseInt(ageFatalityRecord.get(i).fatality);
		}
	%>	
<!-- ----------------End of Sql--------------- -->     
	
           <div id="main" style="height:400px;"></div>
         
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">AgeRange</th>
                  <th style="text-align: center;">Fatalities</th>        
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < ageFatalityRecord.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=ageFatalityRecord.get(i).ageRange %></td>
                  <td align = "center"><%=ageFatalityRecord.get(i).fatality %></td>              
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
        <p>Report Category: Age and Gender</p>
        <p>Report Name: Fatalities of Age Range</p>
      </footer>     
    </div><!-- Container end  -->
					
			
<script src="js/echarts-all.js"></script>
		<script>
		var fatalityInScript = <%=Arrays.toString(fatality)%> ;   
		fatalityInScript.pop();
		var myChart = echarts.init(document.getElementById('main'));   	  
         	var option = {
         		    title : {
         		        text: '',
         		        subtext: ''
         		    },
         		    tooltip : {
         		        trigger: 'axis'
         		    },
         		    legend: {
         		        data:['Fatalities']
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
         		            data:['(0-10]','(10-20]','(20-30]','(30-40]','(40-50]','(50-60]','(60-70]','(70-80]','(80-90]','(90-98]','[99-Above]','NA']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value'
         		        }
         		    ],
         		    series : [
         		        {
         		            name:'Fatalities',
         		            type:'bar',
         		            data:fatalityInScript,
         		            markPoint : {
         		                data : [
         		                    {type : 'max', name: 'max'},
         		                    {type : 'min', name: 'min'}
         		                ]
         		            },
         		            markLine : {
         		                data : [
         		                    {type : 'average', name: 'ave'}
         		                ]
         		            }
         		        }
         		    ]
         		};
         		                            		                                      
        	myChart.setOption(option);
    </script>
	
</body>
</html> 