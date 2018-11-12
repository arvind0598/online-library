<%-- 
    Document   : approve
    Created on : 12 Nov, 2018, 11:35:03 PM
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

    JSONObject pending = new Project.Database().getPendingBooks();
    request.setAttribute("books", pending);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Pending Books</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>  
    </head>
    <body>
        <%@ include file="navbar.jspf"%>
        <h1> Pending Books </h1>
        <div class="row">
            <c:forEach items="${books}" var="book">
                <div class="col l4 m6 s12">
                    <div class="card hoverable">
                        <div class="card-content">
                            <span class="card-title">${book.value.name}</span>
                        </div>
                        <div class="card-tabs">
                            <ul class="tabs tabs-fixed-width">
                                <li class="tab"><a href="#tab${book.key}test1" class="active">Overview</a></li>
                                <li class="tab"><a href="#tab${book.key}test2">Details</a></li>
                            </ul>
                        </div>
                        <div class="card-content">
                            <div id="tab${book.key}test1">
                                <p>
                                    Author: ${book.value.author} <br>
                                    Cost: Rs. ${book.value.cost} <br>
                                    Cost: ${book.value.age} months <br>
                                </p>
                            </div>
                            <div id="tab${book.key}test2">
                                <p>
                                    Genre: ${book.value.genre} <br>
                                    Owner ${book.value.owner} <br>
                                    Details: <br>
                                    ${book.value.details}
                                </p>
                            </div>
                        </div>
                        <div class="card-action">
                            <a href="javascript:approveBook(${book.key})">Approve Book</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type="text/javascript" src="../js/materialize.min.js"></script>
        <script>
            var elem = document.querySelector('.tabs'); var instance = M.Tabs.init(elem, {});

            const approveBook = (id) => {
                $.ajax({
                    type: "POST",
                    url: "../serve_approve",
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

            //        ul = $('#orders'); // your parent ul element
            //        ul.children().each(function (i, li) {
            //            ul.prepend(li)
            //        })
        </script>
    </body>
</html>

