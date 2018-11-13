<%-- 
    Document   : search
    Created on : 13 Nov, 2018, 12:22:44 AM
    Author     : ARVINDS-160953104
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%
    String str = null;
    try {
        str = request.getParameter("search");
        if (str == null) {
            throw new Exception();
        }
        str = str.trim().toLowerCase();
    } catch (Exception e) {
        response.sendRedirect("index.jsp");
    }
    JSONObject products = new Project.Database().searchProducts(str);
    request.setAttribute("products", products);
    session.setAttribute("currentpage", "search.jsp?" + request.getQueryString());
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Search | S Mart</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <div class="container">
            <h2> Search Results</h2>
            <div id="search">
                <div class="row">
                    <c:forEach var="prod" items="${products}">
                        <div class="col m6">
                        <div class="card small hoverable">
                            <div class="card-content">
                                <h3> Book ID: ${prod.key} </h3>
                                        <p> Book Name: ${prod.value.name} </p>
                                        <p> Author: ${prod.value.author}</p>
                                        <p> Cost: Rs. ${prod.value.cost} </p>
                                    </div>
                                    <div class="card-action">
                                        <a href="book.jsp?id=${prod.key}">Product Details</a>
                                    </div> 
                                </div>
                            </div>
                        </section>
                    </c:forEach>
                </div>
            </div>
        </div>
    </body>
</html>

