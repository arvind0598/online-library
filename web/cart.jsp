<%-- 
    Document   : cart
    Created on : 11 Nov, 2018, 8:07:57 PM
    Author     : ARVINDS-160953104
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("login");
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }
    JSONObject products = new Project.Database().getCartDetails(x);
    JSONObject details = new Project.Database().getCustomerDetails(x);
    Boolean hasAddress = details.get("address") != null;
    session.setAttribute("products", products);
    session.setAttribute("details", details);
    session.setAttribute("has_address", hasAddress);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Cart</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <div class="container">
            <table class="responsive-table">
                <tr>
                    <th> Product Name </th>
                    <th> Cost </th>
                    <th> Quantity </th>
                    <th> Sub Cost </th>
                    <th> Actions </th> 
                </tr>
                <c:set var="totalCost" value="${0}" scope="session"/>
                <c:forEach items="${products}" var="product">
                    <tr class="${product.value.secondhand ? "grey lighten-3" : ""}">
                        <td>
                            <a href="product.jsp?id=${product.key}"> ${product.value.name} </a>
                        </td>
                        <td>
                            ${product.value.cost}
                        </td>
                        <td> 
                            ${product.value.qty} 
                        </td>
                        <c:set var="subCost" value="${product.value.cost * product.value.qty}"/>
                        <c:set var="totalCost" value="${totalCost + subCost}" scope="session"/>
                        <td> 
                            ${subCost} 
                        </td>
                        <td>
                            <button class="add waves-effect waves-light btn-small" onclick="updateCart(${product.key},${product.value.qty + 1})"> + </button>
                            <button class="remove waves-effect waves-light btn-small red darken-3" onclick="updateCart(${product.key},${product.value.qty - 1})"> - </button>
                        </td>
                    </tr>
                </c:forEach>    
            </table>

            <div class="section">
                <h6><b> Total Effective Cost:</b> <span id="total">${sessionScope.totalCost}</span></h6>

                <c:if test="${totalCost ne 0}">
                    <button class="waves-effect waves-light btn-large light-blue darken-4" onclick="checkOut()"> 
                        <i class="material-icons right"> shopping_cart </i>
                        Proceed to Payment 
                    </button>
                </c:if>

                <div class="row section">
                    <div class="chip">
                        Note: To change address, visit your profile.
                        <i class="close material-icons">close</i>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>

            const updateCart = (id, qty) => {
                $.ajax({
                    type: "POST",
                    url: "serve_updatecart",
                    data: {
                        "id": id,
                        "qty": qty
                    },
                    success: data => {
                        console.log(data);
                        if(data.status === 0) {
                            M.toast({
                                html: data.message,
                                displayLength: 1500
                            });
                        }
                        else window.location.reload(true);
                    },
                    error: err => {
                        console.log(err);
                        M.toast({
                            html: "There has been a server error. Please try again."
                        });
                    }
                });
            }

            const checkOut = () => {
                <c:choose>
                    <c:when test="${sessionScope.has_address}">
                        window.location.href = "payment.jsp";
                    </c:when>
                    <c:otherwise>
                        M.toast({
                            html:"Please enter address",
                            displayLength: 2000,
                            completeCallback: function() {
                                window.location.href = "profile.jsp";
                            }
                        });
                    </c:otherwise>
                </c:choose>
            }

        </script>
    </body>
</html>
