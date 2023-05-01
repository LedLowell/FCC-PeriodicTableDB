#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Check for argument
if [[ -z $1 ]]
then
# If not found
echo "Please provide an element as an argument."
# End
else
# Check if argument is a number
if [[ $1 =~ ^[0-9]+$  ]]
then
# Get inserted element atomic number using INT type
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
# Get inserted element atomic number using VARCHAR type
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
fi
# If atomic_number is not found
if [[ -z $ATOMIC_NUMBER ]]
then
echo "I could not find that element in the database."
# End
else
# Get element data
ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
ELEMENT_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$ELEMENT_TYPE_ID")
ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
# Output data
echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
fi
fi
