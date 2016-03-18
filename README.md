# Barcode File generator

This code is what's been used to generate barcodes for ticket variable printing
first used in 2015

### install / configure
```
git clone https://gitlab.com/BurningFlipside/BarCodez.git
cd BarCodez
bundle install
```

### Modify ticket numbers

open make_bars.rb and modify the following hash
```
numtix = {
  adult: 2850,
  teen: 75,
  kid: 50,
  child: 25
}
```

### Modify ticket prices

open make_bars.rb and modify the following hash
```
prices = {
  adult: 111,
  teen: 111,
  kid: 33,
  child: 0
}
```

### Modify ticket size

open make_bars.rb and modify the following lines
```
ticket_height = in2pt(4.88) # height in inches
ticket_width = in2pt(2.13) # width in inches

# if changing ticket height or width you may also want to modify the barcode placement
bc_place = {
  :x => 10,
  :y => 21,
  :xdim => 0.8,
  :margin => 5
}
```

### generate the barcodes
```
ruby make_bars.rb
```

### output files
* outputfile.pdf - this is the file to deliver to the printer
* ticket_codez.txt - this file contains the map of ticket number to ticket short code
