#!/home/sliu/.rvm/rubies/ruby-1.8.7-p302/bin/ruby

class ZombieKiller
  @@ps_aux = "/home/sliu/tmp/processes.log"
  
  def initialize
    create_ps("auto")
    kill_process
    create_ps("auto")
    display_message
  end

  def create_ps(grep_for)
    system "ps aux | grep #{grep_for} > #{@@ps_aux}" # 1 '>' to replace log file
    @process_log = File.open(@@ps_aux)
  end

  def kill_process
    @killable_count = 0
    @process_log.each do |process_line|
      pid = process_line.split(" ")[1]
      if process_line =~ /(bin\/autotest|bin\/autospec)/
        @killable_count += 1
        system("kill -9 #{pid}") 
      end
    end
  end

  def display_message
    @length = 0
    @pad    = 40
    puts ""
    puts "  Killed #{@killable_count} zombie autoest and autospec processes.  ".tap {|pr| @length = pr.size}.center(@length + @pad, "#")
    puts "  Following ps aux should not have autoest or autospec processes:  ".center(@length + @pad, "#")
    system "cat #{@@ps_aux}"
  end
end

ZombieKiller.new
