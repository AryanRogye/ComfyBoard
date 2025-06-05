//
//  Reminders.swift
//  ComfyBoard
//
//  Created by Aryan Rogye on 6/5/25.
//

import SwiftUI

struct RemindersWidget: View, Widget {
    var name: String = "RemindersWidget"
    var swiftUIView: AnyView {
        AnyView(self)
    }
    
    @State private var items: [TodoItem] = []
    @State private var newItemText = ""
    @State private var selectedPriority: TodoItem.Priority = .medium
    @State private var showCompleted = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let userDefaultsKey = "ComfyBoard_TodoItems"
    
    var filteredItems: [TodoItem] {
        let visibleItems = showCompleted ? items : items.filter { !$0.isCompleted }
        return visibleItems.sorted { item1, item2 in
            if item1.isCompleted != item2.isCompleted {
                return !item1.isCompleted
            }
            if item1.priority != item2.priority {
                return priorityValue(item1.priority) > priorityValue(item2.priority)
            }
            return item1.createdAt > item2.createdAt
        }
    }
    
    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Reminders")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if !items.isEmpty {
                        Text("\(items.count - completedCount) active • \(completedCount) done")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: { showCompleted.toggle() }) {
                    Image(systemName: showCompleted ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .help(showCompleted ? "Hide completed" : "Show completed")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal, 8)
            
            // Add new item section
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    // Priority selector
                    Menu {
                        ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                            Button(action: { selectedPriority = priority }) {
                                HStack {
                                    Image(systemName: priority.icon)
                                        .foregroundColor(priority.color)
                                    Text(priority.rawValue)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: selectedPriority.icon)
                            .foregroundColor(selectedPriority.color)
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 20)
                    
                    TextField("Add reminder...", text: $newItemText)
                        .textFieldStyle(.plain)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            addItem()
                        }
                        .font(.system(size: 13))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            
            // Items list
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(filteredItems) { item in
                        TodoItemRow(
                            item: item,
                            onToggle: { toggleItem(item) },
                            onDelete: { deleteItem(item) }
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            
            if items.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green.opacity(0.6))
                    Text("No reminders yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Add one above to get started")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .onAppear {
            loadItems()
        }
        .onChange(of: items) { _ in
            saveItems()
        }
    }
    
    private func addItem() {
        let trimmedText = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            let newItem = TodoItem(
                text: trimmedText,
                priority: selectedPriority
            )
            items.insert(newItem, at: 0)
            newItemText = ""
        }
        
        // Haptic feedback
        let impactFeedback = NSHapticFeedbackManager.defaultPerformer
        impactFeedback.perform(.generic, performanceTime: .now)
    }
    
    private func toggleItem(_ item: TodoItem) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index].isCompleted.toggle()
            }
        }
        
        // Haptic feedback
        let impactFeedback = NSHapticFeedbackManager.defaultPerformer
        impactFeedback.perform(.alignment, performanceTime: .now)
    }
    
    private func deleteItem(_ item: TodoItem) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            items.removeAll { $0.id == item.id }
        }
    }
    
    private func priorityValue(_ priority: TodoItem.Priority) -> Int {
        switch priority {
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = decoded
        }
    }
}

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
                    }
                }
            }
            .buttonStyle(.plain)
            
            // Priority indicator
            if !item.isCompleted {
                Circle()
                    .fill(item.priority.color)
                    .frame(width: 6, height: 6)
            }
            
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

struct TodoItem: Identifiable, Codable, Equatable {
    let id = UUID()
    var text: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    var priority: Priority = .medium
    
    enum Priority: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "circle"
            case .medium: return "minus.circle"
            case .high: return "exclamationmark.circle"
            }
        }
    }
}
