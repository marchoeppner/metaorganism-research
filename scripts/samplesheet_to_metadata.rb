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

# Only WGS84 coordinates allowed, need to re-format
def loc2wgs(value)

	value.gsub!(/\"/, '')

	new_value = ""
	if value.match(/^[0-9]*\,[0-9]*/)
		new_value = value.gsub(/\,/, '.')
	elsif value.match(/^[0-9]*\°.*/)
		# Coordinates are negative for lat south and long east
		new_value += "-" if value.match(/.*\S$/) or value.match(/.*W$/)
		new_value = value.gsub(/\"/, '').gsub(/\./, '').gsub(/\°/, '.').gsub(/\'/, '').gsub(/[N,E,S,W]$/, '')
	else
		new_value = value
	end

	return new_value
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

# Report any keys that were not defined in the reference sheet
undefined_keys = []

# Check for reference metadata info
metadata_reference = File.dirname(__FILE__) + "/../metadata/metadata_standard.txt"
raise "Could not find the reference metadata sheet" unless File.exists?(metadata_reference)

ref_keys = []
IO.readlines(metadata_reference).each do |line|
	next if line.match(/^#.*/)
	e = line.strip.split("\t")
	ref_keys << e[1]
end

ref_keys.compact!

# Verify that the converter is available
raise "Could not find the Python XLSX to CSV converter" unless command?("xlsx2csv")

### Convert XLSX to CSV

system("rm metadata-*")
system("xlsx2csv -A -s ';' -o metadata -i #{options.infile}")

frontpage = "metadata-Submitter_Information.csv"
exit "Frontpage missing from XLS sheet" unless File.exist?(frontpage)
meta = Dir["metadata-*MetaData*"][0]
exit "Metadata information missing from XLS sheet" unless File.exist?(meta)

### Get project information from first sheet

project_id = nil
main_contact_name = nil
main_contact_email = nil
principle_investigator = nil

lines = IO.readlines(frontpage).collect{|l| l.gsub(/\"/, "") }

lines.each do |line|
  if line.match(/^Main Contact Name.*/)
    main_contact_name = line.strip.split(";")[1]
  elsif line.match(/^Main Contact Email.*/)
    main_contact_email = line.strip.split(";")[1]
  elsif line.match(/^Principle Investigator.*/)
    principle_investigator = line.strip.split(";")[1]
  elsif line.match(/^Project-ID.*/)
    project_id = line.strip.split(";")[1]
    if project_id.include?("/") || project_id.include?("and")
	project_id.include?("/") ? fixed_id = project_id.split("/")[0] : fixed_id = project_id.split(" ")[0]
	warn "Illegal project ID: #{project_id}. Changing to #{fixed_id}"
	project_id = fixed_id
     end
  end
  
end

#### Parse CSV and create meta data files from second sheet

lines = IO.readlines(meta).collect{|l| l.gsub(/\"/, "") }

units = lines.shift.split(";")

header = lines.shift.split(";")

lims_barcode_column = header.index(header.find{|h| h.include?("LIMS-ID") })

if lims_barcode_column.nil?
	lims_barcode_column = header.index(header.find{|h| h.include?("Lab-ID") })
end

abort "Could not identify the proper LIMS barcode column (user changed name?)" unless lims_barcode_column

library_id = nil

lines.each do |line|

  line.strip!

  next if line.strip.match(/^$/)
    
  elements = line.gsub(/\/"/, "").split(";")

  library_id = elements[lims_barcode_column]
  abort "Library ID could not be parsed" if library_id.nil?

  library_id.include?("-S1") ? library_id = library_id.split("-S1")[0] : library_id = library_id

  f = File.new("#{library_id}.metadata","w+")
  
  metas = []

  units.each_with_index do |unit,index|

    unit = "" if index == 0
    
    key = header[index]
    value = elements.shift

    this_entry = MetaEntry.new(key,value,unit)
   
    metas << this_entry unless unit == ""
    
  end

  next if library_id.length == 0

  [ project_id , main_contact_name, main_contact_email, principle_investigator, library_id ].each { |v| abort "Missing mandatory value detected, check sample sheet" if  v.length == 0 }

  f.puts "CRC_PROJECT_ID\t#{project_id}\tstring"
  f.puts "PRINCIPLE_INVESTIGATOR\t#{principle_investigator}\tstring"
  f.puts "MAIN_CONTACT_NAME\t#{main_contact_name}\tstring"
  f.puts "MAIN_CONTACT_EMAIL\t#{main_contact_email}\tstring"
  f.puts "LIBRARY_ID\t#{library_id}\tstring"
  
  metas.each do |meta|

    if meta.key and meta.value and meta.unit
      next if meta.value.length == 0

      undefined_keys << meta.key  unless ref_keys.include?(meta.key)
	
      meta.key.include?("GEOGRAPHIC_LOCATION") ? val = loc2wgs(meta.value) : val = meta.value
	
      f.puts "#{meta.key}\t#{val}\t#{meta.unit}"
    end

  end

  f.close
  
end

unless undefined_keys.empty?
	undefined_keys.uniq!

	warn "#{undefined_keys.length} undefined keys encountered"
	undefined_keys.each do |k|
		puts k
	end
end
