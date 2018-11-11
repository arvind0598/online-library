<%-- 
    Document   : login
    Created on : 11 Nov, 2018, 5:05:05 PM
    Author     : ARVINDS-160953104
--%>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("login");
    if (x != null && x > 0) {
        response.sendRedirect("index.jsp");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <form id="login" class="container row valign-wrapper">
            <div class="input-field col s6">
                <input id="user" type="email" name="useremail" class="validate" required/>
                <label for="user"> Email ID </label>
            </div>
            <div class="input-field col s6">
                <input id="pass" type="password" name="password" class="validate" required/>
                <label for="pass"> Password </label>
            </div>
            <button class="btn waves-effect waves-light" type="submit">Submit
                <i class="material-icons right">send</i>
            </button>        
        </form>

        <div class="slider">
            <ul class="slides">
                <li>
                    <img src="https://static1.squarespace.com/static/537c12a7e4b0ca838c2ee48d/564c0158e4b06f49e6635c6a/5652add8e4b02e2458acf0d1/1460365453183/Gateway_1200+Blur.jpg?format=2500w"> <!-- random image -->
                    <div class="caption center-align">
                        <h3>WELCOME TO S MART</h3>
                        <h5 class="light grey-text text-lighten-3">Quality Products Just Few Clicks Away</h5>
                    </div>
                </li>
                <li>
                    <img src="https://s20998.pcdn.co/wp-content/uploads/2017/08/IMG_0003.jpg">
                    <div class="caption left-align">
                        <h3>Choose From A Variety Of Products</h3>
                    </div>
                </li>
                <li>
                    <img src="https://cdn.forbesmiddleeast.com/en/wp-content/uploads/sites/3/2017/04/shutterstock_521741356-1635x1091.jpg"> <!-- random image -->
                    <div class="caption right-align">
                        <h3>At Best Prices</h3>
                    </div>
                </li>
                <li>
                    <img src="https://static1.squarespace.com/static/537c12a7e4b0ca838c2ee48d/564c0158e4b06f49e6635c6a/5652add8e4b02e2458acf0d1/1460365453183/Gateway_1200+Blur.jpg?format=2500w"> <!-- random image -->
                    <div class="caption center-align">
                        <h3>Go Get Some!</h3>
                    </div>
                </li>
            </ul>
        </div>


        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>
            let form = $("#login");

            $('.slider').slider();

            form.on("submit", event => {
                event.preventDefault();
                event.stopPropagation();
                $.ajax({
                    type: "POST",
                    url: "serve_login",
                    data: form.serializeArray(),
                    success: data => {
                        console.log(data);
                        M.toast({
                            html: data.message,
                            displayLength: 1000,
                            completeCallback: function () {
                                if (data.status > 0)
                                    window.location.href = "<%=session.getAttribute("currentpage") == null ? "index.jsp" : session.getAttribute("currentpage")%>";
                            }
                        });
                    },
                    error: err => {
                        M.toast({
                            html: "There has been a server error. Please try again."
                        });
                        console.log(err);
                    }
                });
                return false;
            });

        </script>
    </body>
</html>
