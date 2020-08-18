class CoronavirusFindSupportFlow
  class << self
    def option_questions
      {
        feeling_unsafe: :feel_safe,
        paying_bills: :afford_rent_mortgage_bills,
        getting_food: :afford_food,
        being_unemployed: :self_employed,
        going_to_work: :worried_about_work,
        somewhere_to_live: :have_somewhere_to_live,
        mental_health: :mental_health_worries,
        not_sure: :nation,
      }
    end
  end

  delegate :option_questions, to: :class

  attr_reader :node_name, :session
  def initialize(node_name, session = {})
    @node_name = node_name.to_sym
    @session = session || {}
    state_machine.restore!(node_name)
  end

  def next_node
    state_machine.next_node
    state_machine.state
  end

  def state_machine
    @state_machine ||= FiniteMachine.new(self, alias_target: :flow) do
      initial :need_help_with

      event :next_node, {
        need_help_with: flow.next_group_start,
        feel_safe: flow.next_group_start,
        afford_rent_mortgage_bills: flow.next_group_start,
        afford_food: :get_food,
        get_food: flow.node_after_get_food,
        able_to_go_out: :self_employed,
        self_employed: flow.node_after_self_employed,
        have_you_been_made_unemployed: flow.node_after_have_you_been_made_unemployed,
        are_you_off_work_ill: flow.next_group_start,
        worried_about_work: flow.next_group_start,
        have_somewhere_to_live: :have_you_been_evicted,
        have_you_been_evicted: flow.next_group_start,
        mental_health_worries: :nation,
        nation: :results,
      }
    end
  end

  def has_node?
    state_machine.states.include?(node_name)
  end

  def node_after_get_food
    return next_group_start if session[:get_food] == "yes"

    :able_to_go_out
  end

  def node_after_self_employed
    return :worried_about_work if session[:self_employed] == "yes"

    :have_you_been_made_unemployed
  end

  def node_after_have_you_been_made_unemployed
    yes_answers = %w[yes_i_have_been_made_unemployed yes_i_have_been_put_on_furlough]
    return :worried_about_work if yes_answers.include?(session[:have_you_been_made_unemployed])

    :are_you_off_work_ill
  end

  def next_group_start
    return :need_help_with if session[:need_help_with].blank?
    return :nation if selected_group_starts_not_visited.empty?

    selected_group_starts_not_visited.first
  end

  def selected_group_starts_not_visited
    @selected_group_starts_not_visited ||= selected_group_starts - session.keys(&:to_sym)
  end

  def selected_group_starts
    session[:need_help_with].map { |option| option_questions[option.to_sym] }
  end
end
