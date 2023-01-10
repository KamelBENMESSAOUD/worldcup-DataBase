#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WGOALS OGOALS

do
if [[ $WINNER != "winner" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
fi
   WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  #Insert values into games table
  INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER, $OPPONENT, $WGOALS, $OGOALS)")"
  #check if the data were well filled
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
  then
    echo  data inserted!
  else
    echo error of insertion!
  fi

done
