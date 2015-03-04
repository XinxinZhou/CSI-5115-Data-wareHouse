<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>National Collisions Data Mart</title>

<!-- bootstrap core css -->
<link type="text/css" rel="stylesheet" href="css/bootstrap.css">
<link type="text/css" rel="stylesheet" href="css/justified-nav.css">
<style>
body {
  padding-top: 50px;
  padding-bottom: 20px;
}

.single-item {
	padding: 5px 5px 5px 5px;
}

.item-internal {
	padding: 5px 15px 5px 15px;
	border: 2px solid #999;
	border-top-left-radius: 12px;
	border-top-right-radius: 12px;
	border-bottom-left-radius: 6px;
	border-bottom-right-radius: 6px;
	min-height: 330px;
}

.list-group-item {
  position: relative;
  display: block;
  padding: 10px 15px;
  margin-bottom: -1px;
  background-color: #fff;
  border: 0;
  border-top: 1px solid #999;
}

.list-group-item:first-child {
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

.list-group-item:last-child {
  border-bottom: 1px solid #999;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}

.bs-callout  {
  padding: 20px;
  margin: 20px 0;
  border: 1px solid #eee;
  border-left-width: 5px;
  border-radius: 3px;
}

.bs-callout-info {
  border-left-color: #5bc0de;
}

.others {
	padding: 5px 5px 5px 5px;
}

.other-content {
	padding: 5px 10px 5px 10px;
	border: 1px solid #999;
	border-radius: 4px;
	
	font-size: 10px;
}

.jumbotron {
	background-image: url(image/cover.jpg);
	background-position: center left;
	background-size: cover;
}

.jumbotron > h1 {
	color: #fff;
}

.lead {
	color: #fc0;
}
</style>
</head>

<body>
  
  <!-- navigation bar -->
  <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="#"><span class="glyphicon glyphicon-tasks" aria-hidden="true"></span> National Collisions Data Mart</a>
      </div>
      <div id="navbar" class="navbar-collapse collapse">
      </div><!-- navbar-collapse -->
    </div>
  </nav>
  
  <div class="container"><!-- container begin -->
  
    <!-- Jumbotron -->
    <div class="jumbotron">
      <h1>National Collisions Data Mart</h1>
      <p class="lead">Business Intelligence for national collisions data analysis and presentation.</p>
     
    </div>
    
    <!-- info -->
    <div class="bs-callout bs-callout-info">
      <h3>Choose one of the options to start&nbsp;<span class="glyphicon glyphicon-circle-arrow-right" aria-hidden="true"></span></h3>
    </div>
  
    <!-- main contents -->
    <div class="row">
      <div class="col-lg-4 single-item"><!-- single item -->
        <div class="item-internal">
          <h2><span class="glyphicon glyphicon-stats" aria-hidden="true"></span> Collision and Accident</h2>
          <p class="text-danger"></p>
          <ul class="list-group">
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q1.jsp">Collision of Specific Month</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q2.jsp">Explore Data of Date Hierarchy</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q3.jsp">Collision of Different Accident Types</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q4.jsp">Collision of Specific Weather</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q5.jsp">Collision Severity Record</a></li>

          </ul>
          
        </div>
      </div>
        
      <div class="col-lg-4 single-item"><!-- single item -->
        <div class="item-internal">
          <h2><span class="glyphicon glyphicon-stats" aria-hidden="true"></span> Age and Gender</h2>
          <p class="text-danger"></p>
          <ul class="list-group">
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q6.jsp">Collision of Age and Gender</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q7.jsp">Fatalities of Age Range</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q8.jsp">Fatalities of Vehicle and Age Range</a></li>

          </ul>
          
        </div>
      </div>
       
      <div class="col-lg-4 single-item"><!-- single item -->
        <div class="item-internal">
          <h2><span class="glyphicon glyphicon-stats" aria-hidden="true"></span> Road and Vehicle</h2>
          <p class="text-danger"></p>
          <ul class="list-group">
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q9.jsp">Vehicle Contrast by Accident Types</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q10.jsp">Accident Frequency by Road Conditions</a></li>
            <li class="list-group-item"><span class="glyphicon glyphicon-tags" aria-hidden="true"></span> &nbsp;<a href="Q11.jsp">Monthly Number of Vehicles in Collision</a></li>
          </ul>
          
        </div>
      </div>
      
    </div><!-- main content end -->
    
    <!-- info -->
    <div class="bs-callout bs-callout-info">
      <h3>Choose one of the option to direct access the data&nbsp;<span class="glyphicon glyphicon-circle-arrow-right" aria-hidden="true"></span></h3>
    </div>
    
    <!-- other content -->
    <div class="row">
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q1.jsp">Collision of Specific Month</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q2.jsp">Explore Data of Date Hierarchy</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q3.jsp">Different Accident Types</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q4.jsp">Collision of Specific Weather</a></h5>
          <p></p>
        </div>
      </div>
      

       <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q8.jsp">Fatalities of Vehicle and Age Range</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q9.jsp">Vehicle Contrast by Accident Types</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q5.jsp">Collision Severity Record</a></h5>
          <p></p>
        </div>
      </div>
      
       <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q6.jsp">Collision of Age and Gender</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q10.jsp">Accident Frequency by Road Conditions</a></h5>
          <p></p>
        </div>
      </div>
      
      <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q11.jsp">Monthly Number of Vehicles in Collision</a></h5>
          <p></p>
        </div>
      </div>
      
       <div class="col-lg-3 others">
        <div class="other-content">
          <h5><span class="glyphicon glyphicon-record" aria-hidden="true"></span> <a href="Q7.jsp">Fatalities of Age Range</a></h5>
          <p></p>
        </div>
      </div>
      
      
    </div><!-- other content end -->
    
    <!-- Site footer -->
    <footer class="footer">
      <p>&copy; Dara Mart - Xinxin Zhou and Jaiwei Luo, University of Ottawa</p>
    </footer>
  
  </div><!-- container end -->

</body>
</html>
    