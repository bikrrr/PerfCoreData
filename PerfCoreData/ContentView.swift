//
//  ContentView.swift
//  PerfCoreData
//
//  Created by Uhl Albert on 8/19/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    List {
                        ForEach(items) { item in
                            Text("Item \(item.order)")
                                .id(item.order)  // Assign a unique ID for each item
                        }
                    }
                    .onChange(of: items.count) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                Button(action: addItems) {
                    Text("Add 50 Items")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .navigationTitle("CoreData")
            }
        }
    }

    private func addItems() {
        withAnimation {
            // Determine the current maximum order value
            let maxOrder = items.last?.order ?? 0

            for i in 1...50 {
                let newItem = Item(context: viewContext)
                newItem.order = maxOrder + Int64(i)

                do {
                    try viewContext.save()
                } catch {
                    // Handle error
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastItem = items.last {
            withAnimation {
                proxy.scrollTo(lastItem.order, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
