//
//  ForegroundStyleModifier.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

struct ForegroundStyleModifier: ContentModifier {
    typealias Builder = MapContentBuilder
    
    let primary: AnyShapeStyle
    
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content {
        content.foregroundStyle(primary)
    }
}
