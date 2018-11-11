<%-- 
    Document   : landing
    Created on : 12 Nov, 2018, 3:05:16 AM
    Author     : ARVINDS-160953104
--%>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("admlogin");
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Portal</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <div class="container">
            <div class="collection">
                <a href="modify.jsp" class="collection-item">Modify Products</a>
                <a href="orders.jsp" class="collection-item">View Active Orders</a>
                <a href="approve.jsp" class="collection-item">Approve New Books</a>
            </div>
        </div>
       <div class="slider">
            <ul class="slides">
                <li>
                    <!--<img src="https://s20998.pcdn.co/wp-content/uploads/2017/08/IMG_0003.jpg">-->
                    <div class="caption left-align">
                        <h3>Organize the products</h3>
                    </div>
                </li>
                <li>
                    <!--<img src="https://cdn.forbesmiddleeast.com/en/wp-content/uploads/sites/3/2017/04/shutterstock_521741356-1635x1091.jpg">-->
                    <div class="caption right-align">
                        <h3>Keep Track Of Orders</h3>
                    </div>
                </li>
            </ul>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="../js/materialize.min.js"></script>
	<script> $('.slider').slider();</script>
    </body>
</html>