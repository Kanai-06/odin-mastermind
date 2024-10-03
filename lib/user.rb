# require_relative '../main'

class User < Game # rubocop:disable Style/Documentation
  def initialize(name)
    @name = name
  end

  def apply_role(role)
    @role = role

    return unless @role == 'creator'

    @code = get_code
  end

  attr_reader :code

  private

  def get_code
    # Show colors

    puts ''
    puts 'Colors :'.colorize(mode: :underline)
    puts ''
    GUESS_COLORS.each_with_index do |color, index|
      puts "#{index + 1}\t#{CIRCLE.colorize(color: color)}\t#{color.to_s.colorize(color: color, mode: :bold)}"
    end

    # Ask user for colors
    puts ''
    puts "Enter the #{'4 numbers'.colorize(mode: :bold)} of your color code"

    code = ''

    loop do
      if (code = gets.chomp).length == 4 && code.to_i.instance_of?(Integer) &&
         code.chars.all? do |number|
           number.to_i in (1..6)
         end
        break
      else
        puts "The code must be #{'4 numbers'.colorize(mode: :bold)} between #{'1 and 6'.colorize(mode: :bold)}"
      end
    end

    print_code(code)
    code
  end
end
