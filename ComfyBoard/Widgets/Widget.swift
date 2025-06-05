//
//  Widget.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import AppKit
import SwiftUI


/**
 * WidgetEntry represents a widget and its visibility state in the panel.
 * This struct is used to track both the widget itself and whether it's currently visible.
 *
 * Properties:
 * - widget: The Widget instance
 * - isVisible: Boolean flag indicating if the widget is currently visible
 */
struct WidgetEntry: Equatable, Identifiable {
    let id = UUID()
    var widget: Widget
    var isVisible: Bool
    
    static func == (lhs: WidgetEntry, rhs: WidgetEntry) -> Bool {
        lhs.widget.name == rhs.widget.name &&
        lhs.isVisible == rhs.isVisible
    }
}

/**
 * Widget protocol defines the basic structure for all panel widgets.
 * This protocol ensures all widgets have consistent properties for
 * identification, positioning, and view representation.
 *
 * Required Properties:
 * - name: Unique identifier for the widget
 * - swiftUIView: The widget's visual representation
 */
protocol Widget {
    /// Unique identifier for the widget
    var name: String { get }
    
    /// SwiftUI view representation of the widget
    var swiftUIView: AnyView { get }
}
