defmodule LiveViewNativeSwiftUiMapKit.Types.PointOfInterestCategories do
  @derive Jason.Encoder
  defstruct [:type, :categories]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(type) when is_atom(type), do: {:ok, %{ type: Atom.to_string(type) }}
  def cast({type, categories}) when is_atom(type) and is_list(categories), do: {:ok, %{ type: Atom.to_string(type), categories: categories }}
  def cast(_), do: :error
end
