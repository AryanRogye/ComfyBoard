//
//  TodoItemRow.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import SwiftUI

struct TodoItemRow: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Checkbox
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(
                            item.isCompleted ? item.priority.color : Color.secondary.opacity(0.5),
                            lineWidth: 1.5
                        )
                        .frame(width: 16, height: 16)
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(item.priority.color)
                    } else {
                        // this helps keep the tappable zone alive
                        Color.clear.frame(width: 10, height: 10)
                    }
                }
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            
            // Text
            Text(item.text)
                .font(.system(size: 12))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Delete button (shown on hover)
            if isHovered {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 10))
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isHovered ? Color.white.opacity(0.08) : Color.clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .contextMenu {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            
            Button(item.isCompleted ? "Mark Incomplete" : "Mark Complete") {
                onToggle()
            }
        }
    }
}
