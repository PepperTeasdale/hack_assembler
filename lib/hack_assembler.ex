defmodule HackAssembler do
  @moduledoc """
  Documentation for `HackAssembler`.
  """

  defp read_lines(path) do
    File.stream!(path)
  end

  def main([]) do
    raise "You must pass in a .asm file path"
  end

  def main([path]) do
    {:ok, table} = SymbolTable.start_link([])
    instructions =
      read_lines(path)
      |> Parser.strip_whitespace()
      |> Parser.parse_and_filter_labels(table)
      |> Stream.map(&Parser.to_hack_command(&1, table))
      |> Enum.join("\n")

    file = File.open!(String.replace(path, ".asm", ".hack"), [:write])
    IO.binwrite(file, instructions)
    File.close(file)
  end
end
