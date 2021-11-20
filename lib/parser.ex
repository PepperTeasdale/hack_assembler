defmodule Parser do
  def strip_whitespace(tokens) do
    tokens
    |> Stream.map(&strip/1)
    |> Stream.filter(&(!String.starts_with?(&1, "//")))
    |> Stream.filter(&(&1 != "" && &1 != "\n"))
  end

  defp strip(token) do
    token
    |> String.split("//")
    |> hd()
    |> String.trim()
  end

  def to_hack_command("@" <> symbol, table) do
    case Integer.parse(symbol) do
      {_, ""} ->
        to_a_command(symbol)
      :error ->
        if SymbolTable.contains?(table, symbol) do
          SymbolTable.get_address(table, symbol)
          |> to_string()
          |> to_a_command()
        else
          SymbolTable.add_entry(table, symbol)

          SymbolTable.get_address(table, symbol)
          |> to_string()
          |> to_a_command()
        end
    end
  end

  def to_hack_command(c_instruction, _table) do
    [rest | jump] = String.split(c_instruction, ";")
    [comp | dest] = String.split(rest, "=") |> Enum.reverse()
    "111" <> HackCode.comp_bits(comp) <> HackCode.dest_bits(List.first(dest)) <> HackCode.jump_bits(List.first(jump))
  end

  defp to_a_command(num) do
    "0" <>
      (num
      |> String.to_integer()
      |> Integer.to_string(2)
      |> String.pad_leading(15, "0"))
  end

  def parse_and_filter_labels(tokens, table) do
    {without_labels, _} = Enum.reduce(tokens, {[], 0}, fn token, {acc, counter} ->
      if String.starts_with?(token, "(") do
        label = ~r/\(([a-zA-Z0-9_\.\$]*)\)/
          |> Regex.run(token, capture: :all_but_first)
          |> hd()
        SymbolTable.add_entry(table, label, counter)
        {acc, counter}
      else
        {[token | acc], counter + 1}
      end
    end)
    Enum.reverse(without_labels)
  end
end
