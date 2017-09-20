require 'json'

xls = ARGV.shift

lines = `xlsx2csv -s 2 -d tab #{xls}`

puts lines.inspect[0..200]
