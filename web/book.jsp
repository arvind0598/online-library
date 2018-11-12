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
        <div class="container">
            <div class="col s12 m7 valign-wrapper">
                <!--<h4 class="header">Product Details</h4>-->
                <div class="card horizontal hoverable">
                    <div class="card-image">
                        <img src="images/books.jpg">
                    </div>
                    <div class="card-stacked">
                        <div class="card-content">
                            <span class="card-title">${book.name}</span>
                            <h6> Author: ${book.author} </h6>                            
                            <h6>Cost: Rs. ${book.cost}</h6>
                            <h6>Genre: ${book.genre}</h6>
                            <h6>Details: ${book.details}</h6>
                            <c:choose>
                                <c:when test="${book.secondhand eq false}">
                                    <h6>Type: New</h6>
                                </c:when>
                                <c:otherwise>
                                    <h6>Type: Second Hand</h6>
                                </c:otherwise>
                            </c:choose> 
                        </div>
                        <div class="card-action">
                            <c:if test="${sessionScope.login ne null}">
                                <c:choose>
                                    <c:when test="${in_cart eq false}">
                                        <a href="javascript:addToCart(${requestScope.book_id})">Add To Cart</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="cart.jsp">View Cart</a>
                                    </c:otherwise>
                                </c:choose>            
                            </c:if>
                            <c:if test="${sessionScope.login eq null}">
                                <p> Login to add items to your cart </p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>
            let id = <%=item_id%>;

           const addToCart = id => {
                $.ajax({
                    type: "POST",
                    url: "serve_updatecart",
                    data: {
                        "id": id
                    },
                    success: data => {
                        M.toast({
                            html: data.message,
                            displayLength: 1500,
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
            }
        </script>
    </body>
</html>
