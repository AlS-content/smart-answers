module CoronavirusFindSupport
  class NeedHelpWithForm < Form
    answer_flow :coronavirus_find_support
    answer_node :need_help_with

    attr_accessor :need_help_with

    validates :need_help_with,
              presence: { message: "Select what you need to find help with, or ‘Not sure’" },
              valid_options: true

    def options
      {
        feeling_unsafe: "Feeling unsafe where you live, or being worried about someone else",
        paying_bills: "Paying bills",
        getting_food: "Getting food",
        being_unemployed: "Being unemployed or not having any work",
        going_to_work: "Going in to work",
        somewhere_to_live: "Having somewhere to live",
        mental_health: "Mental health and wellbeing",
        not_sure: "I'm not sure",
      }
    end
  end
end
