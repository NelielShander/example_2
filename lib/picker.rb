require 'dry-struct'
require 'dry-monads'
require 'sorbet-runtime'

require_relative 'types'
require_relative 'picker/safe'

module Picker
  extend T::Sig

  module_function

  sig { params(arg0: Integer).returns(T.any(Array, String)) }
  def call(n = nil)
    n ||= rand(1..6)
    initial_state = random_handle_position(n)
    target_state = random_handle_position(n)
    restricted_combinations = (0...n).map { random_handle_position(n) }

    result = Safe.new(
      handles_number: n,
      initial_state:,
      target_state:,
      restricted_combinations:
    ).pick_combination

    if result.success?
      result.success
    else
      result.failure
    end
  end

  def random_handle_position(number)
    (0...number).map { rand(0..9) }
  end
end
