# frozen_string_literal: true

module AttendeeFieldsHelper
  def example_custom_field(field, form)
    case field.kind
    when 'text'
      form.text_field field.name, readonly: true, value: field.kind
    when 'multiline'
      form.text_area field.name, readonly: true, value: field.kind
    when 'email'
      form.email_field field.name, readonly: true, value: field.kind
    when 'multiselect'
      form.select field.name, field.options
    end
  end

  def custom_field(field, form, value = nil)
    value ||= ''
    case field.kind
    when 'text'
      form.text_field field.name, value: value
    when 'multiline'
      form.text_area field.name, value: value
    when 'email'
      form.email_field field.name, value: value
    when 'multiselect'
      form.select field.name, value
    end
  end
end