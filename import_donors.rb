require "csv"
require 'json'


donations = []
offline_donors_file_path = "/Users/joseykinnaman/desktop/offline-donors.csv"
online_donors_file_path = "/Users/joseykinnaman/desktop/online-donors.csv"

# offline donors
CSV.foreach(offline_donors_file_path, headers: true) do |row|
  offline_donors = {designated_name: row["designation_name"] , designated_amount: row["designated_amount"] }
  donations.push(offline_donors)
end

# online donors
CSV.foreach(online_donors_file_path, headers: true) do |row|
  designation_hash = JSON.parse(row["designation"])
  designation_hash.each do |designation, amount|
    donations << { designated_name: designation, designated_amount: amount }
  end
end

grouped_donations = donations.group_by { |item| item[:designated_name] }
leader_board = {}
grouped_donations.each do |designation, items|
  next unless designation # Skip if designated_name is nil?
  total_amount = items.map { |item| item[:designated_amount].to_f }.sum
  leader_board[designation] = { count: items.count, total_amount: total_amount }
end

puts leader_board
# run with `ruby import_donors.rb`
