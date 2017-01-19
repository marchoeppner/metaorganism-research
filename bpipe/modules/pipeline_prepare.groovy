pipeline_prepare = {
	
	doc title: "A generic module to prepare the output options for a pipeline",
	
	desc:"""
		This pipeline module can be used to set global variables required across all subsequent modules
	""",

	author: "mphoeppner@gmail.com"

	// Permanently store the sample name (to preserve it across forks)
	branch.sample = branch.name
	// Set the sample name as output directory

	branch.outdir = branch.sample

	forward inputs

}




	
