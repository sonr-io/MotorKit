import XCTest
@testable import MotorKit
@testable import Motor

final class MotorKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MotorKit().text, "Hello, World!")
    }
    
    func testNewWallet() {
        let error: NSErrorPointer = nil
        guard SNRMotorNewWallet(error) else {
            XCTFail("Failed to create new wallet")
            return
        }
        XCTAssertNil(error)
    }
    
    func testLoadWallet() {
        let error: NSErrorPointer = nil
        guard SNRMotorNewWallet(error) else {
            XCTFail("Failed to create new wallet")
            return
        }
        XCTAssertNil(error)
        
        guard let buf = SNRMotorMarshalWallet() else {
            XCTFail("Buffer was not returned")
            return
        }
        
        guard SNRMotorLoadWallet(buf, error) else{
            XCTFail("Wallet was not loaded" + error.debugDescription)
            return
        }
    }
}
