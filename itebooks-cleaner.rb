require 'rubygems'
require 'bundler/setup'

require 'origami'

pdf = Origami::PDF.read ARGV[0]

pdf.pages.each do |page|
  page[:Annots].each do |reference|
    annotation = pdf.get_object(reference)
    uri = annotation[:A][:URI] if annotation[:A]
    if uri == 'http://www.it-ebooks.info/'
      pdf.delete_object(reference)
      page[:Annots].delete(reference)
    end
  end

  page[:Contents].each do |reference|
    stream = pdf.get_object(reference)
    data = stream.data
    if data.include? '(www.it-ebooks.info)'
      pdf.delete_object(reference)
      page[:Contents].delete(reference)
    end
  end
end

filename = File.basename ARGV[0]
File.rename(filename, "#{filename}.bak") if File.exists? filename

pdf.save filename
