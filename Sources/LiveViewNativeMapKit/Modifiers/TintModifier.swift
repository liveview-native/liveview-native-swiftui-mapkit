//
//  TintModifier.swift
//
//
//  Created by Carson Katri on 7/11/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeStylesheet

@ParseableExpression
struct TintModifier: ContentModifier {
    typealias Builder = MapContentBuilder
    
    static let name = "tint"
    
    let color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content {
        content.tint(color)
    }
}
