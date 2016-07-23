require 'nokogiri'
require 'open-uri'
require "csv"
require 'time'

# output .csv file options
csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

# the filepath of the output .csv file is an argument to this function
filepath    = ARGV[0]

# if the filepath argument is missing, throw error and quit
if ARGV[0] == nil
  puts 'output .csv file name required as argument'
  return
end

# array to store one instance of date, close price and volume
data_array = []

# array of arrays (full_data) - stores all instances of data_array
full_data = []


# counter to check which field is being processed - initialised to zero
# field 1 = date, cnt == 0
# field 5 = close price, cnt == 4
# field 6 = volume, cnt == 5
cnt = 0

# this is the first page with the required data for date range
page = 'https://in.finance.yahoo.com/q/hp?s=AAPL&a=00&b=01&c=1991&d=04&e=4&f=2016&g=d'

continue = true

while continue
# use nokogiri gem to parse HTML into ruby object
  parse_page = Nokogiri::HTML(open(page), nil, 'utf-8')


# parse document for class 'yfnc_tabledata1' - which is the HTML table with data
  parse_page.css('.yfnc_tabledata1').each do |tag|

# process the first field
      if cnt == 0

# ignore line if the first field is not a correct date format (will fall thru to next line)
        begin
          Date.parse(tag.text)
        rescue ArgumentError
          next
        end

# ignore date if it contains a '-' (will fall thru to next line)
        next if tag.text.include?('-')

# convert first field to iso8601 date, move to array and increment field count
        data_array << DateTime.parse(tag.text).to_time.utc.iso8601
        cnt +=1

# move field 5 (closing price) to array and increment field count
      elsif cnt == 4
        data_array << tag.text
        cnt += 1

# move field 6 (volume) to array
# move data for current date (data_array) to full_data array
# initialize data_array to prepare for data of next date
      elsif cnt == 5
        data_array << tag.text
        full_data << data_array
        data_array = []
        cnt += 1

# set field count = 0 as data for current date is complete and we need next date
      elsif cnt == 6
        cnt = 0
        next

      else
# skip column data and increment counter to read next column
        cnt +=1
      end
  end

# check the href of the 'next' page link
  next_page = parse_page.css('td a').map{ |a|
    a['href'] if a['rel'] == 'next' }.compact.uniq

# if next page exists, build url for next page to loop to read data
  if next_page[0].nil?
    continue = false
  else
    page = 'https://in.finance.yahoo.com' + next_page[0].to_s
  end

end


CSV.open(filepath, 'wb', csv_options) do |csv|
  full_data.each do |oneday|
    csv << oneday
  end
end
