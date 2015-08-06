####################################################################################################################################################################################################################################
############################################################################################################## MACROS ##############################################################################################################
####################################################################################################################################################################################################################################

# Paths
PATH_CODE = ./code/
PATH_REPLAY = ./outputFiles/previousGame/
PATH_TARGET = ./executables/pyrat

# Dependencies
DEPENDENCIES = thread, package(str), package(graphics), package(unix)

####################################################################################################################################################################################################################################
############################################################################################################### RULES ##############################################################################################################
####################################################################################################################################################################################################################################

# Main building rule
build:
	printf "<*>: $(DEPENDENCIES)" > $(PATH_CODE)_tags
	printf "_build\n_tags" > $(PATH_CODE).hidden
	cd $(PATH_CODE) && ocamlbuild -use-ocamlfind Main.native
	mv $(PATH_CODE)Main.native $(PATH_TARGET)

# Main cleaning rule
clean:
	rm -rf $(PATH_TARGET) $(PATH_REPLAY)*
	make cleanTmp

# Removes the temporary files
cleanTmp:
	rm -rf $(PATH_CODE)_build $(PATH_CODE)_tags $(PATH_CODE).hidden

####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################