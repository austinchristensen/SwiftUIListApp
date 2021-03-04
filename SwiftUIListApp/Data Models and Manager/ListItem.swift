//
//  ListItem.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import Foundation

struct ListItem : Codable, Identifiable {
    var title: String
    var createdAt: Date
    var id: UUID
    var index: Int
    var detailItems: [String]?
    
    func saveItem() {
        DataManager.save(self, with: id.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(id.uuidString)
    }
}
