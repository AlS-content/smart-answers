class QuestionWithOptionsPresenter < QuestionPresenter
  def options
    @node.options.map { |option_key| option_attributes(option_key) }
  end

  def option_attributes(key)
    option = @renderer.option(key.to_sym)

    if option.is_a?(String)
      { label: option, value: key }
    else
      option.merge({ value: key })
    end
  end
end
