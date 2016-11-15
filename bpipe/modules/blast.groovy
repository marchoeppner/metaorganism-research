blast = {

        doc title: "Run a blast+ search on a FASTA file",

        desc: "Takes a sequence fasta file as input and blasts it against a database",

        author: "mphoeppner@gmail.com"

        var outfmt : 6
        var program : "blastp"
	var procs : "8"
        var max_target_seqs : 10
	var qcov_hsp_perc : 80
	var max_intron_length : 50000
	var directory : "theVoid"

        requires BLAST_DB : "Must specify a blast+ formatted database"

	// Set a different output directory
        if (directory.length() > 0) {
                output.dir = directory
        }

	def options = ""

	if (progam == "tblastn") {
		options += " -max_intron_length $max_intron_length"
	}

        exec "$program -db $BLAST_DB $options -query $input -outfmt $outfmt -max_target_seqs $max_target_seqs -num_threads $procs -out $output","blast"
}

merge_blast_tab = {

	doc "Crude method to merge the tabular output from multiple BLAST searches"

        produce(branch.sample + "_blast.out") {
                exec "cat $inputs > $output"
        }

}
