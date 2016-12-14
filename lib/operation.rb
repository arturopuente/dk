class Operation
  attr_accessor :session

  def initialize(session)
    @session = session
  end

  def run(args)
    if args.first == "shell"
      run_another(args.drop(1).join(' '))
    else
      run_dokku(args.join(' '))
    end
  end

  def run_dokku(command)
    session.open_channel do |channel|
      channel.on_data do |ch, data|
        puts "#{data}"
      end
      channel.exec "dokku #{command}"
    end
  end

  def run_another(command)
    session.open_channel do |channel|
      channel.on_data do |ch, data|
        puts "#{data}"
      end
      channel.exec command
    end
  end

  private

  def execute_on_channel(command)
    session.open_channel do |channel|
      channel.on_data do |ch, data|
        yield data
      end
      channel.exec command
    end
  end
end
