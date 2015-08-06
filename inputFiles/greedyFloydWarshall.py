####################################################################################################################################################################################################################################
######################################################################################################## PRE-DEFINED IMPORTS #######################################################################################################
####################################################################################################################################################################################################################################

# Imports that are necessary for the program architecture to work properly
# Do not edit this code

import ast
import sys
import os

####################################################################################################################################################################################################################################
########################################################################################################### YOUR IMPORTS ###########################################################################################################
####################################################################################################################################################################################################################################

# For the square root

import math

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

TEAM_NAME = "Greedy Floyd-Warshall"

####################################################################################################################################################################################################################################
########################################################################################################## YOUR VARIABLES ##########################################################################################################
####################################################################################################################################################################################################################################

# Matrix of distances as computed by the Floyd-Warshall algorithm

distances = []

####################################################################################################################################################################################################################################

# Matrix of successors as computed by the Floyd-Warshall algorithm

successors = []

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

# Floyd-Warshall algorithm (also called Roy-Warshall algorithm or Roy-Floyd algorithm)
# Computes the successors to allow one to find the shortest paths between every nodes
# Sets the matrix of successors to allow one to retrieve the shortest paths

def floydWarshall (adjacencyMatrix, mazeMap) :
    
    # We initialize the distances and successors
    global distances
    global successors
    distances = [[float("inf") for c in range(len(adjacencyMatrix))] for l in range(len(adjacencyMatrix))]
    successors = [[None for c in range(len(adjacencyMatrix))] for l in range(len(adjacencyMatrix))]
    for l in range(len(adjacencyMatrix)) :
        for c in range(len(adjacencyMatrix)) :
            if l == c :
                distances[l][c] = 0
                successors[l][c] = None
            elif adjacencyMatrix[l][c] >= 1 :
                distances[l][c] = adjacencyMatrix[l][c]
                successors[l][c] = c
    
    # Floyd-Warshall main loop for the top right part (we also use the fact that the graph is undirected)
    for k in range(len(adjacencyMatrix)) :
        for l in range(len(adjacencyMatrix)) :
            for c in range(l + 1, len(adjacencyMatrix)) :
                if distances[l][k] + distances[k][c] < distances[l][c] :
                    distances[l][c] = distances[l][k] + distances[k][c]
                    successors[l][c] = successors[l][k]
                    distances[c][l] = distances[l][c]
                    successors[c][l] = successors[c][k]

####################################################################################################################################################################################################################################

# Returns an integer associated to the given location
# The locations are numbered in lexical order starting from the top left location

def locationToMatrixCoordinate (location, mazeWidth) :
    
    # We return the associated number
    return location[0] * mazeWidth + location[1]

####################################################################################################################################################################################################################################

# Returns a location associated to the given ingeter
# Inverse of locationToMatrixCoordinate

def matrixCoordinateToLocation (index, mazeWidth) :
    
    # We return the associated number
    return (index // mazeWidth, index % mazeWidth)

####################################################################################################################################################################################################################################

# Returns the width and the height of the maze
# Width is the first element of the tuple

def mazeDimensions (mazeMap) :
    
    # We find the max of each coordinate
    mazeMaxLine = 0
    mazeMaxColumn = 0
    for location in mazeMap :
        mazeMaxLine = max(mazeMaxLine, location[0])
        mazeMaxColumn = max(mazeMaxColumn, location[1])
    return (mazeMaxColumn + 1, mazeMaxLine + 1)

####################################################################################################################################################################################################################################

# Returns the adjacency matrix associated to the maze map

def mapToAdjacencyMatrix (mazeMap) :
    
    # We number the locations in order from the top left one
    (mazeWidth, mazeHeight) = mazeDimensions(mazeMap)
    adjacencyMatrix = [[0 for c in range(mazeWidth * mazeHeight)] for l in range(mazeWidth * mazeHeight)]
    for location in mazeMap :
        locationIndex = locationToMatrixCoordinate(location, mazeWidth)
        for (neighbor, neighborDistance) in mazeMap[location] :
            neighborIndex = locationToMatrixCoordinate(neighbor, mazeWidth)
            adjacencyMatrix[locationIndex][neighborIndex] = neighborDistance
    
    # Result
    return adjacencyMatrix
    
####################################################################################################################################################################################################################################

# This is where you should write your code to do things during the initialization delay
# This function should not return anything, but should be used for a short preprocessing
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def initializationCode (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :

    # We use the Floyd-Warshall algorithm to compute the shortest paths between all locations
    adjacencyMatrix = mapToAdjacencyMatrix(mazeMap)
    floydWarshall(adjacencyMatrix, mazeMap)
    
####################################################################################################################################################################################################################################

# This is where you should write your code to determine the next direction
# This function should return one of the directions defined in the CONSTANTS section
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def determineNextMove (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :
    
    # We find the closest coin
    global distances
    global successors
    (mazeWidth, mazeHeight) = mazeDimensions(mazeMap)
    closestCoinIndex = locationToMatrixCoordinate(coins[0], mazeWidth)
    playerIndex = locationToMatrixCoordinate(playerLocation, mazeWidth)
    for coin in coins[1:] :
        coinIndex = locationToMatrixCoordinate(coin, mazeWidth)
        if distances[playerIndex][coinIndex] < distances[playerIndex][closestCoinIndex] :
            closestCoinIndex = coinIndex
    
    # Let's go there
    nextLocation = matrixCoordinateToLocation(successors[playerIndex][closestCoinIndex], mazeWidth)
    return locationsToMove(playerLocation, nextLocation)
    
####################################################################################################################################################################################################################################
############################################################################################################# MAIN LOOP ############################################################################################################
####################################################################################################################################################################################################################################

# This is the entry point when executing this file
# We first send the name of the team to the maze
# The first message we receive from the maze includes its map, the times allowed to the various steps, and the players and coins locations
# Then, at every loop iteration, we get the maze status and determine a move
# Do not edit this code

if __name__ == "__main__" :
    
    # We send the team name
    writeToPipe(TEAM_NAME + "\n")
    
    # We process the initial information and have a delay to compute things using it
    (mazeMap, preparationTime, turnTime, playerLocation, opponentLocation, coins, gameIsOver) = processInitialInformation()
    initializationCode(mazeMap, preparationTime, playerLocation, opponentLocation, coins)
    
    # We decide how to move and wait for the next step
    while not gameIsOver :
        (playerLocation, opponentLocation, coins, gameIsOver) = processNextInformation()
        if gameIsOver :
            break
        nextMove = determineNextMove(mazeMap, turnTime, playerLocation, opponentLocation, coins)
        writeToPipe(nextMove)

####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################