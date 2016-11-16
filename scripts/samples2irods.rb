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
    
    elements = line.strip.split("\t")
    if elements.length == 2
      elements.push("string")
    end
    elements.each do |e|
      e.gsub!(/\;/, ',')
    end
    
    answer += "#{elements.join(';')};"
    
  end
  return answer
  
end

def metadata_to_info(file_name)
  
  answer = {}
  
  IO.readlines(file_name).each do |line|
    
    elements = line.strip.split("\t")
    answer[elements[0]] = elements[1]
    
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
  
  
  meta_string = metadata_to_string(metadata)
  info = metadata_to_info(metadata)
  
  tar_file = group + ".tar"
  
  unless File.exists?(tar_file)
    system("tar -cvf #{tar_file} #{group}_R*")
  end
  
  command = "iput -D tar -f --metadata \"#{meta_string}\" #{tar_file} /CAUZone/home/sukmb352/crc1182/#{info['CRC_PROJECT_ID']}/raw_data/#{tar_file}"
  system command
  puts command
    
end