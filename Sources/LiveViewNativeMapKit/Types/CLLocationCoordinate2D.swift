//
//  CLLocationCoordinate2D.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import CoreLocation
import LiveViewNative
import LiveViewNativeCore

/// A latitude/longitude pair, represented as a list.
///
/// Use a list to create a location coordinate, where the first element is the latitude and second is the longitude.
///
/// ```elixir
/// [latitude, longitude]
/// [38.8951, -77.0364]
/// ```
extension CLLocationCoordinate2D: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init(
            latitude: try container.decode(Double.self),
            longitude: try container.decode(Double.self)
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }
}
