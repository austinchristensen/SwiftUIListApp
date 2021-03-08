//
//  ContentView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddItem = false
    @ObservedObject var updater = ListUpdater()
    
    var body: some View {
        let addNewItemView = AddView(isPresented: $showingAddItem, listUpdater: updater)
        
        NavigationView {
            List {
                ForEach(updater.mainItemsList, id: \.id) { item in
                    NavigationLink(destination: DetailView(listUpdater: updater, selectedItem: item)) {
                        Text(item.title)
                    }
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: move)
            }
            .navigationBarTitle("List it to me baby!")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showingAddItem.toggle()
            })
            .sheet(isPresented: $showingAddItem, content: {
                addNewItemView
            })
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let itemToDelete = updater.mainItemsList[index]
        itemToDelete.deleteItem()
        updater.reloadData()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        updater.mainItemsList.move(fromOffsets: source, toOffset: destination)
        for item in updater.mainItemsList {
            var updatedItem = item
            guard let updatedIndex = updater.mainItemsList.firstIndex(where: {$0.id == item.id} ) else { return }
            updatedItem.index = updatedIndex
            updatedItem.saveItem()
        }
        updater.reloadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
