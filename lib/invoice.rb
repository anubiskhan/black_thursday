require 'date'
require 'time'

# builds invoice class
class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at
  def initialize(hash, parent)
    @id          = hash[:id].to_i
    @customer_id = hash[:customer_id].to_i
    @merchant_id = hash[:merchant_id].to_i
    @status      = hash[:status].to_sym
    @created_at  = Time.parse(hash[:created_at])
    @updated_at  = Time.parse(hash[:updated_at])
    @parent      = parent
  end

  def merchant
    @parent.invoice_repo_finds_merchant_via_engine(merchant_id)
  end

  def items
    @parent.invoice_repo_finds_items_via_engine(id)
  end

  def customer
    @parent.invoice_repo_finds_customer_via_engine(customer_id)
  end

  def transactions
    @parent.invoice_repo_finds_transactions_via_engine(id)
  end

  def is_paid_in_full?
    @parent.invoice_repo_finds_transactions_and_evaluates_via_engine(id)
  end

  def total
    @parent.invoice_repo_finds_invoice_items_total_via_engine(id)
  end
end
