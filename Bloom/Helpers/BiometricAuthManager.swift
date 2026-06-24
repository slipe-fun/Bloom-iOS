//
//  BiometricAuthManager.swift
//  Bloom
//
//  Created by Аскольд on 25.06.2026.
//

import LocalAuthentication

class BiometricAuthManager {
    
    static func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("Biometry doesn't support or not setup: \(error?.localizedDescription ?? "Unknown")")
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Confirm identity for login"
            )
            return success
        } catch {
            print("Authentication error: \(error.localizedDescription)")
            return false
        }
    }
}
