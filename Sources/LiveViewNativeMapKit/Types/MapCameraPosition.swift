//
//  MapCameraPosition.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeCore

/// The positioning of a ``Map``'s camera.
///
/// Create a native binding to synchronize the map camera.
///
/// ```elixir
/// defmodule MyAppWeb.MapLive do
///     native_binding :position, Map, %{ type: :automatic }
/// end
/// ```
///
/// There are several types of camera that can be created.
///
/// ### `automatic`
/// Use the automatic type to let the system decide the best placement for the camera.
///
/// ```elixir
/// %{ type: :automatic }
/// ```
///
/// ### `camera`
/// Provide a custom ``LiveViewNativeMapKit/_MapKit_SwiftUI/MapCamera``.
///
/// ```elixir
/// %{ type: :camera, camera: %{ centerCoordinate: [38.8951, -77.0364], distance: 100_000 } }
/// ```
///
/// ### `item`
/// Display a specific coordinate.
///
/// ```elixir
/// %{ type: :item, item: [38.8951, -77.0364], allowsAutomaticPitch: false }
/// ```
///
/// ### `rect`
/// Display a custom ``LiveViewNativeMapKit/MapKit/MKMapRect`` boundary.
///
/// ```elixir
/// %{ type: :rect, rect: [origin: [38.8951, -77.0364], size: [100, 100]] }
/// ```
///
/// ### `region`
/// Display a region around a central point.
///
/// ```elixir
/// %{ type: :region, center: [38.8951, -77.0364], latitudeDelta: 1, longitudeDelta: 1 }
/// ```
///
/// ### `user_location`
/// Follow the user's current location (if permission is granted). Otherwise, use the `fallback` camera position.
///
/// ```elixir
/// %{ type: :userLocation, followsHeading: true, fallback: %{ type: :automatic } }
/// ```
extension MapCameraPosition: Codable, AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let namespace = attribute?.name.name,
              let type = attribute?.value
        else { throw  AttributeDecodingError.missingAttribute(Self.self) }
        switch type {
        case "automatic":
            self = .automatic
        case "camera":
            self = .camera(.init(
                centerCoordinate: .init(
                    latitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "latitude")),
                    longitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "longitude"))
                ),
                distance: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "distance"))
            ))
        case "item":
            self = .item(
                MKMapItem(
                    placemark: .init(coordinate: .init(
                        latitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "latitude")),
                        longitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "longitude"))
                    ))
                ),
                allowsAutomaticPitch: try element.attributeValue(Bool.self, for: .init(namespace: namespace, name: "allowsAutomaticPitch"))
            )
        case "rect":
            self = .rect(MKMapRect(
                x: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "x")),
                y: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "y")),
                width: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "width")),
                height: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "height"))
            ))
        case "region":
            self = .region(MKCoordinateRegion(
                center: .init(
                    latitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "latitude")),
                    longitude: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "longitude"))
                ),
                span: .init(
                    latitudeDelta: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "latitudeDelta")),
                    longitudeDelta: try element.attributeValue(Double.self, for: .init(namespace: namespace, name: "longitudeDelta"))
                )
            ))
        case "userLocation":
            self = .userLocation(
                followsHeading: try element.attributeValue(Bool.self, for: .init(namespace: namespace, name: "followsHeading")),
                fallback: try Self.init(from: element.attribute(named: "user-location-fallback"), on: element)
            )
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(MapCameraPositionType.self, forKey: .type) {
        case .automatic:
            self = .automatic
        case .camera:
            self = .camera(try container.decode(MapCamera.self, forKey: .camera))
        case .item:
            self = .item(
                MKMapItem(placemark: .init(coordinate: try container.decode(CLLocationCoordinate2D.self, forKey: .item))),
                allowsAutomaticPitch: try container.decodeIfPresent(Bool.self, forKey: .allowsAutomaticPitch) ?? true
            )
        case .rect:
            self = .rect(
                try container.decode(MKMapRect.self, forKey: .rect)
            )
        case .region:
            self = .region(
                .init(
                    center: try container.decode(CLLocationCoordinate2D.self, forKey: .center),
                    span: .init(
                        latitudeDelta: try container.decode(CLLocationDegrees.self, forKey: .latitudeDelta),
                        longitudeDelta: try container.decode(CLLocationDegrees.self, forKey: .longitudeDelta)
                    )
                )
            )
        case .userLocation:
            self = .userLocation(
                followsHeading: try container.decodeIfPresent(Bool.self, forKey: .followsHeading) ?? false,
                fallback: try container.decode(MapCameraPosition.self, forKey: .fallback)
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let camera {
            try container.encode(MapCameraPositionType.camera, forKey: .type)
            try container.encode(camera, forKey: .camera)
        } else if let item {
            try container.encode(MapCameraPositionType.item, forKey: .type)
            try container.encode(item.placemark.coordinate, forKey: .item)
            try container.encode(allowsAutomaticPitch, forKey: .allowsAutomaticPitch)
        } else if let rect {
            try container.encode(MapCameraPositionType.rect, forKey: .type)
            try container.encode(rect, forKey: .rect)
        } else if let region {
            try container.encode(MapCameraPositionType.region, forKey: .type)
            try container.encode(region.center, forKey: .center)
            try container.encode(region.span.latitudeDelta, forKey: .latitudeDelta)
            try container.encode(region.span.longitudeDelta, forKey: .longitudeDelta)
        } else if followsUserLocation,
                  let fallbackPosition
        {
            try container.encode(MapCameraPositionType.userLocation, forKey: .type)
            try container.encode(followsUserHeading, forKey: .followsHeading)
            try container.encode(fallbackPosition, forKey: .fallback)
        }
    }
    
    enum MapCameraPositionType: String, Codable {
        case automatic
        case camera
        case item
        case rect
        case region
        case userLocation
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        
        case camera
        
        case item
        case allowsAutomaticPitch
        
        case rect
        
        case center
        case latitudeDelta
        case longitudeDelta
        
        case followsHeading
        case fallback
    }
}
