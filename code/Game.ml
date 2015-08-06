(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL CONSTANTS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    let _EXPORT_TIKZ_FILE_NAME =
        
        (* Name of the file where to export the maze *)
        "game.tex"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class game (maze                      : Maze.maze)
               (player1                   : Player.player)
               (player2                   : Player.player)
               (interface                 : Interface.interface)
               (singlePlayer              : bool)
               (mazeMapAvailable          : bool)
               (coinsLocationAvailable    : bool)
               (opponentLocationAvailable : bool)
               (preparationTime           : float)
               (turnTime                  : float) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            object (self)
            
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private askPlayer (player                 : Player.player)
                                     (playerHasMoved         : bool ref)
                                     (playerRemainingPenalty : int ref)
                                     (moveAfterPenalty       : char ref)
                                     (nextMoveValue          : int ref) =
                
                (* The player can move normally, we ask for a decision and check if it creates a penalty *)
                if !playerRemainingPenalty = 0 then
                (
                    let move, validMove = player#askForMove in
                    let newL, newC = maze#determineLocationAfterMove move player in
                    nextMoveValue := (maze#weightBetweenCells player#getCurrentLocation (newL, newC));
                    if !nextMoveValue > 1 then
                    (
                        let currentL, currentC = player#getCurrentLocation in
                        playerHasMoved := false;
                        playerRemainingPenalty := !nextMoveValue;
                        moveAfterPenalty := move;
                        ('W', currentL, currentC)
                    )
                    else
                    (
                        playerHasMoved := validMove;
                        (move, newL, newC)
                    )
                )
                
                (* The player is at the end of a penalty *)
                else if !playerRemainingPenalty = 1 then
                (
                    let newL, newC = maze#determineLocationAfterMove !moveAfterPenalty player in
                    playerHasMoved := true;
                    decr playerRemainingPenalty;
                    (!moveAfterPenalty, newL, newC)
                )
                
                (* The player is suffering a penalty *)
                else
                (
                    let currentL, currentC = player#getCurrentLocation in
                    playerHasMoved := false;
                    decr playerRemainingPenalty;
                    ('W', currentL, currentC)
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private distributePoints (locationOfPlayer1 : int * int)
                                            (locationOfPlayer2 : int * int) =
            
                (* Point to player 1 *)
                if maze#coinInCell locationOfPlayer1 && locationOfPlayer1 <> locationOfPlayer2 then
                (
                    player1#earnPoint;
                    maze#removeCoin locationOfPlayer1
                );
                
                (* Point to player 2 *)
                if maze#coinInCell locationOfPlayer2 && locationOfPlayer1 <> locationOfPlayer2 then
                (
                    player2#earnPoint;
                    maze#removeCoin locationOfPlayer2
                );
                
                (* Point to both players *)
                if maze#coinInCell locationOfPlayer1 && locationOfPlayer1 = locationOfPlayer2 then
                (
                    player1#earnHalfPoint;
                    player2#earnHalfPoint;
                    maze#removeCoin locationOfPlayer1
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private isOver =
                
                (* Whatever game mode, if there is no coin, the game is over *)
                if maze#countCoins = 0 then
                    true
                
                (* The game is over if a player can't reach the other's core (2-player game) *)
                else if not singlePlayer then
                    player1#getScore +. float_of_int maze#countCoins < player2#getScore || player2#getScore +. float_of_int maze#countCoins < player1#getScore
                
                (* If none of the previous cases occured, the game continues *)
                else
                    false
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private prepareInformationForPlayer (player    : Player.player)
                                                       (opponent  : Player.player)
                                                       (firstTime : bool) =

                (* String representing the map *)
                let mazeMap = if mazeMapAvailable && firstTime then
                                  maze#mazeToString
                              else
                                  "{}" in

                (* Timing information *)
                let preparationTimeAllowed = string_of_float preparationTime in
                let turnTimeAllowed = string_of_float turnTime in

                (* String representing the coins *)
                let coins = if coinsLocationAvailable then
                                maze#coinsToString
                            else
                                "[]" in

                (* We check if the game is over *)
                let gameIsOver = if self#isOver then
                                     "True"
                                 else
                                     "False" in

                (* Player and opponent's locations *)
                let playerLocation = player#currentLocationToString in
                let opponentLocation = if opponentLocationAvailable then
                                           opponent#currentLocationToString
                                       else
                                           "(-1, -1)" in

                (* String to send *)
                let stringToSend = ref "{" in
                if firstTime then
                    stringToSend := !stringToSend ^ "'mazeMap':" ^ mazeMap ^ ", 'preparationTime':" ^ preparationTimeAllowed ^ ", 'turnTime':" ^ turnTimeAllowed ^ ", ";
                stringToSend := !stringToSend ^ "'coins':" ^ coins ^ ", 'playerLocation':" ^ playerLocation ^ ", 'opponentLocation':" ^ opponentLocation ^ ", 'gameIsOver':" ^ gameIsOver ^ "}";
                !stringToSend
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private sendCurrentInformationToPlayers (sendToPlayer1 : bool)
                                                           (sendToPlayer2 : bool) =

                (* We compute the strings to send to the players and send them as close as possible to both players *)
                let stringToSendToPlayer1 = self#prepareInformationForPlayer player1 player2 false in
                let stringToSendToPlayer2 = self#prepareInformationForPlayer player2 player1 false in
                if sendToPlayer1 then
                    player1#sendText stringToSendToPlayer1;
                if sendToPlayer2 then
                    player2#sendText stringToSendToPlayer2
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private sendInitialInformationToPlayers =

                (* We compute the strings to send to the players and send them as close as possible to both players *)
                let stringToSendToPlayer1 = self#prepareInformationForPlayer player1 player2 true in
                let stringToSendToPlayer2 = self#prepareInformationForPlayer player2 player1 true in
                player1#sendText stringToSendToPlayer1;
                player2#sendText stringToSendToPlayer2
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private writeGameResult =
                
                (* We write the result to the interface *)
                interface#writeMessage (if player1#getScore > player2#getScore || singlePlayer then
                                            (player1#getName ^ " wins the game")
                                        else if player1#getScore < player2#getScore then
                                            (player2#getName ^ " wins the game")
                                        else
                                            "The game is a tie");
                
                (* We also write the statistics to the shell *)
                let resultString = ref ("{'player1': {'score': " ^ string_of_float player1#getScore ^ ", 'moves': " ^ string_of_int player1#getNumberOfMoves ^ ", 'missed': " ^ string_of_int player1#getNumberOfMissedMoves ^ ", 'fences': " ^ string_of_int player1#getNumberOfFencesCrossed ^ "}") in
                if singlePlayer then
                    resultString := !resultString ^ "}"
                else
                    resultString := !resultString ^ ", 'player2': {'score': " ^ string_of_float player2#getScore ^ ", 'moves': " ^ string_of_int player2#getNumberOfMoves ^ ", 'missed': " ^ string_of_int player2#getNumberOfMissedMoves ^ ", 'fences': " ^ string_of_int player2#getNumberOfFencesCrossed ^ "}}";
                print_endline !resultString
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            method exportTikz (outputFilesDirectory : string) =
                
                (* We determine the full file name *)
                let fileName = outputFilesDirectory ^ "/" ^ _EXPORT_TIKZ_FILE_NAME in
                
                (* We open the file and write the maze to it *)
                let channel = open_out fileName in
                Printf.fprintf channel "%s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "%s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "%s\n\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "    %s Essential LaTeX headers\n" "%";
                Printf.fprintf channel "    \\documentclass{standalone}\n";
                Printf.fprintf channel "    \\usepackage{tikz}\n\n";
                Printf.fprintf channel "    %s Graph\n" "%";
                Printf.fprintf channel "    \\begin{document}\n\n";
                Printf.fprintf channel "        %s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "        %s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIKZ STYLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "        %s\n\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "            %s Colors\n" "%";
                Printf.fprintf channel "            \\definecolor{nothing}{HTML}{%06X}\n" Interface._MAZE_BACKGROUND_COLOR;
                Printf.fprintf channel "            \\definecolor{player1}{HTML}{%06X}\n" Interface._PLAYER_1_COLOR;
                Printf.fprintf channel "            \\definecolor{player2}{HTML}{%06X}\n" Interface._PLAYER_2_COLOR;
                Printf.fprintf channel "            \\definecolor{coin}{HTML}{%06X}\n\n" Interface._COINS_COLOR;
                Printf.fprintf channel "        %s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "        %s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIKZ FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "        %s\n\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "            \\begin{tikzpicture}\n\n";
                Printf.fprintf channel "                %s Nodes\n" "%";
                for l = 0 to maze#getHeight - 1 do
                    for c = 0 to maze#getWidth - 1 do
                        let color = if (l, c) = player1#getInitialLocation then
                                        "player1"
                                    else if (l, c) = player2#getInitialLocation then
                                        "player2"
                                    else if maze#coinInitiallyInCell (l, c) then
                                        "coin"
                                    else
                                        "nothing" in
                        Printf.fprintf channel "                \\node[draw, circle, fill=%s] at (%d, %d) (%d-%d) {};\n" color c (maze#getHeight - 1 - l) c (maze#getHeight - 1 - l)
                    done
                done;
                Printf.fprintf channel "\n";
                Printf.fprintf channel "                %s Edges\n" "%";
                for l = 0 to maze#getHeight - 1 do
                    for c = 0 to maze#getWidth - 1 do
                        for l2 = l to maze#getHeight - 1 do
                            for c2 = c to maze#getWidth - 1 do
                                let weight = maze#weightBetweenCells (l, c) (l2, c2) in
                                if weight = 1 then
                                    Printf.fprintf channel "                \\draw[] (%d-%d) -- (%d-%d);\n" c (maze#getHeight - 1 - l) c2 (maze#getHeight - 1 - l2)
                                else if weight > 1 && l <> l2 then
                                    Printf.fprintf channel "                \\draw[] (%d-%d) -- (%d-%d) node[midway, left=-0.08cm]{\\tiny{%d}};\n" c (maze#getHeight - 1 - l) c2 (maze#getHeight - 1 - l2) weight
                                else if weight > 1 && c <> c2 then
                                    Printf.fprintf channel "                \\draw[] (%d-%d) -- (%d-%d) node[midway, above=-0.08cm]{\\tiny{%d}};\n" c (maze#getHeight - 1 - l) c2 (maze#getHeight - 1 - l2) weight
                            done
                        done
                    done
                done;
                Printf.fprintf channel "\n";
                Printf.fprintf channel "            \\end{tikzpicture}\n\n";
                Printf.fprintf channel "        %s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "        %s\n\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "    \\end{document}\n\n";
                Printf.fprintf channel "%s\n" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                Printf.fprintf channel "%s" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
                
                (* Done *)
                close_out channel
                
        (******************************************************************************************************************************************************************************************************************)
            
            method start =
                
                (* We send the initial information to the players and leave them some time to compute stuff *)
                self#sendInitialInformationToPlayers;
                interface#writeMessage "Preparation step";
                let endTime = Unix.gettimeofday () +. preparationTime in
                ToolBox.wait(endTime);
                
                (* We play the game until it is finished *)
                interface#writeMessage "Go";
                let player1HasMoved = ref true in
                let player2HasMoved = ref true in
                let player1RemainingPenalty = ref 0 in
                let player2RemainingPenalty = ref 0 in
                let moveAfterPenalty1 = ref Moves._WRONG in
                let moveAfterPenalty2 = ref Moves._WRONG in
                let nextMoveValue1 = ref 0 in
                let nextMoveValue2 = ref 0 in
                while not self#isOver do

                    (* We send the information to the players, and then update the interface, leaving the time of the animation to compute a result *)
                    self#sendCurrentInformationToPlayers !player1HasMoved !player2HasMoved;
                    interface#update !player1RemainingPenalty !player2RemainingPenalty;

                    (* We ask the players for a choice, and update the penalities *)
                    let (player1Move, newL1, newC1) = self#askPlayer player1 player1HasMoved player1RemainingPenalty moveAfterPenalty1 nextMoveValue1 in
                    let (player2Move, newL2, newC2) = self#askPlayer player2 player2HasMoved player2RemainingPenalty moveAfterPenalty2 nextMoveValue2 in
                    
                    (* We print the decision on the interface *)
                    interface#writeMessage (if singlePlayer then
                                                ("[" ^ String.make 1 player1Move ^ "]")
                                            else
                                                ("[" ^ String.make 1  player1Move ^ "]                                                                                [" ^ String.make 1 player2Move ^ "]"));
                    
                    (* We make the players move *)
                    player1#moveTo newL1 newC1 !nextMoveValue1 (player1Move = 'W');
                    player2#moveTo newL2 newC2 !nextMoveValue2 (player2Move = 'W');
                    
                    (* We update the scores *)
                    self#distributePoints (newL1, newC1) (newL2, newC2)
                    
                done;
                
                (* Final update *)
                self#sendCurrentInformationToPlayers !player1HasMoved !player2HasMoved;
                interface#update !player1RemainingPenalty !player2RemainingPenalty;
                self#writeGameResult
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)