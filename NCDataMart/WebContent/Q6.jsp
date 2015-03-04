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
            <li class="active"><a href="Q6.jsp">Collision Of Age And Gender</a></li>
            <li><a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li><a href="Q8.jsp">FatalitiesOfVehicleAndAgeRange</a></li>
            <li><a href="Q9.jsp">VehicleContrastByAccidentTypes</a></li>
            <li><a href="Q10.jsp">AccidentFrequencyByRoadConditions</a></li>
            <li><a href="Q11.jsp">MonthlyNumberOfVehiclesInCollision</a></li>
          </ul>
        </div><!-- sidebar end -->
        
        
<!-- -----------Define a record class to store the results ---------------->
	<%!	public class GenderRecord {		
			String gender = null;
			String totalCollisions = null;	
			GenderRecord(String g, String t) {
				gender = g;
				totalCollisions = t;
			}
		}	
	
		public class AgeRecord {
			String ageRange = null;
			String totalCollisions = null;
			AgeRecord(String a, String t) {
				ageRange = a;
				totalCollisions = t;				
			}
		}
		
		public class GenderAgeRecord {
			String gender = null;
			String ageRange = null;
			String totalCollisions = null;
			GenderAgeRecord(String g, String a, String t) {
				gender = g;
				ageRange = a;
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
		String genderOrAge  = request.getParameter("GenderOrAge");
		if(genderOrAge == null) genderOrAge = "AgeRange";
		String sqlGender = "SELECT CASE WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'F' THEN 'Female' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'M' THEN 'Male' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'N' THEN 'DataNotApplicable (dummy person record)' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'U' THEN 'Unkown (runaway cars)' WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Gender]) = 1 THEN 'ALL' ELSE ISNULL ([CSIProject].[dbo].[PassengerDimension].[Gender],'NA') END AS Gender,	COUNT([CSIProject].[dbo].[Fact].[Passenger_Key]) AS CollisionNumbers FROM [CSIProject].[dbo].[Fact] JOIN [CSIProject].[dbo].[PassengerDimension] ON [CSIProject].[dbo].[Fact].[Passenger_Key] = [CSIProject].[dbo].[PassengerDimension].[Passenger_Key] GROUP BY [CSIProject].[dbo].[PassengerDimension].[Gender] WITH ROLLUP ";
		String sqlAge = "SELECT CASE WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Age_Range])= 1 THEN 'ALL' ELSE ISNULL([CSIProject].[dbo].[PassengerDimension].[Age_Range], 'NA') 	END AS AgeRange,		 	COUNT([CSIProject].[dbo].[Fact].[Passenger_Key]) AS CollisionNumbers	 FROM [CSIProject].[dbo].[Fact] JOIN [CSIProject].[dbo].[PassengerDimension] ON 	[CSIProject].[dbo].[Fact].[Passenger_Key] = [CSIProject].[dbo].[PassengerDimension].[Passenger_Key] GROUP BY [CSIProject].[dbo].[PassengerDimension].[Age_Range] WITH CUBE";
		String sqlGenderAge = "SELECT CASE WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'F' THEN 'Female' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'M' THEN 'Male' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'N' THEN 'DataNotApplicable (dummy person record)' WHEN [CSIProject].[dbo].[PassengerDimension].[Gender] = 'U' THEN 'Unkown (runaway cars)' WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Gender])= 1 THEN 'ALL' ELSE ISNULL([CSIProject].[dbo].[PassengerDimension].[Gender], 'NA') END AS Gender,	  CASE WHEN GROUPING([CSIProject].[dbo].[PassengerDimension].[Age_Range])= 1 THEN 'ALL' ELSE ISNULL([CSIProject].[dbo].[PassengerDimension].[Age_Range], 'NA') END AS AgeRange,	  COUNT([CSIProject].[dbo].[Fact].[Passenger_Key]) AS CollisionNumbers  FROM  [CSIProject].[dbo].[Fact] JOIN  [CSIProject].[dbo].[PassengerDimension] ON [CSIProject].[dbo].[Fact].[Passenger_Key] = [CSIProject].[dbo].[PassengerDimension].[Passenger_Key] GROUP BY  [CSIProject].[dbo].[PassengerDimension].[Age_Range], [CSIProject].[dbo].[PassengerDimension].[Gender] WITH CUBE ";
		ArrayList<GenderRecord> genderRecord = new ArrayList();
		ArrayList<AgeRecord> ageRecord = new ArrayList();
		ArrayList<GenderAgeRecord> genderAgeRecord = new ArrayList();
		
		ResultSet rsGender = stmt.executeQuery(sqlGender);
		while (rsGender.next())  
			{genderRecord.add(new GenderRecord(rsGender.getString(1),rsGender.getString(2)));}			
		
		ResultSet rsAge = stmt.executeQuery(sqlAge);
		while (rsAge.next())
			{ageRecord.add(new AgeRecord(rsAge.getString(1),rsAge.getString(2)));}
		
		ResultSet rsGenderAge = stmt.executeQuery(sqlGenderAge);
		while (rsGenderAge.next())
			{genderAgeRecord.add(new GenderAgeRecord(rsGenderAge.getString(1),rsGenderAge.getString(2),rsGenderAge.getString(3)));}
		
			int[] totalCollisionsGender = new int[genderRecord.size()];	
			int[] totalCollisionsAge = new int[ageRecord.size()];	
			int[] totalCollisionsGenderAgeFemale = new int[12];	
			int[] totalCollisionsGenderAgeMale = new int[12];	
			int[] totalCollisionsGenderAgeDataNotApplicable = new int[12];	
			int[] totalCollisionsGenderAgeUnknown = new int[12];	
			
			for(int i = 0; i < genderRecord.size(); i++)			
				{totalCollisionsGender[i] = Integer.parseInt(genderRecord.get(i).totalCollisions);	}		
			for(int i = 0; i < ageRecord.size(); i++)			
				{totalCollisionsAge[i] = Integer.parseInt(ageRecord.get(i).totalCollisions);		}
			for(int i = 0; i < genderAgeRecord.size(); i++)	{	
				if(i<12)
					totalCollisionsGenderAgeFemale[i] = Integer.parseInt(genderAgeRecord.get(i).totalCollisions);	
				if(i>=13 && i<25)
					totalCollisionsGenderAgeMale[i-13] = Integer.parseInt(genderAgeRecord.get(i).totalCollisions);
				if(i>=26 && i<34)
					totalCollisionsGenderAgeDataNotApplicable[i-26] = Integer.parseInt(genderAgeRecord.get(i).totalCollisions);
				
				totalCollisionsGenderAgeDataNotApplicable[9] = 0;
				totalCollisionsGenderAgeDataNotApplicable[10] = 0;
				totalCollisionsGenderAgeDataNotApplicable[11] = Integer.parseInt(genderAgeRecord.get(35).totalCollisions);			
				if(i>=37 && i<49) 
					totalCollisionsGenderAgeUnknown[i-37] = Integer.parseInt(genderAgeRecord.get(i).totalCollisions);	
				}	
		
			rsGender.close();
			rsAge.close();
			rsGenderAge.close();
			stmt.close();
			conn.close();
		%>	
<!-- ----------------End of Sql--------------- -->             

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
          <h1 class="page-header" align="center">Collisions of Age and Gender</h1>
          <h3 align="center">Collisions of different <%=genderOrAge %></h3>
           <br>
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">
            <form action = "Q6.jsp" method = "post">
              <select id="GenderOrAge" name ="GenderOrAge" style="height: 30px; margin-right: 20px">
                <option value ="Gender">Gender</option>
                <option value ="AgeRange">AgeRange</option>
                <option value="GenderAgeRange">Gender&AgeRange</option>               
              </select>
              <input class="btn btn-success btn-sm" type="submit" value="Confirm" >
            </form>
          </div>
		 <br>
		
		  <div id="main" style="height:400px;"></div>
		  <br>
		  <br>

	
         
          <div class="table-responsive">
            <table class="table table-striped">
                 
            <%
            if(genderOrAge != null)  {
	      		if(genderOrAge.equalsIgnoreCase("Gender")) {	    	
	    	%>
		    	  <thead>
	                <tr>
	                  <th style="text-align: center;">Gender</th>
	                  <th style="text-align: center;">TotalCollision</th>                      
	                </tr>
	              </thead>
	              <tbody>
            <% 
            		for(int i = 0; i < genderRecord.size(); i++) 
              		{
            %>
		                <tr>
		                  <td align = "center"><%=genderRecord.get(i).gender %></td>
		                  <td align = "center"><%=genderRecord.get(i).totalCollisions%></td>               
		                </tr>   
            <% 
                	}
	      		}
            %>
              	 </tbody>    	  		
	    	<% 
	    	 	if(genderOrAge.equalsIgnoreCase("AgeRange")) {
	    	%>			
	    	 	  <thead>
	                <tr>
	                  <th style="text-align: center;">AgeRange</th>
	                  <th style="text-align: center;">TotalCollision</th>                      
	                </tr>
	              </thead>
	              <tbody>
            <% for(int i = 0; i < ageRecord.size(); i++) 
              	{
            %>
                <tr>
                  <td align = "center"><%=ageRecord.get(i).ageRange %></td>
                  <td align = "center"><%=ageRecord.get(i).totalCollisions%></td>               
                </tr>   
            <% 
                }
	    	 }
            %>
              </tbody>	   
	    	<%		
	    		if(genderOrAge.equalsIgnoreCase("GenderAgeRange")) {
	    	%>
	    	 	  <thead>
	                <tr>
	                  <th style="text-align: center;">Gender</th>
	                  <th style="text-align: center;">AgeRange</th>
	                  <th style="text-align: center;">TotalCollision</th>                      
	                </tr>
	              </thead>
	              <tbody>
            <% for(int i = 0; i < genderAgeRecord.size(); i++) 
              	{
            %>
                <tr>
                  <td align = "center"><%=genderAgeRecord.get(i).gender %></td>
                  <td align = "center"><%=genderAgeRecord.get(i).ageRange %></td>
                  <td align = "center"><%=genderAgeRecord.get(i).totalCollisions%></td>               
                </tr>   
            <% 
                } 
	    	}	    	
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
        <p>Report Name: Collisions of different <%=genderOrAge %></p>
      </footer>
      
    </div><!-- Container end  -->
    
	<script src="js/echarts-all.js"></script>
		<script>
        	var myChart = echarts.init(document.getElementById('main'));
        	var collisionGender  = <%=Arrays.toString(totalCollisionsGender)%>;
        	var collisionsGenderAgeFemale = <%=Arrays.toString(totalCollisionsGenderAgeFemale)%>;
        	var collisionsGenderAgeMale = <%=Arrays.toString(totalCollisionsGenderAgeMale)%>;
        	var collisionsGenderAgeDataNotApplicable = <%=Arrays.toString(totalCollisionsGenderAgeDataNotApplicable)%>;
        	var collisionsGenderAgeUnknown = <%=Arrays.toString(totalCollisionsGenderAgeUnknown)%>;
				
			<% if(genderOrAge != null)  {
	      			if(genderOrAge.equalsIgnoreCase("Gender")) {	     
	      	%>
		        	var option = {
		         		    title : {
		         		        text: '',
		         		        subtext: '',
		         		        x:'center'
		         		    },
		         		    tooltip : {
		         		        trigger: 'item',
		         		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		         		    },
		         		    legend: {         		       
		         		        y : 'bottom',
		         		        data:['Female','Male','DataNotApplicable','Unkown']
		         		    },
		         		    toolbox: {
		         		        show : true,
		         		        feature : {
		         		            mark : {show: true},
		         		            dataView : {show: true, readOnly: false},
		         		            magicType : {
		         		                show: true, 
		         		                type: ['pie', 'funnel']
		         		            },
		         		            restore : {show: true},
		         		            saveAsImage : {show: true}
		         		        }
		         		    },
		         		    calculable : true,
		         		    series : [
		         		        {   
		         		        	name:'Proportion',
		         		            type:'pie',
		         		            radius : [40, 110],
		         		            center : ['50%', 200],
		         		            roseType : 'area',
		         		            x: '10%',               // for funnel
		         		            max: 60,                // for funnel
		         		            sort : 'ascending',     // for funnel
		         		            data:[
		         		                {value:<%=totalCollisionsGender[0]/49005.90%>, name:'Female'},
		         		                {value:<%=totalCollisionsGender[1]/49005.90%>, name:'Male'},
		         		                {value:<%=totalCollisionsGender[2]/49005.90%>, name:'DataNotApplicable'},
		         		                {value:<%=totalCollisionsGender[3]/49005.90%>, name:'Unkown'}
		         		            ]
		         		        }
		         		    ]
		         		};        	         	
		        	myChart.setOption(option);      	
	      	<%
	      			}
	      	%>
	      	
	      	<% 
	      			if(genderOrAge.equalsIgnoreCase("AgeRange")) {
	      	%>
				      	var option = {
			         		    title : {
			         		        text: '',
			         		        subtext: '',
			         		        x:'center'
			         		    },
			         		    tooltip : {
			         		        trigger: 'item',
			         		        formatter: "{a} <br/>{b} : {c} ({d}%)"
			         		    },
			         		    legend: {         		       
			         		        y : 'bottom',
			         		        data:['(0-10]','(10-20]','(20-30]','(30-40]','(40-50]','(50-60]','(60-70]','(70-80]','(80-90]','(90-98]','[99-Above]','NA']
			         		    },
			         		    toolbox: {
			         		        show : true,
			         		        feature : {
			         		            mark : {show: true},
			         		            dataView : {show: true, readOnly: false},
			         		            magicType : {
			         		                show: true, 
			         		                type: ['pie', 'funnel']
			         		            },
			         		            restore : {show: true},
			         		            saveAsImage : {show: true}
			         		        }
			         		    },
			         		    calculable : true,
			         		    series : [
			         		        {   
			         		        	name:'Proportion',
			         		            type:'pie',
			         		            radius : [40, 110],
			         		            center : ['50%', 200],
			         		            roseType : 'area',
			         		            x: '10%',               // for funnel
			         		            max: 60,                // for funnel
			         		            sort : 'ascending',     // for funnel
			         		            data:[
			         		                {value:<%=totalCollisionsAge[0]/49005.90%>, name:'(0-10]'},
			         		                {value:<%=totalCollisionsAge[1]/49005.90%>, name:'(10-20] '},
			         		                {value:<%=totalCollisionsAge[2]/49005.90%>, name:'(20-30]'},
			         		                {value:<%=totalCollisionsAge[3]/49005.90%>, name:'(30-40]'},
			         		                {value:<%=totalCollisionsAge[4]/49005.90%>, name:'(40-50]'},
			         		                {value:<%=totalCollisionsAge[5]/49005.90%>, name:'(50-60]'},
			         		                {value:<%=totalCollisionsAge[6]/49005.90%>, name:'(60-70]'},
			         		                {value:<%=totalCollisionsAge[7]/49005.90%>, name:'(70-80]'},
			         		                {value:<%=totalCollisionsAge[8]/49005.90%>, name:'(80-90]'},
			         		                {value:<%=totalCollisionsAge[9]/49005.90%>, name:'(90-98]'},
			         		                {value:<%=totalCollisionsAge[10]/49005.90%>, name:'[99-Above]'},
			         		                {value:<%=totalCollisionsAge[11]/49005.90%>, name:'NA'}
			         		            ]
			         		        }
			         		    ]
			         		};        	         	
			        	myChart.setOption(option);      	      	    	
	      	<%
					}
			%>
			<% 
	  				if(genderOrAge.equalsIgnoreCase("GenderAgeRange")) {
	  		%>
			      		var option = {
			         		    title : {
			         		        text: '',
			         		        subtext: '',			         		       
			         		    },
			         		    tooltip : {
			         		        trigger: 'axis',			         		        
			         		    },
			         		    legend: {         		       
			         		        y : 'bottom',
			         		       data:['Female','Male','DataNotApplicable','Unkown']
			         		    },
			         		    toolbox: {
			         		        show : true,
			         		        feature : {
			         		            mark : {show: true},
			         		            dataView : {show: true, readOnly: false},
			         		            magicType : {
			         		                show: true, 
			         		                type: ['line', 'bar']
			         		            },
			         		            restore : {show: true},
			         		            saveAsImage : {show: true}
			         		        }
			         		    },
			         		    calculable : true,
			         		   xAxis : [
			             		        {
			             		            type : 'category',
			             		            boundaryGap : false,
			             		           data:['(0-10]','(10-20]','(20-30]','(30-40]','(40-50]','(50-60]','(60-70]','(70-80]','(80-90]','(90-98]','[99-Above]','NA']
					         		     }
			             	 	],
			             	   yAxis : [
			                 		        {
			                 		            type : 'value',
			                 		        }
			                 	],
			         		    
			                 	series : [
			                 		        {
			                 		            name:'Female',
			                 		            type:'line',               		          
			                 		            data:collisionsGenderAgeFemale, 
			                 		        },
			                 		       {
			                 		            name:'Male',
			                 		            type:'line',               		          
			                 		            data:collisionsGenderAgeMale, 
			                 		        },
			                 		       {
			                 		            name:'DataNotApplicable',
			                 		            type:'line',               		          
			                 		            data:collisionsGenderAgeDataNotApplicable, 
			                 		        },
			                 		       {
			                 		            name:'Unknown',
			                 		            type:'line',               		          
			                 		            data:collisionsGenderAgeUnknown, 
			                 		        }	   
			                 		     ]    
			         		};        	         	
			        	myChart.setOption(option);      	      	    	
	  		<%
					}
			%>	
			
			<%
				}
			%>
	      	
	      	
 
    </script>
	
</body>
</html>