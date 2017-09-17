# pointofsale
Project for IAA&amp;T class.  Point of sale system utilizing Raspberry Pi.

## Building/running the application
Use the included gradle wrapper to build the application: `./gradlew clean build`

To run the project locally through Gradle: `./gradlew bootrun`

To run the project outside of Gradle: `java -jar pointofsale.jar`

The web server will listen on port 8080 by default.

The products repository can be queried through the "product" endpoint (HTTP GET, POST, PUT, DELETE).

The inventory can be initially mocked using the script src/test/shell/create-products.sh (uses cURL to POST to localhost).

## TODO
User 'scans' product, triggers query for product, displays information, updates total due.
Upon 'checkout', listen (separate process/app?) for magnetic stripe reader (MSR) to be used, 'process payment', relay card information on web page.
Secure the whole thing.
