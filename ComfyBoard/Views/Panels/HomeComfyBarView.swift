//
//  HomeComfyBarView.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import SwiftUI

struct HomeComfyBarView: View, Equatable {
    
    @ObservedObject private var comfyBarState : ComfyBarState
    
    /// PreComputed
    private var topPadding : CGFloat = 50
    
    init(comfyBarState: ComfyBarState) {
        self.comfyBarState = comfyBarState
    }
    
    static func == (lhs: HomeComfyBarView, rhs: HomeComfyBarView) -> Bool {
        return lhs.comfyBarState.comfyWidgetStore.widgets == rhs.comfyBarState.comfyWidgetStore.widgets
    }
    
    var body: some View {
        VStack {
            ForEach(comfyBarState.comfyWidgetStore.widgets.indices, id: \.self) { index in
                let widgetEntry = comfyBarState.comfyWidgetStore.widgets[index]
                
                if widgetEntry.isVisible {
                    VStack {
                        widgetEntry.widget.swiftUIView
                    }
                }
            }
            .padding(.top, topPadding)
        }
    }
}
