//
//  FileTests.swift
//  XcodeServerSDK
//
//  Created by Mateusz Zając on 22/07/15.
//  Copyright © 2015 Honza Dvorsky. All rights reserved.
//

import XCTest
@testable import XcodeServerSDK

class FileTests: XCTestCase {
    
    let sampleAdded = [
        "status": 1,
        "filePath": "File1.swift"
    ] as [String : Any]
    
    let sampleOther = [
        "status": 1024,
        "filePath": "File2.swift"
    ] as [String : Any]
    
    // MARK: Initialization
    func testDictionaryInit() throws {
        var file = try File(json: sampleAdded)
        
        XCTAssertEqual(file.filePath, "File1.swift")
        XCTAssertEqual(file.status, FileStatus.added)
        
        file = try File(json: sampleOther)
        
        XCTAssertEqual(file.filePath, "File2.swift")
        XCTAssertEqual(file.status, FileStatus.other)
    }
    
    func testInit() {
        let file = File(filePath: "File1.swift", status: .added)

        XCTAssertEqual(file.filePath, "File1.swift")
        XCTAssertEqual(file.status, FileStatus.added)
    }
    
    // MARK: Dictioninarifying
    func testDictionarify() throws {
        let file = try File(json: sampleAdded)
        
        XCTAssertEqual(file.dictionarify(), sampleAdded)
    }
    
}
