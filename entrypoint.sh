#!/bin/sh
# entrypoint.sh

# Krok 1: Generujemy plik konfiguracyjny z podstawionymi zmiennymi.
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Krok 2: Ustawiamy opcje Javy. Zmienna JAVA_OPTS jest standardem odczytywanym przez skrypt catalina.sh.
# To jest pewniejsza metoda niż CATALINA_OPTS.
export JAVA_OPTS="-Dhibernate.hbm2ddl.auto=update"

echo "--- Ustawione opcje JAVA_OPTS ---"
echo "$JAVA_OPTS"
echo "---------------------------------"

# Krok 3: Uruchamiamy oryginalną komendę startową Tomcata.
# Skrypt catalina.sh automatycznie użyje zmiennej JAVA_OPTS.
exec catalina.sh run
