module SmartAnswer
  class ChildBenefitTaxCalculatorFlow < Flow
    def define
      name 'child-benefit-tax-calculator'
      start_page_content_id "201fff60-1cad-4d91-a5bf-d7754b866b87"
      flow_content_id "26f5df1d-2d73-4abc-85f7-c09c73332693"
      status :draft

      # Q1
      multiple_choice :how_many_children? do
        option :"1"
        option :"2"
        option :"3"
        option :"4"
        option :"5"
        option :"6"
        option :"7"
        option :"8"
        option :"9"
        option :"10"

        save_input_as :children_count

        next_node do
          question :which_tax_year?
        end
      end

      # Q2
      multiple_choice :which_tax_year? do
        option :"2012"
        option :"2013"
        option :"2014"
        option :"2015"
        option :"2016"
        option :"2017"
        option :"2018"
        option :"2019"
        option :"2020"

        save_input_as :year

        next_node do
          question :claim_part_year?
        end
      end

      # Q3
      multiple_choice :claim_part_year? do
        option :"yes"
        option :"no"

        save_input_as :claim_part_year

        next_node do |response|
          if response == "yes"
            question :how_many_children_part_year?
          else
            question :income_details
          end
        end
      end

      # Q3a
      multiple_choice :how_many_children_part_year? do
        option :"1"
        option :"2"
        option :"3"
        option :"4"
        option :"5"
        option :"6"
        option :"7"
        option :"8"
        option :"9"
        option :"10"

        save_input_as :part_year_children_count

        next_node do |response|
          question :starting_children
        end
      end

      # outcome :outcome_1
    end
  end
end