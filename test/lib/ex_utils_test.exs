defmodule ExUtilsTest do
  use ExUnit.Case

  test "ExampleStruct is a valid struct" do
    assert %ExUtils.ExampleStruct{}.__struct__ == ExUtils.ExampleStruct
  end

  test "ExUtils.struct_to_json/1 converts a struct to valid JSON without internal __struct__ key" do
    json = ExUtils.struct_to_json %ExUtils.ExampleStruct{}
    map = Poison.decode!(json)
    assert Map.has_key?(map, "__struct__") == :false
    assert Map.has_key?(map, "element1") == :true
  end
end