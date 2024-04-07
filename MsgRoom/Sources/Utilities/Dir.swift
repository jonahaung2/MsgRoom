//
//  Dir.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import Foundation

class Dir: NSObject {
    class func application() -> String {
        return Bundle.main.resourcePath!
    }
    class func application(_ component: String) -> String {
        var path = application()
        path = (path as NSString).appendingPathComponent(component)
        return path
    }
    class func application(_ component1: String, and component2: String) -> String {
        var path = application()
        path = (path as NSString).appendingPathComponent(component1)
        path = (path as NSString).appendingPathComponent(component2)
        
        return path
    }
}
extension Dir {
    class func document() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    class func document(_ component: String) -> String {
        var path = document()
        path = (path as NSString).appendingPathComponent(component)
        createIntermediate(path)
        return path
    }
    class func document(_ component1: String, and component2: String) -> String {
        var path = document()
        path = (path as NSString).appendingPathComponent(component1)
        path = (path as NSString).appendingPathComponent(component2)
        createIntermediate(path)
        return path
    }
}
extension Dir {
    class func cache() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    class func cache(_ component: String) -> String {
        var path = cache()
        path = (path as NSString).appendingPathComponent(component)
        createIntermediate(path)
        return path
    }
}
extension Dir {
    private class func createIntermediate(_ path: String) {
        let directory = (path as NSString).deletingLastPathComponent
        if (exist(directory) == false) {
            create(directory)
        }
    }
    private class func create(_ directory: String) {
        try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }
    private class func exist(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
