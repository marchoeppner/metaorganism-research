transdecoder_orfs = {

	doc about: "Identification of ORFs in assembled transcripts",
	description: "TransDecoder identifies potential ORFs in transcripts",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 1		// Number of cores to use

    	// requires here

	output.dir = input + ".transdecoder_dir"
	
    	// Running a command
	
	produce("longest_orfs.pep") {

                exec "TransDecoder.LongOrfs -t $input","transdecoder"
        }
	
	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
