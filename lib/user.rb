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

  def self.correct_number_input(number_length, integer_start, integer_end)
    number_input = ''
    loop do
      number_input = gets.chomp

      # Ensure the input is a valid number and has the correct length
      if number_input.length == number_length && number_input.to_i.to_s == number_input &&
         number_input.chars.all? { |digit| (integer_start.to_i..integer_end.to_i).cover?(digit.to_i) }
        break
      else
        puts "Each digit of the #{'number'.colorize(mode: :bold)} (of length #{number_length}) must be an integer
      #{"between #{integer_start} and #{integer_end}".colorize(mode: :bold)}"
      end
    end

    number_input.to_i
  end

  def grade_guess(code, guess)
    return if guess.nil?

    puts ''

    puts 'Provide the results :'.colorize(mode: :underline)

    puts "#{'red'.colorize(color: :red, mode: :bold)} (right color, right spot)= "
    @red = User.correct_number_input(1, 0, 4)

    puts "#{'white'.colorize(color: :white, mode: :bold)} (right color, wrong spot)= "
    @white = User.correct_number_input(1, 0, 4)

    @game_finished = true if @red == 4
  end

  def get_guess(iteration, red, white, last_guess)
    puts ''
    puts "Guess #{(iteration + 1).to_s.colorize(mode: :bold)}".colorize(mode: :underline)
    puts ''

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

  def get_colors
    puts ''
    puts "Enter the #{'4 numbers'.colorize(mode: :bold)} of your color code"

    @code = User.correct_number_input(4, 1, 6).to_s
  end
end
