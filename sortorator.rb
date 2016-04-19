require 'csv'
require 'json'
require 'pry'

class Sortorator

	def initialize
		# Define and Read the input file
		customers = CSV.read('customers.csv', { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all })
		# Transform the data to hash
		@transformed_data = customers.map { |row| row.to_hash }
	end	

	def customer_sorter
		# Sort the array of hashes by :customer_name
		customer_sort = @transformed_data.sort_by { |key| key[:customer_name] }
	end

	def customer_counter
		# Calculate the total number of orders per customer.
		orders_per_customer = Hash.new(0)
		@transformed_data.each do |order|
			orders_per_customer[order[:customer_name]] += 1
		end
		return orders_per_customer
	end

	def average_price
		# Calculate the average cost of orders per customer.
		prices_per_customer = Hash.new(0)
		@transformed_data.each do |order|
			# Scrub price string of $ character and convert to float
			price_clean = order[:price].sub('$','').to_f
			prices_per_customer[order[:customer_name]] += price_clean
		end

		price_average_per_customer = Hash.new(0)
		customer_count = customer_counter
		customer_count.each do |name,order_total|
			# We need to round because some of the averages do not conform to two decimal places
			price_average_per_customer[name] = (prices_per_customer[name] / order_total).round(2)
		end
		return price_average_per_customer
	end

	def json_reporter(filename,data_set)
		# Output report as JSON
		File.open('json_reports/'+filename+'.json', 'w') do |file| 
			file.puts JSON.pretty_generate(data_set)
		end
	end
end

sortorator = Sortorator.new
p "New reports available in the ./json_reports directory."
sortorator.json_reporter('sort_by_customer_name',sortorator.customer_sorter)
sortorator.json_reporter('orders_by_customer',sortorator.customer_counter)
sortorator.json_reporter('average_price_by_customer',sortorator.average_price)









      




