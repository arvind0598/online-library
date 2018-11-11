/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Project;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.*;
import java.util.regex.Pattern;
import javax.net.ssl.HttpsURLConnection;
import org.json.simple.JSONArray;
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

    int checkCustomer(String email, String password) {
        int status = -1;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("begin ? := check_customer(?,?); end;");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.execute();
            status = stmt.getInt(1);

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }

    Boolean registerCustomer(String name, String email, String password) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("call register_customer(?,?,?)");
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            System.out.println(stmt);
            stmt.execute();
            conn.close();
            status = true;
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }

    public JSONObject getGenres() {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select * from genres");
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                String name = res.getString(2);
                name = Helper.capitailizeWord(name);
                obj.put(res.getInt(1), name);
            }
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }

    public JSONObject getGenresWithBooks() {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select books.id, genres.id, books.name, genres.name, cost from books join genres on(genres.id = genre) where stock > 0 and display = 1 order by genre");
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                JSONObject book = new JSONObject();
                book.put("id", res.getInt(1));
                book.put("name", res.getString(3));
                book.put("cost", res.getInt(5));
                
                int genreID = res.getInt(2);
                
                if(!obj.containsKey(genreID)) {
                    JSONObject genre = new JSONObject();
                    genre.put("name", res.getString(4));
                    genre.put("data", new JSONArray());
                    obj.put(res.getInt(2), genre);
                }
                
                ((JSONArray)((JSONObject)obj.get(genreID)).get("data")).add(book);
            }
            
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }

    public JSONObject searchProducts(String str) {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select id, name, cost from books where stock > 0 and display = 1 and keywords like ?");
            stmt.setString(1, "%" + str + "%");
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                JSONObject book = new JSONObject();
                book.put("name", res.getString(2));
                book.put("cost", res.getInt(3));
                obj.put(res.getInt(1), book);
            }
            
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return obj;
    }

    public JSONObject getCustomerDetails(int customer_id) {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select email, name, address from login where id = ?");
            stmt.setInt(1, customer_id);
            ResultSet res = stmt.executeQuery();

            if (res.next()) {
                obj.put("email", res.getString(1));
                obj.put("name", res.getString(2));
                obj.put("address", res.getString(3));
            }
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }

    public String getGenreName(int genre_id) {
        String x = new String();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select name from genres where id = ?");
            stmt.setInt(1, genre_id);
            ResultSet res = stmt.executeQuery();

            if (res.next()) {
                x = res.getString(1);
            }
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return x;
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
        char ch = ' ';
        for (int i = 0; i < str.length(); i++) {
            if (ch == ' ' && str.charAt(i) != ' ') {
                s.append(Character.toUpperCase(str.charAt(i)));
            } else {
                s.append(str.charAt(i));
            }
            ch = str.charAt(i);
        }

        return s.toString().trim();
    }

    public static void sendEmail(String email, int order, String name)
            throws MalformedURLException, IOException {

        String preURL = String.format("https://script.google.com/macros/s/AKfycbwZm6E2OzyHqnjwQAe10TgAobIyH1tmhk3nWpt_E3ahlMIajm8/exec?email=%s&order=%d&name=%s", email, order, name.split(" (?!.* )")[0]);

        URL url = new URL(preURL);

        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        System.out.println("GET " + responseCode);

        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder lol = new StringBuilder();
            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                lol.append(inputLine);
            }

            in.close();
        } else {
            System.out.println("GET request not worked");
        }
    }
}
