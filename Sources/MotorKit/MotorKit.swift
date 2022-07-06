import Motor
import Foundation
import SecurityExtensions
import Valet

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
        }
        
        var hasRecord : Bool
        do {
            hasRecord = try secureEnclave.containsObject(forKey: "")
        }catch {
            hasRecord = false
        }
        
        if hasRecord {
            state = MotorState.unauthorized
        }else{
            state = MotorState.unrecognized
        }
        
        let error: NSErrorPointer = nil
        SNRMotorInit(error)
        if error != nil {
            print(error.debugDescription)
            state = MotorState.failedToStart
        }
    }

    // Create a new Account
    //
    // The createAccount() method takes the input of a Vault password and aesDscKey to:
    //    1. Generate a new Wallet
    //    2. Request Faucet for Tokens
    //    3. Create a new WhoIs record for this user
    public func createAccount(password : String, dscKey : SecKey) -> String? {
        // Create Protobuf Request from Params
        var req = Sonrio_Motor_Registry_V1_CreateAccountRequest()
        if let pubKey = dscKey.keyData {
            req.aesDscKey = Data(pubKey)
            req.password = password
        }else {
            return nil
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
            var resp : Sonrio_Motor_Registry_V1_CreateAccountResponse
            do {
                resp = try Sonrio_Motor_Registry_V1_CreateAccountResponse(jsonUTF8Data: respBuf)
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
