//
//  PointOfInterestCategories.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNativeStylesheet

/// Include/exclude types of points of interest.
///
/// Use `all` and `excludingAll` to enable/disable all points of interest.
///
/// Alternatively, use the `including` or `excluding` atom, along with a list of categories.
/// See [`MKPointOfInterestCategory`](https://developer.apple.com/documentation/mapkit/mkpointofinterestcategory) for a list of possible values.
///
/// - Note: Categories have names that start with `MKPOICategory`.
///
/// ```elixir
/// .including([.airport, .evCharger])
/// .excluding([.publicTransport])
/// ```
extension PointOfInterestCategories: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("all").map({ Self.all })
                ConstantAtomLiteral("excludingAll").map({ Self.excludingAll })
                Including.parser(in: context).map({ Self.including($0.categories) })
                Excluding.parser(in: context).map({ Self.excluding($0.categories) })
            }
        }
    }
    
    @ParseableExpression
    struct Including {
        static let name = "including"
        
        let categories: [MKPointOfInterestCategory]
        
        init(_ categories: [MKPointOfInterestCategory]) {
            self.categories = categories
        }
    }
    
    @ParseableExpression
    struct Excluding {
        static let name = "excluding"
        
        let categories: [MKPointOfInterestCategory]
        
        init(_ categories: [MKPointOfInterestCategory]) {
            self.categories = categories
        }
    }
}

extension MKPointOfInterestCategory: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "airport": .airport,
            "amusementPark": .amusementPark,
            "aquarium": .aquarium,
            "atm": .atm,
            "bakery": .bakery,
            "bank": .bank,
            "beach": .beach,
            "brewery": .brewery,
            "cafe": .cafe,
            "campground": .campground,
            "carRental": .carRental,
            "evCharger": .evCharger,
            "fireStation": .fireStation,
            "fitnessCenter": .fitnessCenter,
            "foodMarket": .foodMarket,
            "gasStation": .gasStation,
            "hospital": .hospital,
            "hotel": .hotel,
            "laundry": .laundry,
            "library": .library,
            "marina": .marina,
            "movieTheater": .movieTheater,
            "museum": .museum,
            "nationalPark": .nationalPark,
            "nightlife": .nightlife,
            "park": .park,
            "parking": .parking,
            "pharmacy": .pharmacy,
            "police": .police,
            "postOffice": .postOffice,
            "publicTransport": .publicTransport,
            "restaurant": .restaurant,
            "restroom": .restroom,
            "school": .school,
            "stadium": .stadium,
            "store": .store,
            "theater": .theater,
            "university": .university,
            "winery": .winery,
            "zoo": .zoo,
        ])
    }
}
