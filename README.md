# FoundIt - Campus Lost & Found

FoundIt is a Java web application for a college office to record lost items and let students check which items are still available. The project is designed as a small, practical demo of a lost-and-found workflow using Java servlets, JSP, and MySQL.

## What the app does

### Staff flow

1. Open the app and go to Staff Login.
2. Sign in with the configured staff account.
3. Add a lost item with:
   - item name
   - photo
   - where it was found
   - who handed it in
   - date found
4. View the dashboard of all recorded items.
5. Mark an item as collected once it has been returned.

### Guest flow

1. Open the home page.
2. Use the "View Available Items" option.
3. Browse the currently uncollected items.
4. Visit the college office to claim the item.

## Features

- Staff-only dashboard protected by a servlet session check
- Secure login for staff using the `staff` table
- Image upload support for lost items
- Item status tracking: `AVAILABLE` and `COLLECTED`
- Guest browsing of only available items
- Built-in deployment scripts for local Tomcat setup

## Tech stack

- Java 21
- Jakarta Servlet API
- JSP
- JDBC
- MySQL
- Apache Tomcat 10.1
- HTML and CSS
- VS Code with Java support

No Maven is required for this project.

## Project structure

```text
FoundIt/
├── database/
│   └── schema.sql
├── src/
│   └── com/foundit/
│       ├── filter/
│       │   └── StaffAuthFilter.java
│       ├── model/
│       │   └── Item.java
│       ├── servlet/
│       │   ├── AddItemServlet.java
│       │   ├── CollectItemServlet.java
│       │   ├── GuestItemsServlet.java
│       │   ├── StaffDashboardServlet.java
│       │   ├── StaffLoginServlet.java
│       │   └── StaffLogoutServlet.java
│       └── util/
│           └── DBConnection.java
├── WebContent/
│   ├── WEB-INF/
│   │   ├── classes/
│   │   ├── lib/
│   │   ├── web.xml
│   │   └── views/
│   │       ├── add-item.jsp
│   │       ├── guest-items.jsp
│   │       └── staff-dashboard.jsp
│   ├── css/
│   │   └── style.css
│   ├── index.jsp
│   ├── staff-login.jsp
│   └── uploads/
├── build.bat
├── deploy.bat
├── README.md
└── .gitignore
```

## Requirements

Install the following before running the app:

1. JDK 21
2. Apache Tomcat 10.1
3. MySQL 8.4+
4. VS Code with Java support
5. MySQL Connector/J JAR

## 1. Create the database

Run the SQL script in:

`database/schema.sql`

This creates the `foundit_db` database, the `staff` and `items` tables, and inserts the demo staff account:

```text
Username: staff
Password: foundit123
```

If you are using this for anything beyond a demo, change the default credentials.

## 2. Configure the database connection

Open:

`src/com/foundit/util/DBConnection.java`

Update the username and password to match your MySQL installation:

```java
private static final String USER = "root";
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD";
```

## 3. Add MySQL Connector/J

Download the connector from:

https://dev.mysql.com/downloads/connector/j/

Copy the JAR into:

`WebContent/WEB-INF/lib/`

The folder accepts any file matching:

`mysql-connector-j-*.jar`

## 4. Configure Tomcat path

The helper scripts expect Tomcat at:

`C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1`

If your installation is elsewhere, update the `TOMCAT` path in both `build.bat` and `deploy.bat`.

## 5. Build the project

From the project root, run:

```bat
build.bat
```

This compiles the Java classes into:

`WebContent/WEB-INF/classes`

## 6. Deploy locally

Run:

```bat
deploy.bat
```

This script:

- builds the application
- copies the web app to Tomcat
- backs up the `uploads` directory before redeploy
- starts Tomcat and opens the app in the browser

Once deployment is complete, open:

http://localhost:8080/FoundIt/

If the browser does not open automatically, you can start Tomcat manually with:

```bat
"C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1\bin\startup.bat"
```

## 7. How the application works

### Staff login

The login form posts the username and password to `StaffLoginServlet`. The servlet checks the `staff` table and creates a session when the credentials match.

### Staff authorization

`StaffAuthFilter` blocks access to staff-only pages unless a valid `staffUser` session exists.

### Adding an item

`AddItemServlet` validates the form fields and uploaded image, saves the image to the app's `uploads` folder, and inserts the item into the MySQL `items` table with status `AVAILABLE`.

### Dashboard

`StaffDashboardServlet` loads all items and shows them in reverse order of insertion. Staff can mark a record as collected from the dashboard.

### Guest item list

`GuestItemsServlet` selects only records with `status = 'AVAILABLE'`.

### Marking collected

`CollectItemServlet` updates an item from `AVAILABLE` to `COLLECTED` when the staff clicks the action button.

## Default login

The demo account created by the SQL script is:

```text
Username: staff
Password: foundit123
```

## Upload storage behavior

Uploaded photos are stored in the application's `uploads` directory and are referenced from the JSP pages using their file names. The deployment script backs up existing uploads before replacing the application and restores them after deployment so photos are not lost during a redeploy.

## Notes

This project is a simple academic/demo-type lost-and-found system. It is intentionally lightweight and does not include advanced user roles, messaging, claims workflows, or production-grade security features.
