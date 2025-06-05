//
//  ComfyBoardWindow.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//
import AppKit
import SwiftUI

final class ComfyBoardWindow: NSObject {
    
    enum side {
        case left
        case right
    }
    
    static let shared = ComfyBoardWindow()
    
    private var comfyBoard: FixedPanel!
    
    private let comfyBoardWidth     : CGFloat = 200
    private let comfyBoardHeight    : CGFloat = NSScreen.main?.frame.height ?? 600
    private let comfyBoardSide      : side    = .left
    
    func start() {
        createWindow()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            DispatchQueue.global(qos: .userInitiated).async {
                OtherWindowsWatcher.shared.adjustAllWindows()
            }
        }
    }
    
    func stop() {
        /// Destroy the window
        comfyBoard?.close()
        comfyBoard?.orderOut(nil)
        comfyBoard?.contentView = nil
        comfyBoard?.delegate = nil
    }
    
    private func createWindow() {
        comfyBoard?.setFrame(NSRect(x: 0, y: 0, width: comfyBoardWidth, height: comfyBoardHeight), display: true)
        comfyBoard = FixedPanel(
            contentRect: NSRect(x: 0, y: 0, width: comfyBoardWidth, height: comfyBoardHeight),
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        comfyBoard?.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle
        ]
        comfyBoard?.isFloatingPanel = true
//        comfyBoard?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        comfyBoard?.level = .normal
        comfyBoard?.backgroundColor = NSColor.black
        comfyBoard?.titleVisibility = .hidden
        comfyBoard?.titlebarAppearsTransparent = true
        comfyBoard?.styleMask.insert(.fullSizeContentView)
        
        let blurView = NSVisualEffectView(frame: comfyBoard.contentView!.bounds)
        blurView.autoresizingMask = [.width, .height]
        blurView.blendingMode = .behindWindow
        blurView.material = .sidebar // You can try .hudWindow, .toolTip, etc.
        blurView.state = .active
        
        /// Add A NSHostingView of ComfyBarView
        let comfyBarView = ComfyBarView()
        let hostingView = NSHostingView(rootView: comfyBarView)
        hostingView.frame = blurView.bounds
        hostingView.autoresizingMask = [.width, .height]
        blurView.addSubview(hostingView)
        
        comfyBoard.contentView = blurView
        
        comfyBoard?.makeKeyAndOrderFront(nil)
    }
}
