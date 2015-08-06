(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL CONSTANTS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    let _COMMAND_LINE_ARGUMENTS =
        
        (* Array of arguments in the order in which they are supposed to be provided *)
        [|
            ("<singlePlayer>",              "(boolean)",                               "Set to 'true' if it is a single-player game");
            ("<player1StartingLocation>",   "(int*int)",                               "Starting location for player 1 (requires the game to be single-player, do not use spaces)");
            ("<player1FileName>",           "(string)",                                "Path to the script of player 1");
            ("<player2FileName>",           "(string)",                                "Path to the script of player 2 (ignored if it is a single-player game)");
            ("<randomSeed>",                "(integer)",                               "Seed for random maze generation and coins locations (< 0 for random maze/coins)");
            ("<mazeFileName>",              "(string)",                                "Path to a file describing the maze (if set, there is no need to give the parameters width/height/density)");
            ("<mazeWidth>",                 "(integer > 2)",                           "Width of the maze (must be odd to ensure connectivity)");
            ("<mazeHeight>",                "(integer > 2)",                           "Height of the maze (must be odd to ensure connectivity)");
            ("<mazeDensity>",               "(float >= 0.0 & <= 1.0)",                 "Ratio of walls in the maze");
            ("<coinsFileName>",             "(string)",                                "Path to a file describing the coins locations (if set, there is no need to give the parameters singleCoin/coinsDistribution)");
            ("<singleCoin>",                "(boolean)",                               "Set to 'true' if it is a single-coin game (requires the game to be single-player)");
            ("<coinsDistribution>",         "((float > 0.0 & < 1.0) | integer >= 1)",  "Probability to have a coin in a cell (if float) of number of coins in the maze (if integer)");
            ("<fenceProbability>",          "(float >= 0.0 & <= 1.0)",                 "Probability to have a fence instead of a normal path between two cells");
            ("<nbMovesToCrossFence>",       "(integer > 1)",                           "Number of moves it takes to cross a fence");
            ("<waitForAllPlayers>",         "(boolean)",                               "Indicates if both players play simultaneously (true by default if it is a single-player game)");
            ("<turnTime>",                  "(float >= 0.0)",                          "Time attributed to players to decide how to move (also determines the speed of the animation)");
            ("<preparationTime>",           "(float >= 0.0)",                          "Time attributed to players before the game starts");
            ("<traceLength>",               "(integer)",                               "Displays the paths followed by the players (< 0 for the whole path, 0 for no path, N > 0 for the last N cells)");
            ("<mazeMapAvailable>",          "(boolean)",                               "Indicates if the players know the maze map");
            ("<opponentLocationAvailable>", "(boolean)",                               "Indicates if the players know their opponent's location in the maze (false by default if it is a single-player game)");
            ("<coinsLocationAvailable>",    "(boolean)",                               "Indicates if the players know the coins location in the maze");
            ("<outputFilesDirectory>",      "(string)",                                "Directory where to export the files representating the maze and coins locations");
            ("<hideMazeInterface>",         "(boolean)",                               "If set to true, hides the maze and starts the game as soon as the program is executed (useful for automated tests)")
        |]
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL FUNCTIONS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    let errorInCommandLine () =
        
        (* Values needed to determine the number of spaces to print so that the name/type/description fields are aligned *)
        let maxLengthName = ref 0 in
        let maxLengthType = ref 0 in
        for i = 0 to Array.length _COMMAND_LINE_ARGUMENTS - 1 do
            let (argumentName, argumentType, _) = _COMMAND_LINE_ARGUMENTS.(i) in
            maxLengthName := max !maxLengthName (String.length argumentName);
            maxLengthType := max !maxLengthType (String.length argumentType)
        done;
        
        (* Message to print when something is wrong in the command line *)
        let errorString = ref ("Usage:\n    " ^ Sys.argv.(0)) in
        for i = 0 to Array.length _COMMAND_LINE_ARGUMENTS - 1 do
            let (argumentName, argumentType, argumentDescription) = _COMMAND_LINE_ARGUMENTS.(i) in
            let spaces1 = String.make (!maxLengthName - String.length argumentName + 1) ' ' in
            let spaces2 = String.make (!maxLengthType - String.length argumentType + 1) ' ' in
            errorString := !errorString ^ "\n    " ^ argumentName ^ spaces1 ^ argumentType ^ spaces2 ^ argumentDescription
        done;
        ToolBox.error !errorString
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)

    let parseArgument (argumentNumber          : int)
                      (castFunction            : string -> 'a)
                      (optionalArgument        : bool * 'a)
                      (assertionsWhenDefined   : (('a -> bool) * string) array)
                      (assertionsWhenUndefined : ((unit -> bool) * string) array) =
        
        (* We get the argument as a string *)
        let argumentString = try
                                 Sys.argv.(argumentNumber)
                             with
                                 _ -> errorInCommandLine () in
        
        (* We check if it is correctly defined *)
        let (argumentName, _, _) = _COMMAND_LINE_ARGUMENTS.(argumentNumber - 1) in
        let (canBeUndefined, defaultValue) = optionalArgument in
        let argumentDefined = String.compare argumentString "_" <> 0 in
        if not argumentDefined && not canBeUndefined then
            ToolBox.error ("Argument " ^ argumentName ^ " should be defined");
        
        (* We cast the argument *)
        let argument = if argumentDefined then
                       (
                           try
                               castFunction argumentString
                           with
                               _ -> ToolBox.error ("Wrong value type for argument " ^ argumentName)
                       )
                       else
                           defaultValue in
        
        (* We check the correct assertions *)
        if argumentDefined then
        (
            for i = 0 to Array.length assertionsWhenDefined - 1 do
                let (assertionFunction, assertionErrorMessage) = assertionsWhenDefined.(i) in
                try
                    if not (assertionFunction argument) then
                        failwith ""
                with _ -> ToolBox.error ("Error when checking argument " ^ argumentName ^ ": " ^ assertionErrorMessage)
            done
        )
        else
        (
            for i = 0 to Array.length assertionsWhenUndefined - 1 do
                let (assertionFunction, assertionErrorMessage) = assertionsWhenUndefined.(i) in
                try
                    if not (assertionFunction ()) then
                        failwith ""
                with _ -> ToolBox.error ("Error when checking argument " ^ argumentName ^ ": " ^ assertionErrorMessage)
            done
        );
        
        (* Done *)
        (argument, argumentDefined)
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
(***************************************************************************************************** COMMAND LINE ARGUMENTS *****************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)
    
    (* <singlePlayer> *)
    let argumentNumber = 1;;
    let castFunction = bool_of_string;;
    let optionalArgument = (false, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (singlePlayer, singlePlayerDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    (* <player1StartingLocation> *)
    let argumentNumber = 2;;
    let castFunction = fun argument ->
                       (
                           let shortenedArgument = String.sub argument 1 (String.length argument - 2) in
                           let splittedArgument = Str.split (Str.regexp ",") shortenedArgument in
                           (int_of_string (List.hd splittedArgument), int_of_string (List.hd (List.tl splittedArgument)))
                       );;
    let optionalArgument = (true, (-1, -1));;
    let assertionsWhenDefined = [|((fun argument -> singlePlayer), "Can only be set in a single-player game")|];;
    let assertionsWhenUndefined = [||];;
    let (player1StartingLocation, player1StartingLocationDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    (* <player1FileName> *)
    let argumentNumber = 3;;
    let castFunction = fun argument -> argument;;
    let optionalArgument = (false, "");;
    let assertionsWhenDefined = [|((fun argument -> Sys.file_exists argument), "file does not exist");
                                  ((fun argument -> not (Sys.is_directory argument)), "not a valid file")|];;
    let assertionsWhenUndefined = [||];;
    let (player1FileName, player1FileNameDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;
    
(**********************************************************************************************************************************************************************************************************************************)

    (* <player2FileName> *)
    let argumentNumber = 4;;
    let castFunction = fun argument -> argument;;
    let optionalArgument = (true, "");;
    let assertionsWhenDefined = [|((fun argument -> Sys.file_exists argument), "file does not exist");
                                  ((fun argument -> not (Sys.is_directory argument)), "not a valid file")|];;
    let assertionsWhenUndefined = [|((fun () -> singlePlayer), "must be defined unless it is a single-player game")|];;
    let (player2FileName, player2FileNameDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;
    
(**********************************************************************************************************************************************************************************************************************************)

    (* <randomSeed> *)
    let argumentNumber = 5;;
    let castFunction = int_of_string;;
    let optionalArgument = (false, -1);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (randomSeed, randomSeedDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <mazeFileName> *)
    let argumentNumber = 6;;
    let castFunction = fun argument -> argument;;
    let optionalArgument = (true, "");;
    let assertionsWhenDefined = [|((fun argument -> Sys.file_exists argument), "file does not exist");
                                  ((fun argument -> not (Sys.is_directory argument)), "not a valid file")|];;
    let assertionsWhenUndefined = [||];;
    let (mazeFileName, mazeFileNameDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <mazeWidth> *)
    let argumentNumber = 7;;
    let castFunction = int_of_string;;
    let optionalArgument = (true, -1);;
    let assertionsWhenDefined = [|((fun argument -> argument > 2), "must be > 2");
                                  ((fun argument -> argument mod 2 = 1), "must be odd")|];;
    let assertionsWhenUndefined = [|((fun () -> mazeFileNameDefined), "must be defined unless a maze file is provided")|];;
    let (mazeWidth, mazeWidthDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <mazeHeight> *)
    let argumentNumber = 8;;
    let castFunction = int_of_string;;
    let optionalArgument = (true, -1);;
    let assertionsWhenDefined = [|((fun argument -> argument > 2), "must be > 2");
                                  ((fun argument -> argument mod 2 = 1), "must be odd")|];;
    let assertionsWhenUndefined = [|((fun () -> mazeFileNameDefined), "must be defined unless a maze file is provided")|];;
    let (mazeHeight, mazeHeightDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)
    
    (* <mazeDensity> *)
    let argumentNumber = 9;;
    let castFunction = float_of_string;;
    let optionalArgument = (true, -1.0);;
    let assertionsWhenDefined = [|((fun argument -> argument >= 0.0 && argument <= 1.0), "must be in [0.0; 1.0]")|];;
    let assertionsWhenUndefined = [|((fun () -> mazeFileNameDefined), "must be defined unless a maze file is provided")|];;
    let (mazeDensity, mazeDensityDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <coinsFileName> *)
    let argumentNumber = 10;;
    let castFunction = fun argument -> argument;;
    let optionalArgument = (true, "");;
    let assertionsWhenDefined = [|((fun argument -> Sys.file_exists argument), "file does not exist");
                                  ((fun argument -> not (Sys.is_directory argument)), "not a valid file")|];;
    let assertionsWhenUndefined = [||];;
    let (coinsFileName, coinsFileNameDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <singleCoin> *)
    let argumentNumber = 11;;
    let castFunction = bool_of_string;;
    let optionalArgument = (true, false);;
    let assertionsWhenDefined = [|((fun argument -> not argument || (argument && singlePlayer)), "Can only be set to true in a single-player game")|];;
    let assertionsWhenUndefined = [|((fun () -> coinsFileNameDefined), "must be defined unless a coins file is provided")|];;
    let (singleCoin, singleCoinDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <coinsDistribution> *)
    let argumentNumber = 12;;
    let castFunction = float_of_string;;
    let optionalArgument = (true, -1.0);;
    let assertionsWhenDefined = [|((fun argument -> (argument > 0.0 && argument < 1.0) || (argument >= 1.0 && float_of_int (int_of_float argument) = argument)), "must be in ]0.0; 1.0[ or an integer >= 1")|];;
    let assertionsWhenUndefined = [|((fun () -> coinsFileNameDefined || singleCoin), "must be defined unless a coins file is provided or it is a single-coin game")|];;
    let (coinsDistribution, coinsDistributionDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <fenceProbability> *)
    let argumentNumber = 13;;
    let castFunction = float_of_string;;
    let optionalArgument = (true, -1.0);;
    let assertionsWhenDefined = [|((fun argument -> argument >= 0.0 && argument <= 1.0), "must be in [0.0; 1.0]")|];;
    let assertionsWhenUndefined = [|((fun () -> mazeFileNameDefined), "must be defined unless a maze file is provided")|];;
    let (fenceProbability, fenceProbabilityDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <nbMovesToCrossFence> *)
    let argumentNumber = 14;;
    let castFunction = int_of_string;;
    let optionalArgument = (true, -1);;
    let assertionsWhenDefined = [|((fun argument -> argument > 1), "must be > 1")|];;
    let assertionsWhenUndefined = [|((fun () -> fenceProbability = 0.0 || mazeFileNameDefined), "must be defined unless the probability to have a fence is set to 0.0, or a maze file is provided")|];;
    let (nbMovesToCrossFence, nbMovesToCrossFenceDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <waitForAllPlayers> *)
    let argumentNumber = 15;;
    let castFunction = bool_of_string;;
    let optionalArgument = (true, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [|((fun () -> singlePlayer), "must be defined unless it is a single-player game")|];;
    let (waitForAllPlayers, waitForAllPlayersDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <turnTime> *)
    let argumentNumber = 16;;
    let castFunction = float_of_string;;
    let optionalArgument = (false, -1.0);;
    let assertionsWhenDefined = [|((fun argument -> argument >= 0.0), "must be >= 0.0")|];;
    let assertionsWhenUndefined = [||];;
    let (turnTime, turnTimeDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <preparationTime> *)
    let argumentNumber = 17;;
    let castFunction = float_of_string;;
    let optionalArgument = (false, -1.0);;
    let assertionsWhenDefined = [|((fun argument -> argument >= 0.0), "must be >= 0.0")|];;
    let assertionsWhenUndefined = [||];;
    let (preparationTime, preparationTimeDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <traceLength> *)
    let argumentNumber = 18;;
    let castFunction = int_of_string;;
    let optionalArgument = (false, -1);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (traceLength, traceLengthDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <mazeMapAvailable> *)
    let argumentNumber = 19;;
    let castFunction = bool_of_string;;
    let optionalArgument = (false, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (mazeMapAvailable, mazeMapAvailableDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <opponentLocationAvailable> *)
    let argumentNumber = 20;;
    let castFunction = bool_of_string;;
    let optionalArgument = (true, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [|((fun () -> singlePlayer), "must be defined unless it is a single-player game")|];;
    let (opponentLocationAvailable, opponentLocationAvailableDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <coinsLocationAvailable> *)
    let argumentNumber = 21;;
    let castFunction = bool_of_string;;
    let optionalArgument = (false, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (coinsLocationAvailable, coinsLocationAvailableDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <outputFilesDirectory> *)
    let argumentNumber = 22;;
    let castFunction = fun argument -> argument;;
    let optionalArgument = (false, "");;
    let assertionsWhenDefined = [|((fun argument -> Sys.file_exists argument), "file does not exist");
                                  ((fun argument -> Sys.is_directory argument), "not a valid directory")|];;
    let assertionsWhenUndefined = [||];;
    let (outputFilesDirectory, outputFilesDirectoryDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)

    (* <hideMazeInterface> *)
    let argumentNumber = 23;;
    let castFunction = bool_of_string;;
    let optionalArgument = (false, false);;
    let assertionsWhenDefined = [||];;
    let assertionsWhenUndefined = [||];;
    let (hideMazeInterface, hideMazeInterfaceDefined) = parseArgument argumentNumber castFunction optionalArgument assertionsWhenDefined assertionsWhenUndefined;;

(**********************************************************************************************************************************************************************************************************************************)
(*********************************************************************************************************** MAIN SCRIPT **********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)
    
    (* We set the random seed *)
    if randomSeed = -1 then
        Random.self_init ()
    else
        Random.init randomSeed;;
    
    (* We ignore errors such as Graphics.failure when we close the window *)
    try
        
        (* Initialization of the maze walls *)
        let maze = if mazeFileNameDefined then
                       new FileMaze.fileMaze mazeFileName
                   else
                       new RandomMaze.randomMaze singlePlayer mazeWidth mazeHeight mazeDensity fenceProbability nbMovesToCrossFence in
        maze#initialize;
        
        (* Initialization of the players *)
        let player1 = new Player.player 1 player1FileName waitForAllPlayers singlePlayer in
        player1#initialize player1StartingLocationDefined player1StartingLocation maze#getWidth maze#getHeight;
        let player2 = new Player.player 2 player2FileName waitForAllPlayers singlePlayer in
        player2#initialize false (-1, -1) maze#getWidth maze#getHeight;
        
        (* Initialization of the coins *)
        let coinsGenerator = if singleCoin then
                                 new SingleCoinGenerator.singleCoinGenerator player1#getCurrentLocation maze#getWidth
                             else if String.compare coinsFileName "" <> 0 then
                                 new FileCoinsGenerator.fileCoinsGenerator player1#getCurrentLocation player2#getCurrentLocation maze#getWidth maze#getHeight coinsFileName
                             else if coinsDistribution < 1.0 then
                                 new RandomCoinsGenerator.randomCoinsGenerator player1#getCurrentLocation player2#getCurrentLocation maze#getWidth maze#getHeight coinsDistribution
                             else
                                 new FixedNumberCoinsGenerator.fixedNumberCoinsGenerator player1#getCurrentLocation player2#getCurrentLocation maze#getWidth maze#getHeight (int_of_float coinsDistribution) in
        maze#setCoins coinsGenerator#generateCoins;
        
        (* Initialization of the interface *)
        let interface = new Interface.interface hideMazeInterface maze player1 player2 turnTime singlePlayer traceLength in
        interface#initialize;
        
        (* Initialization of the game *)
        let game = new Game.game maze player1 player2 interface singlePlayer mazeMapAvailable coinsLocationAvailable opponentLocationAvailable preparationTime turnTime in
        game#start;
        
        (* We export everything for the replay *)
        game#exportTikz outputFilesDirectory;
        maze#exportMaze outputFilesDirectory;
        maze#exportCoins outputFilesDirectory;
        player1#exportInitialLocation outputFilesDirectory;
        player1#exportMoves outputFilesDirectory;
        player2#exportMoves outputFilesDirectory;
        
        (* We continue displaying the interface *)
        interface#keepShowing
        
    with
        _ -> ();;

(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)