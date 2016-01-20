#!/usr/bin/env ruby

def colorchart(t = 'x', pad = 1, margin = 0, sp = ' ')
  bgs = [''] + %w(40m 41m 42m 43m 44m 45m 46m 47m)        # '' means default
  fgs = %w(m 1m 30m 1;30m 31m 1;31m 32m 1;32m 33m
    1;33m 34m 1;34m 35m 1;35m 36m 1;36m 37m 1;37m)

  w0 = fgs.map { |s| s.length }.max  # minimum width of label column
  w1 = bgs.map { |s| s.length }.max  # minimum width of other columns
  w = [t.length, w1].max + (2 * pad) # width of cells (pad, no margin)
  t = t.center w, sp
  margin = "#{sp * margin}"

  # header row
  s = "\n#{margin}#{'FG\\BG'.rjust w0, sp}"               # label column
  bgs.each { |bg|	s += "#{margin}#{bg.center w, sp}" }    # other columns
  s += "\n"

  # other rows
  fgs.each do |fg|
    s += "#{margin}#{fg.rjust w0}"                        # label column
    bgs.each do |bg|                                      # other columns
      s += "#{margin}\033[#{fg}"
      s += (bg.length > 0) ? "\033[#{bg}#{t}\033[0m" : t  # no BG when default
    end
    s += "\n"
  end
  s
end

 puts colorchart 'gYw', 2, 1
# puts colorchart 'gYw', 1, 0
#puts colorchart
