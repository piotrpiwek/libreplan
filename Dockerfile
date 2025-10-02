# ETAP 1: Budowanie aplikacji przy użyciu Maven i JDK 8
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests -Dliquibase.skip=true

# ---
# ETAP 2: Uruchomienie aplikacji na serwerze Tomcat 8 z JDK 8
FROM tomcat:8.5-jdk8-temurin

# DODANY KROK: Pobieramy i instalujemy sterownik bazy danych PostgreSQL
# Tomcat potrzebuje tego pliku, aby móc komunikować się z bazą danych Supabase.
RUN curl -L -o /usr/local/tomcat/lib/postgresql.jar https://jdbc.postgresql.org/download/postgresql-42.2.23.jar

# Usuwamy domyślne aplikacje z Tomcata
RUN rm -rf /usr/local/tomcat/webapps/*

# Kopiujemy skompilowany plik .war z etapu 'builder'
COPY --from=builder /app/libreplan-webapp/target/libreplan-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Kopiujemy konfigurację bazy danych JNDI do Tomcata
COPY context.xml /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Wystawiamy port, na którym nasłuchuje Tomcat
EXPOSE 8080

# Komenda, która uruchamia serwer Tomcat
CMD ["catalina.sh", "run"]
