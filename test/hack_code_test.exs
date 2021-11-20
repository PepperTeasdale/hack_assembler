defmodule HackCodeTest do
  use ExUnit.Case

  comp_tests = [
    {"0", "0101010"},
    {"1", "0111111"},
    {"-1", "0111010"},
    {"D", "0001100"},
    {"A", "0110000"},
    {"!D", "0001101"},
    {"!A", "0110001"},
    {"-D", "0001111"},
    {"-A", "0110011"},
    {"D+1", "0011111"},
    {"A+1", "0110111"},
    {"D-1", "0001110"},
    {"A-1", "0110010"},
    {"D+A", "0000010"},
    {"D-A", "0010011"},
    {"A-D", "0000111"},
    {"D&A", "0000000"},
    {"D|A", "0010101"},
    {"M", "1110000"},
    {"!M", "1110001"},
    {"-M", "1110011"},
    {"M+1", "1110111"},
    {"M-1", "1110010"},
    {"D+M", "1000010"},
    {"D-M", "1010011"},
    {"M-D", "1000111"},
    {"D&M", "1000000"},
    {"D|M", "1010101"}
  ]

  for {cmd, expected} <- comp_tests do
    @cmd cmd
    @expected expected
    test "comp_bits(#{@cmd}) returns #{@expected}" do
      actual = HackCode.comp_bits(@cmd)
      assert actual == @expected
    end
  end

  dest_tests = [
    {nil, "000"},
    {"M", "001"},
    {"D", "010"},
    {"MD", "011"},
    {"A", "100"},
    {"AM", "101"},
    {"AD", "110"},
    {"AMD", "111"}
  ]

  for {dest, expected} <- dest_tests do
    @dest dest
    @expected expected
    test "dest_bits(#{@dest}) returns #{@expected}" do
      actual = HackCode.dest_bits(@dest)
      assert actual == @expected
    end
  end

  jump_tests = [
    {nil, "000"},
    {"JGT", "001"},
    {"JEQ", "010"},
    {"JGE", "011"},
    {"JLT", "100"},
    {"JNE", "101"},
    {"JLE", "110"},
    {"JMP", "111"}
  ]

  for {jump, expected} <- jump_tests do
    @jump jump
    @expected expected
    test "jump_bits(#{@jump}) returns #{@expected}" do
      actual = HackCode.jump_bits(@jump)
      assert actual == @expected
    end
  end
end
