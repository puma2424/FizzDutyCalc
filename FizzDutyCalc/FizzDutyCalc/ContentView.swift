//
//  ContentView.swift
//  FizzDutyCalc
//
//  Created by 莊羚羊 on 2025/11/15.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            VStack {
                VStack {
                    HStack {
                        Text("總金額：")
                        Spacer()
                        Text("0")
                    }
                    .padding(5)
                    Divider()
                    HStack {
                        Text("酒稅：")
                        Spacer()
                        Text("0")
                    }
                    .padding(5)
                    HStack {
                        Text("關稅：")
                        Spacer()
                        Text("0")
                    }
                    .padding(5)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 12)

                List {
                    ForEach(items) { item in
                        Text("\(item)")
                    }
                    .onDelete(perform: deleteItems)

                }
            }
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: - 不同行程與選擇
                    } label: {
                        Label("Folder", systemImage: "folder")
                    }

                }
            }
            .navigationTitle("日本")
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
