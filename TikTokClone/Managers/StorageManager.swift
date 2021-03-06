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

    private let storageBucket = Storage.storage().reference()

    private init() {}

    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {

    }

    public func uploadVideoURL(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }

    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        return "\(uuidString)_\(number)_\(unixTimestamp).mov"
    }
}
