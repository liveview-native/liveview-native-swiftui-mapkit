//
//  File.swift
//  
//
//  Created by Carson.Katri on 7/11/23.
//

import SwiftUI
import LiveViewNative
import MapKit

/// Display a preview for look around.
///
/// When the preview is tapped, a look around viewer will be opened.
///
/// Set the ``latitude`` and ``longitude`` for the preview, and configure any options for the viewer when opened.
/// Add the ``allowsNavigation`` and ``showsRoadLabels`` attributes to create a fully-featured viewer.
///
/// ```html
/// <LookAroundPreview latitude={38.8951} longitude={-77.0364} allows-navigation shows-road-labels />
/// ```
///
/// ## Attributes
/// * ``latitude``
/// * ``longitude``
/// * ``allowsNavigation``
/// * ``showsRoadLabels``
/// * ``pointsOfInterestIncluding``
/// * ``pointsOfInterestExcluding``
/// * ``pointsOfInterestExcludeAll``
/// * ``badgePosition``
struct LookAroundPreview: View {
    @ObservedElement private var element
    
    /// The start latitude of the viewer.
    @_documentation(visibility: public)
    @Attribute("latitude") private var latitude: Double
    
    /// The start longitude of the viewer.
    @_documentation(visibility: public)
    @Attribute("longitude") private var longitude: Double

    /// Allow the user to navigate within the viewer. Defaults to `true`.
    @_documentation(visibility: public)
    @Attribute("allows-navigation") private var allowsNavigation = false

    /// Enable/disable road labels on the viewer. Defaults to `true`.
    @_documentation(visibility: public)
    @Attribute("shows-road-labels") private var showsRoadLabels = false

    /// Enable certain point of interest categories.
    ///
    /// A comma separated list of categories.
    ///
    /// See ``LiveViewNativeMapKit/_MapKit_SwiftUI/PointOfInterestCategories`` for more details.
    @_documentation(visibility: public)
    @Attribute("points-of-interest", transform: {
        guard let value = $0?.value
        else { return [] }
        return value.split(separator: ",").map({ MKPointOfInterestCategory(rawValue: String($0)) })
    }) private var pointsOfInterestIncluding: [MKPointOfInterestCategory]
    
    /// Disable certain point of interest categories.
    ///
    /// A comma separated list of categories.
    ///
    /// See ``LiveViewNativeMapKit/_MapKit_SwiftUI/PointOfInterestCategories`` for more details.
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "points-of-interest", name: "excluding"), transform: {
        guard let value = $0?.value
        else { return [] }
        return value.split(separator: ",").map({ MKPointOfInterestCategory(rawValue: String($0)) })
    }) private var pointsOfInterestExcluding: [MKPointOfInterestCategory]
    
    /// Exclude all point of interest categories.
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "points-of-interest", name: "exclude-all")) private var pointsOfInterestExcludeAll: Bool = false
    
    /// The position of the look around badge.
    ///
    /// Possible values:
    /// * `top_leading`
    /// * `top_trailing`
    /// * `bottom_trailing`
    @_documentation(visibility: public)
    @Attribute("badge-position", transform: {
        switch $0?.value {
        case "top_leading":
            return .topLeading
        case "top_trailing":
            return .topTrailing
        case "bottom_trailing":
            return .bottomTrailing
        default:
            return .topLeading
        }
    }) private var badgePosition: MKLookAroundBadgePosition = .topLeading
    
    @State private var resolvedScene: MKLookAroundScene?
    
    var pointsOfInterest: PointOfInterestCategories {
        if !pointsOfInterestIncluding.isEmpty {
            return .including(pointsOfInterestIncluding)
        } else if !pointsOfInterestExcluding.isEmpty {
            return .excluding(pointsOfInterestExcluding)
        } else if pointsOfInterestExcludeAll {
            return .excludingAll
        } else {
            return .all
        }
    }
    
    var body: some View {
        MapKit.LookAroundPreview(initialScene: resolvedScene, allowsNavigation: allowsNavigation, showsRoadLabels: showsRoadLabels, pointsOfInterest: pointsOfInterest, badgePosition: badgePosition)
            .task(id: TaskID(coordinate: .init(latitude: latitude, longitude: longitude))) {
                let request = MKLookAroundSceneRequest(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                self.resolvedScene = try! await request.scene
            }
    }
    
    struct TaskID: Equatable {
        let latitude: Double
        let longitude: Double
        
        init(coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
    }
}
