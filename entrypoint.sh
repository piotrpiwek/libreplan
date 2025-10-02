#!/bin/sh
# entrypoint.sh

# Krok 1: Generujemy plik konfiguracyjny z podstawionymi zmiennymi.
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

echo "--- Konfiguracja bazy danych wygenerowana pomyślnie ---"

# Krok 2: Ustawiamy opcje Javy Z OGRANICZENIAMI PAMIĘCI
# Xms - startowa ilość pamięci, Xmx - maksymalna ilość pamięci
# To jest kluczowe dla darmowego planu Render!
export JAVA_OPTS="-Dhibernate.hbm2ddl.auto=update -Xms256m -Xmx400m"

echo "--- Ustawione opcje JAVA_OPTS ---"
echo "$JAVA_OPTS"
echo "---------------------------------"

# Krok 3: Uruchamiamy oryginalną komendę startową Tomcata.
exec catalina.sh run
