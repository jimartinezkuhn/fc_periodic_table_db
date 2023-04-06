#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#gestionando el arg
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."; exit;
else
  #if $1 is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_TO_SEARCH=$1
  else
    arg=$1
    # cantidad_letras = ${#arg}, si <= 2 symbol
    if (( ${#arg} <= 2 ))
    then
      SYMBOL_TO_SEARCH=$1
    else
      NAME_TO_SEARCH=$1
    fi
  fi
fi

#transformando arg en atomic_number en todos los casos
#echo number $ATOMIC_NUMBER_TO_SEARCH, symbol $SYMBOL_TO_SEARCH, name $NAME_TO_SEARCH
if [[ ! -z $ATOMIC_NUMBER_TO_SEARCH ]]
then
  ATM_N=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ATOMIC_NUMBER_TO_SEARCH")
  #echo $ATM_N
  else if [[ ! -z $SYMBOL_TO_SEARCH ]]
  then
    ATM_N=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL_TO_SEARCH'")
    #echo $ATM_N
  else
    ATM_N=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME_TO_SEARCH'")
    #echo $ATM_N
  fi
fi

#buscar todos los datos necesarios
if [[ -z $ATM_N ]]
then
  echo I could not find that element in the database.
else
FINAL_OUTPUT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number='$ATM_N'")

echo "$FINAL_OUTPUT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_P BAR BOILING_P BAR TYPE_ID BAR TIPO
  do
    echo The element with atomic number $ATM_N is $NAME \($SYMBOL\). It\'s a $TIPO, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius.
  done
fi