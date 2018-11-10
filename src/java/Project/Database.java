/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Project;

import java.sql.*;
import java.util.regex.Pattern;
import org.json.simple.JSONObject;

/**
 *
 * @author ARVINDS-160953104
 */
public class Database {
    
    private Connection connectSql()
            throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection(Credentials.DB_URL, Credentials.DB_USERNAME, Credentials.DB_PASSWORD);
        return conn;
    }
    
    public JSONObject getGenres() {
        JSONObject obj = new JSONObject();
        try {
            Connection conn = connectSql();
            PreparedStatement stmt = conn.prepareStatement("select * from genres");
            ResultSet res = stmt.executeQuery();
            
            while(res.next()) {
                String name = res.getString(2);
                name = Helper.capitailizeWord(name);
                obj.put(res.getInt(1),name);
            }
            
            conn.close();
        }
        
        catch (Exception e) {
            Helper.handleError(e);
        }
        
        return obj;
    }
}

class Helper {

    enum Regex {
        NUMBERS_ONLY("^[0-9]+$"),
        MIN_FOUR_ALPHA_ONLY("^[a-zA-Z]{4,}$"),
        EMAIL("[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$"),
        MIN_SIX_ALPHANUM("^[a-zA-Z0-9]{6,}$"),
        MIN_SIX_ALPHA_SPACES("^[a-zA-Z ]{6,}$"),
        MIN_SIX_ALPHANUM_SPACES("^[a-zA-Z0-9 ]{6,}$"),
        MIN_SIX_LOWERCASE_SPACES("^[a-z ]{6,}$"),
        DESCRIPTION("[a-zA-Z0-9.?! ]{6,}"),
        SIX_TO_TWELVE(".{6,12}");

        private final String str;

        public String getRegex() {
            return this.str;
        }

        Regex(String str) {
            this.str = str;
        }
    }

    public static void handleError(Exception e) {
        try {
            e.printStackTrace();
        } catch (Exception anotherOne) {
            System.out.println(anotherOne.toString());
        }
    }

    public static Boolean regexChecker(Regex r, String str) {
        Boolean status = false;
        try {
            Pattern p = Pattern.compile(r.getRegex());
            status = p.matcher(str).matches();
        } catch (Exception e) {
            status = false;
        }

        return status;
    }
    
    public static String capitailizeWord(String str) { 
        StringBuffer s = new StringBuffer(); 
  
        // Declare a character of space 
        // To identify that the next character is the starting 
        // of a new word 
        char ch = ' '; 
        for (int i = 0; i < str.length(); i++) { 
              
            // If previous character is space and current 
            // character is not space then it shows that 
            // current letter is the starting of the word 
            if (ch == ' ' && str.charAt(i) != ' ') 
                s.append(Character.toUpperCase(str.charAt(i))); 
            else
                s.append(str.charAt(i)); 
            ch = str.charAt(i); 
        } 
  
        // Return the string with trimming 
        return s.toString().trim(); 
    } 
}
