require "tailwindcss/ruby"

Puma::Plugin.create do
  def start(launcher)
    in_background do
      rails_root = defined?(Rails) ? Rails.root : Pathname.new(Dir.pwd)

      input  = rails_root.join("app/assets/stylesheets/tybo_admin.tailwind.css")
      output = rails_root.join("app/assets/builds/tybo_admin.css")
      config = rails_root.join("config/tailwind.config.js")

      unless input.exist?
        launcher.log_writer.write("Tybo: #{input} not found, skipping CSS watch\n")
        next
      end

      command = [
        Tailwindcss::Ruby.executable,
        "-i", input.to_s,
        "-o", output.to_s,
        "-c", config.to_s,
        "-w"
      ]

      pid = spawn(*command)
      launcher.events.on_stopped { Process.kill(:INT, pid) rescue nil }

      begin
        Process.wait(pid)
      rescue Interrupt
        Process.kill(:INT, pid) rescue nil
        Process.wait(pid)
      end
    end
  end
end
