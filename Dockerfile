# ETAP 1: Budowanie aplikacji przy użyciu Maven i JDK 8
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests -Dliquibase.skip=true

# ---
# ETAP 2: Uruchomienie aplikacji na serwerze Tomcat 8 z JDK 8
FROM tomcat:8.5-jdk8-temurin

# Usuwamy domyślne aplikacje z Tomcata
RUN rm -rf /usr/local/tomcat/webapps/*

# Kopiujemy skompilowany plik .war z etapu 'builder'
COPY --from=builder /app/libreplan-webapp/target/libreplan-webapp.war /usr/local/tomcat/webapps/ROOT.war

# DODANY KROK: Kopiujemy konfigurację bazy danych JNDI do Tomcata.
# Tomcat automatycznie załaduje tę konfigurację dla naszej aplikacji (ROOT.war).
COPY context.xml /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Wystawiamy port, na którym nasłuchuje Tomcat
EXPOSE 8080

# Komenda, która uruchamia serwer Tomcat
CMD ["catalina.sh", "run"]
