@preserve
usearch_uchime_ref = {

	doc about: "A generic module that needs a description",
	description: "Description here",
    	constraints: "Information on constraints here",
    	author: "WhoWroteThis"

	// Variables here
	var procs : 1		// Number of cores to use
	var directory : ""	// Allows specifying an output directory

    	// requires here

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}

	def db = ""
	def suffix = "chimera_"

	requires GOLD_FA : "Must provide location of GOLD reference set for chimera detection"
	suffix += "gold"
	
    	// Running a command
	
	transform("fasta") to("clean.fasta",suffix +".fasta") {
		from("fasta") {
		    	exec "$USEARCH -uchime_ref $input -db $GOLD_FA -strand plus -nonchimeras $output1 -chimeras $output2","usearch_uchime_ref"
		}
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
