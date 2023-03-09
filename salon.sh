#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Welcome to our salon ~~~~~\n"

echo -e "Here's our services. How can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  read SERVICE_ID_SELECTED
  SERVICE_GET=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SERVICE_GET ]]
  then
  MAIN_MENU "I could not find that service. What would you like today?"
  else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  
  CUSTOMER_GET=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_GET ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    echo -e "\nWhat time would you like your$SERVICE_GET, $CUSTOMER_NAME?"
    read SERVICE_TIME
    echo -e "\nI have put you down for a$SERVICE_GET at $SERVICE_TIME, $CUSTOMER_NAME."
    CUSTOMER_NEW_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_CUSTOMER_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_NEW_ID', '$SERVICE_ID_SELECTED','$SERVICE_TIME')") 
    else
    echo -e "\nWhat time would you like your$SERVICE_GET, $CUSTOMER_GET?"
    read SERVICE_APPOINTMENT
    echo -e "\nI have put you down for a$SERVICE_GET at $SERVICE_APPOINTMENT, $CUSTOMER_GET."
    CUSTOMER_EXIST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_CUSTOMER_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_EXIST_ID', '$SERVICE_ID_SELECTED','$SERVICE_APPOINTMENT')") 
    fi
  fi
}
MAIN_MENU