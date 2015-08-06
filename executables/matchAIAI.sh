####################################################################################################################################################################################################################################
############################################################################################################ DESCRIPTION ###########################################################################################################
####################################################################################################################################################################################################################################
#
#   This script starts the maze in 2-player mode.
#   This game mode puts together 2 AIs that have to collect more coins than the opponent.
#   Player 1 is on bottom-left and player 2 is on top-right.
#   Since the maze is symmetric, the initial location does not impact the result of the match (unless you provide maze or coins files that are not symmetric).
#
#   In this game, the map of the maze, the opponent's location, and the coins locations are available to the programs playing.
#   The game is asynchronous (i.e missing a deadline won't cause the opponent to wait).
#
####################################################################################################################################################################################################################################
############################################################################################################# ARGUMENTS ############################################################################################################
####################################################################################################################################################################################################################################

# Arguments to provide through the shell
player1FileName="$1"
player2FileName="$2"
if [ -n "$3" ]; then mazeFileName="$3"; else mazeFileName="_"; fi
if [ -n "$4" ]; then coinsFileName="$4"; else coinsFileName="_"; fi

# Arguments defining the game mode
singlePlayer="false"
player1StartingLocation="_"
waitForAllPlayers="false"
turnTime="0.1"
preparationTime="3.0"
mazeMapAvailable="true"
opponentLocationAvailable="true"
coinsLocationAvailable="true"

# Arguments defining the maze (unused if the maze file is provided)
mazeWidth="25"
mazeHeight="25"
mazeDensity="1"
fenceProbability="0.1"
nbMovesToCrossFence="10"

# Arguments defining the coins (unused if the coins file is provided)
singleCoin="false"
coinsDistribution="0.1"

# Other generic arguments
outputFilesDirectory="./outputFiles/previousGame"
randomSeed="-1"
traceLength="10"
hideMazeInterface="false"

####################################################################################################################################################################################################################################
############################################################################################### COMMAND LINE (RUN FROM PROJECT ROOT) ###############################################################################################
####################################################################################################################################################################################################################################

# Arguments verification
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <player1FileName> <player2FileName> [<mazeFileName> [<coinsFileName>]]"
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