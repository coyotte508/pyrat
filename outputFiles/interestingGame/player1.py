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

TEAM_NAME = "Greedy Dijkstra"

####################################################################################################################################################################################################################################
########################################################################################################## YOUR VARIABLES ##########################################################################################################
####################################################################################################################################################################################################################################

# Stores all the moves in a list to restitute them one by one

allMoves = [UP, UP, RIGHT, UP, UP, LEFT, UP, RIGHT, UP, UP, UP, UP, UP, RIGHT, RIGHT, DOWN, RIGHT, LEFT, LEFT, DOWN, RIGHT, RIGHT, DOWN, DOWN, UP, UP, UP, UP, UP, RIGHT, DOWN, RIGHT, RIGHT, RIGHT, UP, DOWN, DOWN, RIGHT, LEFT, DOWN, DOWN, LEFT, DOWN, DOWN, DOWN, RIGHT, DOWN, DOWN, LEFT, LEFT, UP, LEFT, RIGHT, DOWN, RIGHT, RIGHT, DOWN, RIGHT, UP, RIGHT, RIGHT, RIGHT, UP, UP, RIGHT, RIGHT, DOWN, RIGHT, RIGHT, RIGHT, RIGHT, UP, UP, RIGHT, DOWN, DOWN, DOWN, RIGHT, DOWN, RIGHT, DOWN, RIGHT, RIGHT, LEFT, LEFT, UP, UP, LEFT, LEFT, UP, RIGHT, RIGHT, RIGHT, RIGHT, RIGHT, UP, UP, LEFT, LEFT, UP, LEFT, DOWN, UP, UP, LEFT, UP, LEFT, LEFT, LEFT, UP, UP, UP, UP, LEFT, RIGHT, DOWN, LEFT, LEFT, DOWN, DOWN, LEFT, RIGHT, DOWN, LEFT, RIGHT, UP, RIGHT, DOWN, DOWN, UP, UP, LEFT, UP, LEFT, UP, LEFT, LEFT, LEFT, LEFT, UP, LEFT, DOWN, UP, RIGHT, DOWN, RIGHT, RIGHT, UP, UP, RIGHT, RIGHT, DOWN, RIGHT, UP, DOWN, LEFT, UP, LEFT, UP, UP, RIGHT, DOWN, RIGHT, RIGHT, DOWN, UP, UP, UP, UP, RIGHT, UP, UP, UP, UP, LEFT, UP, RIGHT, UP, LEFT, LEFT, DOWN, LEFT, LEFT, LEFT, DOWN, LEFT, DOWN, LEFT, UP, LEFT, LEFT, LEFT, LEFT, DOWN, DOWN, LEFT, UP, UP, UP, LEFT, UP, LEFT, UP, LEFT, LEFT, RIGHT, RIGHT, DOWN, RIGHT, DOWN, RIGHT, DOWN, LEFT, LEFT, LEFT, LEFT, LEFT, DOWN, DOWN, RIGHT, RIGHT, DOWN, RIGHT, UP, DOWN, DOWN, RIGHT, DOWN, RIGHT, RIGHT, RIGHT, DOWN, DOWN, DOWN, DOWN, RIGHT, LEFT, UP, UP, RIGHT, UP, RIGHT, RIGHT, LEFT, UP, RIGHT, LEFT, DOWN, LEFT, UP, UP, UP, UP, RIGHT, RIGHT, UP, UP, UP, UP, RIGHT, UP, RIGHT, RIGHT, DOWN, DOWN, RIGHT, RIGHT, UP, RIGHT, RIGHT, UP, RIGHT, DOWN, RIGHT, DOWN, RIGHT, UP, RIGHT, DOWN, UP, RIGHT, UP, DOWN, LEFT, LEFT, DOWN, DOWN, DOWN, LEFT, LEFT, DOWN, DOWN, LEFT, DOWN, LEFT, DOWN, DOWN, DOWN, RIGHT, RIGHT, DOWN, DOWN, RIGHT, DOWN, DOWN, LEFT, LEFT, DOWN, DOWN, RIGHT, RIGHT, RIGHT, DOWN, DOWN, LEFT, LEFT, DOWN, DOWN, DOWN, LEFT, LEFT, LEFT, DOWN, DOWN, RIGHT, RIGHT, UP, DOWN, LEFT, LEFT, UP, UP, LEFT, DOWN, DOWN, LEFT, DOWN, LEFT, LEFT, UP, UP, LEFT, LEFT, DOWN, LEFT, LEFT, DOWN, LEFT, UP, LEFT, UP, LEFT]

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

    # We return the next move as described by the list
    global allMoves
    nextMove = allMoves[0]
    allMoves = allMoves[1:]
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