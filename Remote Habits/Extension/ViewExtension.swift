import Foundation
import SwiftUI

extension View {
    func binding<Value>(_ getValue: @escaping () -> Value) -> Binding<Value> {
        Binding.get(getValue)
    }
}

extension Binding {
    static func get(_ getValue: @escaping () -> Value) -> Binding<Value> {
        Binding(get: getValue, set: { _ in })
    }
}
