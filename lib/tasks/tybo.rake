require "tailwindcss/ruby"

namespace :tybo do
  desc "Build Tybo Admin CSS"
  task build_css: :environment do
    input  = Rails.root.join("app/assets/stylesheets/tybo_admin.tailwind.css")
    output = Rails.root.join("app/assets/builds/tybo_admin.css")
    config = Rails.root.join("config/tailwind.config.js")

    unless input.exist?
      warn "WARNING: #{input} not found, skipping tybo CSS build"
      next
    end

    command = [
      Tailwindcss::Ruby.executable,
      "-i", input.to_s,
      "-o", output.to_s,
      "-c", config.to_s,
    ]
    command << "--minify" unless ENV["TAILWINDCSS_DEBUG"].present?

    system(*command, exception: true)
  end

  desc "Watch and build Tybo Admin CSS on file changes"
  task watch_css: :environment do
    input  = Rails.root.join("app/assets/stylesheets/tybo_admin.tailwind.css")
    output = Rails.root.join("app/assets/builds/tybo_admin.css")
    config = Rails.root.join("config/tailwind.config.js")

    command = [
      Tailwindcss::Ruby.executable,
      "-i", input.to_s,
      "-o", output.to_s,
      "-c", config.to_s,
      "-w"
    ]

    system(*command)
  rescue Interrupt
    # silent exit on Ctrl-C
  end
end

Rake::Task["assets:precompile"].enhance(["tybo:build_css"])
