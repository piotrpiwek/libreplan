# ETAP 1: Budowanie aplikacji przy użyciu Maven i JDK 8
FROM maven:3.8-openjdk-8 AS builder

WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests -Dliquibase.skip=true

# ---
# ETAP 2: Uruchomienie aplikacji na serwerze Tomcat 8 z JDK 8
FROM tomcat:8.5-jdk8-temurin

# Instalujemy pakiet 'gettext', który zawiera niezbędne narzędzie 'envsubst'
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Pobieramy i instalujemy sterownik bazy danych PostgreSQL
RUN curl -L -o /usr/local/tomcat/lib/postgresql.jar https://jdbc.postgresql.org/download/postgresql-42.2.23.jar

# Usuwamy domyślne aplikacje z Tomcata
RUN rm -rf /usr/local/tomcat/webapps/*

# Kopiujemy skompilowany plik .war
COPY --from=builder /app/libreplan-webapp/target/libreplan-webapp.war /usr/local/tomcat/webapps/ROOT.war

# Kopiujemy szablon context.xml oraz nasz nowy skrypt startowy
COPY context.xml /usr/local/tomcat/conf/Catalina/localhost/context.xml.template
COPY entrypoint.sh /usr/local/tomcat/bin/entrypoint.sh

# Nadajemy skryptowi uprawnienia do wykonania
RUN chmod +x /usr/local/tomcat/bin/entrypoint.sh

# Wystawiamy port
EXPOSE 8080

# Ustawiamy nasz skrypt jako główną komendę kontenera
ENTRYPOINT ["/usr/local/tomcat/bin/entrypoint.sh"]
