@_exported import SonrMotor
import Foundation

@objc(MotorKit) 
class MotorKit : NSObject {
    private(set) var hasWallet = false
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func constantsToExport() -> [AnyHashable : Any]! {
      return [
        "number": 123.9,
        "string": "foo",
        "boolean": true,
        "array": [1, 22.2, "33"],
        "object": ["a": 1, "b": 2]
      ]
    }
    
    // Create a new Account
    //
    // The createAccount() method takes the input of a Vault password and aesDscKey to:
    //    1. Generate a new Wallet
    //    2. Request Faucet for Tokens
    //    3. Create a new WhoIs record for this user
    @objc func createAccount(password : String, aesDscKey : Data) -> Bool {
        // Check if Wallet exists
        if self.hasWallet {
            print("Wallet has already been created")
            return false
        }
        
        var pubKey : SecKey
        do {
            let pk = try KeychainHelper.makeAndStoreKey(name: "io.sonr.motor.key1", requiresBiometry: true)
            pubKey = SecKeyCopyPublicKey(pk)!
        } catch {
            return false
        }
        let data = pubKey as! Data
        
        // Create Protobuf Request from Params
        var req = Sonrio_Motor_Registry_V1_CreateAccountRequest()
        req.aesDscKey = data
        req.password = password
        
        // Serialize Request
        var buf : Data
        do {
            buf = try req.serializedData()
        } catch {
            print("Failed to marshal request with protobuf.")
            return false
        }
        
        // Call Method handle error
        let error: NSErrorPointer = nil
        let resp = MotorCreateAccount(buf, error)
        if error != nil {
            return false
        }
        
        // Set has Wallet bool
        self.hasWallet = (resp != nil)
        return self.hasWallet
    }
}
