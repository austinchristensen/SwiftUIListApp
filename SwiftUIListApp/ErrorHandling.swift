//
//  ErrorHandling.swift
//  SwiftUIListApp
//
//  Created by Austin Christensen on 3/9/21.
//

import Foundation

public enum DataManagerErrors: Error {
    case UnableToAccessDirectory
    case FileNotFoundAtPath
    case DataNotFoundAtPath
    case UnableToLoadAnyFiles
}
