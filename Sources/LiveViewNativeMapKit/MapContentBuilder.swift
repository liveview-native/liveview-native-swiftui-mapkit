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
    }
    
    typealias Content = any MapContent
    
    static func lookup<R: RootRegistry>(_ tag: TagName, element: ElementNode, context: Context<R>) -> Content {
        switch tag {
        case .marker:
            return EmptyMapContent()
        }
    }
    
    static func decodeModifier<R: RootRegistry>(_ type: ModifierType, from decoder: Decoder, registry _: R.Type) throws -> any ContentModifier<MapContentBuilder> {
        switch type {
        case .foregroundStyle:
            return try ForegroundStyleModifier(from: decoder)
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
