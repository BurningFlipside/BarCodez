require 'securerandom'
require 'prawn'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

include Prawn::Measurements #for in2pt methods

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

ticket_height = in2pt(4.88) # height in inches
ticket_width = in2pt(2.13) # width in inches

codez_txt = File.new("ticket_codez.txt",  "w+")
codez_txt.truncate(0) # empty the file

pdf_opts = {
  :page_size => [ticket_width, ticket_height],
  :margin => [0, 0] # [top/bottom, [left/right]]
}
pdf = Prawn::Document.new(pdf_opts)
pdf.font 'Helvetica'

# generate hash of ticket data
tickets = {}
tix.each do |k, v|
  tickets[k.to_sym]=[];
  (1..v[:count]).each do |n|
    tickets[k.to_sym][n] = {
      number: (sprintf "#{v[:code]}%04d", n),
      code: SecureRandom.hex(3).upcase,
      price: v[:price]
    }
  end
end

# iterate ticket data and generate pdf document
tickets.each do |type, block|

  puts "Generating #{type.capitalize} tickets"

  block.each do |ticket|
    next if ticket.nil?
    puts ticket

    bc = Barby::Code128.new("#{ticket[:number]} #{ticket[:code]}")
    bc_out = Barby::PrawnOutputter.new(bc)
    bc_out.height = in2pt(0.2)

    # if changing ticket height or width you may also want to modify the barcode placement
    bc_place = {
      :x => 10,
      :y => 21,
      :xdim => 0.8,
      :margin => 5
    }
    bc_out.annotate_pdf(pdf, bc_place )

    codez_txt.write("#{ticket[:number]} #{ticket[:code]}\n")

    pdf.text_box "#{ticket[:number]} #{ticket[:code]}",
      :at => [10,61], :size=>9, :character_spacing=>1, :align=>:center
    pdf.text_box "#{ticket[:number]} #{ticket[:code]} $#{ticket[:price]}",
      :at => [10,19], :size=>9, :character_spacing=>1, :align=>:center

    pdf.start_new_page
  end
end

codez_txt.close
pdf.render_file 'outputfile.pdf'
