//
//  LookAroundViewerModifier.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

struct LookAroundViewerModifier: ViewModifier, Decodable {
    @LiveBinding private var isPresented: Bool
    private let initialScene: CLLocationCoordinate2D?
    private let allowsNavigation: Bool
    private let showsRoadLabels: Bool
    private let pointsOfInterest: PointOfInterestCategories
    @Event private var onDismiss: Event.EventHandler
    
    @State private var resolvedScene: MKLookAroundScene?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._isPresented = try LiveBinding(decoding: .isPresented, in: container)
        self._onDismiss = try container.decode(Event.self, forKey: .onDismiss)
        self.initialScene = try container.decodeIfPresent(CLLocationCoordinate2D.self, forKey: .initialScene)
        self.allowsNavigation = try container.decode(Bool.self, forKey: .allowsNavigation)
        self.showsRoadLabels = try container.decode(Bool.self, forKey: .showsRoadLabels)
        self.pointsOfInterest = try container.decode(PointOfInterestCategories.self, forKey: .pointsOfInterest)
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
