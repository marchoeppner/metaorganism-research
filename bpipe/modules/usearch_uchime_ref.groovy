@preserve
usearch_uchime_ref = {

	doc about: "A generic module that needs a description",
	description: "Description here",
    	constraints: "Information on constraints here",
    	author: "WhoWroteThis"

	// Variables here
	var procs : 1		// Number of cores to use
	var directory : ""	// Allows specifying an output directory
	var rdp : false		// Use in RDP mode
	var gold : false	// use in gold mode

    	// requires here

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}

	def db = ""
	def suffix = "chimera_"
	if (rdp) {
		requires RDP_FA : "Must provide location of RDP reference set for chimera detection"
		db = RDP_FA
		suffix += "rdp"
	} else if (gold) {
		requires GOLD_FA : "Must provide location of GOLD reference set for chimera detection"
		db = GOLD_FA
		suffix += "gold"
	} else if (gold && rdp) {
		fail "Can only choose one reference set to run against (was: gold and rdp)"
	} else {
		fail "Must choose either rdp or gold as reference set"
	}
	
    	// Running a command
	
	transform("fasta") to("clean.fasta",suffix +".fasta") {
		from("fasta") {
		    	exec "$USEARCH -uchime_ref $input -db $db -strand plus -nonchimeras $output1 -chimeras $output2","usearch_uchime_ref"
		}
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
