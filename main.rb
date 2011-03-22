require 'nil/file'

class Node
  attr_reader :name, :arguments, :content

  def initialize(name, arguments, content)
    @name = name
    @arguments = arguments
    @content = content
  end
end

class Document
  def initialize(path)
    loadDocument(path)
  end

  def loadDocument(path)
    @markup = Nil.readFile(path)
    raise 'Unable to open file' if @markup == nil
    @offset = 0
    @line = 1
    return parseDocument
  end

  def error(message)
    raise "Error on line #{@line}: #{message}"
  end

  def getInput
    return markup[@offset]
  end

  def parseDocument
    contents = []
    currentString = ''
    while @offset < @markup.size
      input = getInput
      case input
      when '['
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
        content = parseDocument
        contents << Element.new(name, arguments, content)
        next
      when ']'
        advance
        break
      when "\n"
        @line += 1
        currentString += input
      when '@'
        advance
        currentString += getInput
      else
        currentString += input
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
