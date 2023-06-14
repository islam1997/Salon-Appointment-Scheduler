#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\nWelcome to My Salon, how can I help you?"

SERVICES_ID=$($PSQL "SELECT * FROM services")
if [[ $SERVICES_ID ]]; then
  while true; do
    echo "$SERVICES_ID" | while read SERVICE_ID BAR NAME; do
      echo "$SERVICE_ID) $NAME"
    done

    read SERVICE_ID_SELECTED

    if [[ $SERVICES_ID =~ (^|[[:space:]])$SERVICE_ID_SELECTED($|[[:space:]]) ]]; then
      break
    else
      echo "I could not find that service. What would you like today?"
    fi
  done
fi

echo -e "\nWhat's your phone number?"

read CUSTOMER_PHONE
DB_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")


if [[ -z $DB_PHONE ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
$PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME','$CUSTOMER_ID','$SERVICES_ID')")
$PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')"
else 
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME
echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME','$CUSTOMER_ID','$SERVICES_ID')")
$PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')"




fi



