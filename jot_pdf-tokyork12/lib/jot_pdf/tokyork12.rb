# frozen_string_literal: true

require_relative "tokyork12/version"
require_relative "tokyork12/slide"
require_relative "tokyork12/highlighter"

module JotPDF
  module Tokyork12
    DATADIR = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "data"))
  end
end
