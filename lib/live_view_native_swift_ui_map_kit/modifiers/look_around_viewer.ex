defmodule LiveViewNativeSwiftUiMapKit.Modifiers.LookAroundViewer do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{NativeBindingName, Event}
  alias LiveViewNativeSwiftUiMapKit.Types.{LocationCoordinate2D, PointOfInterestCategories}

  modifier_schema "look_around_viewer" do
    field :is_presented, NativeBindingName
    field :initial_scene, LocationCoordinate2D
    field :allows_navigation, :boolean, default: true
    field :shows_road_labels, :boolean, default: true
    field :points_of_interest, PointOfInterestCategories
    field :on_dismiss, Event, default: nil
  end
end
