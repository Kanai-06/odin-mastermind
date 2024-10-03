# require_relative '../main'

class Bot < Game
  def apply_role(role)
    @role = role

    return unless @role == 'creator'

    @code = get_code
  end

  attr_reader :code

  private

  def get_code # rubocop:disable Naming/AccessorMethodName
    Array.new(4) { rand(1..6) }.join
  end
end
