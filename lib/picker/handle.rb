module Picker
  class Handle < Dry::Struct
    extend T::Sig

    attribute :position, Types::Integer.enum(*0..5)
    attribute :target_state, Types::Integer.enum(*0..9)
    attribute :state, Types::Integer.enum(*0..9)

    def turns_to_target_state
      turns = turns_to(target_state)
      if turns[:right].size <= turns[:left].size
        turns[:right]
      else
        turns[:left]
      end
    end

    sig { params(new_state: Integer).returns(T::Hash[Symbol, T::Array[Integer]]) }
    def turns_to(new_state)
      turns = {left: [state], right: [state]}

      initial_state = state
      while initial_state != new_state
        initial_state = right_position_from(initial_state)
        turns[:right] << initial_state
      end

      initial_state = state
      while initial_state != new_state
        initial_state = left_position_from(initial_state)
        turns[:left] << initial_state
      end

      turns
    end

    sig { params(position: Integer).returns(Integer) }
    def right_position_from(position)
      (position == 9) ? 0 : position + 1
    end

    sig { params(position: Integer).returns(Integer) }
    def left_position_from(position)
      (position == 0) ? 9 : position - 1
    end
  end
end
