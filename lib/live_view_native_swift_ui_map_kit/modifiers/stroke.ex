defmodule LiveViewNativeSwiftUiMapKit.Modifiers.Stroke do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{ShapeStyle, Color, StrokeStyle}

  modifier_schema "stroke" do
    field :content, ShapeStyle
    field :color, Color
    field :style, StrokeStyle
  end

  def params(content, [style: style]) do
    with {:ok, _} <- ShapeStyle.cast(content) do
      [content: content, style: style]
    else
      _ ->
        [color: content, style: style]
    end
  end
  def params(params) when is_list(params), do: params
  def params(content) do
    with {:ok, _} <- ShapeStyle.cast(content) do
      [content: content]
    else
      _ ->
        [color: content]
    end
  end
end
