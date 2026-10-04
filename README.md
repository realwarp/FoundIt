# FoundIt — Campus Lost & Found

FoundIt is a beginner-friendly full-stack Java mini project for a college campus. Students can create an account, log in, report lost/found items, browse active posts and mark their own posts as returned.

The project deliberately avoids Maven. It is designed for a practical/viva and uses JSP, Servlets, JDBC and MySQL.

## Tech stack

- Java 21
- JSP
- Java Servlets (Jakarta Servlet 6)
- JDBC
- MySQL 8.4+
- Apache Tomcat 10.1
- HTML
- CSS
- JavaScript
- VS Code

## Features

- User registration
- Password hashing with PBKDF2WithHmacSHA256
- Login/logout with sessions
- Lost item posts
- Found item posts
- Lost/Found filters
- Dashboard statistics
- Mark-your-own post as returned
- Client-side validation
- Responsive UI

## Project structure

```text
FoundIt/
├── .vscode/
│   └── settings.json
├── database/
│   └── schema.sql
├── lib/
│   └── README.md
├── src/
│   └── com/foundit/
│       ├── filter/
│       │   └── AuthFilter.java
│       ├── model/
│       │   └── Item.java
│       ├── servlet/
│       │   ├── CreateItemServlet.java
│       │   ├── DashboardServlet.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── MarkReturnedServlet.java
│       │   └── RegisterServlet.java
│       └── util/
│           ├── DBConnection.java
│           ├── HtmlUtil.java
│           └── PasswordUtil.java
├── WebContent/
│   ├── WEB-INF/
│   │   ├── lib/
│   │   ├── views/
│   │   │   ├── dashboard.jsp
│   │   │   └── report-item.jsp
│   │   └── web.xml
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── app.js
│   ├── index.jsp
│   ├── login.jsp
│   └── register.jsp
├── build.bat
├── deploy.bat
└── README.md
```

## Requirements

Install:

1. JDK 21
2. Apache Tomcat 10.1
3. MySQL Server 8.4+
4. VS Code + Extension Pack for Java
5. MySQL Connector/J

## 1. Database setup

Open MySQL Workbench and run:

```sql
SOURCE path/to/FoundIt/database/schema.sql;
```

Or paste the schema into Workbench and execute it.

This creates the `foundit_db` database and its `users` and `items` tables.

## 2. Configure MySQL credentials

Open:

`src/com/foundit/util/DBConnection.java`

Set your local MySQL credentials:

```java
private static final String USER = "root";
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD";
```

The default connection is:

```text
jdbc:mysql://localhost:3306/foundit_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
```

Do not commit a real password to a public repository. For this college project, enter the password locally after cloning.

## 3. Add MySQL Connector/J

Download the official MySQL Connector/J JAR from:

https://dev.mysql.com/downloads/connector/j/

Copy the downloaded JAR into:

`WebContent/WEB-INF/lib/`

The project intentionally uses no Maven.

## 4. Configure VS Code

Open the project folder in VS Code.

The included `.vscode/settings.json` points Java to:

- Tomcat's `lib` JARs
- The project's `WEB-INF/lib` JARs

Change the Tomcat path if your installation is elsewhere.

## 5. Compile

Open a PowerShell terminal in the project root:

```powershell
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force build/classes | Out-Null

$tomcat = "C:\apache-tomcat-10.1"

javac -cp "$tomcat\lib\servlet-api.jar;WebContent\WEB-INF\lib\*" `
      -d build/classes `
      (Get-ChildItem -Recurse src -Filter *.java).FullName
```

Or run:

```bat
build.bat
```

The batch script assumes Tomcat is installed at `C:\apache-tomcat-10.1`.

## 6. Deploy

Run:

```bat
deploy.bat
```

This copies the web files, compiled classes and JDBC JAR into:

```text
C:\apache-tomcat-10.1\webapps\FoundIt\
```

Start Tomcat:

```bat
C:\apache-tomcat-10.1\bin\startup.bat
```

Open:

http://localhost:8080/FoundIt/

## 7. First use

1. Register an account.
2. Log in.
3. Create a LOST or FOUND listing.
4. Return to the dashboard.
5. Filter LOST/FOUND items.
6. Mark one of your own listings as returned.
7. Log out.

## Troubleshooting

### `package jakarta.servlet does not exist`

Check `.vscode/settings.json` and make sure the Tomcat directory is correct.

### Connector/J error

Make sure the MySQL Connector/J JAR is inside `WebContent/WEB-INF/lib/`.

### MySQL connection failure

Make sure MySQL is running and listening on port 3306.

### Access denied

Update the credentials in `DBConnection.java`.

### JSP 500 error

Check Tomcat logs and verify:

- `WEB-INF/classes` contains compiled classes.
- `WEB-INF/lib` contains the Connector/J JAR.
- Tomcat 10.1 is being used.

## Viva explanation

- HTML/CSS/JavaScript: browser interface and basic validation.
- JSP: web pages and server-rendered UI.
- Servlets: request handling and application logic.
- JDBC: Java-to-MySQL database access.
- MySQL: users and lost/found records.
- Tomcat: web application server.

## Security choices

- Passwords are stored as PBKDF2WithHmacSHA256 hashes, not plain text.
- Database queries use `PreparedStatement`.
- Protected routes require an authenticated HTTP session.
- JSP output is HTML-escaped before display.
