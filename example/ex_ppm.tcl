lappend auto_path [pwd]

package require image 1.0

set ppm [PPM::Format new]
set path [pwd]
set inputPath [file join $path asset sample.ppm]
set savePath [file join $path asset Output sample_output.ppm]
$ppm Load $inputPath
$ppm Save $savePath