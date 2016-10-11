fastqx_fastq_quality_filter = {

	doc about: "A generic module that needs a description",
	description: "Description here",
    	constraints: "Information on constraints here",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 1		// Number of cores to use
	var directory : ""	// Allows specifying an output directory

    	// requires here
	requires FASTQ_QUALITY_FILTER : "Must provide location of Fastx fastq_quality_filter location"

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}
	
    	// Running a command
	
	filter("filtered") {
	    	exec "$FASTQ_QUALITY_FILTER -Q33 -q 30 -p 99 -i $input -o $output -v"
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
