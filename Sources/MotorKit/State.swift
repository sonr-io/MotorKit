//
//  File.swift
//  
//
//  Created by Prad Nukala on 7/6/22.
//

import Foundation

public enum MotorState {
    case authorized
    case unsupported
    case unrecognized
    case unauthorized
    case failedToStart
}

public extension MotorState {
    func getTitleMessage() -> String {
        return String(describing: self).uppercased(with: Locale.current)
    }
    
    func getDescriptionMessage() -> String {
        switch self {
        case .unsupported:
            return "The current device is not supported by the Sonr Network. Please use a device that supports Apple Secure Enclave."
        case .unrecognized:
            return "Register for your Sonr ID to use this Application built on the User Owned Internet."
        case .unauthorized:
            return "Would you like to authorize this Application with your Sonr ID?"
        case .authorized:
            return "Return to where you left off."
        case .failedToStart:
            return "Fatal error has occurred."
        }
    }
}
