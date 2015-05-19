# coding:utf-8

require_relative '../test_helper'
require 'ostruct'

module SmartAnswer
  class ValueQuestionTest < ActiveSupport::TestCase
    setup do
      @initial_state = State.new(:example)
    end

    should "save value as a String by default" do
      q = Question::Value.new(:example) do
        save_input_as :myval
        next_node :done
      end

      new_state = q.transition(@initial_state, "123")
      assert_equal '123', new_state.myval
    end

    context "when parse option is Integer" do
      setup do
        @q = Question::Value.new(:example, parse: Integer) do
          save_input_as :myval
          next_node :done
        end
      end

      should "save integer value as an Integer" do
        new_state = @q.transition(@initial_state, "123")
        assert_equal 123, new_state.myval
      end

      should "raise ArgumentError for non-integer value" do
        assert_raises(ArgumentError) { @q.transition(@initial_state, "1.5") }
      end

      should "raise ArgumentError for blank value" do
        assert_raises(ArgumentError) { @q.transition(@initial_state, "") }
      end
    end

    context "when parse option is :to_i" do
      setup do
        @q = Question::Value.new(:example, parse: :to_i) do
          save_input_as :myval
          next_node :done
        end
      end

      should "save valid value as an Integer" do
        new_state = @q.transition(@initial_state, "123")
        assert_equal 123, new_state.myval
      end

      should "save non-integer value as an Integer" do
        new_state = @q.transition(@initial_state, "1.23")
        assert_equal 1, new_state.myval
      end

      should "save blank value as zero" do
        new_state = @q.transition(@initial_state, "")
        assert_equal 0, new_state.myval
      end
    end

    should "save value as a String if parse option specifies unknown type" do
      q = Question::Value.new(:example, parse: Float) do
        save_input_as :myval
        next_node :done
      end

      new_state = q.transition(@initial_state, "123")
      assert_equal '123', new_state.myval
    end
  end
end
