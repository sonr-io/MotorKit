//
//  Utils.swift
//  
//
//  Created by Prad Nukala on 7/7/22.
//

import Foundation
import Valet
import UIKit
import CryptoKit

func newCreateAccountRequest(secureEnclave : SecureEnclaveValet, password: String) -> Data? {
    // Create Protobuf Request from Params
    let privKey = CryptoKit.P256.KeyAgreement.PrivateKey()
    // let pubKey = privKey.publicKey
    
    var req = Sonrio_Motor_Api_V1_CreateAccountRequest()
    req.signedDscShard = privKey.publicKey.rawRepresentation
    req.password = password

    // Store generated private key in keychain
    do {
        try secureEnclave.setObject(privKey.rawRepresentation, forKey: kDeviceSharedKey)
    }catch {
        print("Failed to set privKey in Keychain")
    }

    // Serialize Request
    var buf : Data
    do {
        buf = try req.jsonUTF8Data()
    } catch {
        print("Failed to marshal request with protobuf.")
        return nil
    }
    return buf
}

func newInitializeRequest(pubKey: Data? = nil) -> Data? {
    var req = Sonrio_Motor_Api_V1_InitializeRequest()
    req.deviceID = UIDevice.current.identifierForVendor!.uuidString
    req.homeDir = getDocumentsDirectory().absoluteString
    req.tempDir = getCacheDirectory().absoluteString
    req.supportDir = getSupportDirectory().absoluteString
    
    if pubKey != nil {
        req.deviceKeyprintPub = pubKey!
    }
    // Serialize Request
    var buf : Data
    do {
        buf = try req.jsonUTF8Data()
    } catch {
        return nil
    }

    return buf
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getCacheDirectory() -> URL {
    let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getSupportDirectory() -> URL {
    let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
