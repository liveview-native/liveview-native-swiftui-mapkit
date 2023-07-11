//
//  MapCamera.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit

/// A camera for a map.
///
/// A map camera can be presented by an Elixir map.
///
/// Include the `center_coordinate` and `distance` keys to create a map camera.
/// Optionally add the `heading` and `pitch` keys to configure the orientation of the map.
///
/// ```elixir
/// %{ center_coordinate: [38.8951, -77.0364], distance: 100_000 }
/// %{ center_coordinate: [38.8951, -77.0364], distance: 100_000, heading: -45, pitch: 15 }
/// ```
extension MapCamera: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            centerCoordinate: try container.decode(CLLocationCoordinate2D.self, forKey: .centerCoordinate),
            distance: try container.decode(Double.self, forKey: .distance),
            heading: try container.decodeIfPresent(Double.self, forKey: .heading) ?? 0,
            pitch: try container.decodeIfPresent(Double.self, forKey: .pitch) ?? 0
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.centerCoordinate, forKey: .centerCoordinate)
        try container.encode(self.heading, forKey: .heading)
        try container.encode(self.pitch, forKey: .pitch)
    }
    
    enum CodingKeys: String, CodingKey {
        case centerCoordinate = "center_coordinate"
        case distance
        case heading
        case pitch
    }
}
