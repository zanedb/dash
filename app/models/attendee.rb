# frozen_string_literal: true

require 'csv'
require 'prawn'
require 'net/http'

class Attendee < ApplicationRecord
  include SearchCop
  extend FriendlyId

  search_scope :search do
    attributes %i[first_name last_name], :email
    # attributes :fields
  end

  default_scope { order(created_at: :desc) }

  scope :checked_in, -> { where.not(checked_in_at: nil) }
  scope :checked_in_and_out, -> { where.not(checked_in_at: nil, checked_out_at: nil) }

  belongs_to :event, touch: true

  has_many :fields, through: :values, class_name: 'AttendeeField'
  has_many :values, class_name: 'AttendeeFieldValue', dependent: :destroy
  has_one :attendee_waiver, dependent: :destroy
  accepts_nested_attributes_for :values

  validates_presence_of :first_name, :last_name, :email
  validates_email_format_of :email

  before_create :generate_public_id

  # todo: make good
  after_create :set_fields_create
  after_create :make_waiver
  after_create :handle_webhooks

  after_update :set_fields_update
  
  friendly_id :slug_candidates, use: :scoped, scope: :event
  def slug_candidates
    [
      %i[first_name last_name]
    ]
  end

  CORE_PARAMS = %i[first_name last_name email note created_at checked_in_at checked_out_at].freeze

  def set_attendee_params(attendee_params)
    @attendee_params = attendee_params
  end

  def generate_public_id
    self.public_id = loop do
      random_id = make_public_id
      break random_id unless Attendee.exists?(public_id: random_id)
    end
  end

  def make_public_id
    6.times.map { rand(6) }.join
  end

  # returns an object containing all attendee data
  def attrs
    attributes.to_h.slice(*CORE_PARAMS.map(&:to_s)).merge(field_values)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def field_values
    data = {}
    values.each do |value|
      data[value.field.name] = value.content
    end
    data
  end

  def field_for(name)
    fields.where(name: name)
  end

  def set_fields_create
    fields = self.event.fields

    fields.each do |field|
      self.values.create!(field: field, content: @attendee_params[field.name])
    end
  end

  def set_fields_update
    fields = self.event.fields

    fields.each do |field|
      if @attendee_params
        field.value_for(self).update(content: @attendee_params[field.name])
      end
    end
  end

  def handle_webhooks
    if event.webhooks.any?
      event.webhooks.each do |webhook|
        case webhook.request_type
        when 'GET'
          HTTParty.get(webhook.url)
        when 'POST'
          HTTParty.post(webhook.url, body: { attendee: attrs })
        end
      end
    end
  end

  def make_waiver
    if event.waiver.file.attached? && attendee_waiver.nil?
      build_attendee_waiver(waiver: event.waiver).save(validate: false)
    end
  end

  def waiver_pdf
    return unless event.waiver.file.attached?
    info_pdf = Prawn::Document.new
    info_pdf.text_box "ID: #{public_id}"

    attendee_info = CombinePDF.parse(info_pdf.render).pages[0]
    pdf = CombinePDF.parse Net::HTTP.get_response(URI.parse(event.waiver.file.service_url)).body
    pdf.pages.each { |page| page << attendee_info }
    pdf.to_pdf
  end

  def checked_out?
    checked_out_at.present?
  end

  def checked_in?
    checked_in_at.present?
  end

  def checked_out_by
    User.find(checked_out_by_id)
  end

  def checked_in_by
    User.find(checked_in_by_id)
  end

  def both?
    checked_out? && checked_in?
  end

  def self.checked_in_total
    all.checked_in.count
  end

  def self.checked_in_and_out_total
    all.checked_in_and_out.count
  end

  def self.as_csv
    CSV.generate do |csv|
      keys = CORE_PARAMS.map(&:to_s) + all.first.field_values.keys
      csv << keys
      all.each do |item|
        csv << item.attrs.values
      end
    end
  end

  def self.import_csv(file, event)
    CSV.foreach(file.path, headers: true) do |row|
      row = row.to_h
      core_keys = CORE_PARAMS.map(&:to_s)
      # Create attendee record with core params
      record = event.attendees.create(row.slice(*core_keys))
      # Save custom field values for attendee
      row.except(*core_keys).each do |name, value|
        field = event.fields.where(name: name).first
        record.values.create!(field: field, content: value.to_s)
      end
    end
  end
end
