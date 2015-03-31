#!/usr/bin/env ruby
require 'net/http'
require 'uri'

httptimeout = 3 #seconds
ping_count = 10

servers = [
    {name: 'foos', url: 'http://new-foosboard-api.cfapps.io/status', method: 'http', expect: "200", header: [], content: 'open'},
]

SCHEDULER.every '5s', :first_in => 0 do |job|
  servers && servers.each do |server|
    puts "Server Status Squares: Updating status for #{server[:name]}"
    if server[:method] == 'http'
      begin
        uri = URI.parse(server[:url])
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = httptimeout
        if uri.scheme == "https"
          http.use_ssl=true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        server[:header].each do |header|
          request[header.first] = header.last
        end
        response = http.request(request)
        if response.code == server[:expect]
          puts "status ok... continuing"
          if response.body.match(server[:content])
            puts "Server Status Squares: Request to #{server[:name]} all good"
            result = 1
          end
        else
          puts "Server Status Squares: Request to #{server[:name]} failed with Non-expected response code (namely, #{server[:expect]}). Got: #{response.code}"
          result = 0
        end
      rescue Timeout::Error
        puts "Server Status Squares: Request to #{server[:name]} failed with Timeout::Error"
        result = 0
      rescue Errno::ETIMEDOUT
        puts "Server Status Squares: Request to #{server[:name]} failed with Errno::ETIMEDOUT"
        result = 0
      rescue Errno::EHOSTUNREACH
        puts "Server Status Squares: Request to #{server[:name]} failed with Errno::EHOSTUNREACH"
        result = 0
      rescue Errno::ECONNREFUSED
        puts "Server Status Squares: Request to #{server[:name]} failed with Errno::ECONNREFUSED"
        result = 0
      rescue SocketError => e
        puts "Server Status Squares: Request to #{server[:name]} failed with SocketError. #{e.inspect}"
        result = 0
      rescue Exception => e
        puts "Server Status Squares: Request to #{server[:name]} exception received #{e.inspect}"
        result = 0
      end
    elsif server[:method] == 'ping'
      result = `ping -q -c #{ping_count} #{server[:url]}`
      if ($?.exitstatus == 0)
        result = 1
      else
        result = 0
      end
    end

    send_event(server[:name], result: result)
  end
end