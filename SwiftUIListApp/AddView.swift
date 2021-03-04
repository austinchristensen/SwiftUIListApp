//
//  AddView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import SwiftUI

struct AddView: View {
    @Binding var isPresented: Bool
    @State var title = ""
    @State var newEntry = ""
    @State var newItemToCreate = ListItem(title: "", createdAt: Date(), id: UUID(), index: 0, detailItems: [])
    @ObservedObject var listUpdater: ListUpdater
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section {
                        TextField("Title", text: $title )
                        TextField("New Entry", text: $newEntry)
                        Button("Add Entry") {
                            newItemToCreate.detailItems?.append(self.newEntry)
                            listUpdater.updateCurrentlySelectedItem(updatedItem: newItemToCreate)
                            newEntry = ""
                        }
                    }
                    Text("New Entries: ")
                    List{
                        ForEach(newItemToCreate.detailItems ?? [], id: \.self) { entry in
                            Text(entry)
                        }
                        .onDelete(perform: deleteItem)
                    }
                }
            }
            .navigationBarTitle("New List")
            .navigationBarItems(trailing: Button("Save") {
                saveItem()
            })
        }
    }
    
    func updateItem() {
        
    }
    
    func saveItem() {
        guard title != "" else {
            isPresented = false
            return
        }
        
        newItemToCreate.title = title
        
        newItemToCreate.saveItem()
        
        listUpdater.reloadData()
        
        isPresented = false
    }
    
    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        newItemToCreate.detailItems?.remove(at: index)
    }
}
