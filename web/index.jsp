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
                    <div class="collection with-header">
                        <h4 class="collection-header">${book.value.name}</h4>
                        <c:forEach items="${book.value.data}" var="data">
                            <a href="data.jsp?id=${data.key}" class="collection-item"> ${data.value.name}</a>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
    </body>
</html>
