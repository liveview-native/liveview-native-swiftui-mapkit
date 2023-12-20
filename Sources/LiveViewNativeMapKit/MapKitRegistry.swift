import LiveViewNative
import LiveViewNativeStylesheet
import SwiftUI

/// A registry that includes the ``Map`` element and associated modifiers.
public enum MapKitRegistry<Root: RootRegistry>: CustomRegistry {
    public enum TagName: String {
        case map = "Map"
    }
    
    public static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .map:
            Map<Root>()
        }
    }
    
    public struct CustomModifier: ViewModifier, ParseableModifierValue {
        enum Storage {
            case lookAroundViewer(LookAroundViewerModifier)
            case noop
        }
        
        let storage: Storage
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                LookAroundViewerModifier.parser(in: context).map({ Self(storage: .lookAroundViewer($0)) })
                MapContentBuilder.ModifierType.parser(in: context).map({ _ in Self(storage: .noop) })
            }
        }
        
        public func body(content: Content) -> some View {
            switch storage {
            case .lookAroundViewer(let lookAroundViewerModifier):
                content.modifier(lookAroundViewerModifier)
            case .noop:
                content
            }
        }
    }
}
