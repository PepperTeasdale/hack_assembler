defmodule ParserTest do
  use ExUnit.Case

  setup do
    {:ok, table} = SymbolTable.start_link([])
    %{table: table}
  end

  test "strip_whitespace removes comments" do
    actual =
      Parser.strip_whitespace(["hello", "//world", "hi"])
      |> Enum.to_list()

    assert actual == ["hello", "hi"]
  end

  test "strip_whitespace removes newline characters" do
    actual =
      Parser.strip_whitespace(["hello\n", "\nworld"])
      |> Enum.to_list()

    assert actual == ["hello", "world"]
  end

  test "strip_whitespace removes empty lines" do
    actual =
      Parser.strip_whitespace(["\n", ""])
      |> Enum.to_list()

    assert actual == []
  end

  test "strip_whitespace trims inline comments" do
    actual =
      Parser.strip_whitespace(["hello // world"])
      |> Enum.to_list()

    assert actual == ["hello"]
  end

  test "to_hack_command returns A-instructions translated into machine language", %{table: table} do
    actual = Parser.to_hack_command("@1", table)
    assert actual == "0000000000000001"
  end

  test "to_hack_command replaces symbols in A-instructions when they are defined", %{table: table} do
    assert SymbolTable.contains?(table, "R1") == true
    actual = Parser.to_hack_command("@R1", table)
    assert actual == "0000000000000001"
  end

  test "to_hack_command returns C-instructions with comp, dest and jump translated into machine language", %{table: table} do
    actual = Parser.to_hack_command("D=A;JLE", table)
    assert actual == "1110110000010110"
  end

  test "parse_and_filter_labels removes label definitions and adds their values to the symbol table", %{table: table} do
    cmd = [
      "@0",
      "(MYLABEL)",
      "D=M-1",
      "(ANOTHER_LABEL)"
    ]

    assert SymbolTable.contains?(table, "MYLABEL") == false
    assert SymbolTable.contains?(table, "ANOTHER_LABEL") == false

    actual = Parser.parse_and_filter_labels(cmd, table)
    assert actual == ["@0", "D=M-1"]
    assert SymbolTable.get_address(table, "MYLABEL") == 1
    assert SymbolTable.get_address(table, "ANOTHER_LABEL") == 2
  end
end
