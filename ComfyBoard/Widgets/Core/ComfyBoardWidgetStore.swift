//
//  ComfyBoardWidgetStore.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import Foundation

class ComfyBoardWidgetStore: PanelManager, ObservableObject {
    
    @Published var widgets: [WidgetEntry] = []

    func hideWidget(named name: String) {
        
    }
    
    func showWidget(named name: String) {
        
    }
    
    func clearWidgets() {
        
    }
    
    
    func addWidget(_ widget: Widget) {
        let widgetEntry = WidgetEntry(widget: widget, isVisible: true) // Default visible
        widgets.append(widgetEntry)
    }
    
    func removeWidget(named name: String) {
//        withAnimation(Anim.spring) {
            widgets.removeAll { $0.widget.name == name }
//        }
    }
    
    func toggleWidget(named name: String) {
        if let index = widgets.firstIndex(where: { $0.widget.name == name }) {
            widgets[index].isVisible.toggle()
        }
    }

}
