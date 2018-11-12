<%-- 
    Document   : orders
    Created on : 12 Nov, 2018, 7:08:30 PM
    Author     : ARVINDS-160953104
--%>


<%@page import="org.json.simple.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", -1);

    Integer x = (Integer) session.getAttribute("admlogin");
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }

    JSONObject orders = new Project.Database().getActiveOrders();
    request.setAttribute("orders", orders);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Active Orders | S Mart</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <div class="container">
            <h1> Active Orders </h1>
            <div id="orders">
                <c:forEach var="order" items="${orders}">
                    <div class="divider"></div>
                    <section>
                        <h3> Order #${order.key} </h3>
                        <div class="row">
                            <div class="col l6">
                                <p> Customer Name: ${order.value.name} </p>
                                <p> Address: ${order.value.address}</p>
                                <p> Bill Amount: Rs. ${order.value.bill} </p>
                                <p> Order Time: ${order.value.time}</p>
                            </div>
                            <form class="col l6">
                                <div class="input-field">
                                    <select onchange="changeStatus(${order.key}, this.options[this.selectedIndex].value)">
                                        <option value="0" <c:if test="${order.value.status eq 0}"> selected </c:if>> Received</option>
                                        <option value="1" <c:if test="${order.value.status eq 1}"> selected </c:if>>Dispatched</option>
                                        <option value="2" <c:if test="${order.value.status eq 2}"> selected </c:if>>Delivered</option>
                                    </select>
                                    <label>Order Status</label>
                                </div>  
                            </form>
                        </div>
<!--                    <table>
                            <thead>
                                <tr>
                                    <th> Name </th>
                                    <th> Total Stock </th>
                                    <th> Required Quantity </th>
                                </tr>
                            </thead>
                        <tbody>
                            <%--<c:forEach var="item" items="${order.value.items}">--%>
                            <tr>
                                <td> ${item.item.name} </td>
                                <td> ${item.item.stock} </td>
                                <td> ${item.qty} </td>   
                            </tr>
                            <%--</c:forEach>--%>
                        </tbody>
                    </table>-->
                </section>
                
            </c:forEach>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src="../js/materialize.min.js"></script>
    <script>
        $('select').formSelect();

        const changeStatus = (id, status) => {
            console.log(id, status);
            $.ajax({
                type: "POST",
                url: "../serve_delivery",
                data: {
                    id: id,
                    status: status
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

//        ul = $('#orders'); // your parent ul element
//        ul.children().each(function (i, li) {
//            ul.prepend(li)
//        })
    </script>
    </body>
</html>

