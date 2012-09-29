# If this flag is '0', the output of the make will be small and beautified
# If is '1', the output will show each executed instruction.
export verbose = 0

# If this flag is '1', each instruction is executed using 'time' and after
# its execution, the duration of that execution is showed.
# If it is '0', this is disabled
export timeit = 1

# This are the modules which will be builded. Each module represent a directory
# relative to this currect directory.
#
# As an example, if the project has four components like:
#  Project
#   - client        The source code to build a client program
#   - client/gui    The separated source with the 'graphical user interface' use by the client
#   - server        The server side
#   - common        The source that is common to the client and the server.
#  
#  With this layering, the 'SUBMODULES' variable is
# 
#  SUBMODULES = common client/gui client server
#
#  If you only want to build the sources in the same directory if this makefile
#
#  SUBMODULES = .
#
#  Note that the order is important and is honored in the building process.
SUBMODULES = 

#
# END OF THE CONFIGURATION
#

ifeq ($(verbose), 0)
   ifeq ($(timeit), 1)
      export TIMEIT = time -f "%E"
   else
      export NL = ; echo ""
   endif
   
   export ALIGN = 60

   MAKECALL = $(MAKE) -e --no-print-directory -f - -C $@ $(MAKECMDGOALS) < MakefileModule 
   PRINT_ENTERMAKECALL = @printf "\033[34m%s\n\033[0m" "Entering $@" ; 
   PRINT_LEAVEMAKECALL = ; printf "\033[34m%s\n\033[0m" "Leaving $@" ; 
   export PRINT_ERROR = @printf "\033[31m%s\n\033[0m"  
else
   MAKECALL = $(MAKE) -e -f - -C $@ $(MAKECMDGOALS) < MakefileModule 
   export PRINT_ERROR = @echo   
endif


.PHONY: all clean depclean mostlyclean e1 $(SUBMODULES)

ifndef SUBMODULES
e1:
	$(PRINT_ERROR) "The 'SUBMODULES' must be defined (in the Makefile file)"
endif

#TOEXECUTE = $(filter $(SUBMODULES), $(MAKECMDGOALS))

all: $(SUBMODULES)

depclean: $(SUBMODULES)

clean: $(SUBMODULES)

mostlyclean: $(SUBMODULES)

$(SUBMODULES):
	$(PRINT_ENTERMAKECALL) $(MAKECALL) $(PRINT_LEAVEMAKECALL)

#
# Quick reference
#
# "$@" is the name of the target
# "$?" stores the list of dependents more recent than the target (i.e., those that have changed since the last time make was invoked for the given target).
# "$^" gives you all dependencies of a target (recents or not than the target), without duplicates
# "$+" is like $^, but it keeps duplicates and gives you the entire list of dependencies in the order they appear.
# "$<" only the first dependency
#
# blue: red_unmodified green_modified_recently red_unmodified:
# 	echo $@		# blue
# 	echo $?		# green_modified_recently
# 	echo $^		# red_unmodified green_modified_recently
# 	echo $+		# red_unmodified green_modified_recently red_unmodified
# 	echo $<		# red_unmodified
