# frozen_string_literal: true

require 'csv'
require_relative 'merchant.rb'

# builds merchant repository class
class MerchantRepository
  def initialize(file_path, parent)
    @merchants = []
    @parent = parent
    load_merchants(file_path)
  end

  def all
    @merchants
  end

  def load_merchants(file_path)
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |data|
      @merchants.push(Merchant.new(data, self))
    end
  end

  def find_by_id(id_num)
    @merchants.find do |merchant|
      merchant.id == id_num
    end
  end

  def find_by_name(merch_name)
    @merchants.find do |merchant|
      merchant.name.downcase == merch_name.downcase
    end
  end

  def find_all_by_name(string)
    @merchants.find_all do |merchant|
      merchant.name.downcase.include?(string.downcase)
    end
  end

  def merch_repo_find_items_via_engine(id)
    @parent.engine_finds_all_merchants_via_item_repo(id)
  end

  def merch_repo_finds_invoices_via_engine(id)
    @parent.engine_finds_invoices_via_invoice_repo(id)
  end

  def merch_repo_finds_customers_via_engine(id)
    @parent.engine_finds_merchant_customers_via_invoice_repo(id)
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
