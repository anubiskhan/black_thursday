# frozen_string_literal: true

require 'bigdecimal'
require 'time'

# builds the customer class
class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at
  def initialize(data, parent)
    @id         = data[:id].to_i
    @first_name = data[:first_name]
    @last_name  = data[:last_name]
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @parent     = parent
  end

  def merchants
    @parent.customer_repo_finds_merchants_via_engine(id)
  end
end
