(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class fileCoinsGenerator (player1Location : (int * int))
                             (player2Location : (int * int))
                             (width           : int)
                             (height          : int)
                             (coinsFileName   : string) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            object (self) inherit CoinsGenerator.coinsGenerator as super
    
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private checkCoinInBounds (cell : int * int) =
                
                (* There is an error if the coin is outside of the maze *)
                if fst cell < 0 || fst cell > height - 1 || snd cell < 0 || snd cell > width - 1 then
                    ToolBox.error "There is a coin outside of the maze"
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private checkNoTokenOnCell (cell : int * int) =
                
                (* There is an error if the file has a coin where a player starts *)
                if cell = player1Location || cell = player2Location then
                    ToolBox.error "There is a coin where one of the players starts"
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            method generateCoins =
                
                (* We read the file contents *)
                let channel = open_in coinsFileName in
                let nbChars = in_channel_length channel in
                let contents = String.create nbChars in
                really_input channel contents 0 nbChars;
                close_in channel;
                
                (* In case of error, we write a message *)
                try
                
                    (* We split the coins *)
                    let shortContents = Str.global_replace (Str.regexp "[][ \t\n}{]+") "" contents in
                    let splittedContents = Array.of_list (Str.split (Str.regexp "),?") shortContents) in
                    
                    (* We save them (at the end to respect the order in the file) *)
                    let coins = ref [] in
                    for i = 0 to Array.length splittedContents - 1 do
                        let coin = ToolBox.stringToLocation splittedContents.(i) in
                        self#checkNoTokenOnCell coin;
                        self#checkCoinInBounds coin;
                        coins := !coins @ [coin]
                    done;
                    
                    (* Done *)
                    !coins
                    
                with
                    _ -> ToolBox.error "Error while parsing the coins file"
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)