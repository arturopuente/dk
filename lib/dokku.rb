require 'active_support/all'
require 'net/ssh'
require 'byebug'

require_relative './operation'

class Dokku
  def run(command)
    Net::SSH.start('server', 'root') do |session|
      Operation.new(session).run(command)
      session.loop
    end
  end
end
