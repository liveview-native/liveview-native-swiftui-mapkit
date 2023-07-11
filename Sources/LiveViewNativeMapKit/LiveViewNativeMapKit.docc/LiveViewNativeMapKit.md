# ``LiveViewNativeMapKit``

`liveview-native-swiftui-mapkit` is an add-on library for LiveView Native. It adds MapKit support for displaying interactive maps.

## Installation

1. Add this library as a package to your LiveView Native application's Xcode project
    * In Xcode, select *File* → *Add Packages...*
    * Enter the package URL `https://github.com/liveview-native/liveview-native-swiftui-mapkit`
    * Select *Add Package*

## Usage

When using Swift 5.9+, add the `MapKitRegistry` to the `addons` list of your `#LiveView`.

```swift
import SwiftUI
import LiveViewNative
import LiveViewNativeMapKit // 1. Import the add-on library.

struct ContentView: View {
    var body: some View {
        #LiveView(
          .localhost,
          addons: [MapKitRegistry<_>.self] // 2. Include the `MapKitRegistry`.
        )
    }
}
```

If you are on an older version of Swift, add the `MapKitRegistry` to your app's `AggregateRegistry`.

```diff
import SwiftUI
import LiveViewNative
+ import LiveViewNativeMapKit
+ 
+ struct MyRegistry: CustomRegistry {
+     typealias Root = AppRegistries
+ }
+ 
+ struct AppRegistries: AggregateRegistry {
+     #Registries<
+         MyRegistry,
+         MapKitRegistry<Self>
+     >
+ }

struct ContentView: View {
    var body: some View {
        LiveView<AppRegistries>(.localhost)
    }
}
```

To render a map within a SwiftUI HEEx template, use the `Map` element.
Include map content elements within the map to display custom markers and annotations:

```elixir
defmodule MyAppWeb.MapLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, places: [
      %{ name: "Washington, D.C.", coordinate: [38.8951, -77.0364], icon: "building.columns.fill" },
      %{ name: "New York City", coordinate: [40.730610, -73.935242], icon: "building.2.fill" },
      %{ name: "Philadelphia", coordinate: [39.9526, -75.1652], icon: "bell.fill" },
    ])}
  end

  @impl true
  def render(%{platform_id: :swiftui} = assigns) do
    ~SWIFTUI"""
    <Map>
      <Marker
        :for={%{ name: name, coordinate: [latitude, longitude], icon: icon } <- @places}
        latitude={latitude}
        longitude={longitude}
        system-image={icon}
      >
        <%= name %>
      </Marker>
    </Map>
    """
  end
end
```

![LiveView Native MapKit screenshot](example.png)

## Topics
### Elements
- ``Map``
### Modifiers
- ``LookAroundViewerModifier``
### Annotations and overlays
- ``Marker``
