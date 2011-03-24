require_relative 'Document'

if ARGV.size != 3
  puts '<bokiz file> <LaTeX header> <output directory for HTML/PDF data>'
  exit
end

markupPath = ARGV[0]
latexHeader = ARGV[1]
outputDirectory = ARGV[2]

document = Document.new(markupPath, outputDirectory)
document.generateOutput(latexHeader)
