<%-- 
    Document   : book
    Created on : 12 Nov, 2018, 12:32:19 AM
    Author     : ARVINDS-160953104
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%
    Integer item_id = null;
    try {
        item_id = new Integer(request.getParameter("id"));
        if (item_id < 1) {
            throw new Exception();
        }
    } catch (Exception e) {
        response.sendRedirect("index.jsp");
    }

    JSONObject product = new Project.Database().getBookDetails(item_id);
    Boolean inCart = false;
    if (session.getAttribute("login") != null) {
        inCart = new Project.Database().bookInCart((Integer) session.getAttribute("login"), item_id);
    }
    request.setAttribute("book", product);
    request.setAttribute("book_id", item_id);
    request.setAttribute("in_cart", inCart);
    session.setAttribute("currentpage", "book.jsp?" + request.getQueryString());
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%=product.get("name")%></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <%=product.toString()%>
        <%=inCart%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>
            let id = <%=item_id%>;

            $("#add").on("click", event => {
                event.preventDefault();
                event.stopPropagation();
                $.ajax({
                    type: "POST",
                    url: "serve_updatecart",
                    data: {
                        "id": id
                    },
                    success: data => {
                        M.toast({
                            html: data.message,
                            displayLength: 2500,
                            completeCallback: function () {
                                window.location.reload(true);
                            }
                        });
                    },
                    error: err => {
                        console.log(err);
                        M.toast({
                            html: "There has been a server error. Please try again."
                        });
                    }
                });
            });

            $("#check").on("click", event => {
                window.location = "cart.jsp";
            });
        </script>
    </body>
</html>
