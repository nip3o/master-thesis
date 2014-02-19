require 'parser/current'

def main
  if ARGV.length < 1
    puts "Usage: "
    return
  end

  filename = ARGV[0]
  data = nil

  File.open(filename) do |f|
    data = f.read
  end

  parsed = Parser::CurrentRuby.parse(data)
  parsed.children.each { |e|
    puts e.children[2].to_sexp
    puts '=' * 40
  }
end

if __FILE__ == $0
  main
end
