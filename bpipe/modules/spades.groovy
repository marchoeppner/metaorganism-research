spades = {

	doc about: "The SPADES genome assembler",
	description: "Spades is a short-read assembler for prokaryotic genomes",
    	constraints: "None",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 16		// Number of cores to use
	var directory : "spades"	// Allows specifying an output directory
	var mem : 64		// Amount of RAM to allocate to spades

    	// requires here

	requires SPADES : "Must set the path to the spades binary in the config file."

	// Setting internal variables

	def directory = branch.name
        branch.sample = branch.name

        output.dir = directory

    	// Running a command
	
	produce("scaffolds.fasta") {
                exec "$SPADES -o $output.dir -1 $input1 -2 $input2 -t $procs -m $mem", "spades"
        }
	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }
}
