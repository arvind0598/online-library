<%-- 
    Document   : newbook
    Created on : 12 Nov, 2018, 8:13:52 PM
    Author     : ARVINDS-160953104
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("admlogin");
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }

    Integer cat_id = null;
    try {
        cat_id = new Integer(request.getParameter("cat_id"));
        if (cat_id == null || cat_id < 1) {
            throw new Exception();
        }
    } catch (Exception e) {
        response.sendRedirect("landing.jsp");
        return;
    }

    String categoryName = new Project.Database().getGenreName(cat_id);
    request.setAttribute("cat_id", cat_id);
    request.setAttribute("name", categoryName);

%>

<!DOCTYPE html>
<html>
    <head>
        <title>New Book | Admin</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>
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
                    <input hidden type="text" value="${cat_id}" name="cat_id"/>
                    <div class="row">
                        <div class="input-field col l6 m6 s12">
                            <input id="product_name" type="text" class="validate" name="product_name" required>
                            <label for="product_name"> Product Name </label>
                        </div>
                        <div class="input-field col l6 m6 s12">
                            <input id="product_name" type="text" value="${name}" name="product_name" disabled readonly>
                            <label for="category_name"> Category Name </label>
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
                        <div class="input-field col l4 m4 s4">
                            <input id="offer" type="text" class="validate" name="author" required>
                            <label for="offer"> Author Name </label>
                        </div>
                        <div class="input-field col l4 m4 s4">
                            <input id="cost" type="text" class="validate" name="cost" required>
                            <label for="cost"> Cost </label>
                        </div>             
                        <div class="input-field col l4 m4 s4">
                            <input id="stock" type="text" class="validate" name="stock" required>
                            <label for="stock"> Stock </label>
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
        <script type="text/javascript" src="../js/materialize.min.js"></script>

        <script>
            M.updateTextFields();

            const form = $("#addproduct");

            form.on("submit", event => {
                event.preventDefault();
                event.stopPropagation();
                $.ajax({
                    type: "POST",
                    url: "../serve_firsthand",
                    data: form.serializeArray(),
                    success: data => {
                        console.log(data);
//                        if (data.status === 1)
//                            window.location.href = "index.jsp";
                        M.toast({
                            html: data.message,
                            displayLength: 2000,
                            completeCallback: window.location.href = "genre.jsp?id=${cat_id}"
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