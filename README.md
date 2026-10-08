# FoundIt — Simple Campus Lost & Found

FoundIt is a small college mini-project for recording items handed to the college office and letting students view what is currently available.

The project is intentionally simple so it is easy to build, explain and demonstrate.

## Working

### Staff

1. Open FoundIt.
2. Choose **Staff Login**.
3. Login with the staff account.
4. Add an item with:
   - item name
   - photo
   - where it was found
   - who gave it to staff
   - date found
5. The item is stored in MySQL.
6. When a student collects it, staff clicks **Mark as Collected**.
7. The item status changes from AVAILABLE to COLLECTED.

### Student / Guest

1. Open FoundIt.
2. Choose **Guest Access**.
3. View the available items.
4. Identify the item and go to the college staff/office to collect it.

There is no student account system, messaging system, claims system or payment system.

## Technologies

- Java
- JSP
- Java Servlets
- JDBC
- MySQL
- HTML
- CSS
- Apache Tomcat
- VS Code

JavaScript and Maven are intentionally not required.

## Project structure

```text
FoundIt/
├── database/
│   └── schema.sql
├── src/com/foundit/
│   ├── model/Item.java
│   ├── servlet/
│   │   ├── AddItemServlet.java
│   │   ├── CollectItemServlet.java
│   │   ├── GuestItemsServlet.java
│   │   ├── StaffDashboardServlet.java
│   │   ├── StaffLoginServlet.java
│   │   └── StaffLogoutServlet.java
│   └── util/DBConnection.java
├── WebContent/
│   ├── WEB-INF/
│   │   ├── classes/
│   │   ├── lib/
│   │   ├── web.xml
│   │   └── views/
│   │       ├── add-item.jsp
│   │       ├── guest-items.jsp
│   │       └── staff-dashboard.jsp
│   ├── css/style.css
│   ├── index.jsp
│   └── staff-login.jsp
├── build.bat
├── deploy.bat
└── README.md
```

## Requirements

Install:

1. JDK 21
2. Apache Tomcat 10.1
3. MySQL 8.4+
4. VS Code with Extension Pack for Java
5. MySQL Connector/J

No Maven is needed.

## 1. Set up MySQL

Open MySQL Workbench and run the contents of:

`database/schema.sql`

The script creates the `foundit_db` database, creates the tables and inserts the demo staff account:

```text
Username: staff
Password: foundit123
```

Change these values before using the project anywhere outside a college demo.

## 2. Configure JDBC

Open:

`src/com/foundit/util/DBConnection.java`

Set your MySQL username and password:

```java
private static final String USER = "root";
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD";
```

## 3. Add MySQL Connector/J

Download MySQL Connector/J from:

https://dev.mysql.com/downloads/connector/j/

The connector JAR is intentionally not stored in Git. After cloning this
repository, download Connector/J and copy the JAR into:

`WebContent/WEB-INF/lib/`

Any file matching `mysql-connector-j-*.jar` is accepted. Example:

`mysql-connector-j-26.7.0.jar`

## 4. Configure Tomcat path

The included batch files use:

`C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1`

If Tomcat is installed elsewhere, edit the `TOMCAT` line in both batch files.

## 5. Build

Open a terminal in the project folder and run:

```bat
build.bat
```

This compiles the Java source into:

`WebContent/WEB-INF/classes`

## 6. Deploy

Run:

```bat
deploy.bat
```

Then start Tomcat:

```bat
C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1\bin\startup.bat
```

Open:

http://localhost:8080/FoundIt/

## 7. Test the project

### Staff test

- Staff Login
- username: `staff`
- password: `foundit123`
- Add a test item
- Check that it appears in the dashboard
- Mark it as collected

### Guest test

- Open **View Available Items** from the home page
- Check that only AVAILABLE items are shown

Guest access does not create an account or require a session.

## Upload storage

Uploaded images are served from the application's `uploads` directory so the
JSP image paths remain simple. Before replacing the deployed application,
`deploy.bat` copies that directory to:

`Tomcat\webapps\FoundItUploads\`

It restores the files after deployment, so normal redeployment does not delete
previously uploaded photos.

## Viva explanation

### Why JSP?
JSP is used for the web pages. It can receive data from a Servlet and display it.

### Why Servlet?
Servlets handle requests such as login, adding an item and marking an item collected.

### Why JDBC?
JDBC is the bridge between Java and MySQL.

### Why MySQL?
MySQL stores the staff account and item records permanently.

### How does login work?
The login form sends username and password to a Servlet. The Servlet uses JDBC to check the staff table. If the values match, a session is created and the staff dashboard is opened.

### How does adding an item work?
The staff fills the form. The Servlet receives the form data and photo, stores the photo in the web application's uploads folder, then inserts the item details into MySQL with status AVAILABLE.

### How does a guest see items?
The public guest Servlet selects only rows where status = AVAILABLE and passes them to the JSP page.

### How does collection work?
The staff clicks Mark as Collected. The Servlet updates the item's status from AVAILABLE to COLLECTED.

## Important note

This is a college demonstration project. It is intentionally kept simple rather than being a production-ready lost-and-found platform.
