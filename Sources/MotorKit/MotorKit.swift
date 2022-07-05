@_exported import Motor
import Foundation
import SecurityExtensions
 
class MotorKit {
    static private func start() {
        let error: NSErrorPointer = nil
        SNRMotorInit(error)
        if error != nil {
            print(error.debugDescription)
        }
    }
    
    // Generate new Key
    //
    // The newKey() method generates a new SecKey with the given name-suffix and stores in the device Secure Enclave.
    static func newKey(name : String, useBiometrics : Bool = true) -> SecKey? {
        MotorKit.start()
        let keyName = "io.sonr.motor." + name
        var pubKey : SecKey
        do {
            let pk = try KeychainHelper.makeAndStoreKey(name: keyName, requiresBiometry: useBiometrics)
            pubKey = SecKeyCopyPublicKey(pk)!
        } catch {
            print("Failed to create new key")
            return nil
        }
        return pubKey
    }
    
    // Load existing Key
    //
    // The loadKey() method returns a SecKey if it exists in the Device Secure Enclave.
    static func loadKey(name : String) -> SecKey? {
        let keyName = "io.sonr.motor." + name
        return KeychainHelper.loadKey(name: keyName)
    }
    
    // Remove existing Key
    //
    // The removeKey() method returns True if the Key is succesfully removed from the KeyChain
    static func removeKey(name : String) -> Bool {
        let keyName = "io.sonr.motor." + name
        return KeychainHelper.removeKey(name: keyName)
    }
    
    // Create a new Account
    //
    // The createAccount() method takes the input of a Vault password and aesDscKey to:
    //    1. Generate a new Wallet
    //    2. Request Faucet for Tokens
    //    3. Create a new WhoIs record for this user
    static func createAccount(password : String, dscKey : SecKey) -> String? {
        MotorKit.start()
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
