require 'fileutils'

STDERR.puts "Copying all font files from vendor/asset/font to public/font"

FileUtils.mkdir_p 'public/font/'
FileUtils.cp_r 'vendor/assets/font', 'public/'
