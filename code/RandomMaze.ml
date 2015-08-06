(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class randomMaze (singlePlayer        : bool)
                     (width               : int)
                     (height              : int)
                     (density             : float)
                     (fenceProbability    : float)
                     (nbMovesToCrossFence : int) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            object (self) inherit Maze.maze as super
            
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)

            method private adjacentCells (cell : int * int) =
                
                (* Returns the list of cells touching the given one without considering walls *)
                let neighbors = ref [] in
                if fst cell <> 0 then
                    neighbors := (fst cell - 1, snd cell) :: !neighbors;
                if fst cell <> height - 1 then
                    neighbors := (fst cell + 1, snd cell) :: !neighbors;
                if snd cell <> 0 then
                    neighbors := (fst cell, snd cell - 1) :: !neighbors;
                if snd cell <> width - 1 then
                    neighbors := (fst cell, snd cell + 1) :: !neighbors;
                !neighbors
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private computeWeight =
                
                (* We use the fence weight with a certain probability *)
                if Random.float 1.0 < fenceProbability then
                    nbMovesToCrossFence
                else
                    1
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private generateGraph =
                
                (* The symmetry depends on if it is a single-player game *)
                if singlePlayer then
                    self#generateGraphWithoutSymmetry
                else
                    self#generateGraphWithSymmetry
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private generateGraphWithSymmetry =
                
                (* Initialization of the sets for the merging algorithm *)
                let setsForCells = Hashtbl.create (height * width / 2) in
                for setNumber = 0 to height * width / 2 do
                    let l = setNumber / width in
                    let c = setNumber mod width in
                    Hashtbl.add setsForCells (l, c) setNumber;
                    Hashtbl.add setsForCells (height - 1 - l, width - 1 - c) setNumber
                done;
                
                (* We start from a maze full of walls, remove some and add the weights *)
                let removedWalls = self#removeWalls setsForCells in
                let graph = Hashtbl.create (width * height) in
                let encounteredWalls = ref [] in
                let addWeights = fun formerWall ->
                                 (
                                     let oppositeWall = ((height - 1 - fst (snd formerWall), width - 1 - snd (snd formerWall)), (height - 1 - fst (fst formerWall), width - 1 - snd (fst formerWall))) in
                                     if not (List.mem formerWall !encounteredWalls) && not (List.mem oppositeWall !encounteredWalls) then
                                     (
                                         let weight = self#computeWeight in
                                         Hashtbl.add graph (fst formerWall) (snd formerWall, weight);
                                         Hashtbl.add graph (snd formerWall) (fst formerWall, weight);
                                         Hashtbl.add graph (fst oppositeWall) (snd oppositeWall, weight);
                                         Hashtbl.add graph (snd oppositeWall) (fst oppositeWall, weight);
                                         encounteredWalls := formerWall :: oppositeWall :: !encounteredWalls
                                     )
                                 ) in
                List.iter addWeights removedWalls;

                (* We return the attributes to set in the parent class *)
                (width, height, graph)
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private generateGraphWithoutSymmetry =
                
                (* Initialization of the sets for the merging algorithm *)
                let setsForCells = Hashtbl.create (height * width - 1) in
                for setNumber = 0 to height * width - 1 do
                    let l = setNumber / width in
                    let c = setNumber mod width in
                    Hashtbl.add setsForCells (l, c) setNumber
                done;
                
                (* We start from a maze full of walls, remove some and add the weights *)
                let removedWalls = self#removeWalls setsForCells in
                let graph = Hashtbl.create (width * height) in
                let addWeights = fun formerWall ->
                                 (
                                     let weight = self#computeWeight in
                                     Hashtbl.add graph (fst formerWall) (snd formerWall, weight);
                                     Hashtbl.add graph (snd formerWall) (fst formerWall, weight)
                                 ) in
                List.iter addWeights removedWalls;

                (* We return the attributes to set in the parent class *)
                (width, height, graph)
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private getListOfWalls (previouslyRemovedWalls : ((int * int) * (int * int)) list) =
                
                (* We iterate over the cells and keep the walls in lexical order *)
                let walls = ref [] in
                for l = 0 to height - 1 do
                    for c = 0 to width - 1 do

                        (* We check the neighbors of the current node *)
                        let neighbors = self#adjacentCells (l, c) in
                        let addWallsToList = fun neighbor ->
                                             (
                                                 
                                                 (* We add the walls in lexical order to avoid double entries *)
                                                 let lexicalOrder = l < fst neighbor || (l = fst neighbor && c < snd neighbor) in
                                                 let wall = if lexicalOrder then
                                                                ((l, c), neighbor)
                                                            else
                                                                (neighbor, (l, c)) in
                                                 let wallDoesNotExist = List.mem wall previouslyRemovedWalls in
                                                 let wallAlreadyEncountered = List.mem wall !walls in
                                                 if not wallDoesNotExist && not wallAlreadyEncountered then
                                                     walls := wall :: !walls
                                                    
                                             ) in
                        List.iter addWallsToList neighbors
                        
                    done
                done;
                !walls
                
        (******************************************************************************************************************************************************************************************************************)
            
            method private removeWalls (setsForCells : (int * int, int) Hashtbl.t) =
                
                (* We create a list with all the walls and shuffle it *)
                let walls = self#getListOfWalls [] in
                let shuffledWalls = ToolBox.shuffleList walls in

                (* We iterate over the walls to remove those separating sets of cells *)
                let removedWalls = ref [] in
                let removeWallsFunction = fun wall ->
                                          (
                                              let setForCell1 = Hashtbl.find setsForCells (fst wall) in
                                              let setForCell2 = Hashtbl.find setsForCells (snd wall) in
                                              if setForCell1 <> setForCell2 then
                                              (
                                                  removedWalls := wall :: !removedWalls;
                                                  for l = 0 to height - 1 do
                                                      for c = 0 to width - 1 do
                                                          let setForCellLC = Hashtbl.find setsForCells (l, c) in
                                                          if setForCellLC = setForCell2 then
                                                              Hashtbl.replace setsForCells (l, c) setForCell1
                                                      done
                                                  done
                                              )
                                          ) in
                List.iter removeWallsFunction shuffledWalls;

                (* We shuffle the remaining walls *)
                let remainingWalls = self#getListOfWalls !removedWalls in
                let shuffledRemainingWalls = ref (ToolBox.shuffleList remainingWalls) in

                (* We consider that the current maze defines density 1, and remove random walls until the chosen density is achieved *)
                let nbWallsBeforeRemoving = List.length !shuffledRemainingWalls in
                while (float_of_int (List.length !shuffledRemainingWalls)) /. (float_of_int nbWallsBeforeRemoving) > density do
                    let wallToRemove = List.hd !shuffledRemainingWalls in
                    shuffledRemainingWalls := List.tl !shuffledRemainingWalls;
                    removedWalls := wallToRemove :: !removedWalls;
                done;

                (* We return the removed walls *)
                !removedWalls
            
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)