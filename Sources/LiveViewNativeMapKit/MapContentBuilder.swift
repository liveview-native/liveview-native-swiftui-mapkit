//
//  MapContentBuilder.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative

enum MapContentBuilder: ContentBuilder {
    enum TagName: String {
        case marker = "Marker"
    }
    
    enum ModifierType: String, Decodable {
        case foregroundStyle = "foreground_style"
        case tint
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
    
    static func decodeModifier<R: RootRegistry>(_ type: ModifierType, from decoder: Decoder, registry _: R.Type) throws -> any ContentModifier<MapContentBuilder> {
        switch type {
        case .foregroundStyle:
            return try ForegroundStyleModifier(from: decoder)
        case .tint:
            return try TintModifier(from: decoder)
        }
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
