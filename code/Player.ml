(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL CONSTANTS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    let _COMMAND =
        
        (* Command to start the players' files *)
        "python3"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _EXPORT_INITIAL_LOCATION_FILE_NAME =
        
        (* Name of the file where to export the initial location for player 1 *)
        "player1StartingLocation.txt"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _EXPORT_MOVES_FILE_NAME =
        
        (* Name of the file where to export the coins locations *)
        "playerNUMBER.py"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class player (number:int) (fileName:string) (waitForAllPlayers:bool) (singlePlayer:bool) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            object (self)
            
        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** ATTRIBUTES ***************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)

            val mutable _currentLocation =
                
                (* Stores the current location of the player in the maze *)
                (-1, -1)
                
        (******************************************************************************************************************************************************************************************************************)
        
            val mutable _initialLocation =
                
                (* Stores the initial location for the final export *)
                (-1, -1)
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _inputPipe =
                
                (* Pipe to get input data *)
                open_in "/dev/null"
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _name =
                
                (* Name of the player, initialized later *)
                ""
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _movesHistory =
                
                (* List to store the performed moves *)
                []
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _numberOfFencesCrossed =
                
                (* Number of fences crossed by the player *)
                0
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _numberOfMissedMoves =
                
                (* Number of moves attempted by the player (or deadline missed) that did not end in a change of location *)
                0
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _numberOfMoves =
                
                (* Number of moves performed by the player *)
                0
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _outputPipe =
                
                (* Pipe to snd output data *)
                open_out "/dev/null"
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _previousLocation =
                
                (* Stores the previous location of the player in the maze *)
                (-1, -1)
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _score =
                
                (* Score of the player *)
                0.0
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private movesHistoryToString =
                
                (* No moves *)
                if List.length _movesHistory = 0 then
                    "[]"
                
                (* We fill a string representating the maze *)
                else
                (
                    let representation = ref "[" in
                    let fillRepresentation = fun move ->
                                             (
                                                 let moveString = match move with
                                                                      m when m = Moves._UP    -> "UP"
                                                                    | m when m = Moves._DOWN  -> "DOWN"
                                                                    | m when m = Moves._LEFT  -> "LEFT"
                                                                    | m when m = Moves._RIGHT -> "RIGHT"
                                                                    | _                       -> ("'" ^ String.make 1 Moves._WRONG ^ "'") in
                                                 representation := !representation ^ moveString ^ ", "
                                             ) in
                    List.iter fillRepresentation _movesHistory;
                    representation := String.sub !representation 0 (String.length !representation - 2) ^ "]";
                    !representation
                )
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            method askForMove =
                
                (* We return the player's decision if there is one *)
                let result = if singlePlayer && number = 2 then
                                 (Moves._WRONG, false)
                             else
                             (
                                 try
                                     let char = input_char _inputPipe in
                                     if char = Moves._UP || char = Moves._LEFT || char = Moves._RIGHT || char = Moves._DOWN then
                                         (char, true)
                                     else
                                         (Moves._WRONG, true)
                                 with
                                     _ -> (Moves._WRONG, false)
                             ) in
                
                (* We save the message received *)
                _movesHistory <- _movesHistory @ [fst result];
                result
                
        (******************************************************************************************************************************************************************************************************************)
            
            method currentLocationToString =
                
                (* Returns the representation of the location *)
                ToolBox.intPairToString _currentLocation
                
        (******************************************************************************************************************************************************************************************************************)
            
            method earnHalfPoint =
                
                (* Increases the score of 0.5 *)
                _score <- _score +. 0.5
                
        (******************************************************************************************************************************************************************************************************************)
            
            method earnPoint =
                
                (* Increases the score of 1 *)
                _score <- _score +. 1.0
                
        (******************************************************************************************************************************************************************************************************************)
            
            method exportInitialLocation (outputFilesDirectory : string) =
                
                (* We determine the full file name *)
                let fileName = outputFilesDirectory ^ "/" ^ _EXPORT_INITIAL_LOCATION_FILE_NAME in
                
                (* We open the file and write the maze to it *)
                let channel = open_out fileName in
                Printf.fprintf channel "(%d,%d)\n" (fst _initialLocation) (snd _initialLocation);
                close_out channel
                
        (******************************************************************************************************************************************************************************************************************)
            
            method exportMoves (outputFilesDirectory : string) =
                
                (* We determine the full file name *)
                let fileName = outputFilesDirectory ^ "/" ^ Str.global_replace (Str.regexp "NUMBER") (string_of_int number) _EXPORT_MOVES_FILE_NAME in
                
                (* If it was a single-player game, we remove a potentially existing file for player 2 *)
                if singlePlayer && number = 2 then
                (
                    if Sys.file_exists fileName then
                        Sys.remove fileName
                )
                
                (* In any other case, we export the Python script reproducing the performed moves *)
                else
                (
                    
                    (* We open the file and write an adaptation of the template to it *)
                    let channel = open_out fileName in
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "######################################################################################################## PRE-DEFINED IMPORTS #######################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Imports that are necessary for the program architecture to work properly\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "import ast\n";
                    Printf.fprintf channel "import sys\n";
                    Printf.fprintf channel "import os\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################### PRE-DEFINED CONSTANTS ######################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Possible characters to send to the maze application\n";
                    Printf.fprintf channel "# Any other will be ignored\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "UP = '%c'\n" Moves._UP;
                    Printf.fprintf channel "DOWN = '%c'\n" Moves._DOWN;
                    Printf.fprintf channel "LEFT = '%c'\n" Moves._LEFT;
                    Printf.fprintf channel "RIGHT = '%c'\n\n" Moves._RIGHT;
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Name of your team\n";
                    Printf.fprintf channel "# It will be displayed in the maze\n";
                    Printf.fprintf channel "# You have to edit this code\n\n";
                    Printf.fprintf channel "TEAM_NAME = \"%s\"\n\n" _name;
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "########################################################################################################## YOUR VARIABLES ##########################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Stores all the moves in a list to restitute them one by one\n\n";
                    Printf.fprintf channel "allMoves = %s\n\n" self#movesHistoryToString;
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################### PRE-DEFINED FUNCTIONS ######################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Writes a message to the shell\n";
                    Printf.fprintf channel "# Use for debugging your program\n";
                    Printf.fprintf channel "# Channels stdout and stdin are captured to enable communication with the maze\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "def debug (text) :\n\n";
                    Printf.fprintf channel "    # Writes to the stderr channel\n";
                    Printf.fprintf channel "    sys.stderr.write(text)\n";
                    Printf.fprintf channel "    sys.stderr.flush()\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Reads one line of information sent by the maze application\n";
                    Printf.fprintf channel "# This function is blocking, and will wait for a line to terminate\n";
                    Printf.fprintf channel "# The received information is automatically converted to the correct type\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "def readFromPipe () :\n\n";
                    Printf.fprintf channel "    # Reads from the stdin channel and returns the structure associated to the string\n";
                    Printf.fprintf channel "    try :\n";
                    Printf.fprintf channel "        text = sys.stdin.readline()\n";
                    Printf.fprintf channel "        return ast.literal_eval(text.strip())\n";
                    Printf.fprintf channel "    except :\n";
                    Printf.fprintf channel "        os._exit(-1)\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Sends the text to the maze application\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "def writeToPipe (text) :\n\n";
                    Printf.fprintf channel "    # Writes to the stdout channel\n";
                    Printf.fprintf channel "    sys.stdout.write(text)\n";
                    Printf.fprintf channel "    sys.stdout.flush()\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Reads the initial maze information\n";
                    Printf.fprintf channel "# The function processes the text and returns the associated variables\n";
                    Printf.fprintf channel "# Maze map is a dictionary associating to a location its adjacent locations and the associated weights\n";
                    Printf.fprintf channel "# The preparation time gives the time during which 'initializationCode' can make computations before the game starts\n";
                    Printf.fprintf channel "# The turn time gives the time during which 'determineNextMove' can make computations before returning a decision\n";
                    Printf.fprintf channel "# Player locations are tuples (line, column)\n";
                    Printf.fprintf channel "# Coins are given as a list of locations where they appear\n";
                    Printf.fprintf channel "# A boolean indicates if the game is over\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "def processInitialInformation () :\n\n";
                    Printf.fprintf channel "    # We read from the pipe\n";
                    Printf.fprintf channel "    data = readFromPipe()\n";
                    Printf.fprintf channel "    return (data['mazeMap'], data['preparationTime'], data['turnTime'], data['playerLocation'], data['opponentLocation'], data['coins'], data['gameIsOver'])\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# Reads the information after each player moved\n";
                    Printf.fprintf channel "# The maze map and allowed times are no longer provided since they do not change\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "def processNextInformation () :\n\n";
                    Printf.fprintf channel "    # We read from the pipe\n";
                    Printf.fprintf channel "    data = readFromPipe()\n";
                    Printf.fprintf channel "    return (data['playerLocation'], data['opponentLocation'], data['coins'], data['gameIsOver'])\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "########################################################################################################## YOUR FUNCTIONS ##########################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# This is where you should write your code to do things during the initialization delay\n";
                    Printf.fprintf channel "# This function should not return anything, but should be used for a short preprocessing\n";
                    Printf.fprintf channel "# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations\n";
                    Printf.fprintf channel "# Make sure to have a safety margin for the time to include processing times (communication etc.)\n\n";
                    Printf.fprintf channel "def initializationCode (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :\n\n";
                    Printf.fprintf channel "    # Nothing to do\n";
                    Printf.fprintf channel "    pass\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# This is where you should write your code to determine the next direction\n";
                    Printf.fprintf channel "# This function should return one of the directions defined in the CONSTANTS section\n";
                    Printf.fprintf channel "# This function takes as parameters the maze map, the time it is allowed for computing, the players locations in the maze and the remaining coins locations\n";
                    Printf.fprintf channel "# Make sure to have a safety margin for the time to include processing times (communication etc.)\n\n";
                    Printf.fprintf channel "def determineNextMove (mazeMap, timeAllowed, playerLocation, opponentLocation, coins) :\n\n";
                    Printf.fprintf channel "    # We return the next move as described by the list\n";
                    Printf.fprintf channel "    global allMoves\n";
                    Printf.fprintf channel "    nextMove = allMoves[0]\n";
                    Printf.fprintf channel "    allMoves = allMoves[1:]\n";
                    Printf.fprintf channel "    return nextMove\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "############################################################################################################# MAIN LOOP ############################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n\n";
                    Printf.fprintf channel "# This is the entry point when executing this file\n";
                    Printf.fprintf channel "# We first send the name of the team to the maze\n";
                    Printf.fprintf channel "# The first message we receive from the maze includes its map, the times allowed to the various steps, and the players and coins locations\n";
                    Printf.fprintf channel "# Then, at every loop iteration, we get the maze status and determine a move\n";
                    Printf.fprintf channel "# Do not edit this code\n\n";
                    Printf.fprintf channel "if __name__ == \"__main__\" :\n\n";
                    Printf.fprintf channel "    # We send the team name\n";
                    Printf.fprintf channel "    writeToPipe(TEAM_NAME + \"\\n\")\n\n";
                    Printf.fprintf channel "    # We process the initial information and have a delay to compute things using it\n";
                    Printf.fprintf channel "    (mazeMap, preparationTime, turnTime, playerLocation, opponentLocation, coins, gameIsOver) = processInitialInformation()\n";
                    Printf.fprintf channel "    initializationCode(mazeMap, preparationTime, playerLocation, opponentLocation, coins)\n\n";
                    Printf.fprintf channel "    # We decide how to move and wait for the next step\n";
                    Printf.fprintf channel "    while not gameIsOver :\n";
                    Printf.fprintf channel "        (playerLocation, opponentLocation, coins, gameIsOver) = processNextInformation()\n";
                    Printf.fprintf channel "        if gameIsOver :\n";
                    Printf.fprintf channel "            break\n";
                    Printf.fprintf channel "        nextMove = determineNextMove(mazeMap, turnTime, playerLocation, opponentLocation, coins)\n";
                    Printf.fprintf channel "        writeToPipe(nextMove)\n\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################\n";
                    Printf.fprintf channel "####################################################################################################################################################################################################################################";
                    close_out channel
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getCurrentLocation =
                
                (* Getter for the current location *)
                _currentLocation
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getInitialLocation =
                
                (* Getter for the initial location *)
                _initialLocation
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getPreviousLocation =
                
                (* Getter for the previous location *)
                _previousLocation
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getName =
                
                (* Getter for the name *)
                _name
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getNumber =
                
                (* Getter for the number *)
                number
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getNumberOfFencesCrossed =
                
                (* Getter for the number of fences crossed *)
                _numberOfFencesCrossed
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getNumberOfMissedMoves =
                
                (* Getter for the number of missed moves *)
                _numberOfMissedMoves
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getNumberOfMoves =
                
                (* Getter for the number of moves *)
                _numberOfMoves
                
        (******************************************************************************************************************************************************************************************************************)
            
            method getScore =
                
                (* Getter for the score *)
                _score
                
        (******************************************************************************************************************************************************************************************************************)
            
            method initialize (player1StartingLocationDefined : bool)
                              (startingLocation               : int * int)
                              (mazeWidth                      : int)
                              (mazeHeight                     : int) =
                
                (* If it is a single-player game, we don't do anything for player 2 *)
                if not (singlePlayer && number = 2) then
                (
                    
                    (* Starting location *)
                    _currentLocation <- if player1StartingLocationDefined then
                                        (
                                            if fst startingLocation >= 0 && fst startingLocation < mazeHeight && snd startingLocation >= 0 && snd startingLocation < mazeWidth then
                                                startingLocation
                                            else
                                                ToolBox.error "Invalid initial location for player 1"
                                        )
                                        else if number = 1 then
                                            (mazeHeight - 1, 0)
                                        else
                                            (0, mazeWidth - 1);
                    _previousLocation <- _currentLocation;
                    _initialLocation <- _currentLocation;
                    
                    (* We start the player's script and initialize the pipes *)
                    let commandLine = _COMMAND ^ " " ^ fileName in
                    let (inputPipe, outputPipe) = Unix.open_process commandLine in
                    _inputPipe <- inputPipe;
                    _outputPipe <- outputPipe;

                    (* We ask the script for the player's name *)
                    _name <- input_line inputPipe;
                    
                    (* We set the input channel in non-blocking mode to avoid waiting for players that are too slow *)
                    if not waitForAllPlayers then
                        Unix.set_nonblock (Unix.descr_of_in_channel inputPipe)
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method moveTo (l          : int)
                          (c          : int)
                          (costOfMove : int)
                          (waiting    : bool) =
                
                (* We increase the number of moves by the weight if we effectively move, or we have a missed move *)
                if _currentLocation <> (l, c) then
                (
                    _numberOfMoves <- _numberOfMoves + costOfMove;
                    if costOfMove > 1 then
                        _numberOfFencesCrossed <- _numberOfFencesCrossed + 1
                )
                else if not waiting then
                    _numberOfMissedMoves <- _numberOfMissedMoves + 1;
                
                (* We update the location *)
                _previousLocation <- _currentLocation;
                _currentLocation <- (l, c)
            
        (******************************************************************************************************************************************************************************************************************)
            
            method sendText (text : string) =
                
                (* If it is a single-player game, we don't do anything for player 2 *)
                if not (singlePlayer && number = 2) then
                (
                    
                    (* Sends a line of text through the pipe *)
                    output_string _outputPipe (text ^ "\n");
                    flush _outputPipe
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)