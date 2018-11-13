<%-- 
    Document   : donate
    Created on : 12 Nov, 2018, 10:40:15 PM
    Author     : ARVINDS-160953104
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("login");
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }
    JSONObject genres = new Project.Database().getGenres();
    session.setAttribute("genres", genres);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Donate Book</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
            }

            main {
                flex: 1 0 auto;
            }
        </style>
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <main>
            <div class="container">
                <form id="addproduct">
                    <div class="row">
                        <div class="input-field col l6 m6 s12">
                            <input id="product_name" type="text" class="validate" name="product_name" required>
                            <label for="product_name"> Product Name </label>
                        </div>
                        <div class="input-field col l6 m6 s12">
                            <select name="cat_id" required>
                                <option></option>
                                <c:forEach items="${genres}" var="genre">
                                    <option value="${genre.key}"> ${genre.value} </option>
                                </c:forEach>
                            </select>
                            <label>Genre</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col l12 m12 s12">
                            <textarea id="desc" class="materialize-textarea" required name="desc"></textarea>
                            <label for="desc"> Product Description </label>
                        </div>
                    </div> 
                    
                    <div class="row">
                        <div class="input-field col l12 m12 s12">
                            <input id="keywords" type="text" class="validate" name="keywords" required>
                            <label for="keywords"> Keywords </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col l6 m6 s6">
                            <input id="author" type="text" class="validate" name="author" required>
                            <label for="author"> Author Name </label>
                        </div>          
                        <div class="input-field col l6 m6 s6">
                            <input id="age" type="number" class="validate" name="age" min="1" max="9999" required>
                            <label for="age"> Age(in months) </label>
                        </div>
                    </div>
                    <div class="row center-align">
                        <button class="btn btn-large waves-effect waves-light center-align" type="submit">Submit
                            <i class="material-icons right">send</i>
                        </button>
                    </div>

                </form>
            </div>
        </main>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>
            M.updateTextFields();
            $('select').formSelect();

            const form = $("#addproduct");

            form.on("submit", event => {
                event.preventDefault();
                event.stopPropagation();
                $.ajax({
                    type: "POST",
                    url: "serve_donate",
                    data: form.serializeArray(),
                    success: data => {
                        console.log(data);
                        M.toast({
                            html: data.message,
                            displayLength: 2000,
                            completeCallback: function() {if(data.status === 1)window.location.href = "index.jsp";}
                        });
                    },
                    error: err => {
                        M.toast({
                            html: "There has been a server error. Please try again.",
                            displayLength: 2000
                        });
                        console.log(err);
                    }
                });
                return false;
            });
        </script>
    </body> 
</html>