#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams RESTART identity")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
# ignore the top line of csv file
if [[ $YEAR != 'year' ]]
  # get winner name
  then
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # check if value is already present
    if [[ -z $WINNER_NAME ]]
      then
      # insert winner name in teams table giving a unique team_id
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
          then
          echo Inserted into teams, $WINNER
        fi
      fi
    if [[ -z $OPPONENT_NAME ]]
      then
      # insert loser name in teams table giving a unique team_id
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
          then
          echo Inserted $OPPONENT into teams
        fi
    fi
fi
done
# populate the games table
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
# ignore the top line of csv file
if [[ $YEAR != 'year' ]]
  # get winner name
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_OTHER_STUFF=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  # get winner and opponent ids from the teams table

    if [[ $INSERT_OTHER_STUFF == "INSERT 0 1" ]]
      then
      echo Inserted $WINNER vs $OPPONENT result of round $ROUND
    fi
  fi
  done

