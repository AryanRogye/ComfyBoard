//
//  ComfyBarView.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/4/25.
//

import SwiftUI

struct ComfyBarView: View {
    
    @StateObject private var comfyBarState : ComfyBarState = .shared
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading,spacing: 0) {
                
                /// Way To Switch Between Panels
                
                /// see QuickAccessWidget.swift file to see how it works
                switch comfyBarState.currentPanelState {
                case .home:         HomeComfyBarView(comfyBarState: comfyBarState).equatable()
                case .settings:     EmptyView()
                }
                
                Spacer()
            }
        }
    }
}

