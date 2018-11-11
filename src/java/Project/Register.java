/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Project;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;

/**
 *
 * @author ARVINDS-160953104
 */
@WebServlet(name = "Register", urlPatterns = {"/serve_register"})
public class Register extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\":-1,\"message\":\"send post request\"}");
            out.close();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        String useremail = request.getParameter("email");
        String username = request.getParameter("name");
        String password = request.getParameter("password");

        JSONObject obj = processRequest(useremail, username, password);

        try (PrintWriter out = response.getWriter()) {
            out.println(obj);
            out.close();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "servlet registers a user";
    }// </editor-fold>

    public JSONObject processRequest(String useremail, String username, String password) {

        Boolean useremail_correct = Helper.regexChecker(Helper.Regex.EMAIL, useremail);
        Boolean password_correct = Helper.regexChecker(Helper.Regex.SIX_TO_TWELVE, password);
        Boolean username_correct = Helper.regexChecker(Helper.Regex.MIN_SIX_ALPHA_SPACES, username);

        JSONObject obj = new JSONObject();

        if (!useremail_correct || !password_correct || !username_correct) {
            obj.put("status", -1);
            obj.put("message", "Input provided was not valid.");
            return obj;
        }

        Boolean status = new Database().registerCustomer(username.trim(), useremail.trim(), password);

        obj.put("status", status ? 1 : 0);
        obj.put("message", status ? "Registration successful" : "Registration unsuccessful");
        return obj;
    }
}
