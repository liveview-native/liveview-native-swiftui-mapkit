import LiveViewNative
import SwiftUI

public enum MapKitRegistry<Root: RootRegistry>: CustomRegistry {
    public enum TagName: String {
        case map = "Map"
    }
    
    public enum ModifierType: String, Decodable {
        case lookAroundViewer = "look_around_viewer"
    }
    
    public static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .map:
            Map<Root>()
        }
    }
    
    public static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .lookAroundViewer:
            try LookAroundViewerModifier(from: decoder)
        }
    }
}
