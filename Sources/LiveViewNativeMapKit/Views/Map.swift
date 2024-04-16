//
//  Map.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

/// Display an interactive map.
///
/// Use the `Map` element to create a basic map.
///
/// ```html
/// <Map />
/// ```
///
/// This will present a simple interactive map.
///
/// Add content within the map, such as a ``Marker``, to display additional data.
///
/// ```html
/// <Map>
///   <Marker latitude={38.8951} longitude={-77.0364}>
///     Washington, D.C.
///   </Marker>
/// </Map>
/// ```
///
/// Use the ``selection`` binding to detect which ``Marker`` or other annotation is selected based on its `tag` attribute.
///
/// ```elixir
/// defmodule MyAppWeb.MapLive do
///   native_binding :selection, Atom, nil
/// end
/// ```
///
/// ```html
/// <Map selection={:selection}>
///   <Marker latitude={38.8951} longitude={-77.0364} tag={:dc}>
///     Washington, D.C.
///   </Marker>
/// </Map>
/// ```
///
/// To synchronize the Map's camera position, use the ``position`` binding.
///
/// ```elixir
/// defmodule MyAppWeb.MapLive do
///   native_binding :position, Map, %{ type: :user_location }
/// end
/// ```
///
/// ```html
/// <Map position={:position} />
/// ```
///
/// To only allow certain interactions, use the ``interactionModes`` attribute.
///
/// ```html
/// <Map interaction-modes="pan,rotate" />
/// ```
///
/// Set the `bounds:x` attributes to customize the area of the map that can be viewed.
///
/// Use the ``boundsMinimumDistance``/``boundsMaximumDistance`` to set the zoom bounds.
/// Use the ``boundsLatitude``, ``boundsLongitude``, ``boundsLatitudeDelta``, and ``boundsLongitudeDelta`` to set the pan bounds.
///
/// ```html
/// <Map
///   bounds:latitude={38.8951}
///   bounds:longitude={-77.0364}
///   bounds:latitude-delta={2}
///   bounds:longitude-delta={2}
///
///   bounds:minimum-distance={750_000}
///   bounds:maximum-distance={1_000_000}
/// />
/// ```
@_documentation(visibility: public)
@LiveElement
struct Map<Root: RootRegistry>: View {
    /// A binding that synchronizes the camera position.
    ///
    /// See ``LiveViewNativeMapKit/_MapKit_SwiftUI/MapCameraPosition`` for more details.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "position") private var position: MapCameraPosition = .automatic
    
    /// The latitude of the boundary center.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "latitude")) private var boundsLatitude: Double?
    
    /// The longitude of the boundary center.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "longitude")) private var boundsLongitude: Double?
    
    /// The latitude range of the boundary.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "latitudeDelta")) private var boundsLatitudeDelta: Double?
    
    /// The longitude range of the boundary.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "longitudeDelta")) private var boundsLongitudeDelta: Double?
    
    /// The closest zoom distance, in meters.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "minimumDistance")) private var boundsMinimumDistance: Double?
    
    /// The furthest zoom distance, in meters.
    @_documentation(visibility: public)
    @LiveAttribute(.init(namespace: "bounds", name: "maximumDistance")) private var boundsMaximumDistance: Double?
    
    /// The interactions allowed on the map.
    @_documentation(visibility: public)
    private var interactionModes: MapInteractionModes = .all
    
    /// The currently selected map element, represented by its `tag` attribute.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection: String? = nil
    
    var bounds: MapCameraBounds {
        if let boundsLatitude,
           let boundsLongitude,
           let boundsLatitudeDelta,
           let boundsLongitudeDelta
        {
            return .init(
                centerCoordinateBounds: .init(center: .init(latitude: boundsLatitude, longitude: boundsLongitude), span: .init(latitudeDelta: boundsLatitudeDelta, longitudeDelta: boundsLongitudeDelta)),
                minimumDistance: boundsMinimumDistance,
                maximumDistance: boundsMaximumDistance
            )
        } else {
            return .init(minimumDistance: boundsMinimumDistance, maximumDistance: boundsMaximumDistance)
        }
    }
    
    @LiveElementIgnored
    @ContentBuilderContext<Root, MapContentBuilder> private var context
    @LiveElementIgnored
    @ObservedElement(observeChildren: true) private var element
    
    var body: some View {
        let content = try! MapContentBuilder.buildChildren(of: element, in: context)
        return unbox(content)
    }
    
    func unbox(_ content: some MapContent) -> AnyView {
        AnyView(MapKit.Map(
            position: $position,
            bounds: bounds,
            interactionModes: interactionModes,
            selection: $selection
        ) {
            content
        })
    }
}
