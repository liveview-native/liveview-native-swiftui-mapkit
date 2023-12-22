import LiveViewNative
import SwiftUI

/// A registry that includes the ``Map`` element and associated modifiers.
public enum MapKitRegistry<Root: RootRegistry>: CustomRegistry {
    public enum TagName: String {
        case map = "Map"
        case lookAroundPreview = "LookAroundPreview"
    }
    
    public enum ModifierType: String, Decodable {
        case lookAroundViewer = "look_around_viewer"
    }
    
    public static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .map:
            Map<Root>()
        case .lookAroundPreview:
            LookAroundPreview()
        }
    }
    
    public static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .lookAroundViewer:
            try LookAroundViewerModifier(from: decoder)
        }
    }
}
