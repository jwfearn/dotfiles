# .irbrc

->() do
  # IRB.conf[:AUTO_INDENT] = true

  # for irb prompt info: http://www.rubycentral.org/pickaxe/irb.html#UA
  # for ANSI color info:

  cRED = "\e[31m"
  cGREEN = "\e[32m"
  cPINK = "\e[35m"
  cBG = "\e[30m" #TODO get current background
  cEND = "\e[0m"

  msg = ->(third, hide_first = false, cshow = cRED, chide = cBG) do
    first = '%N(%m):'
    second = '%03n:%i'
    "#{hide_first ? chide : cshow}#{first}#{hide_first ? cshow : ''}#{second}#{third}#{cEND}"
  end

  IRB.conf[:PROMPT][:JF_PROMPT] = {
    PROMPT_I: "#{msg.(' > ')}", # normal prompt
    PROMPT_N: "#{msg.('   ', true)}", # prompt for continuing code
    PROMPT_S: "#{msg.(' %l ', true)}", # prompt for continuing string
    PROMPT_C: "#{msg.(' * ', true, cPINK)}", # prompt for continuing statement
    RETURN: "#{cGREEN}  %s\n#{cEND}" # green, format to return value
  }

  IRB.conf[:PROMPT_MODE] = :JF_PROMPT

  # def cls
  # 	def mysys(a) system(a) end # NOT local!!!!
  # 	mysys('clear')
  # end

  # def foo; 'foo' end
  # bar = ->() { 'bar' } # local
end.()

# # ~/.irbrc
# require_relative './dotfiles/jfirb'
