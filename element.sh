#!/bin/bash

# Variables for PSQL
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check for argument
  #If there is an argument
    if [[ ! -z $1 ]]
    then
    #Check if argument is a number
      #If argument isn't a number
      if [[ ! $1 =~ ^[0-9]+$ ]]
      then
      #result is a symbol or name
      RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types USING(type_id) WHERE symbol ILIKE '$1' OR name ILIKE '$1';")
      else
    #If argument is a number
      #Result is atomic number
      RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types USING(type_id) WHERE elements.atomic_number = $1;")
      fi
    #If element is found
      if [[ ! -z $RESULT ]]
      then
      echo $RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE;
        do
			  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
			  done
      else
    #If element is not found
      echo "I could not find that element in the database."
      
    fi
  #If there isn't an argument
    else
      echo Please provide an element as an argument.
    fi