hmmscan = {

	doc about: "Hmmscan is part of the Hmmer package",
	description: "Search for protein features in sequence data",
    	constraints: "Requires Hmmer and a compatible hmm file",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use
	var directory : ""	// Allows specifying an output directory

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}
	requires HMMER_DB :"Must provide HMM profile"

    	// Running a command
	
	output.dir = branch.sample + "_output"

    	exec "hmmscan --cpu $procs --domtblout $output $HMMER_DB $input"

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
