namespace :coinpost do
  desc "Export a user's item list to csv"
  task :export_user_items_to_csv => :environment do
    require 'csv'

    @from_user = User.find ENV['FROM_USER'] if ENV.has_key? 'FROM_USER'
    @csv_path = ENV['CSV_PATH'] if ENV.has_key? 'CSV_PATH'

    if @from_user.nil? and @csv_path.nil?
      puts "Please specify both a FROM_USER and CSV_PATH in order to export items"
      exit
    end

    CSV.open(@csv_path, "w") do |csv|
      csv << Item.CSV_COLUMNS
      @from_user.items.purchaseable.each{ |item| csv << item.to_csv }
    end
  end
end
