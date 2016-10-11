@intermediate
usearch_fastq_filter = {

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
	
    	// Running a command
	
	transform("fastq") to("fastq_filter.fastq","fastq_filter.fasta") {
	    	exec "$USEARCH -fastq_filter $input -fastq_maxee 0.1 -fastqout $output1 -fastaout $output2","usearch_fastq_filter"
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
