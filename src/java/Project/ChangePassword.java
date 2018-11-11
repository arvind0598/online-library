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
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;

/**
 *
 * @author ARVINDS-160953104
 */
@WebServlet(name = "ChangePassword", urlPatterns = {"/serve_changepass"})
public class ChangePassword extends HttpServlet {

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
        HttpSession sess = request.getSession();
        
        
        String useremail = ((JSONObject)sess.getAttribute("details")).get("email").toString();
        String currPassword = request.getParameter("curr_pass");
        String newPassword = request.getParameter("new_pass");
        
        JSONObject obj = processRequest(useremail, currPassword, newPassword);     
        
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
        return "servlet changes password for a user";
    }// </editor-fold>
    
    public JSONObject processRequest(String userEmail, String currPass, String newPass) {

        Boolean useremail_correct = Helper.regexChecker(Helper.Regex.EMAIL, userEmail);
        Boolean curr_password_correct = Helper.regexChecker(Helper.Regex.SIX_TO_TWELVE, currPass);
        Boolean new_password_correct = Helper.regexChecker(Helper.Regex.SIX_TO_TWELVE, newPass);

        JSONObject obj = new JSONObject();
        Database x = new Database();
        
        if(!useremail_correct || !curr_password_correct || !new_password_correct) {
            obj.put("status", -1);
            obj.put("message", "Input provided was not valid.");  
            return obj;
        }
        
        int user = x.checkCustomer(userEmail, currPass, true);

        if (user <= 0) {
            obj.put("status", 0);
            obj.put("message", "Current password does not match.");         
            return obj;
        }
        
        Boolean status = x.changePassword(user, newPass);
        obj.put("status", status ? 1 : 0);
        obj.put("message", status ? "Successfully changed password" : "Unable to change password.");
        return obj;
    }
}