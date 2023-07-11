defmodule LiveViewNativeSwiftUiMapKit.Types.LocationCoordinate2D do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: {:array, :float}

  def cast(%{ latitude: latitude, longitude: longitude }), do: {:ok, [latitude, longitude]}
  def cast({latitude, longitude}), do: {:ok, [latitude, longitude]}
  def cast([_, _] = value), do: {:ok, value}
  def cast(_), do: :error
end
