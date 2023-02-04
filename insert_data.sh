#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

TR=$($PSQL "TRUNCATE TABLE games, teams")

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read YEAR ROUND W O W_GOALS O_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$O'")
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$W'")
    if [[ -z $W_ID ]]
    then
      INS=$($PSQL "INSERT INTO teams(name) VALUES('$W')")
    fi
    if [[ -z $O_ID ]]
    then
      INS=$($PSQL "INSERT INTO teams(name) VALUES('$O')")
    fi

    if [[ -z $O_ID ]]
    then
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$O'")
    fi

    if [[ -z $W_ID ]]
    then
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$W'")
    fi

    INS=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES('$YEAR', '$W_ID', '$O_ID', '$W_GOALS', '$O_GOALS', '$ROUND')")


  fi
done