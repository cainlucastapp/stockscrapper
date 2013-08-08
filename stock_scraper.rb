require 'rubygems'
require 'mechanize' #This gem needs to be installed
require 'csv' # need to be on ruby 1.9+

browser = Mechanize.new

csv_file_read = File.join(Dir.pwd, 'symbol_info.csv')
csv_file_write = File.join(Dir.pwd, "ticket_info-#{Time.now.to_s}.csv")

CSV.open(csv_file_write, 'wb') do |csv|
  csv << ['Company Name', 'Ticker', 'Contact 1', 'Contact 2', 'Contact 3', 'Officer 1', 'Officer 2', 'Officer 3']
  CSV.foreach(csv_file_read) do |row|
    ticker_symbol = row[0]

      
   
      begin
        
        url = "http://www.otcmarkets.com/stock/#{ticker_symbol}/company-info"
        page = browser.get(url)
        
        company_name = page.at("#xcompanyInfo h3").text
        ticker = page.at("#breadCrumbs li:nth-child(6) , #breadCrumbs li:nth-child(6) a").text
    
        if page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(1)") == nil
          contact_info_1 = "N/A"
        else
          contact_info_1 = page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(1)").text
        end
    
        if page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(2)") == nil
          contact_info_2 = "N/A"
        else
          contact_info_2 = page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(2)").text
        end
    
        if page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(3)") == nil
          contact_info_3 = "N/A"
        else
          contact_info_3 = page.at("#compInfoContactAndDesc :nth-child(4) li:nth-child(3)").text
        end
    
        if page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(1) strong") == nil
          officer_1 = "N/A"
        else
          officer_1 = page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(1) strong").text + " " +
          page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(1) td:nth-child(2)").text
        end
    
        if page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(2) strong") == nil
          officer_2 = "N/A"
        else
          officer_2 = page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(2) strong").text + " " +
          page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(2) td:nth-child(2)").text
        end
    
        if page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(3) strong") == nil
          officer_3 = "N/A"
        else
          officer_3 = page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(3) strong").text + " " +
          page.at("#compInfoDataLeftCol :nth-child(3) tr:nth-child(3) td:nth-child(2)").text
        end

        csv << [company_name, ticker, contact_info_1, contact_info_2, contact_info_3, officer_1, officer_2, officer_3]
    rescue
    end
 
  end
end