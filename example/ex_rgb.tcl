lappend auto_path [pwd]

package require image 1.0

set rgb [RGB::Pixel new 100 152 217]

puts [$rgb ToString]
puts [$rgb GetRGB]