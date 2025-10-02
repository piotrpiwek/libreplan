# ETAP 1: Budowanie aplikacji przy użyciu Maven i JDK 8 (zgodnie z wymaganiami)
FROM maven:3.8-openjdk-8 AS builder

# Ustawiamy katalog roboczy wewnątrz kontenera
WORKDIR /app

# Kopiujemy cały kod źródłowy aplikacji do kontenera
COPY . .

# Uruchamiamy budowanie projektu, pomijając testy i problematyczny plugin Liquibase
RUN mvn clean install -DskipTests -Dliquibase.skip=true

# ---
# ETAP 2: Uruchomienie aplikacji na serwerze Tomcat 8 z JDK 8 (zgodnie z wymaganiami)
FROM tomcat:8.5-jdk8-temurin

# Usuwamy domyślne aplikacje z Tomcata
RUN rm -rf /usr/local/tomcat/webapps/*

# Kopiujemy skompilowany plik .war z etapu 'builder' do katalogu webapps Tomcata
# Prawidłowa nazwa pliku to 'libreplan-webapp.war'
COPY --from=builder /app/libreplan-webapp/target/libreplan-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Wystawiamy port, na którym nasłuchuje Tomcat
EXPOSE 8080

# Komenda, która uruchamia serwer Tomcat po starcie kontenera
CMD ["catalina.sh", "run"]
