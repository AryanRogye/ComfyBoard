//
//  OtherWindowWatcher.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import Cocoa
import ApplicationServices

final class OtherWindowsWatcher {
    
    static let shared = OtherWindowsWatcher()
    private let avoidLeftInset: CGFloat = 200
    
    func isFullScreenSpaceActive() -> Bool {
        for screen in NSScreen.screens {
            if let description = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
                let options = CGDisplayCopyDisplayMode(description)
                if options == nil {
                    return true // Display is likely in a fullscreen space
                }
            }
        }
        return false
    }
    
    func adjustAllWindows() {
        
        /// If In FullScreen Just Return Early
        if isFullScreenSpaceActive() {
            print("⚠️ Application is in Full Screen mode, skipping window adjustments.")
            return
        }
        
        // Ensure accessibility permissions are granted
        let runningApps = NSWorkspace.shared.runningApplications
        
        for app in runningApps {
            guard
                app.processIdentifier != 0,
                app.bundleIdentifier != Bundle.main.bundleIdentifier,
                !app.isHidden,
                app.activationPolicy == .regular
            else { continue }
            
            let appElement = AXUIElementCreateApplication(app.processIdentifier)
            
            var value: CFTypeRef?
            let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &value)
            
            
            if result != .success {
                print("⚠️ Could not get windows for app: \(app.localizedName ?? "Unknown")")
                continue
            }
            
            guard let value = value else { return }
            let windows = (value as! NSArray) as! [AXUIElement]
            
            for window in windows {
                //                print("✅ Found window for: \(app.localizedName ?? "Unknown")")
                adjustWindowIfNeeded(window)
            }
        }
    }
    
    private func adjustWindowIfNeeded(_ window: AXUIElement) {
        var isSettable:DarwinBoolean = false
        var isPositionSettable: DarwinBoolean = false
        var isSizeSettable: DarwinBoolean = false
        
        let result = AXUIElementIsAttributeSettable(window, kAXPositionAttribute as CFString, &isSettable)
        
        if result == .success, !isSettable.boolValue {
            return
        }
        
        var position: CFTypeRef?
        var size: CFTypeRef?
        
        let posResult = AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &position)
        let sizeResult = AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &size)
        
        let isPosSettableResult = AXUIElementIsAttributeSettable(window, kAXPositionAttribute as CFString, &isPositionSettable)
        let isSizeSettableResult = AXUIElementIsAttributeSettable(window, kAXSizeAttribute as CFString, &isSizeSettable)
        
        if isPosSettableResult != .success || isSizeSettableResult != .success ||
            !isPositionSettable.boolValue || !isSizeSettable.boolValue {
            return
        }
        
        guard posResult == .success, sizeResult == .success,
              let position = position, let size = size,
              CFGetTypeID(position) == AXValueGetTypeID(),
              CFGetTypeID(size) == AXValueGetTypeID()
        else {
            print("Failed to unwrap AXValue for window: \(window)")
            return
        }
        
        let posVal = position as! AXValue
        let sizeVal = size as! AXValue
        
        var point = CGPoint.zero
        var sizeStruct = CGSize.zero
        AXValueGetValue(posVal, .cgPoint, &point)
        AXValueGetValue(sizeVal, .cgSize, &sizeStruct)
        
//        print("Current position: \(point), size: \(sizeStruct)")
//        print("App Name: \(getAppName(for: window))")
        
        if point.x < avoidLeftInset {
            point.x = avoidLeftInset
            sizeStruct.width = max(400, sizeStruct.width - avoidLeftInset) // prevent collapsing too far
            
            let newPos = AXValueCreate(.cgPoint, &point)!
            let newSize = AXValueCreate(.cgSize, &sizeStruct)!
            
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, newPos)
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, newSize)
            
            //            print("✅ Resized window to avoid ComfyBoard. New position: \(point), size: \(sizeStruct)")
        }
    }
    
    private func getAppName(for window: AXUIElement) -> String {
        var appName: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &appName)
        
        if result == .success, let name = appName as? String {
            return name
        }
        
        return "Unknown App"
    }
}
