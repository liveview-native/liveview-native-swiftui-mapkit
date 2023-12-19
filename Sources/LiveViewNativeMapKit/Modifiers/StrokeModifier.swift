//
//  StrokeModifier.swift
//
//
//  Created by Carson Katri on 7/25/23.
//

import SwiftUI
import MapKit
import LiveViewNative

struct StrokeModifier: ContentModifier {
    typealias Builder = MapContentBuilder
    
    let color: Color
    let style: StrokeStyle?
    
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content {
        return content.stroke(self.color, style: style ?? .init())
    }
}
