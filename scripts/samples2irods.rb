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


def metadata_to_imeta(file_name)

	answer = []

	IO.readlines(file_name).each do |line|

    		elements = line.strip.split("\t")
    		if elements.length == 2
      			elements.push("string")
    		end
    		elements.each do |e|
      			e.gsub!(/\;/, ',')
    		end

    		answer << elements.collect{|e| "\"#{e}\"" }.join(" ")

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

def extract_library_id(read_name)

	# 21Nov52-DL197_S197_L001
	# 21Nov52-DL070_S70_L001_R2_001.fastq.gz
	if read_name.match(/^[0-9]+[A-Za-z]+[0-9]+-[A-Z]+[0-9]+_S.*/)
		return read_name.split("_S")[0]
	# J39655-L1_S77_L001_R1_001.fastq.gz
	elsif read_name.match(/^[A-Z0-9]+-L[0-9]_S.*/)
		return read_name.split("-")[0]
	else
		abort "Did not find a regexp that fits these reads (#{read_name})"
	end

end

### Get the script arguments and open relevant files
options = OpenStruct.new()
opts = OptionParser.new()
opts.on("-i","--infile", "=INFILE","Input file") {|argument| options.infile = argument }
opts.on("-p","--pretend","Simulate only") {|argument| options.pretend = true }
opts.on("-c","--cleanup","Cleanup existing file before loading") {|argument| options.cleanup = true }
opts.on("-h","--help","Display the usage information") {
 puts opts
 exit
}

opts.parse! 

BASE_URL = "/sfb1182/home"

# Example: F13388-L1_S149_L001_R1_001.fastq.gz
file_groups = Dir.entries(Dir.getwd).select{|e| e.include?(".fastq.gz")}.group_by{|e| e.split("_R")[0] }

file_groups.each do |group,files|
  
  warn "Processing data set #{group}"  
  library_id = extract_library_id(group) 
  warn library_id
  metadata = library_id + ".metadata"

  abort "Could not find the metadata sheet (#{metadata}) for the sample #{group}" unless File.exists?(metadata)
  
  next unless File.exists?(metadata)

  meta_string = metadata_to_string(metadata)
  info = metadata_to_info(metadata)
  meta_sets = metadata_to_imeta(metadata)

  tar_file = group + ".tar"
  
  unless File.exists?(tar_file)
    this_command = "tar -cvf #{tar_file} #{group}* #{metadata}"
    if options.pretend
       warn this_command
    else
    	system(this_command)
    end
  end
  
  #command = "iput -D tar -f --metadata \"#{meta_string}\" #{tar_file} /CAUZone/sfb1182/#{info['CRC_PROJECT_ID']}/raw_data/#{tar_file}"

  command = "irm -f #{BASE_URL}/research-#{info['CRC_PROJECT_ID'].downcase}/raw_data/#{tar_file}"

  if options.cleanup
	  if options.pretend
        	warn command
	  else
        	system command
	  end
  end
    
  command = "iput -D tar -f #{tar_file} #{BASE_URL}/research-#{info['CRC_PROJECT_ID'].downcase}/raw_data/#{tar_file}"

  if options.pretend
	warn command  
  else
  	system command
  end

  meta_sets.each do |ms|
  	imeta_cmd = "imeta add -d #{BASE_URL}/research-#{info['CRC_PROJECT_ID'].downcase}/raw_data/#{tar_file} #{ms}"
  	system imeta_cmd unless options.pretend
  end 
	    
end
