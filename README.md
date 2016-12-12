# fpga-hash-breaker
fpga implementation of md5 hash algorithm with stuff to brute force passwords

Now supports normal 2005 verilog! no longer requires systemverilog.

# Requirements/Features:

Not done yet but I'm aiming for minimal LAB useage. Hopefully a couple hash-cores can fit on a smaller FPGA. I'm writing this for a de1-soc and de0-cv dev boards by TerAsic.

Should operate up to 100MHz hopefully.

Uses an unrolled MD5 algorithm. It takes a little over 64 cycles to crack a hash, but you can feed 1 in per cycle, so hopefully 100 Megahashes/s. If the core is small enough, I'll be able to fit two cores on and double that.

# How to run:
I've been simulating with iverilog and gtkwave, and programming it with Quartus.
