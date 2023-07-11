//
//  MapInteractionModes.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftUI
import MapKit
import LiveViewNative
import LiveViewNativeCore

/// The allowed interactions on a ``Map``.
///
/// Possible values:
/// * `all`
/// * `pan`
/// * `pitch`
/// * `rotate`
/// * `zoom`
/// * A comma-separate list of these values
extension MapInteractionModes: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        let modes = value.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        self = []
        for mode in modes {
            switch mode {
            case "all":
                self.insert(.all)
            case "pan":
                self.insert(.pan)
            case "pitch":
                self.insert(.pitch)
            case "rotate":
                self.insert(.rotate)
            case "zoom":
                self.insert(.zoom)
            default:
                throw AttributeDecodingError.badValue(Self.self)
            }
        }
    }
}
