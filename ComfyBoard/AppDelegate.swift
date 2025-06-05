//
//  AppDelegate.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // This method is called when the application has finished launching.
        // You can perform any setup or initialization here.
        ComfyBoardWindow.shared.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        // This method is called when the application is about to terminate.
        // You can perform any cleanup here.
        ComfyBoardWindow.shared.stop()
    }
}
