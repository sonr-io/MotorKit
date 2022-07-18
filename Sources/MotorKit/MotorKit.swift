import Motor
import Foundation
import SecurityExtensions
import Valet
import CryptoKit

let kDeviceSharedKey : String = "DEVICE_SHARED_KEY"

@objc(MotorKit)
public class MotorKit : NSObject {
    public var state : MotorState
    private var secureEnclave : SecureEnclaveValet

    // Initializer Function
    //
    // 1. Sets up Secure Enclave
    // 2. Checks if Keychain contains motor record
    // 3. Passes record to Bridge
    // 4. Updates state

    @objc(init)
    public init() {
        // Setup Secure enclave
        secureEnclave = SecureEnclaveValet.valet(with: Identifier(nonEmpty: "io.sonr.motor")!, accessControl: .userPresence)
        state = currentMotorState(secureEnclave: secureEnclave)

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
                            print(resp.success)
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
    @objc(createAccount:password:)
    public func createAccount(_ password : String) -> String? {
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

    // Login to an existing account
    @objc(loginAccount:did:password:dscKey:pskKey:)
    public func loginAccount(_ did : String, password : String?, dscKey: Data?, pskKey: Data?) -> Bool {
        let buf = newLoginRequest(did: did, password: password, dscKey: dscKey, pskKey: pskKey)
        if buf != nil {
            let error: NSErrorPointer = nil
            let rawResp = SNRMotorLogin(buf, error)
            if error != nil {
                print(error.debugDescription)
                return false
            }

            // Check Response
            if let respBuf = rawResp {
                var resp : Sonrio_Motor_Api_V1_LoginResponse
                do {
                    resp = try Sonrio_Motor_Api_V1_LoginResponse(jsonUTF8Data: respBuf)
                }catch {
                    print("Failed to marshal request with protobuf")
                    return false
                }
                return resp.success
            }
        }
        return false
    }

    @objc(getAddress)
    public func getAddress() -> String {
        return SNRMotorAddress()
    }

    @objc(getBalance)
    @objc public func getBalance() -> Int {
        return SNRMotorBalance()
    }
}
