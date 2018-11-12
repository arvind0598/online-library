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

    JSONObject books = new Project.Database().getGenresWithBooks();
    request.setAttribute("books", books);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
    </head>
    <body>
        <%@ include file="navbar.jspf"%>

        <div class="row">
            <c:forEach items="${books}" var="book">
                <div class="col m3">
                    <ul class="collection with-header">
                        <li class="collection-header"><h4>${book.key}</h4></li>
                            <c:forEach items="${book.value.data}" var="data">
                                <!--<a href="book.jsp?id=${data.key}" class="collection-item"> ${data.value.name}: </a> Rs. ${data.value.cost}</a>-->
                            <!--                            <li class="collection item">
                                                            <a href="book.jsp?id=${data.key}" class="collection-item"> ${data.value.name} </a>
                                                            <p> Rs. ${data.value.cost} <br> By ${data.value.author} </p>
                                                        </li>-->
                            <li class="collection-item avatar">
                                <i class="material-icons circle">book</i>
                                <span class="title"> ${data.value.name}</span>
                                <p>By ${data.value.author} <br>
                                    Rs. ${data.value.cost}                              
                                </p>
                                <a href="book.jsp?id=${data.key}" class="secondary-content"><i class="material-icons">send</i></a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:forEach>
        </div>
    </body>
</html>
