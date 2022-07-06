import XCTest
@testable import MotorKit
@testable import Motor

final class MotorKitTests: XCTestCase {
    func testCreateAccount() {
        let motor = MotorKit()
        let result = motor.createAccount(password: "password")
        XCTAssertNil(result)
    }
}
