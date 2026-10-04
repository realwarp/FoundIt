# Validation notes

The project was checked for source structure and the Java source was syntax-checked/compiled against a minimal Jakarta Servlet API stub matching the APIs used by the application. Password hashing was also exercised for both valid and invalid passwords.

A full end-to-end Tomcat + JSP + MySQL runtime test cannot be performed in this tool environment because a local Tomcat/MySQL runtime is not available.

For the local Windows runtime, run `build.bat`, install MySQL Connector/J, execute `database/schema.sql`, set the MySQL password in `DBConnection.java`, deploy with `deploy.bat`, and start Tomcat 10.1.