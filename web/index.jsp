<%-- 
    Document   : sample
    Created on : 10 Nov, 2018, 10:36:41 AM
    Author     : ARVINDS-160953104
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%
    JSONObject genres = new Project.Database().getGenres();
    request.setAttribute("genres", genres);
    session.setAttribute("currentpage", "index.jsp");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Genres</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
    </head>
    <body>
        <%@ include file="navbar.jspf"%>

        <div class="row">
            <div class="col m3">
                <div class="collection with-header">
                    <h4 class="collection-header">Genres</h4>
                    <c:forEach items="${genres}" var="genre">
                        <a href="genre.jsp?id=${genre.key}" class="collection-item"> ${genre.value}</a>
                    </c:forEach>
                </div>
            </div>
            <div class="col m9">
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="https://www.franchiseindia.com/uploads/content/ri/art/lodi-the-garden-restaurant-start-60f6b1bb83.jpg">
                        </div>
                        <div class="card-content">
                            <span class="card-title">Fast Home Delivery</span>
                            <p>Products delivered within 24 hours of order placement.</p>
                        </div>
                    </div>
                </div>	
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="http://www.dorusomcutean.com/wp-content/uploads/2017/06/Best-deals-simcard.jpg">
                        </div>
                        <div class="card-content">
                            <span class="card-title">Best Prices And Deals</span>
                            <p>Enjoy daily deals and offers on the best quality products.</p>
                        </div>
                    </div>
                </div>
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2016/03/shutterstock_242438494-1200x676.jpg">
                        </div>
                        <div class="card-content">
                            <span class="card-title">You Speak, We Listen!</span>
                            <p>Your feedback is very important to us.</p>
                        </div>
                    </div>
                </div>
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="https://cmkt-image-prd.global.ssl.fastly.net/0.1.0/ps/386453/1160/772/m1/fpnw/wm1/gurza_01128-.jpg?1425456055&s=3bd789947477aac05f7d9aa57284933b">
                        </div>
                        <div class="card-content">
                            <span class="card-title">Wide Product Range</span>
                            <p>From groceries to clothing, we've got you covered!</p>
                        </div>
                    </div>
                </div>
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="http://bpic.588ku.com//element_origin_min_pic/17/09/02/c525ae37b545af5615d778937d99409c.jpg">
                        </div>
                        <div class="card-content">
                            <span class="card-title">Easy Payments</span>
                            <p>Pay at your own convenience, using your preferred method of payments.</p>
                        </div>
                    </div>
                </div>
                <div class="col m4">
                    <div class="card small hoverable">
                        <div class="card-image">
                            <img src="https://png.pngtree.com/element_origin_min_pic/16/08/18/1757b581c502064.jpg">
                        </div>
                        <div class="card-content">
                            <span class="card-title">Convenient</span>
                            <p>Shop for your favourite products sitting at home.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
