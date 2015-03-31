@meetings = MeetingsFetcher.new()

SCHEDULER.every '1m', allow_overlapping: false do
  @meetings = MeetingsFetcher.new() if @meetings.nil?
  @meetings.refresh_access_token
  #send_event('Museum', @meetings.get_summarized_events('room_museum@pivotallabs.com'))
  send_event('West', @meetings.get_summarized_events('pivotal.io_626f2d77657374%40@resource.calendar.google.com'))
end
