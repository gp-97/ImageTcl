# set the current directory
set imageDir [pwd]

pkg_mkIndex -verbose [file join $imageDir] . lib/*/*.tcl