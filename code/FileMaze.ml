(**********************************************************************************************************************************************************************************************************************************)
(******************************************************************************************************** CLASS DEFINITION ********************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)

    class fileMaze (mazeFileName : string) =

        (******************************************************************************************************************************************************************************************************************)
        (*************************************************************************************************** INHERITANCE **************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
            object (self) inherit Maze.maze as super
            
        (******************************************************************************************************************************************************************************************************************)
        (************************************************************************************************* PRIVATE METHODS ************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
            
            method private assertGraphConnected (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

                (* We raise an error if the graph is not connected *)
                if not (ToolBox.weightedGraphIsConnected graph) then
                    ToolBox.error "Some cells in the maze are not accessible"
            
        (******************************************************************************************************************************************************************************************************************)
            
            method private assertGraphSimple (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

                (* We raise an error if the graph has multiple paths between adjacent cells *)
                if not (ToolBox.weightedGraphIsSimple graph) then
                    ToolBox.error "Some paths between cells are duplicated"
            
        (******************************************************************************************************************************************************************************************************************)
            
            method private assertGraphSymmetric (graph : ((int * int), ((int * int) * int)) Hashtbl.t) =

                (* We raise an error if the graph is not symmetric *)
                if not (ToolBox.weightedGraphIsSymmetric graph) then
                    ToolBox.error "Some paths between cells are not symmetric"
            
        (******************************************************************************************************************************************************************************************************************)
        
            method private generateGraph =

                (* We read the file contents *)
                let channel = open_in mazeFileName in
                let nbChars = in_channel_length channel in
                let contents = String.create nbChars in
                really_input channel contents 0 nbChars;
                close_in channel;
                
                (* In case of an error, we write a message *)
                try
                
                    (* We split the nodes *)
                    let shortContents = Str.global_replace (Str.regexp "[ \t\n}{]+") "" contents in
                    let contentsPerNode = Array.of_list (Str.split (Str.regexp "\\],?") shortContents) in

                    (* For each node, we parse the neighbors (in reverse order to have the same map as in the file) *)
                    let width = ref 0 in
                    let height = ref 0 in
                    let graph = Hashtbl.create (Array.length contentsPerNode) in
                    for i = Array.length contentsPerNode - 1 downto 0 do
                        let sourceAndTargets = Str.split (Str.regexp ":\\[") contentsPerNode.(i) in
                        let source = ToolBox.stringToLocation (List.hd sourceAndTargets) in
                        let targets = Array.of_list (Str.split (Str.regexp "),?") (List.hd (List.tl sourceAndTargets))) in
                        for j = Array.length targets - 2 downto 0 do
                            if j mod 2 = 0 then
                            (
                                let target = ToolBox.stringToLocation targets.(j) in
                                let weight = int_of_string targets.(j + 1) in
                                Hashtbl.add graph source (target, weight)
                            )
                        done;
                        width := max !width (snd source);
                        height := max !height (fst source)
                    done;
                    
                    (* We check that the generated graph is correctly connected, is simple and is symmetric *)
                    self#assertGraphConnected graph;
                    self#assertGraphSimple graph;
                    self#assertGraphSymmetric graph;
                    
                    (* We return the attributes to set in the parent class *)
                    (!width + 1, !height + 1, graph)
                    
                with
                    _ -> ToolBox.error "Error while parsing the maze file"
                
        (******************************************************************************************************************************************************************************************************************)
        (******************************************************************************************************************************************************************************************************************)
        
    end
    
(**********************************************************************************************************************************************************************************************************************************)
(**********************************************************************************************************************************************************************************************************************************)