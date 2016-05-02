trowel_list = {

        def list_name = branch.sample + ".list"

        branch.left = input1
        branch.right = input2

        produce(list_name) {
                exec "echo $input1 >> $output && echo $input2 >> $output"
        }

}


trowel = {

	doc about: "Error correction of Illumina reads",
	description: "Runs the trowel software to error correct reads generated on the Illumina platform",
    	constraints: "None",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use
	var k : 13		// Kmer size

    	// requires here

    	// Running a command
	
	def left_fixed = branch.left + ".out"
        def right_fixed = branch.right + ".out"

        produce(left_fixed,right_fixed) {

                exec "trowel -f $input -t $procs -k $k","trowel"
        }
	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
	
}
