load 'tcp_server.rb' 

@host = '192.168.9.68'
@port = 2000

puts "I'll be listen on #{@host}:#{@port}"

server = MyServer.new(@host, @port)

