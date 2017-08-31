defmodule ExUtils.ExampleStruct do

  defstruct [
    element1: %{
      process: :example,
      type: :first,
      min: 0},
    element2: %{
      process: :example,
      type: :second,
      min: 1},
    element3: %{
      process: :example,
      type: :thirs,
      min: 2},
  ]
end