//
//  CLLocationCoordinate2D.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import CoreLocation
import LiveViewNative
import LiveViewNativeStylesheet
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

extension CLLocationCoordinate2D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableCLLocationCoordinate2D.parser(in: context).map({ Self.init(latitude: $0.latitude, longitude: $0.longitude) })
    }
    
    @ParseableExpression
    struct ParseableCLLocationCoordinate2D {
        static let name = "CLLocationCoordinate2D"
        
        let latitude: Double
        let longitude: Double
        
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
