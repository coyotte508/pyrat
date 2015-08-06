(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class singleCoinGenerator (player1Location : int * int)
                              (mazeWidth       : int) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            object (self) inherit CoinsGenerator.coinsGenerator as super
        
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PUBLIC METHODS *************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method generateCoins =
                
                (* The coin is on the top right cell *)
                let coinLocation = (0, mazeWidth - 1) in
                
                (* The player cannot start on the only coin *)
                if player1Location = coinLocation then
                    ToolBox.error "Cannot start on top-right cell in single-coin mode"
                else
                    [coinLocation]
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)