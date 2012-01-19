require 'socket'               # Get sockets from stdlib
require 'logger'

class MyServer
	def initialize(host, port)
		@server = TCPServer.new(host, 2000)
		@logger = Logger.new('log/server.log', 'daily')

		connect
	end

	def connect
		handle_ctrl_c
		loop do
			Thread.start(@server.accept) do |tcpSocket|
				ip = connect_info(tcpSocket)
				begin
					loop do
						recv = tcpSocket.recv(10)
						unless recv.empty?
							puts recv
							@logger.info(recv)
						end
					end
				rescue SystemCallError
					disconnect_info(ip)
					exit if @interrupted
				ensure
					s.close
				end 
			end
		end
	end

	def connect_info(tcpSocket)
		port, ip = Socket.unpack_sockaddr_in(tcpSocket.getpeername)
		info = "connection open with #{ip}"
		puts info
		@logger.info(info)
		ip
	end

	def disconnect_info(ip)
		info = "connection closed with #{ip}"
		puts info
		@logger.info(info)
	end

	def handle_ctrl_c
		#handle Ctrl+C
		Kernel.trap('INT') do
		  @interrupted = true
		  disconnect
		  exit
		end
	end

	def disconnect
		@server.close
		@logs "server closed"
	end
end

	
