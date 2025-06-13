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

    @possible_codes_2 = @possible_codes.clone

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
      @possible_codes_2.delete(last_guess)
      @possible_codes.each do |code|
        @possible_codes.delete(code) unless grade_guess(code, last_guess) == [red, white]
      end

      puts "Possible codes : #{@possible_codes.length}"

      @guess = next_guess
    end

    if @possible_codes.empty?
      puts 'No possible codes left ! You must have done an error on your grading try again'
      return nil
    end

    print_code(@guess)
    @guess
  end

  def grade_guess_test(code, guess)
    red = 0
    white = 0

    guess.chars.each_with_index do |number, index|
      if number == code[index]
        code = code.sub(number, ' ')
        red += 1
      elsif code.include?(number)
        code = code.sub(number, ' ')
        white += 1
      end
    end

    [red, white]
  end

  def next_guess
    scores = @possible_codes_2.map { |guess| guess_score(guess) }
    max_scores = scores.each_index.select do |index|
      scores[index] == scores.max && @possible_codes.include?(@possible_codes_2[index])
    end
    return @possible_codes_2[scores.find_index(scores.max)] if max_scores.empty?

    @possible_codes_2[max_scores[0]]
  end

  def guess_score(guess)
    scores = []

    (0..3).each do |i|
      (0..4).each do |j|
        score = 0
        @possible_codes.each { |code| score += 1 if grade_guess_test(guess, code) != [i, j] }
        scores.push(score)
      end
    end

    scores.min
  end
end
