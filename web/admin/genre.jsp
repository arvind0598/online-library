<%-- 
    Document   : genre
    Created on : 12 Nov, 2018, 5:45:56 PM
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
        cat_id = new Integer(request.getParameter("id"));
        if (cat_id == null || cat_id < 1) {
            throw new Exception();
        }
    } catch (Exception e) {
        response.sendRedirect("landing.jsp");
        return;
    }
    JSONObject products = new Project.Database().getBooksPerGenreForAdmin(cat_id);
    request.setAttribute("products", products);

    String categoryName = new Project.Database().getGenreName(cat_id);
    request.setAttribute("name", categoryName);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>${name} | Admin</title>
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
            <table class="striped centered">
                <thead>
                    <tr> 
                        <th> Name </th>
                        <th> Cost </th>
                        <th> Stock </th>
                        <th> Remove Item </th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${products}" var="product">
                        <tr>                
                            <td><p> ${product.value.name} </p></td>
                            <td><p> Rs. ${product.value.cost} </p></td> 
                            <td>
                                <form class="container addstock">
                                    <div class="input-field inline">
                                        <input type="text" name="stock" class="validate" value="${product.value.stock}" required data-id="${product.key}">
                                    </div>
                                </form>
                            </td>
                            <td>
                                <button class="btn-floating btn-large waves-effect waves-light red" onclick="deleteProduct(${product.key})">
                                    <i class="material-icons right">delete</i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>

        <footer class="page-footer grey lighten-5">
            <div class="container">
                <div class="row center-align">
                    <a href="newbook.jsp?cat_id=${param.id}"> Click here to add a new book to ${name} </a>
                </div>
            </div>
        </footer>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="../js/materialize.min.js"></script>

        <script>
            const stocks = $(".addstock");
            const offers = $(".addoffer");

            const submitUpdate = (value, id) => {
                $.ajax({
                    type: "POST",
                    url: "../serve_modstock",
                    data: {
                        value: value,
                        id: id
                    },
                    success: data => {
                        console.log(data);
                        M.toast({
                            html: data.message
                        });
                    },
                    error: err => {
                        M.toast({
                            html: "There has been a server error. Please try again."
                        });
                        console.log(err);
                    }
                });
            }

            const deleteProduct = id => {
                $.ajax({
                    type: "POST",
                    url: "../serve_remove",
                    data: {
                        id: id
                    },
                    success: data => {
                        console.log(data);
                        M.toast({
                            html: data.message,
                            completeCallback: window.location.reload(true)
                        });
                    },
                    error: err => {
                        M.toast({
                            html: "There has been a server error. Please try again."
                        });
                        console.log(err);
                    }
                });
            }

            stocks.on("submit", event => {
                event.preventDefault();
                event.stopPropagation();
                submitUpdate(event.currentTarget[0].value, event.currentTarget[0].dataset.id);
                return false;
            });
        </script>

    </body> 
</html>
