nxtrim = {

	doc about: "Removing adapters from mate pair libraries",
	description: "Runs NXtrim in mate-pair libraries generated with the Nextera MP kit",
    	constraints: "None",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use
	var directoy : "nxtrim"	// Allows specifying an output directory

    	if (branch.sample_dir) { sample_dir = true }
    	// requires here

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}
	
    	// Running a command
	
        def mp_file = branch.name + ".mp.fastq.gz"
	produce(mp_file) {
    		exec "nxtrim --separate --norc -1 $input1 -2 $input2 -O $branch.name","nxtrim"
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
}
