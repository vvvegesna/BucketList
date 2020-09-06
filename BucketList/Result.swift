//
//  Result.swift
//  BucketList
//
//  Created by Vegesna, Vijay V EX1 on 9/2/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    public var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
