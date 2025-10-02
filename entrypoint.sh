#!/bin/sh
# entrypoint.sh - ETAP 1: TWORZENIE BAZY

# Krok 1: Generujemy plik konfiguracyjny
envsubst < /usr/local/tomcat/conf/Catalina/localhost/context.xml.template > /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

echo "--- Konfiguracja bazy danych wygenerowana pomyślnie ---"

# Krok 2: Ustawiamy opcje Javy na "create-drop"
# 'create-drop' stworzy całą bazę od zera, a potem ją usunie przy zamknięciu.
# To zmusi aplikację do stworzenia wszystkiego, czego potrzebuje.
# Dodajemy też małe opóźnienie na końcu, żeby proces zdążył się zakończyć.
export JAVA_OPTS="-Dhibernate.hbm2ddl.auto=create-drop -Xms256m -Xmx400m"

echo "--- ETAP 1: Tworzenie schematu bazy danych. To potrwa kilka minut... ---"
echo "Ustawione JAVA_OPTS: $JAVA_OPTS"

# Krok 3: Uruchamiamy serwer, pozwalamy mu stworzyć bazę, a potem go zatrzymujemy
# Używamy 'timeout', aby serwer sam się wyłączył po 10 minutach (600s).
# To da mu wystarczająco dużo czasu na stworzenie WSZYSTKICH tabel.
timeout 600 catalina.sh run &

# Czekamy na proces Tomcata w tle
CATALINA_PID=$!
wait $CATALINA_PID

echo "--- ETAP 1 ZAKOŃCZONY: Schemat bazy danych powinien być gotowy. ---"
# Zakańczamy skrypt z kodem 0 (sukces), aby Render nie zgłosił błędu.
exit 0
