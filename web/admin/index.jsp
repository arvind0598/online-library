<%-- 
    Document   : index
    Created on : 12 Nov, 2018, 2:29:43 AM
    Author     : ARVINDS-160953104
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("admlogin");
    if (x != null) {
        response.sendRedirect("landing.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Admin Login</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <form id="login" class="container row valign-wrapper">
            <input hidden name="admin" value="1"/>
            <div class="input-field col s6">
                <input id="user" type="email" name="useremail" class="validate" required/>
                <label for="user"> E-mail ID </label>
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
                    <img src="../images/genre.jpg">
                    <div class="caption center-align">
                        <h3>WELCOME ADMIN</h3>
                        <h5 class="light grey-text text-lighten-3">Efficient Way Of Keeping Track Of Your Stocks</h5>
                    </div>
                </li>
            </ul>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="../js/materialize.min.js"></script>

        <script>
            let form = $("#login");
            let message = $("#message");
            form.on("submit", event => {
                event.preventDefault();
                event.stopPropagation();
                $.ajax({
                    type: "POST",
                    url: "../serve_login",
                    data: form.serializeArray(),
                    success: data => {
                        if (data.status > 0) {
                            window.location.href = "landing.jsp";
                        }
                        M.toast({html: data.message, displayLength: 1000});
                    },
                    error: err => {
                        M.toast({html: "There has been a server error. Please try again."});
                        console.log(err);
                    }
                });
                return false;
            });
            $(document).ready(function () {
                $('.slider').slider();
            });

        </script>
    </body>
</html>
