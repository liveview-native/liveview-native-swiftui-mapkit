//
//  LookAroundViewerModifier.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

/// Present a look-around viewer at a specific coordinate.
/// 
/// Use the ``isPresented`` binding to show/hide the viewer.
/// Set the ``initialScene`` to change the location of the viewer.
/// 
/// ```elixir
/// look_around_viewer(is_presented: :show_viewer, initial_scene: [40.730610, -73.935242])
/// ```
/// 
/// ## Arguments
/// * ``isPresented``
/// * ``initialScene``
/// * ``allowsNavigation``
/// * ``showsRoadLabels``
/// * ``pointsOfInterest``
/// * ``onDismiss``
@_documentation(visibility: public)
struct LookAroundViewerModifier: ViewModifier, Decodable {
    /// A native binding that synchronizes the presentation of the viewer.
    @_documentation(visibility: public)
    @LiveBinding private var isPresented: Bool

    /// The start location of the viewer.
    @_documentation(visibility: public)
    private let initialScene: CLLocationCoordinate2D?

    /// Allow the user to navigate within the viewer. Defaults to `true`.
    @_documentation(visibility: public)
    private let allowsNavigation: Bool

    /// Enable/disable road labels on the viewer. Defaults to `true`.
    @_documentation(visibility: public)
    private let showsRoadLabels: Bool

    /// Enable/disable certain point of interest categories.
    /// 
    /// See ``LiveViewNativeMapKit/_MapKit_SwiftUI/PointOfInterestCategories`` for more details.
    @_documentation(visibility: public)
    private let pointsOfInterest: PointOfInterestCategories

    /// The event to call when the viewer is closed.
    @_documentation(visibility: public)
    @Event private var onDismiss: Event.EventHandler
    
    @State private var resolvedScene: MKLookAroundScene?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._isPresented = try LiveBinding(decoding: .isPresented, in: container)
        self._onDismiss = try container.decode(Event.self, forKey: .onDismiss)
        self.initialScene = try container.decodeIfPresent(CLLocationCoordinate2D.self, forKey: .initialScene)
        self.allowsNavigation = try container.decode(Bool.self, forKey: .allowsNavigation)
        self.showsRoadLabels = try container.decode(Bool.self, forKey: .showsRoadLabels)
        self.pointsOfInterest = try container.decodeIfPresent(PointOfInterestCategories.self, forKey: .pointsOfInterest) ?? .all
    }
    
    func body(content: Content) -> some View {
        content.lookAroundViewer(
            isPresented: $isPresented,
            initialScene: resolvedScene,
            allowsNavigation: allowsNavigation,
            showsRoadLabels: showsRoadLabels,
            pointsOfInterest: pointsOfInterest
        ) {
            onDismiss()
        }
        .task(id: initialScene.map(TaskID.init)) {
            guard let initialScene else { return }
            let request = MKLookAroundSceneRequest(coordinate: initialScene)
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
    
    enum CodingKeys: CodingKey {
        case isPresented
        case initialScene
        case allowsNavigation
        case showsRoadLabels
        case pointsOfInterest
        case onDismiss
    }
}
