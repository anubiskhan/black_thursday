# frozen_string_literal: true

require_relative 'test_helper.rb'
require_relative '../lib/merchant_repository.rb'
require_relative '../lib/sales_engine.rb'
require_relative './test_engine.rb'

class MerchantRepositoryTest < Minitest::Test
  def setup
    test_engine = TestEngine.new.test_hash
    sales_engine = SalesEngine.new(test_engine)
    @merchant_repo = sales_engine.merchants
  end

  def test_merchant_repository_initializes
    assert_instance_of MerchantRepository, @merchant_repo
  end

  def test_merchant_repository_has_merchants
    merchant_repository = @merchant_repo

    assert_equal 20, merchant_repository.all.count
    assert_instance_of Array, merchant_repository.all
    assert (merchant_repository.all.all? { |merchant| merchant.is_a?(Merchant) })
    assert_equal 'Shopin1901', merchant_repository.all.first.name
  end

  def test_merchant_repository_can_be_searched_by_id
    merchant_repository = @merchant_repo

    result = merchant_repository.find_by_id(12_334_112)

    assert_instance_of Merchant, result
    assert_equal 'Candisart', result.name
    assert_equal 12_334_112, result.id

    result_nil = merchant_repository.find_by_id(9000)

    assert_nil result_nil
  end

  def test_merchant_repository_can_be_searched_by_name
    merchant_repository = @merchant_repo

    result = merchant_repository.find_by_name('Candisart')

    assert_instance_of Merchant, result
    assert_equal 'Candisart', result.name
    assert_equal 12_334_112, result.id

    r_nil = merchant_repository.find_by_name('Kung Foodoo: Caribbean Karate')

    assert_nil r_nil
  end

  def test_merchant_repository_can_find_all_by_name
    merchant_repository = @merchant_repo

    result = merchant_repository.find_all_by_name('se')

    assert_instance_of Array, result
    assert_equal 'perlesemoi', result[0].name
    assert_equal 'Urcase17', result[1].name
    assert_equal 3, result.length

    result_nil = merchant_repository.find_all_by_name('Xtzxtx')

    assert_equal [], result_nil
  end

  def test_merch_repo_find_items_via_engine
    result = @merchant_repo.merch_repo_find_items_via_engine(12_334_144)

    assert result.empty?
  end

  def test_merch_repo_finds_invoices_via_engine
    result = @merchant_repo.merch_repo_finds_invoices_via_engine(12_335_955)

    assert_instance_of Invoice, result[0]
  end

  def test_merch_repo_finds_customers_via_engine
    result = @merchant_repo.merch_repo_finds_customers_via_engine(12_335_955)

    assert_equal 2, result.length
    assert_instance_of Customer, result[0]
  end

  def test_inspect
    assert_equal '#<MerchantRepository 20 rows>', @merchant_repo.inspect
  end
end
