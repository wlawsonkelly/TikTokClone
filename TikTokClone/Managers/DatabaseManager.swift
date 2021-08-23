//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()

    private let database = Database.database().reference()

    private init() {}

    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
