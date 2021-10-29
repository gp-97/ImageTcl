package provide image 1.0
package require Tcl 8.6

namespace eval RGB {
    oo::class create Pixel

    oo::define Pixel {
        variable red green blue

        constructor { r g b } {
            set red $r
            set green $g
            set blue $b
        }
    }

    # RGB setters and getters member functions
    oo::define Pixel {
        method SetRed { r } {
            set red $r
        }
        method SetGreen { g } {
            set green $g
        }
        method SetBlue { b } {
            set blue $b
        }
        method SetRGB { r g b } {
            set red $r
            set green $g
            set blue $b
        }

        method GetRed {} {
            return $red
        }
        method GetGreen {} {
            return $green
        }
        method GetBlue {} {
            return $blue
        }
        method GetRGB {} {
            return [list $red $green $blue]
        }
    }

    # RGB class description
    oo::define Pixel {
        method ToString {} {
            set str "RGB Pixel:\n{\n\tred: $red\n\tgreen: $green\n\tblue: $blue\n}"
            return $str
        }
    }

    # Exports
    oo::define Pixel {
        export ToString
        export SetRed SetGreen SetBlue SetRGB
        export GetRed GetGreen GetBlue GetRGB
    }

}