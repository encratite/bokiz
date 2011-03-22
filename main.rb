require 'nil/file'

require_relative 'functions'

class Document
  attr_writer :sections

  def initialize(path)
    initialiseFunctions
    loadDocument(path)
  end

  def loadDocument(path)
    @markup = Nil.readFile(path)
    raise 'Unable to open file' if @markup == nil
    @offset = 0
    @line = 1
    @sections = []
    return parseDocument
  end

  def initialiseFunctions
    @functions = {
      'bold' => BoldText,
      'section' => SectionFunction,
      'subsection' => SubsectionFunction,
      'subsubsection' => SubsubsectionFunction,
      'paragraph' => Paragraph,
    }
  end

  def error(message)
    raise "Error on line #{@line}: #{message}"
  end

  def getInput
    return markup[@offset]
  end

  def parseDocument(isCode = false)
    contents = []
    currentString = ''
    while @offset < @markup.size
      input = getInput
      addString = lambda { currentString += input }
      case input
      when '['
        if isCode
          addString.call
          advance
          next
        end
        if !currentString.empty?
          contents << currentString
          currentString = ''
        end
        noArgumentsPattern = /\[([a-z]+?)[ \n]/
        argumentsPattern = /\[([a-z]+?)\[(.+?)\][ \n]/
        arguments = nil
        match = input.match(noArgumentsPattern)
        if match == nil
          match = input.match(argumentsPattern)
          if match == nil
            error 'Unable to parse the name of a function'
          end
          arguments = match[2]
        end
        name = match[1]
        @offset += match[0].size
        functionClass = @functions[name]
        if functionClass == nil
          error "Invalid node name: #{node}"
        end
        node = functionClass.new(this, arguments)
        node.children = parseDocument(node.isCode)
        contents << node if node.isPrintable
        next
      when ']'
        if isCode && markup[@offset - 1] != "\n"
          #encountered a non-terminal end of scope tag within a code segment
          #treat it like a regular string and continue parsing
          addString.call
          advance
          next
        end
        advance
        break
      when "\n"
        @line += 1
        addString.call
      when '@'
        #escape sequence so one can print []@ without messing up the parsing the process
        advance
        currentString += getInput
      else
        addString.call
      end
      advance
    end
    if !currentString.empty?
      contents << currentString
    end
    return contents
  end

  def advance
    @offset += 1
  end
end
