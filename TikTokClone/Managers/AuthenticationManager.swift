//
//  AuthenticationManager.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()

    private init() {}

    enum SignInMethod {
        case email
        case google
    }

    public func signIn(with method: SignInMethod) {

    }

    public func signOut() {

    }
}
