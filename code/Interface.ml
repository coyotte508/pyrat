(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL CONSTANTS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    let _COINS_BORDER_COLOR =
        
        (* Color of the border for the coins *)
        0xE1AE13
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _COINS_CELL_RATIO =
        
        (* Size of the coins as a ratio of cell size *)
        0.5
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _COINS_COLOR =
        
        (* Color of the coins *)
        0xE9DF42
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _FENCE_CELL_RATIO =
        
        (* Ratio of cell length used for displaying the fence *)
        0.8
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _FENCE_COLOR =
        
        (* Color of the fences *)
        0xA6A6A6
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _FENCE_FONT_SIZE =
        
        (* Font size for the fences weights *)
        12
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _FENCE_TEXT_COLOR =
        
        (* Color of the fences *)
        Graphics.black
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _FENCE_WIDTH =
        
        (* Number of pixels for the fences *)
        5
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _FONT =
    
        (* Font for the whole application (platform-dependent, found with command 'xlsfonts') *)
        "-misc-heuristica-medium-r-normal--"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _ITEMS_BORDER_SIZE =
        
        (* Size of the borders for coisn and players *)
        4
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _MAZE_BACKGROUND_COLOR =
        
        (* Color of the maze background *)
        Graphics.white
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _MAZE_BORDER_COLOR =
        
        (* Color for the border of the maze *)
        0x444444
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _MAZE_HEIGHT_RATIO =
        
        (* Maze height as a ratio of the height of the window if the window is long enough *)
        0.9
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _MAZE_WALL_WIDTH =
        
        (* Number of pixels for the maze *)
        5
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _MESSAGES_FONT_SIZE =
        
        (* Size of the font used for displaying the messages *)
        20
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PENALITY_FONT_RATIO =
        
        (* Font size fas a ratio of the player's token *)
        0.5
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PENALITY_TEXT_COLOR =
        
        (* Color of the text indicating the penalities *)
        Graphics.black
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_1_COLOR =
        
        (* Color used for player 1 *)
        Graphics.red
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_1_TRACE_COLOR =
        
        (* Color used for the trace left by player 1 *)
        0xFF8888
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_2_COLOR =
        
        (* Color used for player 2 *)
        Graphics.green
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_2_TRACE_COLOR =
        
        (* Color used for the trace left by player 2 *)
        0x88FF88
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYERS_BORDER_COLOR =
        
        (* Color used for player 2 *)
        Graphics.black
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_MOVES_FONT_SIZE =
        
        (* Size of the font used for displaying the number of moves of the players *)
        25
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_MOVES_FROM_BOTTOM_RATIO =
        
        (* Distance from the bottom of the window to the player moves as a ratio of window height *)
        0.2
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_SCORES_FONT_SIZE =
        
        (* Size of the font used for displaying the scores of the players *)
        150
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_STATS_FONT_SIZE =
        
        (* Size of the font used for displaying information on the players *)
        25
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_STATS_FROM_TOP_RATIO =
        
        (* Distance from the top of the window to the player stats as a ratio of window height *)
        0.2
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _PLAYER_TOKEN_CELL_RATIO =
        
        (* Size the token representing the player as a ratio of cell size *)
        0.65
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _TEXT_COLOR =
        
        (* Color of the text *)
        Graphics.white
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _TEXT_INTERLINE =
        
        (* Number of pixels between lines *)
        10
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _WALLS_COLOR =
        
        (* Color used for the walls *)
        Graphics.black
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let _WINDOW_BACKGROUND_COLOR =
        
        (* Background of the window *)
        Graphics.black
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _WINDOW_INITIAL_HEIGHT =
        
        (* Expected height for the window in pixels *)
        880
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _WINDOW_INITIAL_WIDTH =
        
        (* Expected width for the window in pixels *)
        1600
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let _WINDOW_NAME =
        
        (* Name of the window *)
        "PyRat"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class interface (hideMazeInterface : bool)
                    (maze              : Maze.maze)
                    (player1           : Player.player)
                    (player2           : Player.player)
                    (turnTime          : float)
                    (singlePlayer      : bool)
                    (traceLength       : int) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            object (self)
            
        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** ATTRIBUTES ***************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)

            val mutable _player1PastLocations =
                
                (* Stores the past locations of player 1 to display its trace *)
                []
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _player2PastLocations =
                
                (* Stores the past locations of player 2 to display its trace *)
                []
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _previousMessage =
                
                (* We remember the previous message to be able to remove it before printing the next one *)
                ""
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _realMazeHeightRatio =
                
                (* Real ratio of height to use for the maze, initialized after starting the graphics *)
                0.0
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _windowHeight =
                
                (* Real height of the window, initialized after starting the graphics *)
                0
                
        (******************************************************************************************************************************************************************************************************************)

            val mutable _windowWidth =
                
                (* Real width of the window, initialized after starting the graphics *)
                0
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private cellMiddle (l : int)
                                      (c : int) =
                
                (* Needed information *)
                let (x, y) = self#toGraphicsCoordinates l c in
                let cellSize = self#cellSize in
                
                (* Middle of the cell *)
                let xMiddle = x + cellSize / 2 in
                let yMiddle = y - cellSize / 2 in
                (xMiddle, yMiddle)
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private cellSize =
                
                (* We divide the real maze size by the number of cells in the highest dimension *)
                let squareContainingMazeSize = int_of_float ((float_of_int _windowHeight) *. _realMazeHeightRatio) in
                squareContainingMazeSize / max maze#getWidth maze#getHeight
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private colorForPlayer (player : Player.player) =
                
                (* Returns the color associated to the given player *)
                if player#getNumber = 1 then
                    _PLAYER_1_COLOR
                else
                    _PLAYER_2_COLOR
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private columnXForPlayer (player : Player.player) =
                
                (* Location at which the column of the player starts *)
                if player#getNumber = 1 then
                    0
                else
                (
                    let (mazeRealWidth, _) = self#mazeRealSize in
                    let spaceOnSide = (_windowWidth - mazeRealWidth) / 2 in
                    (spaceOnSide + mazeRealWidth + _MAZE_WALL_WIDTH)
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private mazeOrigin =
                
                (* Needed information *)
                let (mazeRealWidth, mazeRealHeight) = self#mazeRealSize in
                
                (* From the bottom left *)
                let xOffset = (_windowWidth - mazeRealWidth) / 2 in
                let yOffset = (_windowHeight - mazeRealHeight) / 2 + _MESSAGES_FONT_SIZE in
                (xOffset, yOffset)
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private mazeRealSize =
                
                (* We reduce the initial dimensions so that the cells are all the same size *)
                let adjustedHeight = self#cellSize * maze#getHeight in
                let adjustedWidth = self#cellSize * maze#getWidth in
                (adjustedWidth, adjustedHeight)
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private renderCoins =
                
                (* We add the coins to the maze *)
                let addCoin = fun coinLocation ->
                              (
                                  let (coinX, coinY) = self#cellMiddle (fst coinLocation) (snd coinLocation) in
                                  Graphics.set_line_width (int_of_float (_COINS_CELL_RATIO *. float_of_int self#cellSize));
                                  Graphics.set_color _COINS_BORDER_COLOR;
                                  Graphics.moveto coinX coinY;
                                  Graphics.lineto coinX coinY;
                                  Graphics.set_line_width (int_of_float (_COINS_CELL_RATIO *. float_of_int self#cellSize) - _ITEMS_BORDER_SIZE);
                                  Graphics.set_color _COINS_COLOR;
                                  Graphics.lineto coinX coinY
                              ) in
                List.iter addCoin maze#getCoins
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderFencePenalty (x1                 : int)
                                              (y1                 : int)
                                              (x2                 : int)
                                              (y2                 : int)
                                              (weightBetweenCells : int) =
                
                (* We write the penalty associated to the fence *)
                let (weightWidth, weightHeight) = Graphics.text_size (string_of_int weightBetweenCells) in
                let weightX = (x1 + x2 - weightWidth) / 2 in
                let weightY = (y1 + y2 - weightHeight) / 2 in
                Graphics.set_color _FENCE_TEXT_COLOR;
                Graphics.moveto weightX weightY;
                Graphics.draw_string (string_of_int weightBetweenCells)
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private renderFences =
                
                (* Needed information *)
                let fenceMargin = int_of_float (float_of_int (self#cellSize - _MAZE_WALL_WIDTH) *. _FENCE_CELL_RATIO) in
                
                (* Graphics parameters *)
                Graphics.set_font (_FONT ^ (string_of_int _FENCE_FONT_SIZE) ^ "-*-*-*-*-*-*-*");
                Graphics.set_text_size _FENCE_FONT_SIZE;
                Graphics.set_line_width _FENCE_WIDTH;
                    
                (* We add the fences to the maze *)
                for l = 0 to maze#getHeight - 1 do
                    for c = 0 to maze#getWidth - 1 do
                        
                        (* Horizontal fence *)
                        let weightBetweenCells1 = maze#weightBetweenCells (l + 1, c) (l, c) in
                        if l <> maze#getHeight - 1 && weightBetweenCells1 > 1 then
                        (
                            Graphics.set_color _FENCE_COLOR;
                            let (x1, y1) = self#toGraphicsCoordinates (l + 1) c in
                            let (x2, y2) = self#toGraphicsCoordinates (l + 1) (c + 1) in
                            Graphics.moveto (x1 + fenceMargin) y1;
                            Graphics.lineto (x2 - fenceMargin) y2;
                            self#renderFencePenalty x1 y1 x2 y2 weightBetweenCells1
                        );
                        
                        (* Vertical fence *)
                        let weightBetweenCells2 = maze#weightBetweenCells (l, c + 1) (l, c) in
                        if c <> maze#getWidth - 1 && weightBetweenCells2 > 1 then
                        (
                            Graphics.set_color _FENCE_COLOR;
                            let (x1, y1) = self#toGraphicsCoordinates l (c + 1) in
                            let (x2, y2) = self#toGraphicsCoordinates (l + 1) (c + 1) in
                            Graphics.moveto x1 (y1 - fenceMargin);
                            Graphics.lineto x2 (y2 + fenceMargin);
                            self#renderFencePenalty x1 y1 x2 y2 weightBetweenCells2
                        )
                        
                    done
                done
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private renderMaze =
                
                (* Needed information *)
                let (xOffset, yOffset) = self#mazeOrigin in
                let (mazeRealWidth, mazeRealHeight) = self#mazeRealSize in
                
                (* Maze background *)
                Graphics.set_color _MAZE_BACKGROUND_COLOR;
                Graphics.fill_rect (xOffset + _MAZE_WALL_WIDTH / 2) (yOffset + _MAZE_WALL_WIDTH / 2) (mazeRealWidth - _MAZE_WALL_WIDTH / 2) (mazeRealHeight - _MAZE_WALL_WIDTH / 2);
                
                (* We draw the maze *)
                Graphics.set_color _WALLS_COLOR;
                Graphics.set_line_width _MAZE_WALL_WIDTH;
                for l = 0 to maze#getHeight - 1 do
                    for c = 0 to maze#getWidth - 1 do
                        
                        (* Horizontal wall *)
                        if l <> maze#getHeight - 1 && maze#wallBetweenCells (l + 1, c) (l, c) then
                        (
                            let (x1, y1) = self#toGraphicsCoordinates (l + 1) c in
                            let (x2, y2) = self#toGraphicsCoordinates (l + 1) (c + 1) in
                            Graphics.moveto x1 y1;
                            Graphics.lineto x2 y2
                        );
                        
                        (* Vertical wall *)
                        if c <> maze#getWidth - 1 && maze#wallBetweenCells (l, c + 1) (l, c) then
                        (
                            let (x1, y1) = self#toGraphicsCoordinates l (c + 1) in
                            let (x2, y2) = self#toGraphicsCoordinates (l + 1) (c + 1) in
                            Graphics.moveto x1 y1;
                            Graphics.lineto x2 y2
                        );
                        
                        (* Dot to separate the cells *)
                        if l <> 0 && c <> 0 then
                        (
                            let (x, y) = self#toGraphicsCoordinates l c in
                            Graphics.moveto x y;
                            Graphics.lineto x y
                        )
                        
                    done
                done;
                
                (* We draw a border around the maze*)
                Graphics.set_color _MAZE_BORDER_COLOR;
                Graphics.moveto (xOffset + _MAZE_WALL_WIDTH / 2) (yOffset + _MAZE_WALL_WIDTH / 2);
                Graphics.lineto (xOffset + mazeRealWidth + _MAZE_WALL_WIDTH / 2) (yOffset + _MAZE_WALL_WIDTH / 2);
                Graphics.lineto (xOffset + mazeRealWidth + _MAZE_WALL_WIDTH / 2) (yOffset + mazeRealHeight + _MAZE_WALL_WIDTH / 2);
                Graphics.lineto (xOffset + _MAZE_WALL_WIDTH / 2) (yOffset + mazeRealHeight + _MAZE_WALL_WIDTH / 2);
                Graphics.lineto (xOffset + _MAZE_WALL_WIDTH / 2) (yOffset + _MAZE_WALL_WIDTH / 2)
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayerMoves (player  : Player.player)
                                             (columnX : int) =
                
                (* Needed information *)
                let (mazeRealWidth, _) = self#mazeRealSize in
                let spaceOnSide = (_windowWidth - mazeRealWidth) / 2 in
                
                (* Player information *)
                Graphics.set_font (_FONT ^ (string_of_int _PLAYER_MOVES_FONT_SIZE) ^ "-*-*-*-*-*-*-*");
                Graphics.set_text_size _PLAYER_MOVES_FONT_SIZE;
                let textY = int_of_float (float_of_int _windowHeight *. _PLAYER_MOVES_FROM_BOTTOM_RATIO) in
                let playerMoves = "Moves:  " ^ string_of_int player#getNumberOfMoves in
                let (playerMovesWidth, playerMovesHeight) = Graphics.text_size playerMoves in
                let playerMissedMoves = "Missed:  " ^ string_of_int player#getNumberOfMissedMoves in
                let (playerMissedMovesWidth, playerMissedMovesHeight) = Graphics.text_size playerMissedMoves in
                let playerFencesCrossed = "Fences:  " ^ string_of_int player#getNumberOfFencesCrossed in
                let (playerFencesCrossedWidth, playerFencesCrossedHeight) = Graphics.text_size playerFencesCrossed in
                
                (* We remove the previous stats *)
                Graphics.set_color _WINDOW_BACKGROUND_COLOR;
                Graphics.fill_rect columnX textY (spaceOnSide - _MAZE_WALL_WIDTH) (playerMovesHeight + 2 * _TEXT_INTERLINE + playerMissedMovesHeight + playerFencesCrossedHeight);
                
                (* We write the number of moves of the player *)
                Graphics.set_color _TEXT_COLOR;
                let movesX = columnX + (spaceOnSide - playerMovesWidth) / 2 in
                Graphics.moveto movesX (textY + 2 * _TEXT_INTERLINE + playerMissedMovesHeight + playerFencesCrossedHeight);
                Graphics.draw_string playerMoves;
                
                (* We write the number of missed moves of the player *)
                let missedMovesX = columnX + (spaceOnSide - playerMissedMovesWidth) / 2 in
                Graphics.moveto missedMovesX (textY + _TEXT_INTERLINE + playerFencesCrossedHeight);
                Graphics.draw_string playerMissedMoves;
                
                (* We write the number of fences crossed by the player *)
                let fencesCrossedX = columnX + (spaceOnSide - playerFencesCrossedWidth) / 2 in
                Graphics.moveto fencesCrossedX textY;
                Graphics.draw_string playerFencesCrossed
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayerScore (player  : Player.player)
                                             (columnX : int) =
                
                (* Needed information *)
                let (mazeRealWidth, _) = self#mazeRealSize in
                let spaceOnSide = (_windowWidth - mazeRealWidth) / 2 in
                
                (* Graphics parameters *)
                Graphics.set_font (_FONT ^ (string_of_int _PLAYER_SCORES_FONT_SIZE) ^ "-*-*-*-*-*-*-*");
                Graphics.set_text_size _PLAYER_STATS_FONT_SIZE;
                
                (* Player information *)
                let playerScore = if float_of_int (int_of_float player#getScore) = player#getScore then
                                      string_of_int (int_of_float player#getScore)
                                  else
                                      string_of_float player#getScore in
                let (playerScoreWidth, playerScoreHeight) = Graphics.text_size playerScore in
                let textY = (_windowHeight - playerScoreHeight) / 2 in
                
                (* We remove the previous score *)
                Graphics.set_color _WINDOW_BACKGROUND_COLOR;
                Graphics.fill_rect columnX textY (spaceOnSide - _MAZE_WALL_WIDTH) playerScoreHeight;
                
                (* We write the score of the player *)
                Graphics.set_color _TEXT_COLOR;
                let textX = columnX + (spaceOnSide - playerScoreWidth) / 2 in
                Graphics.moveto textX textY;
                Graphics.draw_string playerScore
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayerStartingLocation (player : Player.player) =
                
                (* There is a graphical bug that adds a black square around the token sometimes at the beginning *)
                let (startX, startY) = self#cellMiddle (fst player#getCurrentLocation) (snd player#getCurrentLocation) in
                Graphics.set_color _MAZE_BACKGROUND_COLOR;
                let tokenSize = int_of_float (_PLAYER_TOKEN_CELL_RATIO *. float_of_int self#cellSize) - _ITEMS_BORDER_SIZE in
                Graphics.fill_rect (startX - tokenSize / 2) (startY - tokenSize / 2) tokenSize tokenSize;
                
                (* We add the token *)
                self#renderPlayerToken player (startX, startY) true (self#colorForPlayer player) 0;
                
                (* We prepare the trace *)
                if player#getNumber = 1 then
                    _player1PastLocations <- [(startX, startY)]
                else
                    _player2PastLocations <- [(startX, startY)]
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayerStats (player  : Player.player)
                                             (columnX : int) =
            
                (* Needed information *)
                let (mazeRealWidth, _) = self#mazeRealSize in
                let spaceOnSide = (_windowWidth - mazeRealWidth) / 2 in
                
                (* Graphics parameters *)
                Graphics.set_color (self#colorForPlayer player);
                Graphics.set_font (_FONT ^ (string_of_int _PLAYER_STATS_FONT_SIZE) ^ "-*-*-*-*-*-*-*");
                Graphics.set_text_size _PLAYER_STATS_FONT_SIZE;
                
                (* Player information *)
                let textY = int_of_float (float_of_int _windowHeight -. float_of_int _windowHeight *. _PLAYER_STATS_FROM_TOP_RATIO) in
                let playerNumber = "Player " ^ (string_of_int player#getNumber) in
                let (playerNumberWidth, playerNumberHeight) = Graphics.text_size playerNumber in
                let playerName = player#getName in
                let (playerNameWidth, playerNameHeight) = Graphics.text_size playerName in
                
                (* We write the number of the player *)
                let textX = columnX + (spaceOnSide - playerNumberWidth) / 2 in
                Graphics.moveto textX textY;
                Graphics.draw_string playerNumber;
                
                (* We write the name of the player *)
                let textX = columnX + (spaceOnSide - playerNameWidth) / 2 in
                Graphics.moveto textX (textY - _TEXT_INTERLINE - playerNumberHeight);
                Graphics.draw_string playerName
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayerToken (player        : Player.player)
                                             (location      : int * int)
                                             (border        : bool)
                                             (color         : Graphics.color)
                                             (playerPenalty : int) =
                
                (* We add the token *)
                if not (singlePlayer && player#getNumber = 2) then
                (
                    
                    (* Token *)
                    let tokenSize = int_of_float (_PLAYER_TOKEN_CELL_RATIO *. float_of_int self#cellSize) in
                    Graphics.set_line_width tokenSize;
                    if border then
                    (
                        Graphics.set_color _PLAYERS_BORDER_COLOR;
                        Graphics.moveto (fst location) (snd location);
                        Graphics.lineto (fst location) (snd location);
                        Graphics.set_line_width (tokenSize - _ITEMS_BORDER_SIZE)
                    );
                    Graphics.set_color color;
                    Graphics.moveto (fst location) (snd location);
                    Graphics.lineto (fst location) (snd location);
                    
                    (* Penalty (if any) *)
                    if playerPenalty > 0 then
                    (
                        let fontSize = int_of_float (_PENALITY_FONT_RATIO *. (float_of_int tokenSize)) in
                        Graphics.set_font (_FONT ^ (string_of_int fontSize) ^ "-*-*-*-*-*-*-*");
                        Graphics.set_text_size fontSize;
                        Graphics.set_color _PENALITY_TEXT_COLOR;
                        let (playerPenaltyWidth, playerPenaltyHeight) = Graphics.text_size (string_of_int playerPenalty) in
                        Graphics.moveto (fst location - playerPenaltyWidth / 2) (snd location - playerPenaltyHeight / 2);
                        Graphics.draw_string (string_of_int playerPenalty)
                    )
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private renderPlayerTrace (player        : Player.player)
                                             (playerPenalty : int)
                                             (x             : int)
                                             (y             : int) =
                
                (* We fill the trace if needed *)
                if not (singlePlayer && player#getNumber = 2) then
                (
                    
                    (* We get the trace *)
                    let trace = ref (if player#getNumber = 1 then
                                         _player1PastLocations
                                     else
                                         _player2PastLocations) in
                    
                    (* If no trace *)
                    if traceLength = 0 then
                    (
                        self#renderPlayerToken player (List.hd !trace) false _MAZE_BACKGROUND_COLOR playerPenalty;
                        trace := [(x, y)]
                    )
                    
                    (* If full trace *)
                    else if traceLength < 0 then
                    (
                        self#renderPlayerToken player (List.hd !trace) false (self#traceColorForPlayer player) playerPenalty;
                        trace := [(x, y)]
                    )
                    
                    (* If limited-size trace *)
                    else
                    (
                        let reversedLocations = List.rev !trace in
                        if List.length !trace = traceLength * self#cellSize then
                        (
                            self#renderPlayerToken player (List.hd reversedLocations) false _MAZE_BACKGROUND_COLOR playerPenalty;
                            trace := List.rev (List.tl reversedLocations)
                        );
                        let traceFunction = fun location ->
                                            (
                                                self#renderPlayerToken player location false (self#traceColorForPlayer player) playerPenalty
                                            ) in
                        List.iter traceFunction (List.tl reversedLocations);
                        trace := (x, y) :: !trace
                    );
                    
                    (* We update the trace *)
                    if player#getNumber = 1 then
                        _player1PastLocations <- !trace
                    else
                        _player2PastLocations <- !trace
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayersLocationWithAnimation (player1        : Player.player)
                                                              (player2        : Player.player)
                                                              (playerPenalty1 : int)
                                                              (playerPenalty2 : int) =
                
                (* Pixels to clean at each frame *)
                let previous1 = ref (self#cellMiddle (fst player1#getPreviousLocation) (snd player1#getPreviousLocation)) in
                let previous2 = ref (self#cellMiddle (fst player2#getPreviousLocation) (snd player2#getPreviousLocation)) in
                
                (* Animation *)
                for frame = 1 to self#cellSize do
                    
                    (* Traces *)
                    if player1#getPreviousLocation <> player1#getCurrentLocation then
                        previous1 := self#renderPlayersLocationWithAnimationOneFrame player1 playerPenalty1 frame;
                    if player2#getPreviousLocation <> player2#getCurrentLocation then
                        previous2 := self#renderPlayersLocationWithAnimationOneFrame player2 playerPenalty2 frame;
                    
                    (* We add the tokens in the end so they cannot be covered by a trace *)
                    self#renderPlayerToken player1 !previous1 true _PLAYER_1_COLOR playerPenalty1;
                    self#renderPlayerToken player2 !previous2 true _PLAYER_2_COLOR playerPenalty2;
                    
                    (* We sleep a while *)
                    let endTime = Unix.gettimeofday () +. (turnTime /. float_of_int self#cellSize) in
                    ToolBox.wait(endTime)
                    
                done;
                
                (* We render the fences again so that they are always above the traces *)
                self#renderFences
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private renderPlayersLocationWithAnimationOneFrame (player        : Player.player)
                                                                      (playerPenalty : int)
                                                                      (frame         : int) =
                
                (* We move pixel by pixel *)
                let xDifference = snd player#getCurrentLocation - snd player#getPreviousLocation in
                let yDifference = fst player#getPreviousLocation - fst player#getCurrentLocation in
                let previousCenter = self#cellMiddle (fst player#getPreviousLocation) (snd player#getPreviousLocation) in
                let frameX = fst previousCenter + xDifference * frame in
                let frameY = snd previousCenter + yDifference * frame in
                self#renderPlayerTrace player playerPenalty frameX frameY;
                (frameX, frameY)
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private toGraphicsCoordinates (l : int)
                                                 (c : int) =
                
                (* Needed information *)
                let (xOffset, yOffset) = self#mazeOrigin in
                let cellSize = self#cellSize in
                
                (* Switches from matrix coordinates to graphics coordinates *)
                let x = xOffset + c * cellSize + _MAZE_WALL_WIDTH / 2 in
                let y = yOffset + (maze#getHeight - l) * cellSize + _MAZE_WALL_WIDTH / 2 in
                (x, y)
                
        (******************************************************************************************************************************************************************************************************************)
        
            method private traceColorForPlayer (player : Player.player) =
                
                (* Returns the trace color associated to the given player *)
                if player#getNumber = 1 then
                    _PLAYER_1_TRACE_COLOR
                else
                    _PLAYER_2_TRACE_COLOR
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method initialize =
                
                (* Only if the interface is not hidden *)
                if not hideMazeInterface then
                (
                
                    (* We prepare the window *)
                    Graphics.open_graph (" " ^ (string_of_int _WINDOW_INITIAL_WIDTH) ^ "x" ^ (string_of_int _WINDOW_INITIAL_HEIGHT) ^ "+0-0");
                    _windowWidth <- Graphics.size_x ();
                    _windowHeight <- Graphics.size_y ();
                    Graphics.set_color _WINDOW_BACKGROUND_COLOR;
                    Graphics.fill_rect 0 0 _windowWidth _windowHeight;
                    Graphics.set_window_title _WINDOW_NAME;
                    _realMazeHeightRatio <- if float_of_int _windowWidth /. (float_of_int _windowHeight *. _MAZE_HEIGHT_RATIO) >= 2.0 then
                                                _MAZE_HEIGHT_RATIO
                                            else
                                                float_of_int _windowWidth /. 2.0 /. float_of_int _windowHeight;
                    
                    (* We render the maze and the players *)
                    self#renderMaze;
                    self#renderCoins;
                    self#renderFences;
                    self#renderPlayerStats player1 (self#columnXForPlayer player1);
                    self#renderPlayerScore player1 (self#columnXForPlayer player1);
                    self#renderPlayerMoves player1 (self#columnXForPlayer player1);
                    self#renderPlayerStartingLocation player1;
                    if not singlePlayer then
                    (
                        self#renderPlayerStats player2 (self#columnXForPlayer player2);
                        self#renderPlayerScore player2 (self#columnXForPlayer player2);
                        self#renderPlayerMoves player2 (self#columnXForPlayer player2);
                        self#renderPlayerStartingLocation player2
                    );
                    
                    (* We wait until the user presses space *)
                    self#writeMessage "Press space to start the game";
                    while Graphics.read_key () <> ' ' do
                        ()
                    done;
                    self#writeMessage ""
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method keepShowing =
                
                (* Prevents the interface from closing at the end of the program *)
                if not hideMazeInterface then
                    ignore (Graphics.read_key ())
                
        (******************************************************************************************************************************************************************************************************************)
            
            method update (playerPenalty1 : int)
                          (playerPenalty2 : int) =
                
                (* Only if the interface is not hidden *)
                if not hideMazeInterface then
                (
                
                    (* We update the scores, moves and the locations *)
                    self#renderPlayersLocationWithAnimation player1 player2 playerPenalty1 playerPenalty2;
                    self#renderPlayerScore player1 (self#columnXForPlayer player1);
                    self#renderPlayerMoves player1 (self#columnXForPlayer player1);
                    if not singlePlayer then
                    (
                        self#renderPlayerScore player2 (self#columnXForPlayer player2);
                        self#renderPlayerMoves player2 (self#columnXForPlayer player2)
                    )
                    
                )
                
                (* If it is hidden, we just wait until the end of the turn *)
                else
                (
                    let endTime = Unix.gettimeofday () +. turnTime in
                    ToolBox.wait(endTime)
                )
                
        (******************************************************************************************************************************************************************************************************************)
            
            method writeMessage (message : string) =
                
                (* Only if the interface is not hidden *)
                if not hideMazeInterface then
                (
                
                    (* Graphics parameters *)
                    Graphics.set_font (_FONT ^ (string_of_int _MESSAGES_FONT_SIZE) ^ "-*-*-*-*-*-*-*");
                    Graphics.set_text_size _MESSAGES_FONT_SIZE;
                    
                    (* Message area *)
                    let (_, yOffset) = self#mazeOrigin in
                    let (messageWidth, messageHeight) = Graphics.text_size message in
                    let messageX = (_windowWidth - messageWidth) / 2 in
                    let messageY = (yOffset - _MESSAGES_FONT_SIZE) / 2 in
                    
                    (* We remove the previous message and store the new one to be able to remove it later *)
                    Graphics.set_color _WINDOW_BACKGROUND_COLOR;
                    let (oldMessageWidth, oldMessageHeight) = Graphics.text_size _previousMessage in
                    let oldMessageX = (_windowWidth - oldMessageWidth) / 2 in
                    Graphics.fill_rect oldMessageX messageY oldMessageWidth oldMessageHeight;
                    _previousMessage <- message;
                    
                    (* We display the message *)
                    Graphics.set_color _TEXT_COLOR;
                    Graphics.moveto messageX messageY;
                    Graphics.draw_string message
                    
                )
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)