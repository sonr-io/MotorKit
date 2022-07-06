import Motor
import Foundation
import SecurityExtensions
import Valet
import CryptoKit

let kDeviceSharedKey : String = "DEVICE_SHARED_KEY"

public class MotorKit {
    public var state : MotorState
    private var secureEnclave : SecureEnclaveValet

    // Initializer Function
    //
    // 1. Sets up Secure Enclave
    // 2. Checks if Keychain contains motor record
    // 3. Passes record to Bridge
    // 4. Updates state
    public init() {
        // Setup Secure enclave
        secureEnclave = SecureEnclaveValet.valet(with: Identifier(nonEmpty: "io.sonr.motor")!, accessControl: .userPresence)
        if !secureEnclave.canAccessKeychain() {
            state = MotorState.unsupported
            return
        }

        state = MotorState.unrecognized
        do {
            let hasRecord = try secureEnclave.containsObject(forKey: kDeviceSharedKey)
            if hasRecord {
                state = MotorState.unauthorized
            }
        }catch {
            print("Failed to fetch record")
        }

        DispatchQueue.global(qos: .userInitiated).async {
            print("This is run on a background queue")
            let error: NSErrorPointer = nil
            var req = Sonrio_Motor_Api_V1_InitializeRequest()
            req.deviceID
            // Serialize Request
            var buf : Data
            do {
                buf = try req.jsonUTF8Data()
            } catch {
                print("Failed to marshal request with protobuf.")
                return
            }

            SNRMotorInit(buf, error)
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                if error != nil {
                    print(error.debugDescription)
                    self.state = MotorState.failedToStart
                }
            }
        }
    }

    // Create a new Account
    //
    // The createAccount() method takes the input of a Vault password and aesDscKey to:
    //    1. Generate a new Wallet
    //    2. Request Faucet for Tokens
    //    3. Create a new WhoIs record for this user
    public func createAccount(password : String) -> String? {
        // Create Protobuf Request from Params
        let privKey = CryptoKit.P256.KeyAgreement.PrivateKey()
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
            return ""
        }

        // Call Method handle error
        let error: NSErrorPointer = nil
        let rawResp = SNRMotorCreateAccount(buf, error)
        if error != nil {
            print(error.debugDescription)
            return nil
        }

        // Check Response
        if let respBuf = rawResp {
            var resp : Sonrio_Motor_Api_V1_CreateAccountResponse
            do {
                resp = try Sonrio_Motor_Api_V1_CreateAccountResponse(jsonUTF8Data: respBuf)
            }catch {
                print("Failed to marshal request with protobuf")
                return nil
            }
            return resp.address
        }

        // No response returned
        return nil
    }
}
