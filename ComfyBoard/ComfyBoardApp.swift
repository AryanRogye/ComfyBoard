//
//  ComfyBoardApp.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import SwiftUI

@main
struct ComfyBoardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        /// Show Nothing
        WindowGroup {
        }
        .defaultLaunchBehavior(.suppressed)
    }
}
