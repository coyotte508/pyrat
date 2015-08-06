####################################################################################################################################################################################################################################
############################################################################################################ DESCRIPTION ###########################################################################################################
####################################################################################################################################################################################################################################
#
#   This scripts replays the last match using the files in the provided directory.
#   This will exactly the same match as previously.
#
#   The directory must contain valid files "player1.ml", "player2.ml", "maze.txt", "coins.txt".
#
####################################################################################################################################################################################################################################
############################################################################################################# ARGUMENTS ############################################################################################################
####################################################################################################################################################################################################################################

# Arguments to provide through the shell
filesDirectory="$1"

# Arguments defining the game mode
player1FileName="$1/player1.py"
player2FileName="$1/player2.py"
if ! [ -f "$player2FileName" ]; then player2FileName="_"; fi
if [ -f "$player2FileName" ]; then singlePlayer="false"; else singlePlayer="true"; fi
if ! [ -f "$player2FileName" ]; then player1StartingLocation=`cat $1/player1StartingLocation.txt`; else player1StartingLocation="_"; fi
mazeFileName="$1/maze.txt"
coinsFileName="$1/coins.txt"
waitForAllPlayers="true"
turnTime="0.1"
preparationTime="3.0"
mazeMapAvailable="false"
opponentLocationAvailable="false"
coinsLocationAvailable="false"

# Arguments defining the maze (unused if the maze file is provided)
mazeWidth="_"
mazeHeight="_"
mazeDensity="_"
fenceProbability="_"
nbMovesToCrossFence="_"

# Arguments defining the coins (unused if the coins file is provided)
singleCoin="_"
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
  echo "Usage: $0 <filesDirectory>"
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