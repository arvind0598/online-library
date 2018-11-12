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
@WebServlet(name = "DonateBook", urlPatterns = {"/serve_donate"})
public class DonateBook extends HttpServlet {

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
        JSONObject obj = new JSONObject();

        String temp_cust_id = sess.getAttribute("login") == null ? "-1" : sess.getAttribute("login").toString();
        String temp_cat_id = request.getParameter("cat_id");
        String product_name = request.getParameter("product_name");
        String desc = request.getParameter("desc");
        String keywords = request.getParameter("keywords");
        String temp_cost = request.getParameter("cost");
        String temp_age = request.getParameter("age");        
        String author = request.getParameter("author");

        Boolean author_ok = Helper.regexChecker(Helper.Regex.MIN_SIX_ALPHA_SPACES, author);
        Boolean cost_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_cost);
        Boolean age_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_age);
        Boolean cust_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_cust_id);
        Boolean product_name_ok = Helper.regexChecker(Helper.Regex.MIN_SIX_ALPHANUM_SPACES, product_name);
        Boolean desc_ok = Helper.regexChecker(Helper.Regex.DESCRIPTION, desc);
        Boolean keywords_ok = Helper.regexChecker(Helper.Regex.MIN_SIX_LOWERCASE_SPACES, keywords);
        Boolean cat_id_ok = Helper.regexChecker(Helper.Regex.NUMBERS_ONLY, temp_cat_id);

        if (!cust_ok) {
            obj.put("status", -1);
            obj.put("message", "Login to continue.");
        } else if (!author_ok || !cost_ok || !product_name_ok || !desc_ok || !keywords_ok || !cat_id_ok || !age_ok) {
            obj.put("status", -1);
            obj.put("message", "Invalid Request");
        } 
        else {
            int cost = Integer.parseInt(temp_cost);
            JSONObject product = new JSONObject();
            product.put("cost", cost);
            product.put("author", author);
            product.put("name", product_name);
            product.put("desc", desc);
            product.put("keywords", keywords.toLowerCase());
            product.put("genre", temp_cat_id);
            product.put("age", Integer.parseInt(temp_age));
            
            Boolean status = new Database().addSecondHand(product, Integer.parseInt(temp_cust_id));
            obj.put("status", status ? 1 : 0);
            obj.put("message", status ? "Thanks. We'll pick up the book within 24 hours." : "There was an error.");
        }

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
        return "adds a new secondhand book";
    }// </editor-fold>
}