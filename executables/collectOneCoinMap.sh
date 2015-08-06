####################################################################################################################################################################################################################################
############################################################################################################ DESCRIPTION ###########################################################################################################
####################################################################################################################################################################################################################################
#
#   This script starts the maze in single-player mode.
#   The objective here is to collect the only coin in the maze, located in top-right position.
#
#   In this game, the map of the maze and the coin location are available to the program playing.
#
####################################################################################################################################################################################################################################
############################################################################################################# ARGUMENTS ############################################################################################################
####################################################################################################################################################################################################################################

# Arguments to provide through the shell
player1FileName="$1"
if [ -n "$2" ]; then mazeFileName="$2"; else mazeFileName="_"; fi
if [ -n "$3" ]; then coinsFileName="$3"; else coinsFileName="_"; fi

# Arguments defining the game mode
singlePlayer="true"
player1StartingLocation="_"
player2FileName="_"
waitForAllPlayers="_"
turnTime="0.1"
preparationTime="3.0"
mazeMapAvailable="true"
opponentLocationAvailable="_"
coinsLocationAvailable="true"

# Arguments defining the maze (unused if the maze file is provided)
mazeWidth="25"
mazeHeight="25"
mazeDensity="0.9"
fenceProbability="0"
nbMovesToCrossFence="_"

# Arguments defining the coins (unused if the coins file is provided)
singleCoin="true"
coinsDistribution="_"

# Other generic arguments
outputFilesDirectory="./outputFiles/previousGame"
randomSeed="-1"
traceLength="-1"
hideMazeInterface="false"

####################################################################################################################################################################################################################################
############################################################################################### COMMAND LINE (RUN FROM PROJECT ROOT) ###############################################################################################
####################################################################################################################################################################################################################################

# Arguments verification
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <player1FileName> [<mazeFileName> [<coinsFileName>]]"
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