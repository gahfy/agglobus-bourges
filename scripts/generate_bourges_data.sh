#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo $SCRIPT_DIR
cd $SCRIPT_DIR

printf "\033[0;32mDownloading data\033[0m\n"

curl -sL $(curl -sL https://data.centrevaldeloire.fr/api/v2/catalog/datasets/agglobus-offre-theorique-mobilite-reseau-urbain-de-bourges/exports/csv | grep -oEi 'https://[^;]+') > BOURGES.zip

printf "Inflating archive\n"
unzip BOURGES.zip

printf "Removing archive\n"
rm BOURGES.zip

printf "\033[0;32mGenerating routes table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' routes.txt

# Removing backup files
printf "Removing backup file\n"
rm routes.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat routes.txt | sed "s/\([^,]*\),[^,]*,\([^,]*\),\([^,]*\),[^,]*,[^,]*,[^,]*,\([^,]*\),\([^,]*\),\([^,]*\)/INSERT INTO routes(route_id, route_short_name, route_long_name, route_color, route_text_color, route_sort_order) VALUES ('\1', '\2', '\3', '\4', '\5', \6);/g" > routes.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS routes(route_id TEXT NOT NULL PRIMARY KEY, route_short_name TEXT NOT NULL, route_long_name TEXT NOT NULL, route_color TEXT NOT NULL, route_text_color TEXT NOT NULL, route_sort_order INTEGER NOT NULL);\n/' routes.sql

# Remove backup file
printf "Removing backup file\n"
rm routes.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat routes.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm routes.sql

# Remove CSV file
printf "Remove data file\n"
rm routes.txt




printf "\033[0;32mGenerating calendar table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' calendar.txt

# Removing backup files
printf "Removing backup file\n"
rm calendar.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat calendar.txt | sed "s/\([^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*\)/INSERT INTO calendar(service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) VALUES (\1);/g" > calendar.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS calendar(service_id INTEGER NOT NULL PRIMARY KEY, monday INTEGER NOT NULL, tuesday INTEGER NOT NULL, wednesday INTEGER NOT NULL, thursday INTEGER NOT NULL, friday INTEGER NOT NULL, saturday INTEGER NOT NULL, sunday INTEGER NOT NULL, start_date INTEGER NOT NULL, end_date INTEGER NOT NULL);\n/' calendar.sql

# Remove backup file
printf "Removing backup file\n"
rm calendar.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat calendar.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm calendar.sql

# Remove CSV file
printf "Remove data file\n"
rm calendar.txt




printf "\033[0;32mGenerating calendar dates table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' calendar_dates.txt

# Removing backup files
printf "Removing backup file\n"
rm calendar_dates.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat calendar_dates.txt | sed "s/\([^,]*,[^,]*,[^,]*\)/INSERT INTO calendar_dates(service_id, date, exception_type) VALUES (\1);/g" > calendar_dates.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS calendar_dates(service_id INTEGER NOT NULL PRIMARY KEY, date INTEGER NOT NULL, exception_type INTEGER NOT NULL);\n/' calendar_dates.sql

# Remove backup file
printf "Removing backup file\n"
rm calendar_dates.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat calendar_dates.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm calendar_dates.sql

# Remove CSV file
printf "Remove data file\n"
rm calendar_dates.txt




printf "\033[0;32mGenerating shapes table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' shapes.txt

# Removing backup files
printf "Removing backup file\n"
rm shapes.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat shapes.txt | sed "s/\([^,]*\),\([^,]*,[^,]*,[^,]*\)/INSERT INTO shapes(shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence) VALUES ('\1', \2);/g" > shapes.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS shapes(shape_pt_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, shape_id TEXT NOT NULL, shape_pt_lat REAL NOT NULL, shape_pt_lon REAL NOT NULL, shape_pt_sequence INTEGER NOT NULL);\n/' shapes.sql

# Remove backup file
printf "Removing backup file\n"
rm shapes.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat shapes.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm shapes.sql

# Remove CSV file
printf "Remove data file\n"
rm shapes.txt




printf "\033[0;32mGenerating trips table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' trips.txt

# Removing backup files
printf "Removing backup file\n"
rm trips.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat trips.txt | sed "s/\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*,[^,]*\)/INSERT INTO trips(route_id, service_id, trip_id, trip_headsign, trip_short_name, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed) VALUES ('\1', \2, '\3', '\4', '\5', \6, '\7', '\8', \9);/g" > trips.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS trips(route_id TEXT NOT NULL, service_id INTEGER NOT NULL, trip_id TEXT NOT NULL PRIMARY KEY, trip_headsign TEXT NOT NULL, trip_short_name TEXT NOT NULL, direction_id INTEGER NOT NULL, block_id TEXT NOT NULL, shape_id TEXT NOT NULL, wheelchair_accessible INTEGER NOT NULL, bikes_allowed INTEGER NOT NULL, FOREIGN KEY(route_id) REFERENCES routes(route_id));\n/' trips.sql

# Remove backup file
printf "Removing backup file\n"
rm trips.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat trips.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm trips.sql

# Remove CSV file
printf "Remove data file\n"
rm trips.txt







printf "\033[0;32mGenerating stops table\033[0m\n"

# Remove first line which is useless
printf "Removing first line of file\n"
sed -i".bck" -e '1d' stops.txt

# Replace all instances of ' by '' in order to make it compatible for SQL statements
printf "Switching ' to '' to prepare for SQL statements\n"
sed -i".bck" -e "s/'/''/g" stops.txt

# Removing backup files
printf "Removing backup file\n"
rm stops.txt.bck

# Replace each single line by an INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat stops.txt | sed "s/\([^,]*\),[^,]*,\([^,]*\),[^,]*,\([^,]*,[^,]*\),[^,]*,[^,]*,[^,]*,\([^,]*\),[^,]*,[^,]*,[^,]*,[^,]*/INSERT INTO stops(stop_id, stop_name, stop_lon, stop_lat, parent_station) VALUES ('\1', '\2', \3, '\4');/g" > stops.sql

# Add the create table statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS stops(stop_id TEXT NOT NULL PRIMARY KEY, stop_name TEXT NOT NULL, stop_lon REAL NOT NULL, stop_lat REAL NOT NULL, parent_station TEXT NOT NULL);\n/' stops.sql

# Remove backup file
printf "Removing backup file\n"
rm stops.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database\n"
cat stops.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file\n"
rm stops.sql

# Remove CSV file
printf "Remove data file\n"
rm stops.txt



printf "\033[0;32mGenerating stop times table\033[0m\n"

# Longest part of the script.
# Change all formatted times into number of seconds since midnight
for HOUR in {0..23}
do
  for MINUTE in {0..59}
  do
    OCCURRENCE=$((HOUR * 60 + MINUTE + 1))
    NUMBER=$((HOUR * 3600 + MINUTE * 60))
	  FORMATTED_HOUR=$(printf "%02d" $HOUR)
	  FORMATTED_MINUTE=$(printf "%02d" $MINUTE)
    sed -i".bck" -e "s/$FORMATTED_HOUR:$FORMATTED_MINUTE:00/$NUMBER/g" stop_times.txt
    printf "\rEditing time ($OCCURRENCE / 1440)"
  done
done

# Remove first line which is useless
printf "\nRemoving first line of file\n"
sed -i".bck" -e '1d' stop_times.txt

# Remove backup file
printf "Removing backup file\n"
rm stop_times.txt.bck

# Replace each single line by SQL INSERT statement
printf "Converting CSV entries into SQL statements\n"
cat stop_times.txt | sed "s/\([^,]*\),\([^,]*,[^,]*\),\([^,]*\),\([^,]*,[^,]*,[^,]*\),[^,]*,\([^,]*\),[^,]*/INSERT INTO stop_times(trip_id, arrival_time, departure_time, stop_id, stop_sequence, pickup_type, drop_off_type, stop_headsign) VALUES ('\1', \2, '\3', \4, '\5');/g" > stop_times.sql

# Add CREATE TABLE statement
printf "Adding CREATE TABLE statement\n"
sed -i".bck" -e '1s/^/CREATE TABLE IF NOT EXISTS stop_times(stop_time_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, trip_id TEXT NOT NULL, arrival_time INTEGER NOT NULL, departure_time INTEGER NOT NULL, stop_id TEXT NOT NULL, stop_sequence INTEGER NOT NULL, pickup_type INTEGER NOT NULL, drop_off_type INTEGER NOT NULL, stop_headsign TEXT NOT NULL, FOREIGN KEY(stop_id) REFERENCES stops(stop_id), FOREIGN KEY(trip_id) REFERENCES trips(trip_id));\n/' stop_times.sql

# Remove backup file
printf "Removing backup file\n"
rm stop_times.sql.bck

#Import data in sqlite database
printf "Import data in SQLite database"
cat stop_times.sql | sqlite3 bourges.db

# Remove sql file
printf "Remove SQL file"
rm stop_times.sql

# Remove CSV file
printf "Remove data file\n"
rm stop_times.txt

#Remove unused files
printf "Remove unused file\n"
rm agency.txt
rm stop_extensions.txt
rm transfers.txt
