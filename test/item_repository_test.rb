# frozen_string_literal: true

require_relative 'test_helper.rb'
require_relative '../lib/item_repository.rb'
require_relative '../lib/sales_engine.rb'
require_relative './test_engine.rb'

class ItemRepositoryTest < Minitest::Test
  def setup
    test_engine = TestEngine.new.test_hash
    sales_engine = SalesEngine.new(test_engine)
    @item_repository = sales_engine.items
  end

  def test_it_exists
    assert_instance_of ItemRepository, @item_repository
  end

  def test_item_repository_can_hold_items
    assert_equal 18, @item_repository.all.count
    assert (@item_repository.all.all? { |item| item.is_a?(Item) })
  end

  def test_item_repository_holds_item_attributes
    assert_equal '510+ RealPush Icon Set', @item_repository.all.first.name
    assert_equal 0.12e2, @item_repository.all.first.unit_price
  end

  def test_it_can_find_item_by_name
    result = @item_repository.find_by_name('510+ RealPush Icon Set')

    result_nil = @item_repository.find_by_name('kittens')

    assert_instance_of Item, result
    assert_equal 0.12e2, result.unit_price
    assert_equal '510+ RealPush Icon Set', result.name
    assert_nil result_nil
  end

  def test_it_can_find_item_by_id
    result = @item_repository.find_by_id(263_395_617)

    result_nil = @item_repository.find_by_id(1989)

    assert_instance_of Item, result
    assert_equal 'Glitter scrabble frames', result.name
    assert_equal 263_395_617, result.id
    assert_nil result_nil
  end

  def test_it_can_find_all_with_description
    result = @item_repository.find_all_with_description('Disney glitter frames')

    result_nil = @item_repository.find_all_with_description('Gilded dog turd')

    assert_equal 0.135e2, result[0].unit_price
    assert_equal 'Disney scrabble frames', result[0].name
    assert result_nil.empty?
  end

  def test_it_can_find_all_by_price
    result = @item_repository.find_all_by_price(7.0)

    result_nil = @item_repository.find_all_by_price(999)

    assert_equal 263_396_013, result[0].id
    assert_equal 0.7e1, result[0].unit_price
    assert result_nil.empty?
  end

  def test_it_can_find_all_by_price_range
    result = @item_repository.find_all_by_price_in_range((0..9.0))

    assert_equal 0.7e1, result[0].unit_price
    assert_equal 'Free standing Woden letters', result[0].name
  end

  def test_it_can_find_all_by_merchant_id
    result = @item_repository.find_all_by_merchant_id(12_334_185)

    result_nil = @item_repository.find_all_by_merchant_id(666)

    assert_equal 'Glitter scrabble frames', result[0].name
    assert_equal 'Disney scrabble frames', result[1].name
    assert_equal 'Free standing Woden letters', result[2].name
    assert result_nil.empty?
  end

  def test_item_repo_finds_merchant_via_engine
    ir = @item_repository
    result = ir.item_repo_finds_merchant_via_engine(12_334_141)

    result_nil = ir.item_repo_finds_merchant_via_engine(263_396_209)

    assert_instance_of Merchant, result
    assert_nil result_nil
  end

  def test_inspect
    assert_equal '#<ItemRepository 18 rows>', @item_repository.inspect
  end
end
