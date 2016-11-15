signalp = {

	doc about: "Predicting signaling peptides in aminoacid sequences",
	description: "Uses SignalP to predict signalling peptides",
    	constraints: "Requires version 4.1",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use

    	// requires here

    	// Running a command
	
        output.dir = branch.sample + "_output"

        exec "signalp -f short -n $output $input","signalp"

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
