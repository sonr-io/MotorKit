import XCTest
@testable import MotorKit
@testable import SonrMotor

final class MotorKitTests: XCTestCase {
    func testNewWallet() {
        let error: NSErrorPointer = nil
        guard MotorNewWallet(error) else {
            XCTFail("Failed to create new wallet")
            return
        }
        XCTAssertNil(error)
    }
    
    func testLoadWallet() {
        let error: NSErrorPointer = nil
        guard MotorNewWallet(error) else {
            XCTFail("Failed to create new wallet")
            return
        }
        XCTAssertNil(error)
        
        guard let buf = MotorMarshalWallet() else {
            XCTFail("Buffer was not returned")
            return
        }
        
        guard MotorLoadWallet(buf, error) else{
            XCTFail("Wallet was not loaded" + error.debugDescription)
            return
        }
    }
}
