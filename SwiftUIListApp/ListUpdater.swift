//
//  ListUpdater.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import Foundation

class ListUpdater: ObservableObject {
    @Published var mainItemsList = [ListItem]()
    @Published var currentlySelectedItem: ListItem?
    
    init() {
        mainItemsList = DataManager.loadAll(type: ListItem.self)?.sorted(by: {
            $0.index < $1.index
        }) ?? []
    }
    
    public func updateCurrentlySelectedItem(updatedItem: ListItem) {
        currentlySelectedItem = updatedItem
    }
    
    public func reloadData() {
        mainItemsList = DataManager.loadAll(type: ListItem.self)?.sorted(by: {
            $0.index < $1.index
        }) ?? []
    }
}
