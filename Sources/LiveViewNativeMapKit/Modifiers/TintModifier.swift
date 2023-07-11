//
//  TintModifier.swift
//
//
//  Created by Carson Katri on 7/11/23.
//

import SwiftUI
import MapKit
import LiveViewNative

struct TintModifier: ContentModifier {
    typealias Builder = MapContentBuilder
    
    let color: Color
    
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content {
        content.tint(color)
    }
}
