module GlucometerBsls::Contract
  class Create < Reform::Form
    EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

    property :email
    property :mmol
    property :date

    validation :default do
      required(:email).filled(format?: EMAIL_FORMAT)
      required(:date).filled(:date_time?)
      required(:mmol).filled(:float?)
    end
  end
end
  