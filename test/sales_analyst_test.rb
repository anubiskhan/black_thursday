# frozen_string_literal: true

require 'bigdecimal'
require_relative 'test_helper.rb'
require_relative './test_engine.rb'
require_relative '../lib/sales_analyst.rb'
require_relative '../lib/sales_engine.rb'

class SalesAnalystTest < Minitest::Test
  def setup
    test_engine = TestEngine.new.test_hash
    @sales_engine = SalesEngine.new(test_engine)
    @sales_analyst = SalesAnalyst.new(@sales_engine)
  end

  def test_analyst_initializes
    assert_instance_of SalesAnalyst, @sales_analyst
  end

  def test_item_collect_helper_method_works
    result = @sales_analyst.item_collector

    assert_instance_of Array, result
    assert (result.all? { |item| item.is_a?(Item)})
  end

  def test_can_return_average_items_per_merchant
    result = @sales_analyst.average_items_per_merchant

    assert_equal 0.9, result
  end

  def test_standard_deviation_method_is_accurate
    data_set = [3, 4, 5]
    result = @sales_analyst.standard_deviation(4, data_set)

    assert_equal 1.0, result
  end

  def test_mean_method_is_accurate
    data_set = [3, 4, 5]
    result = @sales_analyst.find_mean(data_set)

    assert_equal 4, result
  end

  def test_can_return_standard_deviation_items_per_merchant
    result = @sales_analyst.average_items_per_merchant_standard_deviation

    assert_equal 1.78, result
  end

  def test_can_find_merchants_with_high_item_count
    result = @sales_analyst.merchants_with_high_item_count

    assert_instance_of Array, result
    assert_equal 'GoldenRayPress', result[0].name
  end

  def test_can_find_average_item_price_of_merchant
    result = @sales_analyst.average_item_price_for_merchant(12_334_105)

    assert_instance_of BigDecimal, result
    assert_equal 0.2999e2, result
  end

  def test_can_find_average_of_average_merchant_item_price
    result = @sales_analyst.average_average_price_per_merchant

    assert_equal BigDecimal.new(6.96, 3), result
    assert_instance_of BigDecimal, result
  end

  def test_can_find_golden_items
    result = @sales_analyst.golden_items

    assert_instance_of Array, result

    assert (result.all? { |item| item.is_a?(Item)})
  end

  def test_invoice_collect_helper_method_works
    result = @sales_analyst.invoice_collector

    assert_instance_of Array, result
    assert (result.all? { |invoice| invoice.is_a?(Invoice)})
  end

  def test_gets_standard_deviation_of_all_item_prices_helper_method
    result = @sales_analyst.price_standard_deviation

    assert_instance_of BigDecimal, result
    assert_equal BigDecimal.new(4.46, 3), result
  end

  def test_merchant_collector_helper_method_works
    result = @sales_analyst.merchant_collector

    assert_instance_of Array, result
    assert (result.all? { |merchant| merchant.is_a?(Merchant)})
  end

  def test_find_average_invoices_per_merchant
    result = @sales_analyst.average_invoices_per_merchant

    assert_equal 2.05, result
  end

  def test_can_return_standard_deviation_invoices_per_merchant
    result = @sales_analyst.average_invoices_per_merchant_standard_deviation

    assert_equal 0.65, result
  end

  def test_can_find_top_merchants_by_invoice_count
    result = @sales_analyst.top_merchants_by_invoice_count

    assert_instance_of Array, result
    assert_instance_of Merchant, result[0]
  end

  def test_can_find_bottom_merchants_by_invoice_count
    result = @sales_analyst.bottom_merchants_by_invoice_count

    assert_instance_of Array, result
    assert_instance_of Merchant, result[0]
  end

  def test_it_can_find_average_invoices_per_weekday
    result = @sales_analyst.average_invoices_per_weekday

    assert_equal 5.86, result
  end

  def test_it_can_find_average_invoices_per_weekday_standard_deviation
    result = @sales_analyst.average_invoices_per_weekday_standard_deviation

    assert_equal 1.21, result
  end

  def test_weekday_totals_returns_hash_with_weekday_invoice_total
    result = @sales_analyst.weekday_totals

    assert_equal 7, result.length
    assert result.keys.include?('Wednesday')
  end

  def test_can_find_top_days_by_invoice_count
    mean_weekday = @sales_analyst.average_invoices_per_weekday
    stdv_wkday = @sales_analyst.average_invoices_per_weekday_standard_deviation
    invoices_by_weekday = @sales_analyst.weekday_totals
    result = @sales_analyst.top_days_by_invoice_count

    assert_equal 5.86, mean_weekday
    assert_equal 1.21, stdv_wkday
    assert_equal 7, invoices_by_weekday.length
    assert_equal 0, invoices_by_weekday[:Friday]
    assert_equal ['Monday'], result
  end

  def test_can_return_invoice_statuses_as_percent_share
    pending_result = @sales_analyst.invoice_status(:pending)
    shipped_result = @sales_analyst.invoice_status(:shipped)
    returned_result = @sales_analyst.invoice_status(:returned)

    assert_equal 31.71, pending_result
    assert_equal 58.54, shipped_result
    assert_equal 9.76, returned_result
  end

  def test_merchants_ranked_by_revenue
    result = @sales_analyst.merchants_ranked_by_revenue

    assert_instance_of Array, result
    assert (result.all? { |merchant| merchant.is_a?(Merchant)})
  end

  def test_can_find_total_revenue_by_date
    date = Time.parse('2005-11-11')
    date_invs = @sales_analyst.date_invoices(date)
    valid_invs = @sales_analyst.valid_invoices(date_invs)
    invoice_items = @sales_analyst.convert_to_invoice_items(valid_invs)
    result = @sales_analyst.total_revenue_by_date(date)

    assert_equal 1, date_invs.length
    assert_equal 1, valid_invs.length
    assert_equal 1, invoice_items.length
    assert_equal BigDecimal.new(986.68, 5), result
  end

  def test_can_find_revenue_by_merchant
    merch_invs = @sales_analyst.find_merchant_invoices(12_336_837)
    result = @sales_analyst.revenue_by_merchant(12_336_837)

    assert_equal 1, merch_invs.length
    assert_equal BigDecimal.new(986.68, 5), result
    assert_instance_of BigDecimal, result
  end

  def test_can_find_top_revenue_earners
    result = @sales_analyst.top_revenue_earners(10)
    result_no_arg = @sales_analyst.top_revenue_earners

    assert_instance_of Array, result
    assert_instance_of Merchant, result[0]
    assert_equal 10, result.length
    assert_equal 20, result_no_arg.length
  end

  def test_merchants_with_pending_invoices
    result = @sales_analyst.merchants_with_pending_invoices

    assert_equal 19, result.length
    assert_equal 'Candisart', result[1].name
    assert_equal result, result.uniq
  end

  def test_merchants_with_only_one_item
    result = @sales_analyst.merchants_with_only_one_item

    assert_equal 7, result.length
    assert_equal 'Shopin1901', result[0].name
    assert_equal 12334115, result[3].id
  end

  def test_find_merchants_by_month_registered
    result = @sales_analyst.find_merchants_by_month_registered(3)

    assert_instance_of Merchant, result[0]
    assert_equal 4, result.length
  end

  def test_find_good_invoice_items
    result = @sales_analyst.find_good_invoice_items(12_336_837)

    assert_instance_of InvoiceItem, result[0]
    assert_equal 205, result[0].id
  end

  def test_merchants_with_only_one_item_registered_in_month
    result = @sales_analyst.merchants_with_only_one_item_registered_in_month('March')

    assert_instance_of Array, result
    assert_instance_of Merchant, result[0]
    assert_equal 2, result.length
  end

  def test_invoice_item_helper_method_works
    result = @sales_analyst.invoice_items_collector

    assert_instance_of Array, result
    assert (result.all? { |invoice_item| invoice_item.is_a?(InvoiceItem)})
  end

  def test_most_sold_item_for_merchant
    result = @sales_analyst.most_sold_item_for_merchant(12_334_135)

    assert_instance_of Array, result
    assert_instance_of Item, result[0]
    assert_equal 'Waffle', result[0].name
  end

  def test_can_find_best_item_for_merchant
    result = @sales_analyst.best_item_for_merchant(12_334_135)

    assert_instance_of Item, result
    assert_equal 'Syrup', result.name
  end
end
