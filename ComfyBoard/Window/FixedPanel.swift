//
//  FixedPanel.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import AppKit


class FixedPanel: NSPanel {
    private var fixedFrame: NSRect = .zero

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func mouseDown(with event: NSEvent) {
        // Disable drag
    }
    
    
    override func setFrame(_ frameRect: NSRect, display flag: Bool) {
        // Block external moves unless we explicitly allowed it
        if fixedFrame != .zero && frameRect.origin != fixedFrame.origin {
            super.setFrame(fixedFrame, display: flag)
        } else {
            fixedFrame = frameRect
            super.setFrame(frameRect, display: flag)
        }
    }

    override func setFrameOrigin(_ point: NSPoint) {
        // Block frame origin changes
        if fixedFrame != .zero && point != fixedFrame.origin {
            return
        }
        fixedFrame.origin = point
        super.setFrameOrigin(point)
    }
}
