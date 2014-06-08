class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : session[:date] ? session[:date] : Date.today
    
    require 'openssl'
    OpenSSL::SSL.send(:remove_const, :VERIFY_PEER)
    OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE) 
    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    
    require 'rubygems'
    require 'google/api_client'
    
    #What data comes back from OmniAuth?     
    @auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    if @auth != nil
            @token = @auth["credentials"]["token"]
    
            client = Google::APIClient.new
            client.authorization.access_token = @token
            service = client.discovered_api('calendar', 'v3')

            calendar = client.execute(
              :api_method => service.calendar_list.list,
              :parameters => { },
              :headers => {'Content-Type' => 'application/json'}).data.items.select do |item| item.summary == "Birthdays" end
            events = client.execute(
              :api_method => service.events.list,
              :parameters => { 'calendarId' => calendar[0]['id'] },
              :headers => {'Content-Type' => 'application/json'}).data.items.select do |item| item['start']['dateTime'].month == @date.month end
            result = '<style>'
            events.each do |event| 
                #date = DateTime.new(event['start']['dateTime'].year,event['start']['dateTime'].month,event['start']['dateTime'].day)
                result = result +'td[name="' + event['start']['dateTime'].strftime(format="%Y-%m-%d") + '"]{ color : red; } '
            end
            result = result + '</style>'
            @result = result
    end
    @result = "Please, sign in to Google" unless @result != nil
    
    require 'fog/wunderlist'
    require 'pp'
    
    service = Fog::Tasks::new:provider => 'Wunderlist',
                             :wunderlist_username => 'future.sparkle@gmail.com',
                             :wunderlist_password => 'Kubuliadisu!'
                             
    #list = service.lists.find { |l| l.title == 'Groceries' }
    #service.tasks.each do |task|
    #    pp task
    #end
    
    
    grocerieslist = service.list_lists.body.find { |item| item["title"] == "Groceries" }
    groceries = service.list_tasks.body.select { |item| item["list_id"] == grocerieslist["id"] }
    @todo_array = groceries
  end
end
