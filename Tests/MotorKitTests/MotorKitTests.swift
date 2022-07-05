import XCTest
@testable import MotorKit
@testable import Motor

final class MotorKitTests: XCTestCase {
    func testCreateAccount() {
        let key = MotorKit.newKey(name: "test")
        if let pk = key {
            let result = MotorKit.createAccount(password: "Test", dscKey: pk)
             XCTAssertNil(result)
        }else{
            XCTFail()
        }
    }
}
