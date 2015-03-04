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
    
    
 <!-- -----------Define a record   
		 class to store the results ---------------->
	<%!	public class SpecificDayRecord {		
			String year = null;
			String month = null;
			String day = null;
			String totalCollisions = null;
			SpecificDayRecord(String y, String m, String d, String t) {
				year = y;
				month = m;
				day = d;
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
		String year = request.getParameter("Year");
		String month = request.getParameter("Month");		
		String day = request.getParameter("DayOfWeek");	
		if(year == null) year ="1999";
		if(month == null) month = "01";
		if(day == null) day = "1";
		
		
		String monthName = null;
		String dayName = null;
		
	
		if(day != null){
			if(!day.contains("ALL"))
				switch (Integer.parseInt(day)) {
					case 1: dayName = "Monday"; break;
					case 2: dayName = "Tuesday"; break;
					case 3: dayName = "Wednesday"; break;
					case 4: dayName = "Thursday"; break;
					case 5: dayName = "Friday"; break;
					case 6: dayName = "Saturday"; break;
					case 7: dayName = "Sunday"; break;
					default: dayName = day;
				}
			else 
				dayName = "All Days";		
		}
					
		
		if(month != null){
			if(!month.contains("ALL")) 
				switch (Integer.parseInt(month)) {
				case 1: monthName = "January"; break;
				case 2: monthName = "February"; break;
				case 3: monthName = "March"; break;
				case 4: monthName = "April"; break;
				case 5: monthName = "May"; break;
				case 6: monthName = "June"; break;
				case 7: monthName = "July"; break;
				case 8: monthName = "August"; break;
				case 9: monthName = "September"; break;
				case 10: monthName = "October"; break;
				case 11: monthName = "November"; break;
				case 12: monthName = "December"; break;
				default: monthName = month;
				}
			else
				monthName = "All Months";
		}
			
		
 	
		String sqlAllAllAll = "SELECT DISTINCT  CASE  WHEN GROUPING(CalendarYear) = 1 THEN 'ALL'  ELSE ISNULL(CalendarYear,'NA')  END AS CalendarYear,	 CASE WHEN GROUPING(MonthOfYear) = 1 THEN 'ALL'	 ELSE ISNULL(MonthOfYear,'NA') 	 END AS MonthOfYear,	 CASE WHEN GROUPING([DayOfWeek]) = 1 THEN 'ALL'	 ELSE ISNULL([DayOfWeek],'NA') 	 END AS [DayOfWeek],	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE ORDER BY [CalendarYear],[MonthOfYear],[DayOfWeek] ";			
		String sqlAllAllDay = "SELECT DISTINCT CASE WHEN GROUPING(CalendarYear) = 1 THEN 'ALL' ELSE ISNULL(CalendarYear,'NA') END AS CalendarYear,	CASE WHEN GROUPING(MonthOfYear) = 1 THEN 'ALL'	ELSE ISNULL(MonthOfYear,'NA') 	END AS MonthOfYear,	COUNT(Number_Of_Vehicles) AS TotalCollisions FROM Fact JOIN  CollisionDateDimension ON Fact.Date_Key = CollisionDateDimension.Date_Key Where [DayOfWeek] = '" + day +"' Group BY CalendarYear,MonthOfYear WITH CUBE";
		String sqlAllMonthDay = "SELECT DISTINCT  CASE  WHEN GROUPING(CalendarYear) = 1 THEN 'ALL'  ELSE ISNULL(CalendarYear,'NA')  END AS CalendarYear,	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE CollisionDateDimension.MonthOfYear = '"+ month +"' and [DayOfWeek] = '" + day +"' Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE " ;
		String sqlAllMonthAll = "SELECT DISTINCT  CASE  WHEN GROUPING(CalendarYear) = 1 THEN 'ALL'  ELSE ISNULL(CalendarYear,'NA')  END AS CalendarYear,	 CASE WHEN GROUPING([DayOfWeek]) = 1 THEN 'ALL'	 ELSE ISNULL([DayOfWeek],'NA') 	 END AS [DayOfWeek],	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE CollisionDateDimension.MonthOfYear = '" + month +"'  Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE ";
		String sqlYearMonthDay = "SELECT DISTINCT  CASE  WHEN GROUPING(CalendarYear) = 1 THEN 'ALL'  ELSE ISNULL(CalendarYear,'NA')  END AS CalendarYear, MonthOfYear, CASE WHEN GROUPING([DayOfWeek]) = 1 THEN 'ALL'	 ELSE ISNULL([DayOfWeek],'NA') 	 END AS [DayOfWeek],	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE  CalendarYear = '" + year + "' AND CollisionDateDimension.MonthOfYear = '" + month +"' AND [DayOfWeek] = '" + day + "' Group BY CalendarYear,MonthOfYear,[DayOfWeek] " ;
		String sqlYearMonthAll = "SELECT DISTINCT  CASE WHEN GROUPING([DayOfWeek]) = 1 THEN 'ALL'	 ELSE ISNULL([DayOfWeek],'NA') 	 END AS [DayOfWeek],	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE [CalendarYear] = '" + year + "' AND [MonthOfYear] = '" + month + "' Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE ORDER BY [DayOfWeek] " ;
		String sqlYearAllAll = "SELECT DISTINCT  CASE WHEN GROUPING(MonthOfYear) = 1 THEN 'ALL'	 ELSE ISNULL(MonthOfYear,'NA') 	 END AS MonthOfYear,	 CASE WHEN GROUPING([DayOfWeek]) = 1 THEN 'ALL'	 ELSE ISNULL([DayOfWeek],'NA') 	 END AS [DayOfWeek],	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE [CalendarYear] = '"+ year +"' Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE ORDER BY [MonthOfYear],[DayOfWeek] " ;
		String sqlYearAllDay = "SELECT DISTINCT  CASE WHEN GROUPING(MonthOfYear) = 1 THEN 'ALL'	 ELSE ISNULL(MonthOfYear,'NA') 	 END AS MonthOfYear,	 COUNT(Number_Of_Vehicles) AS TotalCollisions  FROM Fact  JOIN  CollisionDateDimension  ON Fact.Date_Key = CollisionDateDimension.Date_Key  WHERE [CalendarYear] = '"+ year +"' AND [DayOfWeek] = '"+ day +"' Group BY CalendarYear,MonthOfYear,[DayOfWeek] WITH CUBE ORDER BY [MonthOfYear] " ;

		ArrayList<SpecificDayRecord> dayRecord1 = new ArrayList(); //3D, no figure
		ArrayList<SpecificDayRecord> dayRecord2 = new ArrayList(); //2D
		ArrayList<SpecificDayRecord> dayRecord3 = new ArrayList();
		ArrayList<SpecificDayRecord> dayRecord4 = new ArrayList();
		ArrayList<SpecificDayRecord> dayRecord5 = new ArrayList();
		ArrayList<SpecificDayRecord> dayRecord6 = new ArrayList();
		ArrayList<SpecificDayRecord> dayRecord7 = new ArrayList();
		ArrayList<SpecificDayRecord> dayRecord8 = new ArrayList();
		
		
		
		
		int type = 0;
		int[] type3 = new int[13]; int count3 = 0;
		int[][] type4 = new int[14][8]; 
		int[] type6 = new int[8]; int count6 = 0;
		int[][] type7 = new int[12][8];  
		int[] type8 = new int[12]; int count8 = 0;
		//if(year.contains("ALL") && month.contains("ALL") && day.contains("ALL")) {
		//	type = 1;
			ResultSet rsAllAllAll = stmt.executeQuery(sqlAllAllAll);
			while (rsAllAllAll.next()) { 
				dayRecord1.add(new SpecificDayRecord(rsAllAllAll.getString(1),rsAllAllAll.getString(2),rsAllAllAll.getString(3),rsAllAllAll.getString(4)));	
			} 	
			rsAllAllAll.close();
		//}
		//if(year.contains("ALL") && month.contains("ALL") && !day.contains("ALL")) {
		//	type = 2;
			ResultSet rsAllAllDay = stmt.executeQuery(sqlAllAllDay);
			while (rsAllAllDay.next()) { 
				dayRecord2.add(new SpecificDayRecord(rsAllAllDay.getString(1),rsAllAllDay.getString(2),day,rsAllAllDay.getString(3)));	
			} 	
			rsAllAllDay.close();
		//}
		//if(year.contains("ALL") && !month.contains("ALL") && !day.contains("ALL")) {
		//type = 3;
			ResultSet rsAllMonthDay = stmt.executeQuery(sqlAllMonthDay);
			while (rsAllMonthDay.next()) { 
				dayRecord3.add(new SpecificDayRecord(rsAllMonthDay.getString(1),month,day,rsAllMonthDay.getString(2)));	
				if(count3<13) type3[count3++] = Integer.parseInt(rsAllMonthDay.getString(2));
			} 	
			rsAllMonthDay.close();
		//}
		//if(year.contains("ALL") && !month.contains("ALL") && day.contains("ALL")) {
		//	type = 4;
			ResultSet rsAllMonthAll = stmt.executeQuery(sqlAllMonthAll);
			while (rsAllMonthAll.next()) { 
				dayRecord4.add(new SpecificDayRecord(rsAllMonthAll.getString(1),month,rsAllMonthAll.getString(2),rsAllMonthAll.getString(3)));
				if(!rsAllMonthAll.getString(1).contains("ALL")) {
					if(!rsAllMonthAll.getString(2).contains("ALL")) {
						if(!rsAllMonthAll.getString(2).contains("U"))
							type4[(Integer.parseInt(rsAllMonthAll.getString(1))-1999)][Integer.parseInt(rsAllMonthAll.getString(2))-1] = Integer.parseInt(rsAllMonthAll.getString(3));
						else
							type4[(Integer.parseInt(rsAllMonthAll.getString(1))-1999)][7] = Integer.parseInt(rsAllMonthAll.getString(3));
					}
				} else{
					if(!rsAllMonthAll.getString(2).contains("ALL")) {
						if(!rsAllMonthAll.getString(2).contains("U"))
							type4[13][Integer.parseInt(rsAllMonthAll.getString(2))-1] = Integer.parseInt(rsAllMonthAll.getString(3));
						else
							type4[13][7] = Integer.parseInt(rsAllMonthAll.getString(3));
					}
				}			
			} 	
			rsAllMonthAll.close();
		//}
		//if(!year.contains("ALL") && !month.contains("ALL") && !day.contains("ALL")) {
		//	type = 5;
			ResultSet rsYearMonthDay = stmt.executeQuery(sqlYearMonthDay);
			while (rsYearMonthDay.next()) { 
				dayRecord5.add(new SpecificDayRecord(rsYearMonthDay.getString(1),rsYearMonthDay.getString(2),rsYearMonthDay.getString(3),rsYearMonthDay.getString(4)));	
			} 	
			rsYearMonthDay.close();
		//}
		//if(!year.contains("ALL") && !month.contains("ALL") && day.contains("ALL")) {
		//	type = 6;
			ResultSet rsYearMonthAll = stmt.executeQuery(sqlYearMonthAll);
			while (rsYearMonthAll.next()) { 
				dayRecord6.add(new SpecificDayRecord(year,month,rsYearMonthAll.getString(1),rsYearMonthAll.getString(2)));
				if(!rsYearMonthAll.getString(1).contains("ALL"))
					type6[count6++] = Integer.parseInt(rsYearMonthAll.getString(2));
			} 	
			rsYearMonthAll.close();
		//}
		//if(!year.contains("ALL") && month.contains("ALL") && day.contains("ALL")) {
		//	type = 7;
			ResultSet rsYearAllAll = stmt.executeQuery(sqlYearAllAll);
			while (rsYearAllAll.next()) { 
				dayRecord7.add(new SpecificDayRecord(year,rsYearAllAll.getString(1),rsYearAllAll.getString(2),rsYearAllAll.getString(3)));			
				if(!rsYearAllAll.getString(1).contains("ALL") && !rsYearAllAll.getString(1).contains("U")) {
					if(!rsYearAllAll.getString(2).contains("ALL")) {
						if(!rsYearAllAll.getString(2).contains("U"))
							type7[(Integer.parseInt(rsYearAllAll.getString(1))-1)][Integer.parseInt(rsYearAllAll.getString(2))-1] = Integer.parseInt(rsYearAllAll.getString(3));
						else
							type7[(Integer.parseInt(rsYearAllAll.getString(1))-1)][7] = Integer.parseInt(rsYearAllAll.getString(3));
					}
				} 
			}
			rsYearAllAll.close();
		//}
		//if(!year.contains("ALL") && month.contains("ALL") && !day.contains("ALL")) {
		//	type = 8;
			ResultSet rsYearAllDay = stmt.executeQuery(sqlYearAllDay);
			while (rsYearAllDay.next()) { 
				dayRecord8.add(new SpecificDayRecord(year,rsYearAllDay.getString(1),day,rsYearAllDay.getString(2)));	
				if(count8 < 12) type8[count8++] = Integer.parseInt(rsYearAllDay.getString(2));
			} 	
			rsYearAllDay.close();
		//}	
			stmt.close();
			conn.close();
			
			
			int[][] yearMonthNum= new int [14][12];	//type 2
			 
			
			if(year != null && month != null && day != null){
				if(year.contains("ALL") && month.contains("ALL") && day.contains("ALL")) type = 1;
				if(year.contains("ALL") && month.contains("ALL") && !day.contains("ALL")) {
					type = 2;
					for(int i = 0; i < dayRecord2.size(); i++) {
						if(!dayRecord2.get(i).year.contains("ALL")) {
							if(!dayRecord2.get(i).month.contains("ALL")) {
								yearMonthNum[(Integer.parseInt(dayRecord2.get(i).year)-1999)][Integer.parseInt(dayRecord2.get(i).month)-1] = Integer.parseInt(dayRecord2.get(i).totalCollisions);
							}
						} else{
							if(!dayRecord2.get(i).month.contains("ALL")) {
								yearMonthNum[13][Integer.parseInt(dayRecord2.get(i).month)-1] = Integer.parseInt(dayRecord2.get(i).totalCollisions);
							}
						}
					}
				}
				if(year.contains("ALL") && !month.contains("ALL") && !day.contains("ALL")) {
					type = 3;
					
				}
				if(year.contains("ALL") && !month.contains("ALL") && day.contains("ALL")) type = 4;
				if(!year.contains("ALL") && !month.contains("ALL") && !day.contains("ALL")) type = 5;
				if(!year.contains("ALL") && !month.contains("ALL") && day.contains("ALL")) type = 6;
				if(!year.contains("ALL") && month.contains("ALL") && day.contains("ALL")) type = 7;
				if(!year.contains("ALL") && month.contains("ALL") && !day.contains("ALL")) type = 8;
			}

		%>	
<!-- ----------------End of Sql--------------- -->        
    
    
    
    
    
     <!-- Main container -->
    <div class="container-fluid">
      <div class="row">   
        <div class="col-sm-3 col-md-2 sidebar"><!-- sidebar -->
          <ul class="nav nav-sidebar">
            <li><a href="Q1.jsp">Collision Of Specific Month</a></li>
            <li class="active"><a href="Q2.jsp">Explore Data Of Date Hierarchy</a></li>
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
        

               
 <!-- main content area -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        
       <h2 class="page-header" align="center">Collision Accident Analytic Report</h2>
       <h3 align="center">        
	         <%switch(type) { 
	         	  case 0:%> Collision of Monday in January,1999<%break; 
		          case 1: %> Collision From 1999 To 2011
		         <%break;case 2: %> Collision Of <%=dayName%> Every Month From 1999 To 2011 
		         <%break;case 3: %> Collision Of <%=dayName%>,<%=monthName %> From 1999 To 2011 
		         <%break;case 4: %> Collision Of <%=monthName%> From 1999 To 2011 
		         <%break;case 5: %> Collision Of <%=dayName%>,<%=monthName%>,<%=year%>
		         <%break;case 6: %> Collision Of All Days In <%=monthName%>,<%=year%> 
		         <%break;case 7: %> Collision Of <%=year%> 
		         <%break;case 8: %> Collision Of <%=dayName%> Every Month,<%=year%> 
	             <%break;default:%> Collision
	         <%} %>         
         </h3>
          <br>
          <!-- Control buttons -->
          <div class="btn-control" style="text-align: center">
            <form action = "Q2.jsp" method = "post">
               <select id="Year" name ="Year" style="height: 30px; margin-right: 20px">
                <option value ="1999">1999</option>
                <option value ="2000">2000</option>
                <option value ="2001">2001</option>
                <option value ="2002">2002</option>
                <option value ="2003">2003</option>
                <option value ="2004">2004</option>
                <option value ="2005">2005</option>
                <option value ="2006">2006</option>
                <option value ="2007">2007</option>
                <option value ="2008">2008</option>
                <option value ="2009">2009</option>
                <option value ="2010">2010</option>
				<option value ="2011">2011</option>      
				<option value ="ALL">ALL</option>                           
             </select>            
             <select id="Month" name ="Month" style="height: 30px; margin-right: 20px">
                <option value ="01">January</option>
                <option value ="02">February</option>
                <option value ="03">March</option>
                <option value ="04">April</option>
                <option value ="05">May</option>
                <option value ="06">June</option>
                <option value ="07">July</option>
                <option value ="08">August</option>
                <option value ="09">September</option>
                <option value ="10">October</option>
                <option value ="11">November</option>
                <option value ="12">December</option>
                <option value ="ALL">ALL</option>                     
              </select>          
              <select id="DayOfWeek" name ="DayOfWeek" style="height: 30px; margin-right: 20px">
                <option value ="1">Monday</option>
                <option value ="2">Tuesday</option>
                <option value="3">Wednesday</option>
                <option value="4">Thursday</option>
                <option value="5">Friday</option>
                <option value="6">Saturday</option>
                <option value="7">Sunday</option>
                <option value="ALL">ALL</option>
              </select>              
              <input class="btn btn-success btn-sm" type="submit" value="Confirm" >
            </form>
          </div>
			<br>

        
    
		  <div id="main" style="height:400px;"></div>

	<!--  
         <h2 class="sub-header">   
         
         <%switch(type) { 
         	  case 0:%> Record <%break; 
	          case 1: %> Detaialed Record From 1999 To 2011
	         <%break;case 2: %> Record Of <%=dayName%> Every Month From 1999 To 2011 
	         <%break;case 3: %> Record Of <%=dayName%>,<%=monthName %> From 1999 To 2011 
	         <%break;case 4: %> Record Of <%=monthName%> From 1999 To 2011 
	         <%break;case 5: %> Record Of <%=dayName%>,<%=monthName%>,<%=year%>
	         <%break;case 6: %> Record Of All Days In <%=monthName%>,<%=year%> 
	         <%break;case 7: %> Record Of <%=year%> 
	         <%break;case 8: %> Record Of <%=dayName%> Every Month,<%=year%> 
             <%break;default:%> Record
         <%} %>
         </h2>
       -->
          <div class="table-responsive">
            <% 
            	if(type ==1) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">Month</th>
                   <th style="text-align: center;">DayOfWeek</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord1.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord1.get(i).year %></td>
                  <td align = "center"><%=dayRecord1.get(i).month %></td>   
                  <td align = "center"><%=dayRecord1.get(i).day %></td>   
                  <td align = "center"><%=dayRecord1.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type ==2) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">Month</th>                  
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord2.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord2.get(i).year %></td>
                  <td align = "center"><%=dayRecord2.get(i).month %></td>                      
                  <td align = "center"><%=dayRecord2.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type == 3) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord3.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord3.get(i).year %></td>
                  <td align = "center"><%=dayRecord3.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type == 4) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">Day of Week</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord4.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord4.get(i).year %></td>
                  <td align = "center"><%=dayRecord4.get(i).day %></td>
                  <td align = "center"><%=dayRecord4.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type == 5) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Year</th>
                  <th style="text-align: center;">Month</th>
                  <th style="text-align: center;">Day of Week</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord5.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord5.get(i).year %></td>
                  <td align = "center"><%=dayRecord5.get(i).month %></td>
                  <td align = "center"><%=dayRecord5.get(i).day %></td>
                  <td align = "center"><%=dayRecord5.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            
            <% 
            	if(type == 6) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Day of Week</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord6.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord6.get(i).day %></td>
                  <td align = "center"><%=dayRecord6.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type == 7) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Month</th>
                  <th style="text-align: center;">Day of Week</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord7.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord7.get(i).month %></td>
                  <td align = "center"><%=dayRecord7.get(i).day %></td>
                  <td align = "center"><%=dayRecord7.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
            <% 
            	if(type == 8) {
            %>         
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="text-align: center;">Month</th>
                  <th style="text-align: center;">TotalCollision</th>                      
                </tr>
              </thead>
              <tbody>
              <% for(int i = 0; i < dayRecord8.size(); i++) 
              	{
              %>
                <tr>
                  <td align = "center"><%=dayRecord8.get(i).month %></td>
                  <td align = "center"><%=dayRecord8.get(i).totalCollisions %></td>              
                </tr>   
               <%  
                }  
              %>
              </tbody>
            </table>
            <% } %>
            
          </div><!-- table container end -->
          
      
		 
          
        </div><!-- main content end -->
        
      </div>
      
      <hr>
      
      <footer class="footer" style="text-align: right;">
      	<p>Source: National Collision Data Mart</p>
        <p>Report Category: Collision and Accident</p>
        <p>        
        <%switch(type) { 
	         	  case 0:%> Report Name: Collision of Monday in January,1999<%break; 
		          case 1: %> Report Name: Collision From 1999 To 2011
		         <%break;case 2: %> Report Name: Collision Of <%=dayName%> Every Month From 1999 To 2011 
		         <%break;case 3: %> Report Name: Collision Of <%=dayName%>,<%=monthName %> From 1999 To 2011 
		         <%break;case 4: %> Report Name: Collision Of <%=monthName%> From 1999 To 2011 
		         <%break;case 5: %> Report Name: Collision Of <%=dayName%>,<%=monthName%>,<%=year%>
		         <%break;case 6: %> Report Name: Collision Of All Days In <%=monthName%>,<%=year%> 
		         <%break;case 7: %> Report Name: Collision Of <%=year%> 
		         <%break;case 8: %> Report Name: Collision Of <%=dayName%> Every Month,<%=year%> 
	             <%break;default:%> Report Name: Collision
	         <%} %>         
		</p>
      </footer>
    </div><!-- Container end  -->
					
	<script src="js/echarts-all.js"></script>
		<script>
        	var myChart = echarts.init(document.getElementById('main'));
        	var collision_1999  = <%=Arrays.toString(yearMonthNum[0])%>;
        	var collision_2000  = <%=Arrays.toString(yearMonthNum[1])%>;
        	var collision_2001  = <%=Arrays.toString(yearMonthNum[2])%>;
        	var collision_2002  = <%=Arrays.toString(yearMonthNum[3])%>;
        	var collision_2003  = <%=Arrays.toString(yearMonthNum[4])%>;
        	var collision_2004  = <%=Arrays.toString(yearMonthNum[5])%>;
        	var collision_2005  = <%=Arrays.toString(yearMonthNum[6])%>;
        	var collision_2006  = <%=Arrays.toString(yearMonthNum[7])%>;
        	var collision_2007  = <%=Arrays.toString(yearMonthNum[8])%>;
        	var collision_2008  = <%=Arrays.toString(yearMonthNum[9])%>;
        	var collision_2009  = <%=Arrays.toString(yearMonthNum[10])%>;
        	var collision_2010  = <%=Arrays.toString(yearMonthNum[11])%>;
        	var collision_2011  = <%=Arrays.toString(yearMonthNum[12])%>;
        	var collision_all   = <%=Arrays.toString(yearMonthNum[13])%>;
        	
        	var type3YearCollision = <%=Arrays.toString(type3)%>;
        	
        	var type4_1999  = <%=Arrays.toString(type4[0])%>;
        	var type4_2000  = <%=Arrays.toString(type4[1])%>;
        	var type4_2001  = <%=Arrays.toString(type4[2])%>;
        	var type4_2002  = <%=Arrays.toString(type4[3])%>;
        	var type4_2003  = <%=Arrays.toString(type4[4])%>;
        	var type4_2004  = <%=Arrays.toString(type4[5])%>;
        	var type4_2005  = <%=Arrays.toString(type4[6])%>;
        	var type4_2006  = <%=Arrays.toString(type4[7])%>;
        	var type4_2007  = <%=Arrays.toString(type4[8])%>;
        	var type4_2008  = <%=Arrays.toString(type4[9])%>;
        	var type4_2009  = <%=Arrays.toString(type4[10])%>;
        	var type4_2010  = <%=Arrays.toString(type4[11])%>;
        	var type4_2011  = <%=Arrays.toString(type4[12])%>;
        
        	var type6Days = <%=Arrays.toString(type6)%>;    	
        	
        	var type7Jan = <%=Arrays.toString(type7[0])%>;
        	var type7Feb = <%=Arrays.toString(type7[1])%>;
        	var type7Mar = <%=Arrays.toString(type7[2])%>;
        	var type7Apr = <%=Arrays.toString(type7[3])%>;
        	var type7May = <%=Arrays.toString(type7[4])%>;
        	var type7Jun = <%=Arrays.toString(type7[5])%>;
        	var type7Jul = <%=Arrays.toString(type7[6])%>;
        	var type7Aug = <%=Arrays.toString(type7[7])%>;
        	var type7Sep = <%=Arrays.toString(type7[8])%>;
        	var type7Oct = <%=Arrays.toString(type7[9])%>;
        	var type7Nov = <%=Arrays.toString(type7[10])%>;
        	var type7Dec = <%=Arrays.toString(type7[11])%>;
        	
        	var type8Month = <%=Arrays.toString(type8)%>;
        	
        	
         	var option2 = {
         		    title : {
         		        text: '',
         		        subtext: ''
         		    },
         		    tooltip : {
         		        trigger: 'axis'
         		    },
         		    legend: {
         		        data:['1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011']
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
         		            boundaryGap : false,
         		            data : ['January','February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [
               		        {
               		            name:'1999',
               		            type:'line',               		          
               		            data:collision_1999, 
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		       {
               		            name:'2000',
               		            type:'line',               		          
               		            data:collision_2000,
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
               		            name:'2001',
               		            type:'line',               		          
               		            data:collision_2001,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2002',
               		            type:'line',               		          
               		            data:collision_2002,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           		},      
               		        },
               		        {
               		            name:'2003',
               		            type:'line',               		          
               		            data:collision_2003,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2004',
               		            type:'line',               		          
               		            data:collision_2004,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2005',
               		            type:'line',               		          
               		            data:collision_2005,
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
               		            name:'2006',
               		            type:'line',               		          
               		            data:collision_2006,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2007',
               		            type:'line',               		          
               		            data:collision_2007,
               		         	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           		},      
               		        },
               		        {
               		            name:'2008',
               		            type:'line',            		          
               		            data:collision_2008,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2009',
               		            type:'line',               		          
               		            data:collision_2009,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2010',
               		            type:'line',             		          
               		            data:collision_2010,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2011',
               		            type:'line',             		          
               		            data:collision_2011,
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
         	
         	var option3 = {
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
         		            boundaryGap : false,
         		            data:['1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [

               		       {
               		            name:'',
               		            type:'line',               		          
               		            data:type3YearCollision,
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
         	
         	var option4 = {
         		    title : {
         		        text: '',
         		        subtext: ''
         		    },
         		    tooltip : {
         		        trigger: 'axis'
         		    },
         		    legend: {
         		    	data:['1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011']
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
         		            boundaryGap : false,
         		            data:['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday','Unknown']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [
               		        {
               		            name:'1999',
               		            type:'line',               		          
               		            data:type4_1999, 
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		       {
               		            name:'2000',
               		            type:'line',               		          
               		            data:type4_2000,
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
               		            name:'2001',
               		            type:'line',               		          
               		            data:type4_2001,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2002',
               		            type:'line',               		          
               		            data:type4_2002,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           		},      
               		        },
               		        {
               		            name:'2003',
               		            type:'line',               		          
               		            data:type4_2003,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2004',
               		            type:'line',               		          
               		            data:type4_2004,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2005',
               		            type:'line',               		          
               		            data:type4_2005,
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
               		            name:'2006',
               		            type:'line',               		          
               		            data:type4_2006,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2007',
               		            type:'line',               		          
               		            data:type4_2007,
               		         	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           		},      
               		        },
               		        {
               		            name:'2008',
               		            type:'line',            		          
               		            data:type4_2008,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2009',
               		            type:'line',               		          
               		            data:type4_2009,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2010',
               		            type:'line',             		          
               		            data:type4_2010,
               		        	markPoint : {
	               	                data : [
	               	                    {type : 'max', name: 'Max'},
	               	                    {type : 'min', name: 'Min'}
	               	                ]
         	           			}, 
               		        },
               		        {
               		            name:'2011',
               		            type:'line',             		          
               		            data:type4_2011,
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
         	
         	var option6 = {
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
         		            boundaryGap : false,
         		            data:['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday','Unknown']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [

               		       {
               		            name:'',
               		            type:'line',               		          
               		            data:type6Days,
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
         	
         	
         	var option7 = {
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
         		            boundaryGap : false,
         		            data:['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [

               		       {
               		            name:'January',
               		            type:'line',               		          
               		            data:type7Jan,
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
               		            name:'February',
               		            type:'line',               		          
               		            data:type7Feb,
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
               		            name:'March',
               		            type:'line',               		          
               		            data:type7Mar,
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
               		            name:'April',
               		            type:'line',               		          
               		            data:type7Apr,
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
               		            name:'May',
               		            type:'line',               		          
               		            data:type7May,
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
               		            name:'June',
               		            type:'line',               		          
               		            data:type7Jun,
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
               		            name:'July',
               		            type:'line',               		          
               		            data:type7Jul,
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
               		            name:'August',
               		            type:'line',               		          
               		            data:type7Aug,
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
               		            name:'September',
               		            type:'line',               		          
               		            data:type7Sep,
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
               		            name:'October',
               		            type:'line',               		          
               		            data:type7Oct,
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
               		            name:'November',
               		            type:'line',               		          
               		            data:type7Nov,
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
               		            name:'December',
               		            type:'line',               		          
               		            data:type7Dec,
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
         	
         	var option8 = {
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
         		            boundaryGap : false,
         		            data : ['January','February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
         		        }
         		    ],
         		    yAxis : [
         		        {
         		            type : 'value',
         		        }
         		    ],
         		    series : [               		        
               		       {
               		            name:'',
               		            type:'line',               		          
               		            data:type8Month,
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
         	
         	
        <%switch(type) { 
       	  case 0:%> myChart.setOption(option2); <%break; 
	          case 1: %> myChart.setOption(option2);
	         <%break;case 2: %> myChart.setOption(option2);
	         <%break;case 3: %> myChart.setOption(option3);
	         <%break;case 4: %> myChart.setOption(option4);
	         <%break;case 5: %> myChart.setOption(option2);
	         <%break;case 6: %> myChart.setOption(option6);
	         <%break;case 7: %> myChart.setOption(option7);
	         <%break;case 8: %> myChart.setOption(option8);
           <%break;default:%> myChart.setOption(option2);
       <%} %>
       
         	
         	
        	
    </script>		

</body>
</html> 