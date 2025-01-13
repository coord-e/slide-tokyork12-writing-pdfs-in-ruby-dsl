# frozen_string_literal: true

require "rubocop/rake_task"

RuboCop::RakeTask.new

task :build do
  require "jot_pdf/tokyork12"
  require "chunky_png"
  File.open("main.pdf", "w") do |f|
    JotPDF::Tokyork12.write(f) do
      # rubocop:disable Security/Eval
      eval(File.read("main.rb"))
      # rubocop:enable Security/Eval
    end
  end
end

task default: %i[rubocop build]
