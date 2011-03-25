require 'fileutils'
require 'tempfile'

require 'nil/file'

module LaTeX
  MathIntro = <<EOF
\\documentclass{article}
\\usepackage{amsmath}
\\usepackage{amsthm}
\\usepackage{amssymb}
\\pagestyle{empty}
\\begin{document}
\\begin{equation*}
EOF

  MathOutro = <<EOF

\\end{equation*}
\\end{document}
EOF

  def self.generateImage(latex, temporaryDirectory, outputPath)
    base = 'image'
    latexPath = Nil.joinPaths(temporaryDirectory, "#{base}.tex")
    imagePath = Nil.joinPaths(temporaryDirectory, "#{base}.png")
    FileUtils.mkdir_p(temporaryDirectory)
    latex = MathIntro + latex + MathOutro
    Nil.writeFile(latexPath, latex)
    latexCommand = "latex --src -interaction=nonstopmode #{latexPath} -output-directory #{temporaryDirectory}";
    dvipngCommand = "dvipng -gamma 1.5 -T tight -D 120 -bg Transparent -o #{imagePath} #{Nil.joinPaths(temporaryDirectory, base)}"
    #puts latexCommand
    `#{latexCommand}`
    #puts dvipngCommand
    `#{dvipngCommand}`
    FileUtils.mkdir_p(File.dirname(outputPath))
    FileUtils.move(imagePath, outputPath)
    filenames = ['aux', 'dvi', 'log', 'tex'].map { |x| "#{base}.#{x}" }
    filenames << 'texput.log'
    filenames.each do |name|
      FileUtils.rm_f(Nil.joinPaths(temporaryDirectory, name))
    end
  end
end
