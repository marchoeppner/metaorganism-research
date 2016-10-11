usearch_fastq_mergepairs = {

	doc about: "Usearch fastq_mergepairs",
	description: "Usearch - a search and clustering algorithm ",
    	constraints: "Should be version 8.0 or higher.",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 1		// Number of cores to use
	var directory : ""	// Allows specifying an output directory

    	// requires here

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	}
	
    	// Running a command
	
	def forward_reads = inputs.find{ it =~ /.*_R1.*/ }
	def reverse_reads = inputs.find{ it =~/.*_R2.*/ }
	def merged_fastq = branch.name + "_merged.fastq"
	
	produce(merged_fastq) {
	    	exec "$USEARCH -fastq_mergepairs $input1 -reverse $input2 -fastq_minlen 200 -fastq_minmergelen 300 -fastq_maxmergelen 350 -fastq_minovlen 100 -fastq_maxdiffs 1 -fastqout $output"
	}

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
