//
//  Reminders.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import SwiftUI

struct RemindersWidget: View, Widget {
    /// Protocol conformance
    var name: String = "RemindersWidget"
    var swiftUIView: AnyView {
        AnyView(self)
    }
    
    /// Body
    var body: some View {
        VStack {
            Text("Hello")
        }
    }
    
}
