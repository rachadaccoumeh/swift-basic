//
//  ViewController.swift
//  local auth
//
//  Created by Telepaty 4 on 01/03/2023.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    let context = LAContext()

    var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            let reason = "Authenticate using Face ID or Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [self] success, error in
                if success {
                    // User authenticated successfully using biometric data
                    print("User authenticated successfully using biometric data")
                } else {
                    // Biometric authentication failed
                    print("Biometric authentication failed")
                    
                    // Prompt the user to enter their passcode
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                        if success {
                            // User authenticated successfully using passcode
                            print("User authenticated successfully using passcode")
                        } else {
                            // Passcode authentication failed
                            print("Passcode authentication failed")
                        }
                    }
                }
            }
        } else {
            // Biometric authentication is not available
            print("Biometric authentication is not available")
            
        }
        
        
        
        
        
        
        
    }


}

