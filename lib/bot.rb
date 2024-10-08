class Bot < Game
  def apply_role(role)
    @role = role
    if @role == 'guesser'
      @possible_codes = []

      (1..6).each do |i|
        string = '    '
        string[0] = i.to_s

        (1..6).each do |j|
          string[1] = j.to_s

          (1..6).each do |k|
            string[2] = k.to_s

            (1..6).each do |l|
              string[3] = l.to_s

              @possible_codes.push(String.new(string))
            end
          end
        end
      end
    end

    if @role == 'creator' # rubocop:disable Style/GuardClause

      @code = Array.new(4) { rand(1..6) }.join
      @game_finished = false
      @red = 0
      @white = 0
    end
  end

  attr_reader :code, :guess, :game_finished, :red, :white

  def grade_guess(code, guess)
    @red = 0
    @white = 0

    guess.chars.each_with_index do |number, index|
      if number == code[index]
        code = code.sub(number, ' ')
        @red += 1
      elsif code.include?(number)
        code = code.sub(number, ' ')
        @white += 1
      end
    end

    @game_finished = true if @red == 4

    [@red, @white]
  end

  def get_guess(iteration, red, white, last_guess)
    show_colors if iteration.zero?

    puts ''
    puts "Guess #{(iteration + 1).to_s.colorize(mode: :bold)}".colorize(mode: :underline)
    puts ''

    if iteration.zero?
      @guess = '1122'
    else
      @possible_codes.delete(last_guess)
      @possible_codes.each do |code|
        @possible_codes.delete(code) unless grade_guess(code, last_guess) == [red, white]
      end

      puts "Possible codes : #{@possible_codes.length}"

      @guess = @possible_codes.length > 1 ? @possible_codes[rand(@possible_codes.length)] : @possible_codes[0]
    end

    if @possible_codes.empty?
      puts 'No possible codes left ! You must have done an error on your grading try again'
      return nil
    end

    print_code(@guess)
    @guess
  end
end
