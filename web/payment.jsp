<%-- 
    Document   : payment.jsp
    Created on : 12 Nov, 2018, 5:19:29 PM
    Author     : ARVINDS-160953104
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.json.simple.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer customer_id = (Integer) session.getAttribute("login");
    Long total_cost = (Long) session.getAttribute("totalCost");
    Long total_savings = (Long) session.getAttribute("totalSavings");

    if (customer_id == null || customer_id < 1) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Payment</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
        <style>            
            #loader {
                position: absolute;
                left: 0;
                top: 0;
                transition: all 500ms ease;
                z-index: 10;
            }

            .loading {
                background: rgba(255,255,255,0.8);
                height: 100%;
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div id="loader"></div>
        <%@ include file="navbar.jspf"%>
        <table class="responsive-table">
                <tr>
                    <th> Book Name </th>
                    <th> Cost </th>
                    <th> Quantity </th>
                    <th> Sub Cost </th> 
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
                    </tr>
                </c:forEach>    
            </table>
        <p><b> Total Cost:</b> <span id="total">Rs. ${sessionScope.totalCost}</span></p>
        <button onclick="loader('PayTM')" class="waves-effect waves-light btn"> Pay via PayTM </button>
        <button onclick="loader('Tez')" class="waves-effect waves-light btn"> Pay via Tez </button>
        <button onclick="loader('Online Banking')" class="waves-effect waves-light btn"> Pay via Online Banking </button>
    </body>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src="js/materialize.min.js"></script>

    <script>
            const loader = type => {
                alert("Simulating " + type + " payment.");
                $("#loader").addClass("loading");
                $.ajax({
                    type: "POST",
                    url: "serve_checkout",
                    success: data => {
                        console.log(data);
                        window.setTimeout(() => {
                            $("#loader").removeClass("loading");
                            M.toast({
                                html: data.message,
                                displayLength: 2500,
                                completeCallback: function () {
                                    if(data.status > 0) window.location.href = "index.jsp";
                                }
                            });
                        }, 3000);
                    },
                    error: err => {
                        console.log(err);
                        alert("There has been a server error. Please try again.");
                    }
                });
            }
    </script>    
</html>
