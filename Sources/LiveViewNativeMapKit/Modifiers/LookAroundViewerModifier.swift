//
//  LookAroundViewerModifier.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeStylesheet

/// Present a look-around viewer at a specific coordinate.
/// 
/// Use the ``isPresented`` binding to show/hide the viewer.
/// Set the ``initialScene`` to change the location of the viewer.
/// 
/// ```elixir
/// lookAroundViewer(is_presented: attr("show_viewer"), initial_scene: [40.730610, -73.935242])
/// ```
/// 
/// ## Arguments
/// * ``isPresented``
/// * ``initialScene``
/// * ``allowsNavigation``
/// * ``showsRoadLabels``
/// * ``pointsOfInterest``
/// * ``onDismiss``
@ParseableExpression
struct LookAroundViewerModifier: ViewModifier {
    static let name = "lookAroundViewer"
    
    /// A native binding that synchronizes the presentation of the viewer.
    @ChangeTracked private var isPresented: Bool

    /// The start location of the viewer.
    private let initialScene: CLLocationCoordinate2D?

    /// Allow the user to navigate within the viewer. Defaults to `true`.
    private let allowsNavigation: Bool

    /// Enable/disable road labels on the viewer. Defaults to `true`.
    private let showsRoadLabels: Bool

    /// Enable/disable certain point of interest categories.
    /// 
    /// See ``LiveViewNativeMapKit/_MapKit_SwiftUI/PointOfInterestCategories`` for more details.
    private let pointsOfInterest: PointOfInterestCategories

    /// The event to call when the viewer is closed.
    @Event private var onDismiss: Event.EventHandler
    
    @State private var resolvedScene: MKLookAroundScene?
    
    init(
        isPresented: ChangeTracked<Bool>,
        initialScene: CLLocationCoordinate2D?,
        allowsNavigation: Bool = true,
        showsRoadLabels: Bool = true,
        pointsOfInterest: PointOfInterestCategories = .all,
        onDismiss: Event? = nil
    ) {
        self._isPresented = isPresented
        self.initialScene = initialScene
        self.allowsNavigation = allowsNavigation
        self.showsRoadLabels = showsRoadLabels
        self.pointsOfInterest = pointsOfInterest
        self._onDismiss = onDismiss ?? Event()
    }
    
    func body(content: Content) -> some View {
        content
        #if os(iOS)
            .lookAroundViewer(
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
        #endif
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
