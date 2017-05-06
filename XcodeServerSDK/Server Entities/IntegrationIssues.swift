//
//  IntegrationIssues.swift
//  XcodeServerSDK
//
//  Created by Mateusz Zając on 12.08.2015.
//  Copyright © 2015 Honza Dvorsky. All rights reserved.
//

import Foundation
import BuildaUtils

open class IntegrationIssues: XcodeServerEntity {
    
    open let buildServiceErrors: [IntegrationIssue]
    open let buildServiceWarnings: [IntegrationIssue]
    open let triggerErrors: [IntegrationIssue]
    open let errors: [IntegrationIssue]
    open let warnings: [IntegrationIssue]
    open let testFailures: [IntegrationIssue]
    open let analyzerWarnings: [IntegrationIssue]
    
    // MARK: Initialization
    
    public required init(json: JSON) throws {
        self.buildServiceErrors = try json.arrayForKey("buildServiceErrors").map { try IntegrationIssue(json: $0) }
        self.buildServiceWarnings = try json.arrayForKey("buildServiceWarnings").map { try IntegrationIssue(json: $0) }
        self.triggerErrors = try json.arrayForKey("triggerErrors").map { try IntegrationIssue(json: $0) }
        
        // Nested issues
        self.errors = try json.xcodeReadValues("errors")
        self.warnings = try json.xcodeReadValues("warnings")
        self.testFailures = try json.xcodeReadValues("testFailures")
        self.analyzerWarnings = try json.xcodeReadValues("testFailures")
        
        try super.init(json: json)
    }
    
}
