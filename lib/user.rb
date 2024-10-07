class User < Game # rubocop:disable Style/Documentation
  def initialize(name)
    @name = name
  end

  def apply_role(role)
    @code = ''
    @guess = ''
    @game_finished = false
    @red = 0
    @white = 0
  end

  attr_reader :name, :code, :guess, :game_finished, :red, :white

  def grade_guess(code, guess)
    return if guess.nil?

    puts 'Provide the results :'.colorize(mode: :underline)

    puts "#{'red'.colorize(color: :red, mode: :bold)} (right color, right spot)= "
    @red = gets.chomp.to_i

    puts "#{'white'.colorize(color: :white, mode: :bold)} (right color, wrong spot)= "
    @white = gets.chomp.to_i

    @game_finished = true if @red == 4
  end

  def get_guess(iteration, red, white, last_guess)
    puts "Guess #{(iteration + 1).to_s.colorize(mode: :bold)}"

    if iteration.zero?
      show_colors
    else
      puts "#{'Results :'.colorize(mode: :underline)}\n
      #{'red'.colorize(color: :red, mode: :bold)} (right color, right spot)= #{red}\n
      #{'white'.colorize(color: :white, mode: :bold)} (right color, wrong spot)= #{white}"
    end

    print_code(@guess = get_colors)
    @guess
  end

  private

  def show_colors
    puts ''
    puts 'Colors :'.colorize(mode: :underline)
    puts ''
    GUESS_COLORS.each_with_index do |color, index|
      puts "#{index + 1}\t#{CIRCLE.colorize(color: color)}\t#{color.to_s.colorize(color: color, mode: :bold)}"
    end
  end

  def get_colors
    puts ''
    puts "Enter the #{'4 numbers'.colorize(mode: :bold)} of your color code"

    @code = ''

    loop do
      if (@code = gets.chomp).length == 4 && @code.to_i.instance_of?(Integer) &&
         @code.chars.all? do |number|
           number.to_i in (1..6)
         end
        break
      else
        puts "The code must be #{'4 numbers'.colorize(mode: :bold)} between #{'1 and 6'.colorize(mode: :bold)}"
      end
    end

    @code
  end
end
