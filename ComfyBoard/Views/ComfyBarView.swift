//
//  ComfyBarView.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import SwiftUI

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
        let comfyBoardWidgetStore = ComfyBoardWidgetStore()
    }
}

struct ComfyBarView: View {
    
    @StateObject private var comfyBarState : ComfyBarState = .shared
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading,spacing: 0) {
                
                /// Way To Switch Between Panels
                
                /// see QuickAccessWidget.swift file to see how it works
                switch comfyBarState.currentPanelState {
                case .home:         HomeComfyBarView()
                case .settings:     EmptyView()
                }
                
                Spacer()
            }
        }
    }
}

