Application.put_env(:elixir, :ansi_enabled, true)

IEx.configure(
  colors: [
    enabled: true,
    eval_result: [:bright, :cyan]
  ],
  default_prompt: [
      "\e[G", # move to column 1
      :magenta,
      "%prefix>",
      :reset
    ] |> IO.ANSI.format |> IO.chardata_to_string,
  alive_prompt: [
      "\e[G",
      :bright,
      :magenta,
      "%prefix(%node)>",
      :reset
    ] |> IO.ANSI.format |> IO.chardata_to_string,
  history_size: -1
)

# # ~/.iex.exs
# Code.require_file("dotfiles/jfiex.exs", __DIR__)
