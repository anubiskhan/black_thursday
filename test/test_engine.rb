# frozen_string_literal: true

class TestEngine
  def test_hash
    {
      items: './test/fixtures/items.csv',
      merchants: './test/fixtures/merchants.csv',
      invoices: './test/fixtures/invoices.csv',
      invoice_items: './test/fixtures/invoice_items.csv',
      transactions: './test/fixtures/transactions.csv',
      customers: 'test/fixtures/customers.csv'
    }
  end
end
