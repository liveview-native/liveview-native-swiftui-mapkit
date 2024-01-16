//
//  ForegroundStyleModifier.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeStylesheet

@ParseableExpression
struct ForegroundStyleModifier: ContentModifier {
    typealias Builder = MapContentBuilder
    
    static let name = "foregroundStyle"
    
    let style: AnyShapeStyle
    
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content {
        content.foregroundStyle(style)
    }
    
    init(_ style: AnyShapeStyle) {
        self.style = style
    }
}
