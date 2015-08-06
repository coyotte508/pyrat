(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class fixedNumberCoinsGenerator (player1Location : int * int)
                                    (player2Location : int * int)
                                    (mazeWidth       : int)
                                    (mazeHeight      : int)
                                    (numberOfCoins   : int) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            object (self) inherit CoinsGenerator.coinsGenerator as super
            
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private checkNumberOfCoins (maxNbCoins : int) =
                
                (* We check that the number of coins is not too big *)
                if numberOfCoins > maxNbCoins then
                    ToolBox.error "Number of coins is too high to fit in the maze"
                
        (******************************************************************************************************************************************************************************************************************)
                
                method private generateCoinsWithSymmetry =
                    
                    (* We check the required number of coins *)
                    self#checkNumberOfCoins (mazeWidth * mazeHeight - 2);
                    
                    (* We put the top-right half of locations in a list, but not the middle one if the number of coins is odd, and the top-right one *)
                    let halfLocations = ref [] in
                    let maxL = mazeHeight - max 0 ((mazeHeight - mazeWidth) / 2) - 1 in
                    for l = 0 to maxL do
                        let minC = ref (max 0 (l - (mazeHeight - mazeWidth) / 2)) in
                        if l >= mazeHeight / 2 then
                            incr minC;
                        let maxC = if l = 0 then
                                       mazeWidth - 2
                                   else
                                       mazeWidth - 1 in
                        for c = !minC to maxC do
                            halfLocations := (l, c) :: !halfLocations
                        done
                    done;

                    (* We shuffle the locations *)
                    let shuffledHalfLocations = Array.of_list (ToolBox.shuffleList !halfLocations) in
                    
                    (* We add coins at the first locations *)
                    let coins = ref [] in
                    for i = 0 to int_of_float (floor (float_of_int numberOfCoins /. 2.0)) - 1 do
                        coins := shuffledHalfLocations.(i) :: !coins;
                        coins := (mazeHeight - 1 - fst shuffledHalfLocations.(i), mazeWidth - 1 - snd shuffledHalfLocations.(i)) :: !coins
                    done;
                    
                    (* If the number of coins is odd, we add a last one in the middle of the maze *)
                    if numberOfCoins mod 2 = 1 then
                        coins := (mazeHeight / 2, mazeWidth / 2) :: !coins;
                    
                    (* Done *)
                    !coins
                    
        (******************************************************************************************************************************************************************************************************************)
            
            method private generateCoinsWithoutSymmetry =
                
                (* We check the required number of coins *)
                self#checkNumberOfCoins (mazeWidth * mazeHeight - 1);
                
                (* We put the locations in a list, but not the bottom-left one *)
                let locations = ref [] in
                for l = 0 to mazeHeight - 1 do
                    for c = 0 to mazeWidth - 1 do
                        if (l, c) <> player1Location then
                            locations := (l, c) :: !locations
                    done
                done;

                (* We shuffle the locations *)
                let shuffledLocations = Array.of_list (ToolBox.shuffleList !locations) in
                
                (* We add coins at the first locations *)
                let coins = ref [] in
                for i = 0 to numberOfCoins - 1 do
                    coins := shuffledLocations.(i) :: !coins
                done;
                
                (* Done *)
                !coins
                
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            method generateCoins =

                (* The symmetry depends on if it is a single-player game *)
                if player2Location = (-1, -1) then
                    self#generateCoinsWithoutSymmetry
                else
                    self#generateCoinsWithSymmetry
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)