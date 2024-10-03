require 'bundler/setup'
Bundler.require(:default)

CIRCLE = '⬤'.freeze

GUESS_COLORS = %i[
  cyan
  green
  yellow
  blue
  magenta
  grey
].freeze

GRADE_COLORS = %i[
  red
  white
].freeze

class Game
  def start_game
    give_roles(create_user, Bot.new)
  end

  private

  private_constant :User, :Bot

  def give_roles(user, bot)
    puts 'Do you want to be the creator (enter 0) or the guesser (enter 1)'
    user_role_index = valid_input(0, 1)

    @creator = (if user_role_index == 0
                  user.apply_role('creator')
                  user
                else
                  bot.apply_role 'creator'
                  bot
                end)
    @guesser = (if user_role_index == 1
                  user.apply_role('guesser')
                  user
                else
                  bot.apply_role 'guesser'
                  bot
                end)
    nil
  end

  def create_user
    puts 'What is your name'
    name = gets.chomp

    User.new(name)
  end

  def valid_input(start_input, end_input)
    until (start_input..end_input).cover?(user_input = gets.chomp.to_i)
      puts "Input value must be between #{start_input} and #{end_input}"
    end

    user_input
  end

  def print_code(code) # rubocop:disable Metrics/AbcSize
    puts(code.chars.reduce('') do |string, char|
      "#{string}   #{char} #{' ' * GUESS_COLORS[char.to_i - 1].length}"
    end)
    puts(code.chars.reduce('') do |string, char|
      "#{string}   #{CIRCLE.colorize(color: GUESS_COLORS[char.to_i - 1])} #{GUESS_COLORS[char.to_i - 1]}"
    end)
  end
end

require_relative 'lib/user'
require_relative 'lib/bot'
