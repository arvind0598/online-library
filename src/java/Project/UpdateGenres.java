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
@WebServlet(name = "UpdateGenres", urlPatterns = {"/serve_modgenres"})
public class UpdateGenres extends HttpServlet {

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

        String category = request.getParameter("genre");
        String temp_admin_id = sess.getAttribute("admlogin") == null ? "" : sess.getAttribute("admlogin").toString();
        String type = request.getParameter("type");

        JSONObject obj = processRequest(category, temp_admin_id, type);

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
        return "adds a category";
    }// </editor-fold>

    public JSONObject processRequest(String category, String temp_admin_id, String type_str) {
        Boolean type_valid = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, type_str);
        Boolean admin_id_valid = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_admin_id);
        Boolean category_correct = false;

        JSONObject obj = new JSONObject();

        if (!admin_id_valid) {
            obj.put("status", -1);
            obj.put("message", "Login to continue.");
            return obj;
        }
        
        if(!type_valid) {
            obj.put("status", -1);
            obj.put("message", "Invalid request");
            return obj;
        }
        
        int type = Integer.parseInt(type_str);
        category_correct = type == 0 ? 
                Helper.regexChecker(Helper.Regex.MIN_FOUR_ALPHA_ONLY, category) :  Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, category);

        if (!category_correct) {
            obj.put("status", -1);
            obj.put("message", "Input provided was not valid.");
            return obj;
        }

        int admin_id = Integer.parseInt(temp_admin_id);
        Boolean status = false;
        
        if(type == 0) {
            status = new Database().addGenre(category.trim(), admin_id);
        }
        else {
            int category_id = Integer.parseInt(category);
            status = new Database().removeGenre(category_id, admin_id);
        }

        obj.put("status", status ? 1 : 0);
        obj.put("message", status ? "Successfully modified" : "Internal error.");
        return obj;
    }

}
