export path_separator = /
export verbose = 0
export timeit = 1


ifeq ($(verbose), 0)
   ifeq ($(timeit), 1)
      export TIMEIT = time -f "%E"
   else
      export NL = ; echo ""
   endif
   
   export ALIGN = 60

   MAKECALL = $(MAKE) -e --no-print-directory -f - -C $(subst .,$(path_separator),$@) $(MAKECMDGOALS) < MakefileModule 
   PRINT_ENTERMAKECALL = @printf "\033[34m%s\n\033[0m" "Entering $@" ; 
   PRINT_LEAVEMAKECALL = ; printf "\033[34m%s\n\033[0m" "Leaving $@" ; 
else
   MAKECALL = $(MAKE) -e -f - -C $(subst .,$(path_separator),$@) $(MAKECMDGOALS) < MakefileModule 
endif

SUBMODULES = common os ipc tp.vendedores_tickets

.PHONY: all clean depclean mostlyclean $(SUBMODULES)

all: $(SUBMODULES)

depclean: $(SUBMODULES)

clean: $(SUBMODULES)

mostlyclean: $(SUBMODULES)

$(SUBMODULES):
	$(PRINT_ENTERMAKECALL) $(MAKECALL) $(PRINT_LEAVEMAKECALL)

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
