//
//  CLLocationCoordinate2D.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import CoreLocation
import LiveViewNative
import LiveViewNativeCore

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
