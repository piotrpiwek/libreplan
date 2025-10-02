#!/bin/sh
# entrypoint.sh

# Używamy envsubst do podmiany zmiennych w naszym szablonie i tworzymy finalny plik konfiguracyjny
# dla Tomcata w odpowiednim miejscu.
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Wyświetlamy wygenerowany plik w logach, żeby mieć pewność, że zmienne zostały wstawione
echo "--- Wygenerowany plik konfiguracyjny bazy danych (ROOT.xml) ---"
cat /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml
echo "--------------------------------------------------------"

# Uruchamiamy oryginalną komendę startową Tomcata
exec catalina.sh run
