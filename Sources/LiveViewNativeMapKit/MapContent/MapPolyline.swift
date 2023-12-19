//
//  MapPolyline.swift
//
//
//  Created by Carson Katri on 7/25/23.
//

import LiveViewNative
import MapKit
import SwiftUI
import CoreLocation

/// Create a line between a set of coordinates.
///
/// Use `<Coordinate>` elements within the `<MapPolyline>` to create a line.
///
/// ```html
/// <MapPolyline contour-style="geodesic">
///   <Coordinate latitude={38.8951} longitude={-77.0364} />
///   <Coordinate latitude={39.8951} longitude={-76.0364} />
///   <Coordinate latitude={40.8951} longitude={-78.0364} />
/// </MapPolyline>
/// ```
@_documentation(visibility: public)
struct MapPolyline<R: RootRegistry>: MapContent {
    /// The points of the polyline path.
    @_documentation(visibility: public)
    let coordinates: [CLLocationCoordinate2D]
    
    /// The way lines are drawn. Defaults to `straight`.
    ///
    /// Possible values:
    /// * ``geodesic``
    /// * ``straight``
    @_documentation(visibility: public)
    let contourStyle: MapKit.MapPolyline.ContourStyle
    
    let element: ElementNode
    let context: MapContentBuilder.Context<R>
    
    init(element: ElementNode, context: MapContentBuilder.Context<R>) throws {
        self.coordinates = try element
            .elementChildren()
            .filter { $0.tag == "Coordinate" }
            .map {
                .init(
                    latitude: try $0.attributeValue(Double.self, for: "latitude"),
                    longitude: try $0.attributeValue(Double.self, for: "longitude")
                )
            }
        
        switch try element.attributeValue(String.self, for: "contour-style") {
        case "geodesic":
            self.contourStyle = .geodesic
        case "straight":
            self.contourStyle = .straight
        default:
            self.contourStyle = .straight
        }
        
        self.element = element
        self.context = context
    }
    
    @MapKit.MapContentBuilder
    var body: some MapContent {
        MapKit.MapPolyline(coordinates: coordinates, contourStyle: contourStyle)
    }
}
