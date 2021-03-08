//
//  AddView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import SwiftUI

struct AddView: View {
    @Binding var isPresented: Bool
    @State var showErrorMessage: Bool = false
    @State var title = ""
    @State var newEntry = ""
    @State var newItemToCreate = ListItem(title: "", createdAt: Date(), id: UUID(), index: 0, detailItems: [])
    @ObservedObject var listUpdater: ListUpdater
    
    var body: some View {
        NavigationView {
            Form{
                Section {
                    TextField("Title", text: $title)
                    TextField("New Entry", text: $newEntry)
                    Button("Add Entry") {
                        if newEntry != "" {
                           newItemToCreate.detailItems?.append(newEntry)
                        }
                        newEntry = ""
                    }
                }
                .alert(isPresented: $showErrorMessage) {
                                    Alert(title: Text("Error"), message: Text("Title is required"), dismissButton: .default(Text("OK")))
                                }
                Text("New Entries: ")
                List{
                    ForEach(newItemToCreate.detailItems ?? [], id: \.self) { entry in
                        Text(entry)
                    }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: move)
                }
            }
            .navigationBarTitle("New List")
            .navigationBarItems(trailing:
                                    HStack{
                                        EditButton()
                                        Button("Save") {
                                            saveItem()
                                        }
                                    }
            )
        }
    }
    
    func saveItem() {
        guard title != "" else {
            showErrorMessage.toggle()
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
    
    func move(from source: IndexSet, to destination: Int) {
        newItemToCreate.detailItems?.move(fromOffsets: source, toOffset: destination)
    }
}
