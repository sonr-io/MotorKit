import Motor
import Foundation
import SecurityExtensions
import Valet
import CryptoKit

let kDeviceSharedKey : String = "DEVICE_SHARED_KEY"

public class MotorKit {
    public var address : String
    public var state : MotorState
    private var secureEnclave : SecureEnclaveValet
    private var dscShardRaw : String

    // Initializer Function
    //
    // 1. Sets up Secure Enclave
    // 2. Checks if Keychain contains motor record
    // 3. Passes record to Bridge
    // 4. Updates state
    public init() {
        // Setup Secure enclave
        secureEnclave = SecureEnclaveValet.valet(with: Identifier(nonEmpty: "io.sonr.motor")!, accessControl: .userPresence)
        state = currentMotorState(secureEnclave: secureEnclave)
        address = ""
        dscShardRaw = ""
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("This is run on a background queue")
            let error: NSErrorPointer = nil
            let buf = newInitializeRequest()
            if buf != nil {
                let rawResp = SNRMotorInit(buf, error)
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    if error != nil {
                        print(error.debugDescription)
                        self.state = MotorState.failedToStart
                        return
                    }
                    
                    // Check Response
                    if let respBuf = rawResp {
                        var resp : Sonrio_Motor_Api_V1_InitializeResponse
                        do {
                            resp = try Sonrio_Motor_Api_V1_InitializeResponse(jsonUTF8Data: respBuf)
                            self.address = resp.address
                            self.dscShardRaw = resp.dscShardRaw
                        }catch {
                            print("Failed to marshal request with protobuf")
                            return
                        }
                    }
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
        // Create a request for a new account
        let buf = newCreateAccountRequest(secureEnclave: secureEnclave, password: password)
        if buf != nil {
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
        }

        // No response returned
        return nil
    }
    
    public func getAddress() -> String {
        return SNRMotorAddress()
    }
    
    public func getBalance() -> Int {
        return SNRMotorBalance()
    }
}
