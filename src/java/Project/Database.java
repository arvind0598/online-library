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

    int checkCustomer(String email, String password, Boolean internal) {
        int status = -1;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("begin ? := check_customer(?,?,?); end;");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setInt(4, internal ? 1 : 0);
            stmt.execute();
            status = stmt.getInt(1);

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    int checkAdmin(String email, String password) {
        int status = -1;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("begin ? := check_admin(?,?); end;");
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
            stmt.execute();
            status = true;
            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }

    Boolean logoutUser(int user_id) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("call logout_user(?)");
            stmt.setInt(1, user_id);
            stmt.execute();
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
                name = Helper.capitalizeWord(name);
                obj.put(res.getInt(1), name);
            }

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }

    public JSONObject getGenresWithBooks() {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select books.id, books.name, author, genres.name, cost, owner from books join genres on(genres.id = genre) where stock > 0 and display = 1 order by genre");
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                JSONObject book = new JSONObject();
                book.put("name", Helper.capitalizeWord(res.getString(2)));
                book.put("author", Helper.capitalizeWord(res.getString(3)));
                book.put("cost", res.getInt(5));
                book.put("secondhand", res.getInt(6) != 0);

                String genreName = Helper.capitalizeWord(res.getString(4));

                if (!obj.containsKey(genreName)) {
                    JSONObject genre = new JSONObject();
                    genre.put("data", new JSONObject());
                    obj.put(genreName, genre);
                }

                ((JSONObject)((JSONObject) obj.get(genreName)).get("data")).put(res.getInt(1), book);
            }

            conn.close();

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

            conn.close();

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

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }

    public JSONObject getCartDetails(int customer_id) {
        JSONObject obj = new JSONObject();
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select book_id, qty, name, cost, owner from cart join books on(book_id = id) where cust_id = ? and active = 1");
            stmt.setInt(1, customer_id);
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                JSONObject books = new JSONObject();
                books.put("qty", res.getInt(2));
                books.put("name", Helper.capitalizeWord(res.getString(3)));
                books.put("cost", res.getInt(4));
                books.put("secondhand", res.getInt(5) != 0);
                obj.put(res.getInt(1), books);
            }

            conn.close();
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

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return x;
    }

    Boolean updateCart(int customer_id, int book_id, int qty) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("call update_cart_qty(?,?,?)");
            stmt.setInt(1, customer_id);
            stmt.setInt(2, book_id);
            stmt.setInt(3, qty);
            stmt.execute();
            conn.close();
            status = true;

        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    public JSONObject getOrderHistory(int customer_id) {
        JSONObject obj = new JSONObject();
         try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select id, bill, status from orders where cust_id = ?");
            stmt.setInt(1, customer_id);
            ResultSet res = stmt.executeQuery();

            while (res.next()) {
                JSONObject item = new JSONObject();
                int order_id = res.getInt(1);
                item.put("bill", res.getInt(2));
                item.put("status", res.getInt(3));
                obj.put(order_id, item);
            }

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }
    
    Boolean changePassword(int customer_id, String password) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("call change_password(?,?)");
            stmt.setInt(1, customer_id);
            stmt.setString(2, password);
            stmt.execute();
            conn.close();
            status = true;

        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    Boolean changeAddress(int customer_id, String address) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("call change_address(?,?)");
            stmt.setInt(1, customer_id);
            stmt.setString(2, address);
            stmt.execute();
            conn.close();
            status = true;

        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    public Boolean bookInCart(int customer_id, int book_id) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            PreparedStatement stmt = conn.prepareStatement("select * from cart where cust_id = ? and book_id = ?");
            stmt.setInt(1, customer_id);
            stmt.setInt(2, book_id);
            ResultSet res = stmt.executeQuery();

            if(res.next()) {
                status = true;
            }

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    public JSONObject getBookDetails(int book_id) {
        JSONObject obj = new JSONObject();
        try {
            Connection conn = connectSql();
            PreparedStatement stmt = conn.prepareStatement("select genres.name, books.name, details, cost, age, owner, author from books join genres on(books.genre = genres.id) where books.id = ? and stock > 0 and display = 1");
            stmt.setInt(1, book_id);
            ResultSet res = stmt.executeQuery();

            if (res.next()) {
                obj.put("genre", Helper.capitalizeWord(res.getString(1)));
                obj.put("name", Helper.capitalizeWord(res.getString(2)));
                obj.put("details", res.getString(3));
                obj.put("cost", res.getInt(4));
                obj.put("age", res.getInt(5));
                obj.put("secondhand", res.getInt(6) != 0);
                obj.put("author", Helper.capitalizeWord(res.getString(7)));
            }

            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }

        return obj;
    }
    
    Boolean addGenre(String genre, int admin_id) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("begin ? := add_genre(?,?); end;");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setString(2, genre);
            stmt.setInt(3, admin_id);
            stmt.execute();
            status = stmt.getInt(1) == 1;
            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
    }
    
    Boolean removeGenre(int genre, int admin_id) {
        Boolean status = false;
        try (Connection conn = connectSql()) {
            CallableStatement stmt = conn.prepareCall("begin ? := remove_genre(?,?); end;");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.setInt(2, genre);
            stmt.setInt(3, admin_id);
            stmt.execute();
            status = stmt.getInt(1) == 1;
            conn.close();
        } catch (Exception e) {
            Helper.handleError(e);
        }
        return status;
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

    public static String capitalizeWord(String str) {
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
