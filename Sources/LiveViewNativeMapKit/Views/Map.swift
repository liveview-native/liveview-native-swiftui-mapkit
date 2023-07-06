//
//  Map.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

struct Map<R: RootRegistry>: View {
    @LiveBinding(attribute: "position") private var position: MapCameraPosition
    
    @Attribute(.init(namespace: "bounds", name: "center-coordinate-bounds-center-latitude")) private var boundsCenterCoordinateBoundsLatitude: Double?
    @Attribute(.init(namespace: "bounds", name: "center-coordinate-bounds-center-longitude")) private var boundsCenterCoordinateBoundsLongitude: Double?
    @Attribute("bounds:center-coordinate-bounds-latitude-delta") private var boundsCenterCoordinateBoundsLatitudeDelta: Double?
    @Attribute("bounds:center-coordinate-bounds-longitude-delta") private var boundsCenterCoordinateBoundsLongitudeDelta: Double?
    
    @Attribute("bounds:minimum-distance") private var boundsMinimumDistance: Double?
    @Attribute("bounds:maximum-distance") private var boundsMaximumDistance: Double?
    
    @Attribute("interaction-modes") private var interactionModes: MapInteractionModes
    @LiveBinding(attribute: "selection") private var selection: String?
    
    var bounds: MapCameraBounds {
        if let boundsCenterCoordinateBoundsLatitude,
           let boundsCenterCoordinateBoundsLongitude,
           let boundsCenterCoordinateBoundsLatitudeDelta,
           let boundsCenterCoordinateBoundsLongitudeDelta
        {
            return .init(
                centerCoordinateBounds: .init(center: .init(latitude: boundsCenterCoordinateBoundsLatitude, longitude: boundsCenterCoordinateBoundsLongitude), span: .init(latitudeDelta: boundsCenterCoordinateBoundsLatitudeDelta, longitudeDelta: boundsCenterCoordinateBoundsLongitudeDelta)),
                minimumDistance: boundsMinimumDistance,
                maximumDistance: boundsMaximumDistance
            )
        } else {
            return .init(minimumDistance: boundsMinimumDistance, maximumDistance: boundsMaximumDistance)
        }
    }
    
    @ContentBuilderContext<R> private var context
    @ObservedElement(observeChildren: true) private var element
    
    var body: some View {
        MapKit.Map(
            position: $position,
            bounds: bounds,
            interactionModes: interactionModes,
            selection: $selection
        ) {
            
        }
    }
}
