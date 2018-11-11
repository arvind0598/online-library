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
@WebServlet(name = "ChangeAddress", urlPatterns = {"/serve_changeadd"})
public class ChangeAddress extends HttpServlet {

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
        Integer userid = (Integer)sess.getAttribute("login");
        String address = request.getParameter("address");

        JSONObject obj = processRequest(userid, address);
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
        return "servlet changes address for a user";
    }// </editor-fold>
    
    public JSONObject processRequest(int userid, String address) {
        
        JSONObject obj = new JSONObject();
        
        if(userid < 1) {
            obj.put("status", -1);
            obj.put("message", "Please login again to continue.");                          
            return obj;
        }
        
        Boolean address_correct = true;
        
        if(!address_correct) {
            obj.put("status", -1);
            obj.put("message", "Input provided was not valid.");
        }
        
        Boolean status = new Database().changeAddress(userid, address);
        
        obj.put("status", status ? 1 : 0);
        obj.put("message", status ? "Succesfully changed Address" : "There was an error.");
        return obj;
    }

}
