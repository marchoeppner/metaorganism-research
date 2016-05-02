fastqc = {

	doc title: "Quality control of read data using FastQC",
	
	desc: """
		FastQC is a light-weight java tool that analyses RNAseq
		read data and reports statistics on the sequencing quality. 
	""",

	constraints: "Requires one (single-end) or two (paired-end) gzipped fastq files",

	author: "marc.hoeppner@bils.se"
	var paired : true
	var directory : "fastqc"

	input_extension = ".gz"	

	output.dir = directory

	def products

	if (paired) {
		products = [
			("$input1".replaceAll(/.*\//,"") - input_extension + '_fastqc.html'),
			("$input2".replaceAll(/.*\//,"") - input_extension + '_fastqc.html')
		]
	} else {
		products = [
			("$input".replaceAll(/.*\//,"") - input_extension + '_fastqc.html')
		]
	}

	if (paired) {
		produce(products) {
			multi "fastqc --outdir=${output.dir} $input1","fastqc --outdir=${output.dir} $input2"
		}
	} else {
		produce(products) {
			exec "fastqc --outdir=${output.dir} $input"
		}
	}
}
