#!/home/sliu/.rvm/rubies/ruby-1.8.7-p302/bin/ruby

class JrubyZombieKiller
  @@ps_aux = "/home/sliu/tmp/ps_grep.log"
  
  def initialize
    2.times do
      create_ps
      kill_process
      display_message
    end
  end

  def create_ps
    system "ps aux | grep 'rails server' > #{@@ps_aux}"
    @process_log = File.open(@@ps_aux)
  end

  def kill_process
    @killable_count = 0
    @process_log.each do |process_line|
      pid = process_line.split(" ")[1]
      if process_line =~ /rails\ server/
        @killable_count += 1
        system("kill -9 #{pid}") 
      end
    end
  end

  def display_message
    @length = 0
    @pad    = 40
    puts ""
    puts "  Killed #{@killable_count} zombie jruby rails server processes.  ".tap {|pr| @length = pr.size}.center(@length + @pad, "#")
    puts "  Following ps aux should not have jruby rails server processes:  ".center(@length + @pad, "#")
    system "cat #{@@ps_aux}"
  end
end

JrubyZombieKiller.new
