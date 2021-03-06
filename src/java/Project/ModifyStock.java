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
@WebServlet(name = "ModifyStock", urlPatterns = {"/serve_modstock"})
public class ModifyStock extends HttpServlet {
    
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
        
        String temp_admin_id = sess.getAttribute("admlogin") == null ? "-1" : sess.getAttribute("admlogin").toString();
        String temp_value = request.getParameter("value");
        String temp_id = request.getParameter("id");

        JSONObject obj = processRequest(temp_admin_id, temp_id, temp_value);

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
        return "updates offers or stocks for a given product";
    }// </editor-fold>

    public JSONObject processRequest(String temp_admin_id, String temp_book_id, String temp_stock) {

        Boolean admin_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_admin_id);
        Boolean value_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_stock);
        Boolean id_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_book_id);

        JSONObject obj = new JSONObject();

        if (!admin_ok) {
            obj.put("status", -1);
            obj.put("message", "Login to continue.");
            return obj;
        } 
        
        else if (!value_ok || !id_ok) {
            obj.put("status", -1);
            obj.put("message", "Input provided was not valid.");
            return obj;
        }

        int book_id = Integer.parseInt(temp_book_id);
        int value = Integer.parseInt(temp_stock);
        int admin_id = Integer.parseInt(temp_admin_id);

        Boolean status = new Database().updateStock(book_id, value, admin_id);

        obj.put("status", status ? 1 : 0);
        obj.put("message", status ? "Succesfully updated." : "Unable to update stock.");
        return obj;
    }

}
