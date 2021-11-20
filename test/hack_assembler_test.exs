defmodule HackAssemblerTest do
  use ExUnit.Case

  @expected_hack_code """
  0000000000010000
  1110111111001000
  0000000000010001
  1110101010001000
  0000000000010000
  1111110000010000
  0000000001100100
  1110010011010000
  0000000000010010
  1110001100000001
  0000000000010000
  1111110000010000
  0000000000010001
  1111000010001000
  0000000000010000
  1111110111001000
  0000000000000100
  1110101010000111
  0000000000010010
  1110101010000111
  """

  setup do
    on_exit(fn -> File.rm("#{Path.dirname(__ENV__.file())}/support/test_prog.hack") end)
  end

  test "main writes a binary hack language representation of the assembly code file passed in" do
    test_file = "#{Path.dirname(__ENV__.file())}/support/test_prog.asm"
    HackAssembler.main([test_file])
    generated_hack_file = "#{Path.dirname(__ENV__.file())}/support/test_prog.hack"
    str = File.read!(generated_hack_file)
    assert str == String.trim(@expected_hack_code)
  end
end
