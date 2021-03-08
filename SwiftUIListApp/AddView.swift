//
//  AddView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import SwiftUI

struct AddView: View {
    @Binding var isPresented: Bool
    @ObservedObject var listUpdater: ListUpdater
    
    @State private var showErrorMessage: Bool = false
    @State private var title = ""
    @State private var newEntry = ""
    @State private var newItemToCreate = ListItem(title: "", createdAt: Date(), id: UUID(), index: 0, detailItems: [])
    
    var body: some View {
        NavigationView {
            Form {
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
                Text("New Entries:")
                List {
                    ForEach(newItemToCreate.detailItems ?? [], id: \.self) { detailItem in
                        Text(detailItem)
                    }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: move)
                }
            }
            .navigationBarTitle("New List")
            .navigationBarItems(trailing: HStack {
                EditButton()
                Button("Save") {
                    saveItem()
                }
            })
        }
    }
    
    private func saveItem() {
        guard title != "" else {
            showErrorMessage.toggle()
            return
        }
        
        newItemToCreate.title = title
        
        newItemToCreate.saveItem()
        
        listUpdater.reloadData()
        
        isPresented = false
    }
    
    private func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        newItemToCreate.detailItems?.remove(at: index)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        newItemToCreate.detailItems?.move(fromOffsets: source, toOffset: destination)
    }
}
