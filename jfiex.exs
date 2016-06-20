# IO.inspect __ENV__.file

IEx.configure(
  default_prompt: IO.ANSI.format([
      "\e[G",
      :magenta,
      "%prefix",
      ">"
    ]) |> IO.chardata_to_string,
  alive_prompt: IO.ANSI.format([
      "\e[G",
      :magenta,
      :bright,
      "%prefix(%node)",
      ">"        # 
    ]) |> IO.chardata_to_string,
  history_size: -1,
  colors: [
    eval_result: [:cyan, :bright]
  ]
)

# ELIXIR TIPS:
# iex> h # iex help
# iex> h IEx # iex man page
