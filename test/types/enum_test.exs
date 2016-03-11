defmodule EnumTest do
  use ExUnit.Case

  test "enum macro is used correctly and datatype is string" do
    assert ExampleEnum.type == :string
  end

  test "enum has items" do
    assert ExampleEnum.allowed_items == ~w(foo bar baz)
  end

  test "takes allowed item as string and turns it into a symbol" do
    assert ExampleEnum.cast("bar") == {:ok, :bar}
  end

  test "takes allowed item as a symbol and leaves it that way" do
    assert ExampleEnum.cast(:bar) == {:ok, :bar}
  end

  test "refuses datatypes other than string and atom" do
    assert ExampleEnum.cast(1) == {:error, "Value needs to be a string or an atom."}
  end

  test "refuses casting a symbol that is not part of allowed items" do
    assert ExampleEnum.cast(:buz) == {:error, "Value is not an allowed item."}
  end

  test "refuses casting a string that is not part of allowed items" do
    assert ExampleEnum.cast("buz") == {:error, "Value is not an allowed item."}
  end

  test "takes atom and dumps it into a string to save it into the database" do
    assert ExampleEnum.dump(:baz) == {:ok, "baz"}
  end

  test "refuses to save other types than atoms" do
    assert ExampleEnum.dump("baz") == {:error, "Value needs to be an atom."}
  end

end
