# ETAP 1: Budowanie aplikacji przy użyciu Maven i JDK
# Używamy oficjalnego obrazu Maven z wbudowanym JDK 17
FROM maven:3.8.5-openjdk-17 AS builder

# Ustawiamy katalog roboczy wewnątrz kontenera
WORKDIR /app

# Kopiujemy cały kod źródłowy aplikacji do kontenera
COPY . .

# Uruchamiamy budowanie projektu za pomocą Maven. 
# -DskipTests pomija testy, co znacznie przyspiesza budowanie obrazu.
RUN mvn clean install -DskipTests -Dliquibase.skip=true

# ---
# ETAP 2: Uruchomienie aplikacji na serwerze Tomcat
# Używamy lekkiego, oficjalnego obrazu Tomcat
FROM tomcat:9.0-jdk17-temurin

# Usuwamy domyślne aplikacje z Tomcata, aby było czysto
RUN rm -rf /usr/local/tomcat/webapps/*

# Kopiujemy skompilowany plik .war z etapu 'builder' do katalogu webapps Tomcata.
# Zmieniamy nazwę na ROOT.war, aby aplikacja była dostępna pod głównym adresem URL,
# a nie np. /libreplan/
COPY --from=builder /app/libreplan-webapp/target/libreplan.war /usr/local/tomcat/webapps/ROOT.war

# Wystawiamy port, na którym nasłuchuje Tomcat
EXPOSE 8080

# Komenda, która uruchamia serwer Tomcat po starcie kontenera
CMD ["catalina.sh", "run"]
