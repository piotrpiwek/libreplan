#!/bin/sh
# entrypoint.sh

# Krok 1: Generujemy plik konfiguracyjny z podstawionymi zmiennymi.
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

echo "--- Konfiguracja bazy danych wygenerowana pomyślnie ---"

# Krok 2: Uruchamiamy serwer Tomcat z bezpośrednio wstrzykniętą zmienną środowiskową.
# Polecenie 'env' uruchamia program w zmodyfikowanym środowisku.
# To gwarantuje, że proces Javy zobaczy naszą opcję.
exec env JAVA_OPTS="-Dhibernate.hbm2ddl.auto=update" catalina.sh run
