# Barcode File generator

This code is what's been used to generate barcodes for ticket variable printing.

It will generate a list of ticket numbers following the format
* AXXXX for adult tickets
* TXXXX for teen tickets
* KXXXX for kid tickets
* CXXXX for child tickets

Ticket numbers are then paired with a randomly generated 6 character short code.

Outputs two files, see below.


### install / configure
```
git clone https://gitlab.com/BurningFlipside/BarCodez.git
cd BarCodez
bundle install
```

### Modify ticket numbers or prices

open make_bars.rb and modify the following hash
```
# define tickets numbers, prices, and code prefix
tix = {
  adult: {
    code: 'A',
    count: 2850,
    price: 111
  },
  teen: {
    code: 'T',
    count: 75,
    price: 111
  },
  kid: {
    code: 'K',
    count: 50,
    price: 33
  },
  child: {
    code: 'C',
    count: 25,
    price: 0
  }
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
