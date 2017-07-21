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

def command?(command)
  system("which #{ command} > /dev/null 2>&1")
end

class MetaEntry
  
  attr_accessor :key, :value, :unit
  
  def initialize(key,value,unit)
    @key = key.strip.split(/\s/).join("_").upcase.gsub(/-/, '_').gsub(/[\(,\)]/, '')
    @value = value.strip
    @unit = unit.strip
        
    _sane?
  end
  
  private
  
  def _sane?
    
    
    
  end
  
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

# Verify that the converter is available
raise "Could not find the Python XLSX to CSV converter" unless command?("xlsx2csv")

### Convert XLSX to CSV

# Sheet 1 provides information about the submitter
csv_file_p1 = options.infile.gsub(/\.xlsx/, '.p1.tab')
system("xlsx2csv #{options.infile} -s 1 -d tab > #{csv_file_p1}")
# Sheet 2 includes the sample information
csv_file_p2 = options.infile.gsub(/\.xlsx/, '.p2.tab')
system("xlsx2csv #{options.infile} -s 2 -d tab > #{csv_file_p2}")

### Get project information from first sheet

project_id = nil
main_contact_name = nil
main_contact_email = nil

lines = IO.readlines(csv_file_p1)
lines.each do |line|
  if line.match(/^Main Contact Name.*/)
    main_contact_name = line.strip.split("\t")[1]
  elsif line.match(/^Main Contact Email/)
    main_contact_email = line.strip.split("\t")[1]
  elsif line.match(/^Project-ID.*/)
    project_id = line.strip.split("\t")[1]
    if project_id.include?("/")
	fixed_id = project_id.split("/")[0]
	warn "Illegal project ID: #{project_id}. Changing to #{fixed_id}"
	project_id = fixed_id
     end
  end
  
end

#### Parse CSV and create meta data files from second sheet

lines = IO.readlines(csv_file_p2)

units = lines.shift.split("\t")

header = lines.shift.split("\t")

lims_barcode_column = header.index(header.find{|h| h.include?("LIMS-ID") })

lines.each do |line|

  next if line.strip.match(/^$/)
    
  elements = line.split("\t")
  
  f = File.new("#{elements[lims_barcode_column]}.metadata","w+")
  
  metas = []

  units.each_with_index do |unit,index|

    unit = "" if index == 0
    
    key = header[index]
    value = elements.shift

    this_entry = MetaEntry.new(key,value,unit)
   
    metas << this_entry unless unit == ""
    
  end
  
  f.puts "CRC_PROJECT_ID\t#{project_id}\tstring"
  f.puts "MAIN_CONTACT_NAME\t#{main_contact_name}\tstring"
  f.puts "MAIN_CONTACT_EMAIL\t#{main_contact_email}\tstring"
  
  metas.each do |meta|
    
    if meta.key and meta.value and meta.unit
      next if meta.value.length == 0
      f.puts "#{meta.key}\t#{meta.value}\t#{meta.unit}"
    end

  end

  f.close
  
end


