# The Online Library
An online semi-library system using Java Servlets, JSP and Oracle SQL with PL SQL, made for DBS Lab Project, CCE V Semester. 


## Setup Instructions

Download Netbeans with Java EE bundled, from [here](https://netbeans.org/downloads/).

While installing, also install the Tomcat server, there is no need to use Glassfish.

Download and install Oracle 11G Express Edition from [here](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/xe-prior-releases-5172097.html).

Create a file called Credentials.java in the Project package containing these:

```
public class Credentials {
    public static String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    public static String DB_USERNAME = "system";
    public static String DB_PASSWORD = "your password here";
}
```

Use the @ command in the SQL Plus CLI to run the SQL scripts, in the order setup->more->data

Run project using Netbeans.

Ps. Remember to commit.
