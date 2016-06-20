# IEx.Options.set(:colors, enabled: true)

IEx.configure(
  colors: [
    enabled: true,
    eval_result: [:cyan, :bright]
  ],
  # default_prompt: IO.ANSI.format([
  #     "\e[G", # move to column 1
  #     :magenta,
  #     "%prefix",
  #     ">"
  #   ]) |> IO.chardata_to_string,
  default_prompt: [
      "\e[G", # move to column 1
      "\e[35m", # magenta
      # :magenta,
      "%prefix",
      ">",
      "\e[0m"
    ] |> IO.chardata_to_string,
  alive_prompt: IO.ANSI.format([
      "\e[G",
      :magenta,
      :bright,
      "%prefix(%node)",
      ">"        # 
    ]) |> IO.chardata_to_string,
  history_size: -1
)

# ELIXIR TIPS:
# iex> h # iex help
# iex> h IEx # iex man page
