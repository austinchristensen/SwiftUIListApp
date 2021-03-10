//
//  ListItem.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import Foundation

struct ListItem : Codable {
    var title: String
    var id: UUID
    var index: Int
    var detailItems: [String]?
    
    func saveItem() {
        DataManager.save(object: self, name: id.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(name: id.uuidString)
    }
}
