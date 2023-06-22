# Starting the Development Server
To run the server in development mode you execute `mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=development`. You may also add `-Dspring-boot.run.fork=false` to enable debugging to work in Intellij.

To populate the database with example data do a `GET` request to `http://127.0.0.1:8900/populateDB`.

# Accessing the Swagger documentation
API documentation is found at [http://localhost:8900/swagger-ui.html] when the sever is running in development mode. Otherwise this functionality is disabled.
