//
//  DetailView.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/4/21.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var listUpdater: ListUpdater
    let selectedItem: ListItem
    
    @State private var showErrorMessage: Bool = false
    @State private var hasSaved: Bool = false
    @State private var newEntry = ""
    @State private var itemToModify = ListItem(title: "", createdAt: Date(), id: UUID(), index: 0, detailItems: [])
    
    private var backButton : some View { Button(action: {
        if (selectedItem.detailItems == itemToModify.detailItems) {
            self.presentationMode.wrappedValue.dismiss()
        } else if !hasSaved {
            showErrorMessage.toggle()
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }) {
        HStack {
            Image("ic_back")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            Text("Back")
        }
    }}
    
    var body: some View {
        Form {
            Section {
                TextField("New Entry", text: $newEntry)
                Button("Add Entry") {
                    if newEntry != "" {
                        itemToModify.detailItems?.append(newEntry)
                    }
                    newEntry = ""
                }
            }
            .alert(isPresented: $showErrorMessage) {
                Alert(
                    title: Text("Warning! Are you sure you want to leave?"),
                    message: Text("Leaving now will delete all changes"),
                    primaryButton: .default(Text("Leave")) {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel())
            }
            Text("Entries:")
            List {
                ForEach(itemToModify.detailItems ?? [], id: \.self) { detailItem in
                    Text(detailItem)
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: move)
            }
        }
        .navigationBarTitle("Details for: \(itemToModify.title)")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: HStack {
            EditButton()
            Button("Save") {
                saveItem()
            }
        })
        .onAppear(perform: {
            itemToModify = selectedItem
        })
    }
    
    private func saveItem() {
        hasSaved = true
        itemToModify.saveItem()
        listUpdater.reloadData()
    }
    
    private func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        itemToModify.detailItems?.remove(at: index)
        listUpdater.reloadData()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        itemToModify.detailItems?.move(fromOffsets: source, toOffset: destination)
        itemToModify.saveItem()
        listUpdater.reloadData()
    }
}
