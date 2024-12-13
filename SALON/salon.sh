#! /bin/bash

# Define the database connection
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# Display the main menu
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

# Display the list of services
MAIN_MENU() {
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  if [[ -z $AVAILABLE_SERVICES ]]; then
    echo "Sorry, we do not have any services available right now."
    exit
  fi

  echo "$AVAILABLE_SERVICES" | while IFS="|" read SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  # Check if the selected service is valid
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME ]]; then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU
  else
    GET_CUSTOMER_INFO $SERVICE_ID_SELECTED "$SERVICE_NAME"
  fi
}

# Get customer information
GET_CUSTOMER_INFO() {
  SERVICE_ID_SELECTED=$1
  SERVICE_NAME=$2

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]; then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo -e "\nSorry, we could not schedule your appointment. Please try again."
  fi
}

# Run the main menu
MAIN_MENU
