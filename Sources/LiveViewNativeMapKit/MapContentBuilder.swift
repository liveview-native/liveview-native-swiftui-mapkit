//
//  MapContentBuilder.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeStylesheet

enum MapContentBuilder: ContentBuilder {
    enum TagName: String {
        case marker = "Marker"
    }
    
    enum ModifierType: ContentModifier {
        typealias Builder = MapContentBuilder
        
        case foregroundStyle(ForegroundStyleModifier)
        case tint(TintModifier)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                ForegroundStyleModifier.parser(in: context).map(Self.foregroundStyle)
                TintModifier.parser(in: context).map(Self.tint)
            }
        }
        
        func apply<R>(
            to content: Builder.Content,
            on element: ElementNode,
            in context: Builder.Context<R>
        ) -> Builder.Content where R : RootRegistry {
            switch self {
            case .foregroundStyle(let modifier):
                return modifier.apply(to: content, on: element, in: context)
            case .tint(let modifier):
                return modifier.apply(to: content, on: element, in: context)
            }
        }
    }
    
    typealias Content = any MapContent
    
    static func lookup<R: RootRegistry>(_ tag: TagName, element: ElementNode, context: Context<R>) -> Content {
        let content = switch tag {
        case .marker:
            try! Marker<R>(element: element, context: context)
        }
        func applyTag(_ content: some MapContent) -> Content {
            if let tag = element.attributeValue(for: "tag") {
                return content.tag(tag)
            } else {
                return content
            }
        }
        return applyTag(content)
    }
    
    static func empty() -> Content {
        EmptyMapContent()
    }
    
    static func reduce(accumulated: Content, next: Content) -> Content {
        unbox(accumulated: accumulated, next: next)
    }
    
    static func unbox(accumulated: some MapContent, next: some MapContent) -> Content {
        return MapKit.MapContentBuilder.buildBlock(accumulated, next)
    }
}
