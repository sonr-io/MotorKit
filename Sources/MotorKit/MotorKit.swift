import Motor
import Foundation

@objc(MotorKit)
class MotorKit : NSObject {
    private(set) var hasWallet = false
    

    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    @objc func newWallet() -> Bool {
        var result = false;
        DispatchQueue.global(qos: .background).sync {
          result = self._newWallet()
        }
        return result;
    }
    
    func _newWallet() -> Bool {
        let error: NSErrorPointer = nil
        let resp = SNRMotorNewWallet(error)
        if error != nil {
            return false
        }
        return resp
    }
}
