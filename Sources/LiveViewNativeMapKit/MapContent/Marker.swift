//
//  Marker.swift
//
//
//  Created by Carson Katri on 7/11/23.
//

import LiveViewNative
import MapKit
import SwiftUI
import CoreLocation

/// Create a system balloon marker that displays on a map.
///
/// Provide a ``latitude`` and ``longitude`` for the marker.
/// Include a label as the content. The label will be displayed below the marker.
///
/// ```html
/// <Marker latitude={38.8951} longitude={-77.0364}>
///   Washington, D.C.
/// </Marker>
/// ```
///
/// Provide the ``image``, ``systemImage``, or ``monogram`` attribute to customize the pin icon.
///
/// ```html
/// <Marker latitude={38.8951} longitude={-77.0364} system-image="building.columns.fill">
///   Washington, D.C.
/// </Marker>
/// ```
///
/// Add a `tag` attribute to the marker to use as the selection value.
@_documentation(visibility: public)
struct Marker<R: RootRegistry>: MapContent {
    /// The latitude of the marker.
    @_documentation(visibility: public)
    let latitude: Double
    
    /// The longitude of the marker.
    @_documentation(visibility: public)
    let longitude: Double
    
    /// Use the value as a monogram instead of the default pin icon.
    @_documentation(visibility: public)
    let monogram: String?
    
    /// Use the provided image resource instead of the default pin icon.
    @_documentation(visibility: public)
    let image: String?
    
    /// Use the provided system image instead of the default pin icon.
    @_documentation(visibility: public)
    let systemImage: String?
    
    let element: ElementNode
    let context: MapContentBuilder.Context<R>
    
    init(element: ElementNode, context: MapContentBuilder.Context<R>) throws {
        self.latitude = try element.attributeValue(Double.self, for: "latitude")
        self.longitude = try element.attributeValue(Double.self, for: "longitude")
        
        self.monogram = element.attributeValue(for: "monogram")
        
        self.image = element.attributeValue(for: "image")
        self.systemImage = element.attributeValue(for: "system-image")
        
        self.element = element
        self.context = context
    }
    
    var title: String {
        switch element.children().first?.data {
        case let .some(.leaf(text)):
            text
        default:
            ""
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    @MapKit.MapContentBuilder
    var body: some MapContent {
        if let monogram {
            MapKit.Marker(title, monogram: SwiftUI.Text(monogram), coordinate: coordinate)
        } else if let image {
            MapKit.Marker(title, image: image, coordinate: coordinate)
        } else if let systemImage {
            MapKit.Marker(title, systemImage: systemImage, coordinate: coordinate)
        } else {
            MapKit.Marker(coordinate: coordinate) {
                MapContentBuilder.buildChildViews(of: element, in: context)
            }
        }
    }
}
