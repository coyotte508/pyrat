####################################################################################################################################################################################################################################
######################################################################################################## PRE-DEFINED IMPORTS #######################################################################################################
####################################################################################################################################################################################################################################

# Imports that are necessary for the program architecture to work properly
# Do not edit this code

import ast
import sys
import os

####################################################################################################################################################################################################################################
####################################################################################################### PRE-DEFINED CONSTANTS ######################################################################################################
####################################################################################################################################################################################################################################

# Possible characters to send to the maze application
# Any other will be ignored
# Do not edit this code

UP = 'U'
DOWN = 'D'
LEFT = 'L'
RIGHT = 'R'

####################################################################################################################################################################################################################################

# Name of your team
# It will be displayed in the maze
# You have to edit this code

TEAM_NAME = "Depth-first search"

####################################################################################################################################################################################################################################
########################################################################################################## YOUR VARIABLES ##########################################################################################################
####################################################################################################################################################################################################################################

# Stores the locations that were already visited in the maze

alreadyVisited = []

####################################################################################################################################################################################################################################

# Stores the result path computed during preprocessing to send it to the maze afterwards

resultPath = []

####################################################################################################################################################################################################################################

# Stores the moves corresponding to the result path

resultMoves = []

####################################################################################################################################################################################################################################
####################################################################################################### PRE-DEFINED FUNCTIONS ######################################################################################################
####################################################################################################################################################################################################################################

# Writes a message to the shell
# Use for debugging your program
# Channels stdout and stdin are captured to enable communication with the maze
# Do not edit this code

def debug (text) :
    
    # Writes to the stderr channel
    sys.stderr.write(text)
    sys.stderr.flush()

####################################################################################################################################################################################################################################

# Reads one line of information sent by the maze application
# This function is blocking, and will wait for a line to terminate
# The received information is automatically converted to the correct type
# Do not edit this code

def readFromPipe () :
    
    # Reads from the stdin channel and returns the structure associated to the string
    try :
        text = sys.stdin.readline()
        return ast.literal_eval(text.strip())
    except :
        os._exit(-1)

####################################################################################################################################################################################################################################

# Sends the text to the maze application
# Do not edit this code

def writeToPipe (text) :
    
    # Writes to the stdout channel
    sys.stdout.write(text)
    sys.stdout.flush()

####################################################################################################################################################################################################################################

# Reads the initial maze information
# The function processes the text and returns the associated variables
# Maze map is a dictionary associating to a location its adjacent locations and the associated weights
# The preparation time gives the time during which 'initializationCode' can make computations before the game starts
# The turn time gives the time during which 'determineNextMove' can make computations before returning a decision
# Player locations are tuples (line, column)
# Coins are given as a list of locations where they appear
# A boolean indicates if the game is over
# Do not edit this code

def processInitialInformation () :
    
    # We read from the pipe
    data = readFromPipe()
    return (data['mazeMap'], data['preparationTime'], data['turnTime'], data['playerLocation'], data['opponentLocation'], data['coins'], data['gameIsOver'])

####################################################################################################################################################################################################################################

# Reads the information after each player moved
# The maze map and allowed times are no longer provided since they do not change
# Do not edit this code

def processNextInformation () :

    # We read from the pipe
    data = readFromPipe()
    return (data['playerLocation'], data['opponentLocation'], data['coins'], data['gameIsOver'])

####################################################################################################################################################################################################################################
########################################################################################################## YOUR FUNCTIONS ##########################################################################################################
####################################################################################################################################################################################################################################

# Transforms a pair of locations into a move going from the first to the second

def locationsToMove (location1, location2) :
    
    # Depends on the difference
    difference = (location1[0] - location2[0], location1[1] - location2[1])
    if difference == (0, 1) :
        return LEFT
    elif difference == (0, -1) :
        return RIGHT
    elif difference == (1, 0) :
        return UP
    else :
        return DOWN
    
####################################################################################################################################################################################################################################

# Returns the neighbors of the given location that have not been visited yet

def nonVisitedNeighbors (mazeMap, location) :
    
    # We get the neighbors and keep the non-visited ones
    global alreadyVisited
    allNeighbors = mazeMap[location]
    keptNeighbors = list(filter(lambda n : n not in alreadyVisited, allNeighbors))
    return keptNeighbors

####################################################################################################################################################################################################################################

# Performs a depth-first search to find a sequence of moves that leads to the target location

def depthFirstSearch (mazeMap, pathToCurrentLocation, targetLocation) :
    
    # We mark the current location as visited
    global alreadyVisited
    currentLocation = pathToCurrentLocation[-1]
    alreadyVisited.append(currentLocation)
    
    # If we have reached the target location, we stop
    if currentLocation == targetLocation :
        global resultPath
        resultPath = pathToCurrentLocation
        raise Exception("Finished")
    
    # Still not finished: we test the non-visited neighbors of the current location
    neighbors = nonVisitedNeighbors(mazeMap, currentLocation)
    for n in neighbors :
        depthFirstSearch(mazeMap, pathToCurrentLocation + [n], targetLocation)

####################################################################################################################################################################################################################################

# This is where you should write your code to do things during the initialization delay
# This function should not return anything, but should be used for a short preprocessing
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def initializationCode (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :
    
    # We perform a depth-first search to find a path to the coin
    try :
        depthFirstSearch(mazeMap, [playerLocation], coins[0])
    
    # When it is finished, we transform the path into moves
    except :
        global resultPath
        global resultMoves
        for l in range(len(resultPath) - 1) :
            resultMoves.append(locationsToMove(resultPath[l], resultPath[l + 1]))
    
####################################################################################################################################################################################################################################

# This is where you should write your code to determine the next direction
# This function should return one of the directions defined in the CONSTANTS section
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def determineNextMove (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :
    
    # We return the next move as it was previously computed
    global resultMoves
    (nextMove, *remainingMoves) = resultMoves
    resultMoves = remainingMoves
    return nextMove

####################################################################################################################################################################################################################################
############################################################################################################# MAIN LOOP ############################################################################################################
####################################################################################################################################################################################################################################

# This is the entry point when executing this file
# We first send the name of the team to the maze
# The first message we receive from the maze application includes the map of the maze in addition to the players and coins locations
# Then, at every loop iteration, we get the maze status and determine a move
# Do not edit this code

if __name__ == "__main__" :
    
    # We send the team name
    writeToPipe(TEAM_NAME + "\n")
    
    # We process the initial information and have a delay to compute things using it
    (mazeMap, playerLocation, opponentLocation, coins, gameIsOver) = processInitialInformation()
    initializationCode(mazeMap, playerLocation, opponentLocation, coins)
    
    # We decide how to move and wait for the next step
    while not gameIsOver :
        (playerLocation, opponentLocation, coins, gameIsOver) = processNextInformation()
        if gameIsOver :
            break
        nextMove = determineNextMove(mazeMap, playerLocation, opponentLocation, coins)
        writeToPipe(nextMove)

####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################