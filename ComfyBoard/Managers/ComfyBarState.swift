//
//  ComfyBarState.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import Cocoa

enum PanelState: String, CaseIterable {
    case home
    case settings
}

class ComfyBarState: ObservableObject {
    
    static let shared = ComfyBarState()
    
    init() {
        self.createWidgetStore()
    }
    
    @Published var currentPanelState: PanelState = .home
    @Published var comfyWidgetStore: ComfyBoardWidgetStore!
}


extension ComfyBarState {
    internal func createWidgetStore() {
        self.comfyWidgetStore = ComfyBoardWidgetStore()
        
        self.comfyWidgetStore.addWidget(RemindersWidget())
    }
}
