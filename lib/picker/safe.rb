require_relative 'handle'

module Picker
  class Safe < Dry::Struct
    extend T::Sig
    include Dry::Monads[:result]

    attribute :handles_number, Types::Integer.enum(*1..6)
    attribute :initial_state, Types::Array.of(Types::Integer.enum(*0..9))
    attribute :target_state, Types::Array.of(Types::Integer.enum(*0..9))
    attribute :restricted_combinations, Types::Array.of(Types::Array.of(Types::Integer.enum(*0..9)))

    def pick_combination
      print_initial

      return Failure('Изначальная комбинация есть в запрещенных.') if restricted_combinations.include?(initial_state)
      return Failure('Целевая комбинация есть в запрещенных.') if restricted_combinations.include?(target_state)

      result = turns

      if result.instance_of?(Dry::Monads::Failure)
        result
      else
        print_combination(result)
        Success(result)
      end

    rescue => e
      Failure(e.message)
    end

    private

    def handles
      @handles ||= (0...handles_number).map { |position| new_handle(position:, initial_state:, target_state:) }
    end

    def print_initial
      $stdout.puts "N = #{handles_number}"
      $stdout.puts "initial state = #{current_state}"
      $stdout.puts "target_state = #{target_state}"
      $stdout.puts 'restricted_combinations:'
      restricted_combinations.each { |combination| $stdout.puts combination.to_s }
    end

    sig { params(result: T::Array[Integer]).returns(NilClass) }
    def print_combination(result)
      $stdout.puts 'combinations:'
      result.each { |combination| $stdout.puts combination.to_s }
      nil
    end

    def turns
      handle_turns = handles.map(&:turns_to_target_state)
      positions = handle_turns.map { |turn| turn.size - 1 }
      combinations = [new_combination(handle_turns, positions)]

      (0...handles_number).reverse_each.map do |index|
        until positions[index].zero?
          positions[index] -= 1

          if restricted_combinations.include? new_combination(handle_turns, positions)
            return Failure('Невозможно подобрать комбинацию.') if (index - 1) < 0

            positions[index] += 1
            positions[index - 1] -= 1
          end

          combinations << new_combination(handle_turns, positions)
        end
      end

      combinations
    end

    def new_combination(handle_turns, positions)
      handle_turns.map.with_index do |handle_turn, index|
        handle_turn.reverse[positions[index]]
      end
    end

    sig { params(position: Integer, initial_state: Array, target_state: Array).returns(::Picker::Handle) }
    def new_handle(position:, initial_state:, target_state:)
      ::Picker::Handle.new(
        position:,
        state: initial_state[position],
        target_state: target_state[position]
      )
    end

    def current_state
      handles.map(&:state)
    end
  end
end
