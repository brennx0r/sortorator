require 'minitest'
require 'minitest/autorun'
require_relative 'sortorator'

class TestSortorator < Minitest::Test 

	def setup
		@sortorator = Sortorator.new
	end

	def test_customer_sorter_contains_customer_name
		assert_equal "@transformed_data.sort_by { |key| key[:customer_name] }", @sortorator.customer_sorter
	end

	def test_customer_counter
		assert_includes "Jill Ham", @sortorator.test_customer_counter
	end
end