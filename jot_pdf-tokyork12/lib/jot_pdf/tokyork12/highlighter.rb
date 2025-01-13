# frozen_string_literal: true

module JotPDF
  module Tokyork12
    module Highlighter
      TokenType = Data.define(:regex, :color, :bold)
      Match = Data.define(:begin, :end, :type)
      Style = Data.define(:token_types) do
        def match(line, pos: 0)
          matches = token_types.filter_map do |tt|
            if (md = line.match(tt.regex, pos))
              b = begin
                md.begin("token")
              rescue IndexError
                md.begin(0)
              end
              e = begin
                md.end("token")
              rescue IndexError
                md.end(md.size - 1)
              end
              Match.new(
                begin: b,
                end: e,
                type: tt,
              )
            end
          end
          i = 0 # for stability
          matches.min_by { |m| [m.begin, i += 1] }
        end

        def each_token(text)
          cursor = 0
          while (m = match(text, pos: cursor))
            yield nil, text[cursor...m.begin]
            yield m.type, text[m.begin...m.end]
            cursor = m.end
          end
          yield nil, text[cursor..]
        end

        def and(m)
          tts = m.map do |k, v|
            color, bold =
              if v.is_a? Hash
                [v[:color], v[:bold]]
              else
                [v, false]
              end
            TokenType.new(
              regex: k,
              color:,
              bold:,
            )
          end
          Style.new(token_types: tts + token_types)
        end
      end

      Plain = Style.new(token_types: [])
      PDF = Style.new(token_types: [
                        TokenType.new(
                          regex: /%.*$/,
                          color: 0xb2bec3,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: /^\d{10} \d{5} n$/,
                          color: 0xdef3bc,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: /^\d{10} \d{5} f$/,
                          color: 0xb2bec3,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: /(^|\W)(?<token>\d+ \d+ obj|endobj|stream|endstream|xref|trailer|startxref \d+)($|\W)/,
                          color: 0xa29bfe,
                          bold: true,
                        ),
                        TokenType.new(
                          regex: /(^|\W)(?<token>\d+ \d+ R|\d+|\(.*\))($|\W)/,
                          color: 0x74b9ff,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: %r{(?<token>/\w+)($|\W)},
                          color: 0x81ecec,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: /(^|\W)(?<token>BT|Tf|Td|Tj|ET)($|\W)/,
                          color: 0xa29bfe,
                          bold: false,
                        ),
                        TokenType.new(
                          regex: /(<<|>>|\[|\])/,
                          color: 0xb2bec3,
                          bold: false,
                        ),
                      ])
      Ruby = Style.new(token_types: [
                         TokenType.new(
                           regex: /#[^{].*$/,
                           color: 0xb2bec3,
                           bold: false,
                         ),
                         TokenType.new(
                           regex: /(^|\W)(?<token>def|do|begin|class|end|yield)($|\W)/,
                           color: 0xa29bfe,
                           bold: true,
                         ),
                         TokenType.new(
                           regex: /(?<token>@\w+)($|\W)/,
                           color: 0x81ecec,
                           bold: false,
                         ),
                         TokenType.new(
                           regex: /(^|[^a-zA-Z0-9_:])(?<token>:\w+|\d+)/,
                           color: 0x74b9ff,
                           bold: false,
                         ),
                         TokenType.new(
                           regex: /("|})[^\#{}"]*("|\#{)/,
                           color: 0x74b9ff,
                           bold: false,
                         ),
                         TokenType.new(
                           regex: /({|}|\[|\])/,
                           color: 0xb2bec3,
                           bold: false,
                         ),
                       ])

      def self.adhoc(m)
        Plain.and(m)
      end
    end
  end
end
