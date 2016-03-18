require 'securerandom'
require 'prawn'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

include Prawn::Measurements #for in2pt methods

numtix = {
  adult: 2850,
  teen: 75,
  kid: 50,
  child: 25
}
prices = {
  adult: 111,
  teen: 111,
  kid: 33,
  child: 0
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

a_tnums = Array (1..numtix[:adult]).collect{ |n| sprintf 'A%04d', n}
t_tnums = Array (1..numtix[:teen]).collect{ |n| sprintf 'T%04d', n}
k_tnums = Array (1..numtix[:kid]).collect{ |n| sprintf 'K%04d', n}
c_tnums = Array (1..numtix[:child]).collect{ |n| sprintf 'C%04d', n}
ticketnums = a_tnums + t_tnums + k_tnums + c_tnums

ticketnums.each do |number|
  secret = SecureRandom.hex(3).upcase
  case number[0,1]
  when "A"
    price = prices[:adult]
  when "T"
    price = prices[:teen]
  when "K"
    price = prices[:kid]
  when "C"
    price = prices[:child]
  end

  barcode = Barby::Code128.new("#{number} #{secret}")
  bc_out = Barby::PrawnOutputter.new(barcode)

  bc_out.height = in2pt(0.2)

  # if changing ticket height or width you may also want to modify the barcode placement
  bc_place = {
    :x => 10,
    :y => 21,
    :xdim => 0.8,
    :margin => 5
  }
  bc_out.annotate_pdf(pdf, bc_place )

  codez_txt.write("#{number} #{secret}\n")

  pdf.text_box "#{number} #{secret}", :at => [10,61], :size=>9, :character_spacing=>1, :align=>:center
  pdf.text_box "#{number} #{secret} $#{price}", :at => [10,19], :size=>9, :character_spacing=>1, :align=>:center

  pdf.start_new_page unless number == ticketnums.last
end

codez_txt.close
pdf.render_file 'outputfile.pdf'
