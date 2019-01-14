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

  validates_presence_of :first_name, :last_name, :email
  validates_email_format_of :email
  validates :public_id,
            presence: true,
            length: { minimum: 2 },
            uniqueness: true

  before_validation :generate_public_id,
                    on: :create
  after_validation :regenerate_public_id,
                   on: :create,
                   if: proc { |object| object.errors.any? }

  friendly_id :slug_candidates, use: :scoped, scope: :event
  def slug_candidates
    [
      %i[first_name last_name]
    ]
  end

  CORE_PARAMS = %i[first_name last_name email note created_at checked_in_at checked_out_at].freeze

  def generate_public_id
    update_attribute(:public_id, make_public_id)
  end
  alias regenerate_public_id generate_public_id

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
