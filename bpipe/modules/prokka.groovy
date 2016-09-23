prokka = {

	doc about: "A module to run the Prokka annotation pipeline",
	description: "Prokka annotates bacterial genome assemblies",
    	constraints: "Must have Prokka and all its dependencies in $PATH",
    	author: "mphoeppner@gmail.com"

	// Variables here
	var procs : 8		// Number of cores to use
	var directory : ""	// Allows specifying an output directory
	var centre : "ZMB"

    	// requires here

	requires PROKKA : "Must set path to prokka executable in the config file."

	// Set a different output directory
    	if (directory.length() > 0) {
		output.dir = directory
	} else {
		def directory = "prokka." + branch.name
		output.dir = directory
	}
	
        def locustag = branch.sample

        produce(locustag + ".log") {
                exec "$PROKKA --outdir $output.dir --addgenes --cpus $procs --mincontiglen 1000 --centre $centre --locustag $locustag --force $input","prokka"
        }

	// Validation here?

        check {
                exec "[ -s $output ]"
        } otherwise {
                fail "Output empty, terminating $branch.name"
        }

}
