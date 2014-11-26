require 'date'
require 'json'
require 'socket'

root = ARGV[0]

s = TCPSocket.new 'localhost', 2947

s.puts '?WATCH={"enable":true,"json":true}'
last = ""
mod = 0

while line = s.gets
  j = JSON.parse(line)
  if (j['class'] != 'TPV') then
    next
  end

  mod = (mod + 1) % 10
  if (mod == 0) then
    next
  end

  pos = "#{j['lat']},#{j['lon']}"
  if (pos != last) then
    last = pos
    t = DateTime.parse(j['time']).to_time.to_i
    open(File.join(root, "locations"), 'a') do |f|
      f.puts "#{t},#{pos}"
    end
    open(File.join(root, "location.last"), 'w') do |f|
      f.puts t
      f.puts pos
    end
  end
end
puts "-done-"
s.close
