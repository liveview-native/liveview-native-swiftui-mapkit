//
//  PointOfInterestCategories.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit

/// Include/exclude types of points of interest.
///
/// Use `all` and `excluding_all` to enable/disable all points of interest.
///
/// Alternatively, use the `including` or `excluding` atom, along with a list of categories.
/// See [`MKPointOfInterestCategory`](https://developer.apple.com/documentation/mapkit/mkpointofinterestcategory) for a list of possible values.
///
/// - Note: Categories have names that start with `MKPOICategory`.
///
/// ```elixir
/// {:including, ["MKPOICategoryAirport", "MKPOICategoryEVCharger"]}
/// {:excluding, ["MKPOICategoryPublicTransport"]}
/// ```
extension PointOfInterestCategories: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "all":
            self = .all
        case "excluding_all":
            self = .excludingAll
        case "including":
            var nested = try container.nestedUnkeyedContainer(forKey: .categories)
            var include = [MKPointOfInterestCategory]()
            while !nested.isAtEnd {
                include.append(MKPointOfInterestCategory(rawValue: try nested.decode(String.self)))
            }
            self = .including(include)
        case "excluding":
            var nested = try container.nestedUnkeyedContainer(forKey: .categories)
            var exclude = [MKPointOfInterestCategory]()
            while !nested.isAtEnd {
                exclude.append(MKPointOfInterestCategory(rawValue: try nested.decode(String.self)))
            }
            self = .excluding(exclude)
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown PointOfInterestCategories type '\(`default`)'"))
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        case categories
    }
}

//extension MKPointOfInterestCategory: Decodable {
//    public init(from decoder: Decoder) throws {
//        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))
//    }
//}
