spades = {

	doc about: "The SPADES genome assembly",
	description: "Spades is a short-read assembler for prokaryotic genomes",
    	constraints: "None",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use
	var directory : "spades"	// Allows specifying an output directory

    	if (branch.sample_dir) { sample_dir = true }
    	// requires here

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}
	
    	// Running a command
	
    	exec "spades.py -t $procs -o $directory"

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
