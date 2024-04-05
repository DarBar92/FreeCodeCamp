#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ Welcome to the Salon! ~~\n"

SERVICES() {
  if [[ $1 ]]
    then
    echo -e "\n$1"
  fi
# services
  # get services
    SERVICES=$($PSQL "SELECT service_id, name FROM services;")
  # display them 
    echo -e "\nOur Services:\n"
    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
    echo "$SERVICE_ID) $NAME"
    done
  # choose service
    echo -e "\nChoose your service:"
    read SERVICE_ID_SELECTED
    CHOSEN_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if not found
    if [[ -z $CHOSEN_SERVICE_ID ]]
      then
      #display services again
      SERVICES "That is not a valid service. Please try again"
      else
      BOOKING
    fi
}

BOOKING() {
  # customers phone number
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    # get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if not found
    if [[ -z $CUSTOMER_ID ]]
      then
        # get customers name
        echo -e "\nWhat is your name?"
        read CUSTOMER_NAME
        # add customer
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
        echo "inserted $CUSTOMER_NAME, $CUSTOMER_PHONE into customers"
        # get customer_id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
  # get time
    echo -e "\nWhat time would you like your appointment to be?"
    read SERVICE_TIME
  #insert appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $CHOSEN_SERVICE_ID, '$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $CHOSEN_SERVICE_ID")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ //') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/^ //')."
}

SERVICES