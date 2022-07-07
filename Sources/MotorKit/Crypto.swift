import Valet
import CryptoKit
import SecurityExtensions
import Valet

func currentMotorState(secureEnclave : SecureEnclaveValet) -> MotorState {
    if !secureEnclave.canAccessKeychain() {
        return MotorState.unsupported
    }
    do {
        let hasRecord = try secureEnclave.containsObject(forKey: kDeviceSharedKey)
        if hasRecord {
            return MotorState.unauthorized
        }
    }catch {
        print("Failed to fetch record")
    }
    return MotorState.unrecognized
}

func generatePrivKey() -> P256.KeyAgreement.PrivateKey {
    return CryptoKit.P256.KeyAgreement.PrivateKey()
}
