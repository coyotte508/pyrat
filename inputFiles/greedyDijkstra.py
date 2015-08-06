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

# Min-heap

import heapq

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

TEAM_NAME = "Greedy Dijkstra"

####################################################################################################################################################################################################################################
########################################################################################################## YOUR VARIABLES ##########################################################################################################
####################################################################################################################################################################################################################################

# Stores the moves corresponding to the path to follow

movesToApply = []

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

# Dijkstra's algorithm to compute the shortest paths from the initial locations to all the nodes
# Returns for each location the previous one that leads to the shortest path

def dijkstra (mazeMap, initialLocation) :
    
    # We initialize the labels and associated paths
    minHeap = []
    distances = {initialLocation:0}
    predecessors = {}
    for location in mazeMap :
        if location != initialLocation :
            distances[location] = float("inf")
            predecessors[location] = None
        heapq.heappush(minHeap, (distances[location], location))
    
    # Main loop
    while len(minHeap) != 0 :
        (locationDistance, location) = heapq.heappop(minHeap)
        for (neighbor, neighborDistance) in mazeMap[location] :
            newDistanceToNeighbor = locationDistance + neighborDistance
            if newDistanceToNeighbor < distances[neighbor] :
                minHeap[minHeap.index((distances[neighbor], neighbor))] = (newDistanceToNeighbor, neighbor)
                heapq.heapify(minHeap)
                distances[neighbor] = newDistanceToNeighbor
                predecessors[neighbor] = location
    
    # Result
    return (predecessors, distances)
    
####################################################################################################################################################################################################################################

# Updates a global list with the path to the closest coin

def findClosestCoin (mazeMap, playerLocation, coins) :

    # We compute the shortest paths to all locations using Dijkstra's algorithm
    (predecessors, distances) = dijkstra(mazeMap, playerLocation)
    
    # We find the closest coin
    closestCoin = coins[0]
    for coin in coins :
        if distances[coin] < distances[closestCoin] :
            closestCoin = coin
    
    # We retrieve the path to it
    shortestPathToCoin = [closestCoin]
    while shortestPathToCoin[0] in predecessors :
        shortestPathToCoin = [predecessors[shortestPathToCoin[0]]] + shortestPathToCoin
    
    # We save the moves associated to the path
    global movesToApply
    for l in range(len(shortestPathToCoin) - 1) :
        movesToApply.append(locationsToMove(shortestPathToCoin[l], shortestPathToCoin[l + 1]))

####################################################################################################################################################################################################################################

# This is where you should write your code to do things during the initialization delay
# This function should not return anything, but should be used for a short preprocessing
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def initializationCode (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :
    
    # Nothing to do
    pass
    
####################################################################################################################################################################################################################################

# This is where you should write your code to determine the next direction
# This function should return one of the directions defined in the CONSTANTS section
# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations
# Make sure to have a safety margin for the time to include processing times (communication etc.)

def determineNextMove (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :
    
    # If no path is currently stored, we find the path to the closest coin
    global movesToApply
    if not movesToApply :
        findClosestCoin(mazeMap, playerLocation, coins)
    
    # We apply the stored moves
    nextMove = movesToApply[0]
    movesToApply = movesToApply[1:]
    return nextMove

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