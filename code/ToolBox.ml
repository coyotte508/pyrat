(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** GLOBAL FUNCTIONS ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)
    
    let error (message : string) =
        
        (* We print the message and exit *)
        print_endline ("[ERROR] " ^ message);
        exit (-1)
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let intPairToString (cell : int * int) =
        
        (* Returns the representation of the cell *)
        "(" ^ string_of_int (fst cell) ^ ", " ^ string_of_int (snd cell) ^ ")"
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    let hashtblDistinctKeys (table : ('a, 'b) Hashtbl.t) =

        (* We fill a list with the keys *)
        let keys = ref [] in
        let fillKeys = fun key _ ->
                       (
                           if not (List.mem key !keys) then
                               keys := key :: !keys
                       ) in
        Hashtbl.iter fillKeys table;
        !keys
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    let listOfIntPairsToString (listToRepresent : (int * int) list) =
        
        (* No elements *)
        if List.length listToRepresent = 0 then
            "[]"
        
        (* We fill a string representating the elements *)
        else
        (
            let representation = ref "[" in
            let fillRepresentation = fun element ->
                                     (
                                         representation := !representation ^ intPairToString element ^ ", "
                                     ) in
            List.iter fillRepresentation listToRepresent;
            representation := String.sub !representation 0 (String.length !representation - 2) ^ "]";
            !representation
        )
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    let shuffleList (listToShuffle : 'a list) =
    
        (* We shuffle the list *)
        let createRandomMappingFunction = fun element ->
                                          (
                                              (Random.bits (), element)
                                          ) in
        let randomMapping = List.map createRandomMappingFunction listToShuffle in
        let sortedRandomMapping = List.sort compare randomMapping in
        List.map snd sortedRandomMapping
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)
    
    let stringToLocation (tupleAsString : string) =
        
        (* We remove the remaining parentheses and split the comma *)
        let shortTupleAsString = Str.global_replace (Str.regexp "[()]+") "" tupleAsString in
        let tuple = Str.split (Str.regexp ",") shortTupleAsString in
        (int_of_string (List.hd tuple), int_of_string (List.hd (List.tl tuple)))
        
    ;;
    
(**********************************************************************************************************************************************************************************************************************************)

    let wait (endTime : float) =
        
        (* We wait in a try/catch *)
        while Unix.gettimeofday () < endTime do
            try
                Thread.delay (endTime -. Unix.gettimeofday ())
            with
                _ -> ()
        done
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
    
    let weightedGraphIsConnected (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

        (* We use a breadth first search *)
        let visitedNodes = ref [(0, 0)] in
        let queue = ref [(0, 0)] in
        while List.length !queue <> 0 do
            let nextElement = List.hd !queue in
            queue := List.tl !queue;
            let neighbors = Hashtbl.find_all graph nextElement in
            let visitNewNeighbors = fun (neighbor, _) ->
                                    (
                                        if not (List.mem neighbor !visitedNodes) then
                                        (
                                            visitedNodes := neighbor :: !visitedNodes;
                                            queue := !queue @ [neighbor]
                                        )
                                    ) in
            List.iter visitNewNeighbors neighbors;
        done;

        (* Ok if we have visited all nodes *)
        (List.length !visitedNodes = List.length (hashtblDistinctKeys graph))
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
    
    let weightedGraphIsSimple (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

        (* We check that every path is unique *)
        let result = ref true in
        let foundPairs = ref [] in
        let checkSimple = fun node (neighbor, _) ->
                          (
                              if List.mem (node, neighbor) !foundPairs then
                                  result := false
                              else
                                  foundPairs := (node, neighbor) :: !foundPairs
                          ) in
        Hashtbl.iter checkSimple graph;
        !result
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
    
    let weightedGraphIsSymmetric (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

        (* We check that every path has a symmetric counterpart *)
        let result = ref true in
        let checkSymmetry = fun node (neighbor, weight) ->
                            (
                                if not (List.mem (node, weight) (Hashtbl.find_all graph neighbor)) then
                                    result := false
                            ) in
        Hashtbl.iter checkSymmetry graph;
        !result
        
    ;;

(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)