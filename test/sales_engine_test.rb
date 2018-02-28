# frozen_string_literal: true

require_relative 'test_helper.rb'
require_relative '../lib/sales_engine.rb'
require_relative './test_engine.rb'

class SalesEngineTest < Minitest::Test
  def setup
    test_engine = TestEngine.new.test_hash
    @sales_engine = SalesEngine.from_csv(test_engine)
  end

  def test_sales_engine_initializes
    sales_engine = @sales_engine

    assert_instance_of SalesEngine, sales_engine
  end

  def test_sales_engine_has_merch_repo
    sales_engine = @sales_engine
    merchant_repo = sales_engine.merchants
    merchant = merchant_repo.find_by_name('Shopin1901')

    assert_instance_of MerchantRepository, merchant_repo
    assert_instance_of Merchant, merchant
    assert_equal 12_334_105, merchant.id
    assert_equal 'Shopin1901', merchant.name
  end

  def test_sales_engine_has_item_repo
    sales_engine = @sales_engine
    item_repo = sales_engine.items
    item = item_repo.find_by_name('Glitter scrabble frames')

    assert_instance_of ItemRepository, item_repo
    assert_instance_of Item, item
    assert_equal 263_395_617, item.id
    assert_equal 'Glitter scrabble frames', item.name
  end

  def test_sales_engine_has_invoice_repo
    sales_engine = @sales_engine
    invoice_repo = sales_engine.invoices
    invoice = invoice_repo.find_by_id(1)

    assert_instance_of InvoiceRepository, invoice_repo
    assert_instance_of Invoice, invoice
    assert_equal 1, invoice.id
  end

  def test_merchant_items_returns_items_array
    sales_engine = @sales_engine

    merchant = sales_engine.merchants.find_by_id(12_334_141)
    merchant.items

    assert_equal 1, merchant.items.count
    assert_equal '510+ RealPush Icon Set', merchant.items[0].name
  end

  def test_item_merchant_returns_merchant_instance
    sales_engine = @sales_engine

    item = sales_engine.items.find_by_id(263_395_237)
    item.merchant

    assert_equal 'jejum', item.merchant.name
  end

  def test_engine_finds_merchant_via_merch_repo
    result = @sales_engine.engine_finds_merchant_via_merchant_repo(12_334_105)

    assert_instance_of Merchant, result
  end

  def test_engine_finds_merchant_customers_via_invoice_repo
    result = @sales_engine.engine_finds_merchant_customers_via_invoice_repo(12_335_955)

    assert_equal 2, result.length
    assert_instance_of Customer, result[0]
  end

  def test_engine_finds_customer_merchants_via_invoice_repo
    result = @sales_engine.engine_finds_customer_merchants_via_invoice_repo(1)

    assert_equal 4, result.length
    assert_instance_of Merchant, result[0]
  end

  def test_engine_finds_paid_invoice_and_returns_cost
    result = @sales_engine.engine_finds_paid_invoice_and_evaluates_cost(46)
    unpaid = @sales_engine.engine_finds_paid_invoice_and_evaluates_cost(14)

    assert_equal BigDecimal.new(986.68, 5), result
    assert_nil unpaid
  end

  def test_engine_can_find_invoice_using_id_passed_by_tran_repo
    result = @sales_engine.engine_finds_invoice_via_invoice_id(18)

    assert_equal 18, result.id
    assert_equal 5, result.customer_id
    assert_equal 12_334_271, result.merchant_id
    assert_equal :shipped, result.status
  end

  def test_engine_can_find_transaction_using_invoice_id_passed_from_inv_repo
    result = @sales_engine.engine_finds_transactions_via_invoice_id(2779)

    assert_equal 19, result[0].id
    assert_equal 4_318_767_847_968_505, result[0].credit_card_number
  end
end
