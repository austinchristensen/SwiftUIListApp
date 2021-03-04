//
//  ListUpdater.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import Foundation

class ListUpdater: ObservableObject {
    @Published var mainItemsList = [ListItem]()
    
    init() {
        mainItemsList = DataManager.loadAll(ListItem.self).sorted(by: {
            $0.index < $1.index
        })
        print("on init: count =  \(mainItemsList.count)")
    }
    
    public func reloadData() {
        mainItemsList = DataManager.loadAll(ListItem.self).sorted(by: {
            $0.index < $1.index
        })
        print("on reloadData: count = \(mainItemsList.count)")
    }
}
