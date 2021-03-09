//
//  DataManager.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/3/21.
//

import Foundation

public class DataManager {
    
    // Get document directory
    static fileprivate func getDocumentDirectory() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            NSLog(DataManagerErrors.UnableToAccessDocumentDirectory.localizedDescription)
            return nil
        }
        return url
    }
    
    // Save any kind of codable object
    static func save <T: Encodable> (_ object: T, with fileName: String) {
        guard let url = getDocumentDirectory()?.appendingPathComponent(fileName, isDirectory: false) else { return }
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    // Load any kind of codeable object
    static func load <T: Decodable> (_ fileName: String, with type: T.Type) -> T? {
        guard let url = getDocumentDirectory()?.appendingPathComponent(fileName, isDirectory: false) else { return nil }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            NSLog("\(DataManagerErrors.FileNotFoundAtPath.localizedDescription): \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                NSLog(error.localizedDescription)
                return nil
            }
        } else {
            NSLog("\(DataManagerErrors.DataNotFoundAtPath.localizedDescription): \(url.path)")
            return nil
        }
    }
    
    // Load all files from a directory
    static func loadAll <T: Decodable> (_ type: T.Type) -> [T]? {
        guard let path = getDocumentDirectory()?.path else { return nil }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            
            var modelObjects = [T]()
            
            for fileName in files {
                guard let modelObject = load(fileName, with: type) else { return nil }
                modelObjects.append(modelObject)
            }
            
            return modelObjects
        } catch {
            NSLog(DataManagerErrors.UnableToLoadAnyFiles.localizedDescription)
            return nil
        }
    }
    
    // Delete a file
    static func delete (_ fileName: String) {
        guard let url = getDocumentDirectory()?.appendingPathComponent(fileName, isDirectory: false) else { return }
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
}
