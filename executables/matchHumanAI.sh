####################################################################################################################################################################################################################################
############################################################################################################ DESCRIPTION ###########################################################################################################
####################################################################################################################################################################################################################################
#
#   This script starts the maze in 2-player mode.
#   The first player (bottom-left) is a human player that can control the token using the small interface or using the arrows on the keyboard.
#   The second player (top-right) can be any AI, or another human player.
#   However, if player 2 is a human, there will be focus issues in order to control the tokens.
#
#   In this game, the map of the maze, the opponent's location, and the coins locations are available to the programs playing.
#   The game is asynchronous (i.e missing a deadline won't cause the opponent to wait).
#
####################################################################################################################################################################################################################################
############################################################################################################# ARGUMENTS ############################################################################################################
####################################################################################################################################################################################################################################

# Arguments to provide through the shell
player2FileName="$1"
if [ -n "$2" ]; then mazeFileName="$2"; else mazeFileName="_"; fi
if [ -n "$3" ]; then coinsFileName="$3"; else coinsFileName="_"; fi

# Arguments defining the game mode
singlePlayer="false"
player1StartingLocation="_"
player1FileName="./inputFiles/humanPlayer.py"
waitForAllPlayers="false"
turnTime="0.1"
preparationTime="3.0"
mazeMapAvailable="true"
opponentLocationAvailable="true"
coinsLocationAvailable="true"

# Arguments defining the maze (unused if the maze file is provided)
mazeWidth="25"
mazeHeight="25"
mazeDensity="0.9"
fenceProbability="0.1"
nbMovesToCrossFence="10"

# Arguments defining the coins (unused if the coins file is provided)
singleCoin="false"
coinsDistribution="0.1"

# Other generic arguments
outputFilesDirectory="./outputFiles/previousGame"
randomSeed="-1"
traceLength="20"
hideMazeInterface="false"

####################################################################################################################################################################################################################################
############################################################################################### COMMAND LINE (RUN FROM PROJECT ROOT) ###############################################################################################
####################################################################################################################################################################################################################################

# Arguments verification
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <player2FileName> [<mazeFileName> [<coinsFileName>]]"
  exit 1
fi

# Command line
./executables/pyrat \
    $singlePlayer \
    $player1StartingLocation \
    $player1FileName \
    $player2FileName \
    $randomSeed \
    $mazeFileName \
    $mazeWidth \
    $mazeHeight \
    $mazeDensity \
    $coinsFileName \
    $singleCoin \
    $coinsDistribution \
    $fenceProbability \
    $nbMovesToCrossFence \
    $waitForAllPlayers \
    $turnTime \
    $preparationTime \
    $traceLength \
    $mazeMapAvailable \
    $opponentLocationAvailable \
    $coinsLocationAvailable \
    $outputFilesDirectory \
    $hideMazeInterface \
    &

####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################