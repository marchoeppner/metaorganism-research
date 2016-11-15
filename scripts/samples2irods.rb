#!/usr/bin/ruby
# == NAME
# samplesheet_to_metadata.rb
#
# == USAGE
# ./this_script.rb [ -h | --help ]
#[ -i | --infile ] |[ -o | --outfile ] | 
# == DESCRIPTION
# Converts the sample sheets from Z3 to metadata files
#
# == OPTIONS
# -h,--help Show help
# -i,--infile=INFILE input file

#
# == EXPERT OPTIONS
#
# == AUTHOR
#  Marc Hoeppner, mphoeppner@gmail.com

require 'optparse'
require 'ostruct'

### Define modules and classes here

def metadata_to_string(file_name)
  
  answer = ""
  
  IO.readlines(file_name).each do |line|
    
    elements = line.split("\t")
    answer += "#{elements.join(';')}"
    
  end
  return answer
  
end

### Get the script arguments and open relevant files
options = OpenStruct.new()
opts = OptionParser.new()
opts.on("-i","--infile", "=INFILE","Input file") {|argument| options.infile = argument }
opts.on("-h","--help","Display the usage information") {
 puts opts
 exit
}

opts.parse! 

# F13388-L1_S149_L001_R1_001.fastq.gz
file_groups = Dir.entries(Dir.getwd).select{|e| e.include?(".fastq.gz")}.group_by{|e| e.split("_")[0..2].join("_")}

file_groups.each do |group,files|
  
  metadata = group.split("-")[0] + ".metadata"

  raise "Could not fin the metadata sheet (#{metadat}) for the sample #{group}" unless File.exists?(metadata)
  
  meta_string = metadata_to_string(metdata)
  
  puts meta_string
    
end