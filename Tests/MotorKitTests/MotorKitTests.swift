import XCTest
@testable import MotorKit
@testable import Motor

final class MotorKitTests: XCTestCase {
    func testCreateAccount() {
        let motor = MotorKit()
        let key = SecKey.create(withData:
                                    [UInt8()])
        let result = motor.createAccount(password: "password", dscKey: key!)
        XCTAssertNil(result)
    }
}
