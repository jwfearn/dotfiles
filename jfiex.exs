Application.put_env(:elixir, :ansi_enabled, true)

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
      :bright,
      :magenta,
      "%prefix>",
      :reset
    ] |> IO.ANSI.format |> IO.chardata_to_string,
  alive_prompt: [
      "\e[G",
      "\e[1;35m", # bright magenta
      "%prefix(%node)>",
      :reset
    ] |> IO.ANSI.format |> IO.chardata_to_string,
  history_size: -1
)

# ELIXIR TIPS:
# iex> h # iex help
# iex> h IEx # iex man page
