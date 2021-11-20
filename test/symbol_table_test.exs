defmodule SymbolTableTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, table} = SymbolTable.start_link(%{})
    %{table: table}
  end

  test "add_entry/2 stores incrementing location by symbol, starting at 16", %{table: table} do
    assert SymbolTable.contains?(table, "i") == false
    assert SymbolTable.contains?(table, "j") == false
    SymbolTable.add_entry(table, "i")
    assert SymbolTable.get_address(table, "i") == 16
    SymbolTable.add_entry(table, "j")
    assert SymbolTable.get_address(table, "j") == 17
  end

  test "add_entry/3 stores supplied location by symbol", %{table: table} do
    assert SymbolTable.contains?(table, "i") == false
    SymbolTable.add_entry(table, "i", 42)
    assert SymbolTable.get_address(table, "i") == 42
  end
end
