# PPM image file format support
#
# 24 bit color support is provided.
#
# Data members:
#   imageFormat: P3 only
#   depth: maximum color value
#   cols: number of columns
#   rows: number of rows
#   data: list of pixels

package provide image 1.0
package require Tcl 8.6

namespace eval PPM {
    oo::class create Format

    oo::define Format {
        variable imageFormat
        variable cols rows
        variable depth
        variable data

        constructor { { format "P3" } { width 0 } { height 0 } { maxDepth 255} {pixelData {}}} {
            set imageFormat $format
            set cols $width
            set rows $height
            set depth $maxDepth
            set data $pixelData
        }
    }

    # Setters and Getters definition
    oo::define Format {
        method SetWidth { width } {
            set cols $width
        }
        method SetHeight { height } {
            set rows $height
        }
        method SetMaxDepth { maxDepth  } {
            set depth $maxDepth
        }
        method SetPixelData { pixelData } {
            set size [llength $pixelData]
            set pixelData [join $pixelData " "]
            if { [expr { size % 3 }] == 0 } {
                set data {}
                for { set idx 0 } { $idx < $size } {incr idx 3} {
                    set r [lindex $pixelData $idx]
                    set g [lindex $pixelData [expr { $idx + 1 }]]
                    set b [lindex $pixelData [expr { $idx + 2 }]]

                    set rgb [RGB::Pixel $r $g $b]
                    lappend data $rgb
                }
            }
            set data $pixelData
        }

        method GetImageFormat {} {
            return $imageFormat
        }
        method GetWidth {} {
            return $cols
        }
        method GetHeight {} {
            return $rows
        }
        method GetMaxDepth {} {
            return $depth
        }
        method GetPixelData {} {
            return $data
        }
    }

    oo::define Format {
        method Load { filepath } {
            # Read and store whole file
            set ppmImg [open $filepath r]
            set lines [split [read $ppmImg] "\n"]
            close $ppmImg

            set lines [string trim $lines]
            set lineCount [llength $lines]

            set processedLines {}

            for { set linIdx 0 } { $linIdx < $lineCount } { incr linIdx} {
                set line [string trim [lindex $lines $linIdx]]
                if { [string equal "#" [string index $line 0]] } {
                    continue
                } else {
                    lappend processedLines $line
                }
            }
            set lineCount [llength $processedLines]

            set imgFormCheck 0

            if { [string equal "P3" [lindex $processedLines 0]] } {
                set imageFormat "P3"
                set imgFormCheck 1
            } else {
                return
            }

            if { $imgFormCheck == 1} {
                set dimensions [join [lindex $processedLines 1] " "]
                set cols [lindex $dimensions 0]
                set rows [lindex $dimensions 1]

                set maxDepth [lindex $processedLines 2]

                for { set linIdx 3 } { $linIdx < $lineCount } { incr linIdx} {
                    set line [join [lindex $processedLines $linIdx] " "]
                    for {set pixIdx 0} { $pixIdx < [llength $line] } { incr pixIdx 3 } {
                        set r [lindex $line $pixIdx]
                        set g [lindex $line [expr { $pixIdx + 1 }]]
                        set b [lindex $line [expr { $pixIdx + 2 }]]

                        set rgbPix [RGB::Pixel new $r $g $b]
                        lappend data $rgbPix
                    }
                }
            }

            set ppmObj [PPM::Format new $cols $rows $depth $data]
            return $ppmObj
        }

        method Save { { filepath "output.ppm" }} {
            set fwrite [open $filepath w]

            puts $fwrite $imageFormat
            puts $fwrite "${cols}\t${rows}"
            puts $fwrite $depth

            for { set y 0 } { $y < $rows } { incr y } {
                for { set x 0 } { $x < $cols } { incr x } {
                    set idx [expr { $y * $cols + $x }]
                    set rgb [lindex $data $idx]
                    set r [$rgb GetRed]
                    set g [$rgb GetBlue]
                    set b [$rgb GetGreen]
                    puts -nonewline $fwrite "$r\t$g\t$b\t"
                }
                puts $fwrite ""
            }
            close $fwrite
        }
    }

    # Handle Exports
    oo::define Format {
        export SetWidth SetHeight SetMaxDepth SetPixelData
        export GetImageFormat GetWidth GetHeight GetMaxDepth GetPixelData
        export Load Save
    }
}