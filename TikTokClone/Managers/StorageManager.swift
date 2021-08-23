//
//  StorageManager.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()

    private let database = Storage.storage().reference()

    private init() {}

    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {

    }
}
