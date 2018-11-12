<%-- 
    Document   : profile
    Created on : 11 Nov, 2018, 10:48:06 PM
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
    if (x == null || x < 1) {
        response.sendRedirect("index.jsp");
        return;
    }
    JSONObject details = new Project.Database().getCustomerDetails(x);
    session.setAttribute("details", details);

    JSONObject orders = new Project.Database().getOrderHistory(x);
    session.setAttribute("orders", orders);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Profile</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <div class="row">
            <div class="col l6">
                <div class="card hoverable">
                    <div class="card-content">
                        <span class="card-title"> ${details.name} </span>
                        <div>
                            <p> <b>Email:</b> ${details.email} </p>
                            <p> <b>No. Of Books Donated:</b> ${details.donated eq null ? 0 : details.donated}</p>
                            <c:choose>
                                <c:when test="${details.address ne null}">
                                    <p> <b>Address:</b> ${details.address} </p>
                                </c:when>
                                <c:otherwise>
                                    <p><b> Please Enter Address to place order. </b></p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                            
                <form id="change_add" onsubmit=" return changeAddress()" class="card small hoverable">
                    <div class="card-content">
                        <span class="card-title"> Change Address </span>
                        <div class="row">
                            <div class="input-field col l12">
                                <textarea id="address" name="address" class="materialize-textarea" required></textarea>
                                <label for="address"> New Address </label>
                            </div>
                        </div>
                    </div>
                    <div class="card-action">
                        <button class="waves-effect waves-light btn">Change Address</button>
                    </div>
                </form>
            </div>
                            
                
            <div class="col l6">
                <form id="change_pass" onsubmit="return changePass()" class="card hoverable">
                    <div class="card-content">
                        <span class="card-title"> Change Password </span>
                        <div class="row">
                            <div class="input-field col l8">
                                <input type="password" id="curr_pass" name="curr_pass" class="validate" pattern =".{6,12}" title="6-12 characters" required/>
                                <label for="curr_pass">Current Password</label>
                            </div>
                        </div>
                        <div class="row"> 
                            <div class="input-field col l8">
                                <input type="password" id="new_pass" name="new_pass" class="validate" pattern =".{6,12}" title="6-12 characters" required/>
                                <label for="new_pass">New Password</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col l8">
                                <input type="password" id="conf_pass" class="validate" pattern =".{6,12}" title="6-12 characters" required/>
                                <label for="conf_pass">Confirm New Password</label>
                            </div>
                        </div>
                    </div>
                    <div class="card-action">
                        <button class="waves-effect waves-light btn">Change Password</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="divider"></div>
        
            <div class="grey lighten-4">
                <h3 class="center-align"> Order History </h3>
                <div class="row">
                    <c:forEach items="${orders}" var="ord">

                        <c:set value="${ord.value.status}" var="status"/>
                        <c:set value="${status eq 0 ? 'Received' : status eq 1 ? 'Dispatched' : 'Delivered'}" var="orderstring"/>

                        <div class="col l4">
                            <div class="card hoverable">
                                <div class="card-content">		
                                    <h4> Order #${ord.key} </h4>
                                    <p> <b>Final Amount :</b> Rs.${ord.value.bill} </p>
                                    <p> <b>Status :</b> ${orderstring} </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>

        <script>
            let passForm = $("#change_pass");
            let addressForm = $("#change_add");

            const changePass = () => {
                if ($("#new_pass").val() !== $("#conf_pass").val()) {
                    M.toast({
                        html : "Passwords do not match.",
                        displayLength: 1000
                    });
                    return false;
                }
                $.ajax({
                    type: "POST",
                    url: "serve_changepass",
                    data: passForm.serializeArray(),
                    success: data => {
                        M.toast({
                            html : data.message,
                            displayLength: 1000
                        });
                    },
                    error: err => {
                        alert("There has been an error.");
                        console.log(err);
                    }
                });
                return false;
            }

            const changeAddress = () => {
                $.ajax({
                    type: "POST",
                    url: "serve_changeadd",
                    data: addressForm.serializeArray(),
                    success: data => {
                        M.toast({
                            html: data.message,
                            displayLength: 1500,
                            completeCallback: function() {
                                if(data.status === 1)
                                    window.location.reload(true);
                            }
                        });     
                    },
                    error: err => {
                        M.toast({html: "There has been an error."});
                        console.log(err);
                    }
                });
                return false;
            }
        </script>
    </body>
</html>
