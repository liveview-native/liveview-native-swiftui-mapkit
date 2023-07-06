//
//  MapCameraPosition.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit

extension MapCameraPosition: Codable {
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
    
    enum CodingKeys: CodingKey {
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
