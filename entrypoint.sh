#!/bin/sh
# entrypoint.sh - ETAP 2: NORMALNE URUCHOMIENIE

# Krok 1: Generujemy plik konfiguracyjny
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

echo "--- Konfiguracja bazy danych wygenerowana pomyślnie ---"

# Krok 2: Ustawiamy opcje Javy na "validate"
# Teraz, gdy baza już istnieje, aplikacja ma tylko sprawdzić, czy wszystko jest OK.
# To zapewni błyskawiczny start.
export JAVA_OPTS="-Dhibernate.hbm2ddl.auto=validate -Xms256m -Xmx400m"

echo "--- ETAP 2: Uruchamianie aplikacji w trybie walidacji... ---"
echo "Ustawione JAVA_OPTS: $JAVA_OPTS"

# Krok 3: Uruchamiamy normalnie serwer Tomcat
exec catalina.sh run
