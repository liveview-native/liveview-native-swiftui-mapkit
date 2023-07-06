//
//  MapCamera.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit

extension MapCamera: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            centerCoordinate: try container.decode(CLLocationCoordinate2D.self, forKey: .centerCoordinate),
            distance: try container.decode(Double.self, forKey: .distance),
            heading: try container.decode(Double.self, forKey: .heading),
            pitch: try container.decode(Double.self, forKey: .pitch)
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.centerCoordinate, forKey: .centerCoordinate)
        try container.encode(self.heading, forKey: .heading)
        try container.encode(self.pitch, forKey: .pitch)
    }
    
    enum CodingKeys: CodingKey {
        case centerCoordinate
        case distance
        case heading
        case pitch
    }
}
