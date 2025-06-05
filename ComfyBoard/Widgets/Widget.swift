//
//  Widget.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import AppKit
import SwiftUI

/**
 * Widget protocol defines the basic structure for all panel widgets.
 * This protocol ensures all widgets have consistent properties for
 * identification, positioning, and view representation.
 *
 * Required Properties:
 * - name: Unique identifier for the widget
 * - alignment: Optional alignment preference (left/right)
 * - swiftUIView: The widget's visual representation
 */
protocol Widget {
    /// Unique identifier for the widget
    var name: String { get }

    /// SwiftUI view representation of the widget
    var swiftUIView: AnyView { get }
}
