// Trimmomatic module

trimmomatic = {

    var paired : true
    var procs : 8
    var sliding_window : true
    var directory : "trimmomatic"

    doc title: "Adapter trimming of read files using Trimmomatic",
        desc: """
            Performs adapter trimming on paired-end RNA-seq reads.

            Requires:
            TM_PATH : Location of the Trimmomatic files
            TM_JAR : The name of the Trimmomatic jar file
            ADAPTER : The name of the Trimmomatic adapter file
        """,
        contraints: """
            Files must be paired-end
            Files can be compressed (.fq.gz) or uncompressed (.fq)
        """,
        author: "mphoeppner@gmail.com"

    requires TM_PATH : "Must set TM_PATH variable to point to Trimmomatic folder"
    requires TM_JAR : "Must set TM_JAR variable to point to Trimmomatic java file"
    requires ADAPTER : "Must set the type of adapters to use"

    // Determine whether to write this into a sub-folder or not

    output.dir = directory

    input_extension = ".fq.gz"

    def options

    if (sliding_window) {
	options = "SLIDINGWINDOW:4:15"
    } else {
	options = ""
    }

    def products
    def command

    if (paired) {
        products = [
            ("$input1".replaceAll(/.*\//,"") - input_extension + '_paired.fq.gz'),
	    ("$input2".replaceAll(/.*\//,"") - input_extension + '_paired.fq.gz'),
            ("$input1".replaceAll(/.*\//,"") - input_extension + '_unpaired.fq.gz'),
            ("$input2".replaceAll(/.*\//,"") - input_extension + '_unpaired.fq.gz')
        ]
    } else {
        products = [
            ("$input".replaceAll(/.*\//,"") - input_extension + '_unpaired.fq.gz')
       ]
    }

    if (paired) {
        produce(products) {
		exec "java -jar $TM_JAR PE -threads $procs $input1 $input2 ${output1} ${output3} ${output2} ${output4} ILLUMINACLIP:$TM_PATH/adapters/$ADAPTER:2:30:10 LEADING:2 TRAILING:2 $options MINLEN:50","trimmomatic"
        }
    } else {
        produce(products) {
	        exec "java -jar $TM_JAR SE -threads $procs $input $output ILLUMINACLIP:$TM_PATH/adapters/$ADAPTER:2:30:10 LEADING:2 TRAILING:2 $options MINLEN:50 >$output.dir/trimmomatic.out 2>$output.dir/trimmomatic.err && md5sum $output >$output.dir/trimmomatic.md5","trimmomatic"
        }
    }

    check {
        exec "[ -s $output1 ]"
    } otherwise {
        succeed "The Trimmomatic filtering left not reads, stopping this branch ($branch.name)"
    }

}
