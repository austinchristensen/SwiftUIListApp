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
            List{
                ForEach(updater.mainItemsList, id: \.id) { item in
                    Text(item.title)
                }
                .onDelete(perform: deleteItem)
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
    
    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let itemToDelete = updater.mainItemsList[index]
        itemToDelete.deleteItem()
        updater.reloadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
