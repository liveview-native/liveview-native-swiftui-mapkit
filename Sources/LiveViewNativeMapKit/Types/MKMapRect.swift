//
//  MKMapRect.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import MapKit

/// :null
/// :world
/// [origin: coordinate, size: [100, 100]]
extension MKMapRect: Codable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            switch try container.decode(String.self) {
            case "null":
                self = .null
            case "world":
                self = .world
            case let `default`:
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown MKMapRect type '\(`default`)'"))
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                origin: .init(try container.decode(CLLocationCoordinate2D.self, forKey: .origin)),
                size: try container.decode(MKMapSize.self, forKey: .size)
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.origin.coordinate, forKey: .origin)
        try container.encode(self.size, forKey: .size)
    }
    
    enum CodingKeys: CodingKey {
        case origin
        case size
    }
}

extension MKMapSize: Codable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           try container.decode(String.self) == "world" {
            self = .world
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                width: try container.decode(Double.self, forKey: .width),
                height: try container.decode(Double.self, forKey: .height)
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.width, forKey: .width)
        try container.encode(self.height, forKey: .height)
    }
    
    enum CodingKeys: CodingKey {
        case width
        case height
    }
}
