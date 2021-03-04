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
    @ObservedObject var listUpdater: ListUpdater
    
    var body: some View {
        NavigationView {
            Form{
                TextField("Title", text: $title )
            }
            .navigationBarTitle("New List")
            .navigationBarItems(trailing: Button("Save") {
                saveItem()
            })
        }
        
    }
    
    func saveItem() {
        guard title != "" else {
            isPresented = false
            return
        }
        let newItem = ListItem(title: title, createdAt: Date(), id: UUID(), index: 0, detailItems: [])
        
        newItem.saveItem()
        
        listUpdater.reloadData()
        
        isPresented = false
    }
}
