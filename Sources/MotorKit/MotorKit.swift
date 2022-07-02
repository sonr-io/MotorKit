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
    
    @objc func createAccount(buf:Data) -> Bool {
        if self.hasWallet {
            print("Wallet has already been created")
            return false
        }
        
        let error: NSErrorPointer = nil
        let resp = MotorCreateAccount(buf, error)
        if error != nil {
            return false
        }
                self.hasWallet = (resp != nil)
        return (resp != nil)
    }
}
