//
//  DetailView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/4/21.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var listUpdater: ListUpdater
    @State var newEntry = ""
    @State var itemToModify = ListItem(title: "", createdAt: Date(), id: UUID(), index: 0, detailItems: [])
    let selectedItem: ListItem
    
    var body: some View {
        Form{
            Section {
                TextField("New Entry", text: $newEntry)
                Button("Add Entry") {
                    itemToModify.detailItems?.append(self.newEntry)
                    listUpdater.updateCurrentlySelectedItem(updatedItem: itemToModify)
                    newEntry = ""
                }
            }
            Text("Entries: ")
            List{
                ForEach(itemToModify.detailItems ?? [], id: \.self) { detailItem in
                    Text(detailItem)
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: move)
            }
        }
        .navigationBarTitle("Details for: \(itemToModify.title)")
        .navigationBarItems(trailing:
                                HStack {
                                    EditButton()
                                    Button("Save") {
                                        self.saveItem()
                                    }
                                }
        )
        .onAppear {
            itemToModify = selectedItem
        }
        .onDisappear {
            saveItem()
        }
    }
    
    func saveItem() {
        itemToModify.saveItem()
        listUpdater.reloadData()
    }
    
    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        itemToModify.detailItems?.remove(at: index)
        listUpdater.reloadData()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        itemToModify.detailItems?.move(fromOffsets: source, toOffset: destination)
        itemToModify.saveItem()
        listUpdater.reloadData()
    }
}
