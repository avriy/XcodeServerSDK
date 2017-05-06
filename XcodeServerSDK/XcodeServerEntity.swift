//
//  XcodeServerEntity.swift
//  Buildasaur
//
//  Created by Honza Dvorsky on 14/12/2014.
//  Copyright (c) 2014 Honza Dvorsky. All rights reserved.
//

import Foundation
import BuildaUtils

public protocol XcodeRead {
    init(json: [String: Any]) throws
}

public protocol XcodeWrite {
    func dictionarify() -> [String: Any]
}

open class XcodeServerEntity : XcodeRead, XcodeWrite {
    
    open let id: String!
    open let rev: String!
    open let tinyID: String!
    open let docType: String!
    
    //when created from json, let's save the original data here.
    open let originalJSON: JSON?
    
    //initializer which takes a dictionary and fills in values for recognized keys
    public required init(json: JSON) throws {
        
        self.id = json.optionalStringForKey("_id")
        self.rev = json.optionalStringForKey("_rev")
        self.tinyID = json.optionalStringForKey("tinyID")
        self.docType = json.optionalStringForKey("doc_type")
        self.originalJSON = json
    }
    
    public init() {
        self.id = nil
        self.rev = nil
        self.tinyID = nil
        self.docType = nil
        self.originalJSON = nil
    }
    
    open func dictionarify() -> JSON {
        fatalError("Must be overriden by subclasses that wish to dictionarify their data")
    }
    
    open class func optional<T: XcodeRead>(_ json: [String: Any]?) throws -> T? {
        if let json = json {
            return try T(json: json)
        }
        return nil
    }
}

//parse an array of dictionaries into an array of parsed entities
public func XcodeServerArray<T>(_ jsonArray: [JSON]) throws -> [T] where T: XcodeRead {
    return try jsonArray.map { json in
        return try T(json: json)
    }
}

public typealias JSON = [String: Any]

extension Dictionary where Key == String, Value == Any {
    func optionalStringForKey(_ key: String) -> String? {
        return self[key] as? String
    }
    
    func stringForKey(_ key: String) throws -> String {
        guard let value = self[key] as? String else {
            throw JSONError.unexpectedItemType(key)
        }
        return value
    }
    
    func optionalXcodeReadValues<T: XcodeRead>(_ key: String) -> [T]? {
        guard let arrayOfJSONs = self[key] as? [[String: Any]] else {
            return nil
        }
        
        return arrayOfJSONs.flatMap { try? T(json: $0) }
    }
    
    func xcodeReadValues<T: XcodeRead>(_ key: String) throws -> [T] {
        guard let arrayOfJSONs = self[key] as? [[String: Any]] else {
            throw JSONError.unexpectedItemType(key)
        }
        return try arrayOfJSONs.map { try T(json: $0) }
    }
    
    
    func xcodeReadValue<T: XcodeRead>(for key: String) throws -> T {
        guard let dictionary = self[key] as? [String: Any] else {
            throw JSONError.unexpectedItemType(key)
        }
        
        return try T(json: dictionary)
    }
    
    func optionalXcodeReadValue<T: XcodeRead>(_ key: String) -> T? {
        guard let dictionary = self[key] as? [String: Any] else {
            return nil
        }
        
        return try? T(json: dictionary)
    }
    
    public func optionalDateForKey(_ key: String) -> Date? {
        
        if let dateString = self.optionalStringForKey(key) {
            let date = Date.dateFromXCSString(dateString)
            return date
        }
        return nil
    }
    
    public func dateForKey(_ key: String) throws -> Date {
        guard let item = self.optionalDateForKey(key) else {
            throw JSONError.valueNotFound(key: key)
        }
        return item
    }
    
    
    public func nonOptionalForKey<Z>(_ key: String) throws -> Z {
        guard let item: Z = optionalForKey(key) else {
            throw JSONError.valueNotFound(key: key)
        }
        return item
    }
    
    public func optionalForKey<Z>(_ key: String) -> Z? {
        
        if let optional = self[key] as? Z {
            return optional
        }
        return nil
    }
    
    public func optionalIntForKey(_ key: String) -> Int? {
        return self.optionalForKey(key)
    }
    
    public func intForKey(_ key: String) throws -> Int {
        return try nonOptionalForKey(key)
    }
    
    public func optionalDictionaryForKey(_ key: String) -> JSON? {
        return self.optionalForKey(key)
    }
    
    public func dictionaryForKey(_ key: String) throws -> JSON {
        return try self.nonOptionalForKey(key)
    }

    public func optionalDoubleForKey(_ key: String) -> Double? {
        return self.optionalForKey(key)
    }
    
    public func doubleForKey(_ key: String) throws -> Double {
        return try self.nonOptionalForKey(key)
    }
    
    public func optionalBoolForKey(_ key: String) -> Bool? {
        return self.optionalForKey(key)
    }
    
    public func boolForKey(_ key: String) throws -> Bool {
        return try self.nonOptionalForKey(key)
    }
    
    public func optionalArrayForKey(_ key: String) -> NSArray? {
        return self.optionalForKey(key)
    }
    
    public func arrayForKey<T>(_ key: String) throws -> [T] {
        return try self.nonOptionalForKey(key)
    }
    
}
