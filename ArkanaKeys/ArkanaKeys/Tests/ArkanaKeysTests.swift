// DO NOT MODIFY
// Automatically generated by Arkana (https://github.com/rogerluan/arkana)

import Foundation
import ArkanaKeysInterfaces
import XCTest
@testable import ArkanaKeys

final class ArkanaKeysTests: XCTestCase {
    private var salt: [UInt8]!
    private var globalSecrets: ArkanaKeysGlobalProtocol!

    override func setUp() {
        super.setUp()
        salt = [
            0x71, 0x81, 0x1d, 0xdb, 0x3, 0x25, 0x47, 0x23, 0x36, 0xb0, 0x95, 0xef, 0x92, 0xa9, 0x2a, 0x1c, 0x3e, 0x4a, 0x3e, 0xa3, 0x27, 0x61, 0x70, 0x5f, 0x1, 0x23, 0x30, 0x4b, 0x76, 0xaa, 0xe3, 0x20, 0xeb, 0x79, 0x91, 0x42, 0x75, 0x95, 0x90, 0x1f, 0xb0, 0xa5, 0x28, 0x1e, 0xf8, 0x33, 0x2b, 0xf6, 0x3e, 0x13, 0xfe, 0x53, 0x8c, 0x5a, 0x75, 0x54, 0x92, 0x69, 0xd5, 0xab, 0xc0, 0x4a, 0x3a, 0x42
        ]
        globalSecrets = ArkanaKeys.Global()
    }

    override func tearDown() {
        globalSecrets = nil
        salt = nil
        super.tearDown()
    }

    func test_decodeRandomHexKey_shouldDecode() {
        let encoded: [UInt8] = [
            0x41, 0xb5, 0x2f, 0xee, 0x31, 0x41, 0x23, 0x14, 0xe, 0xd5, 0xf6, 0x8d, 0xa2, 0x90, 0x1e, 0x2f, 0x7, 0x7a, 0x5d, 0x96, 0x43, 0x51, 0x48, 0x67, 0x60, 0x42, 0x53, 0x2d, 0x10, 0x9f, 0x86, 0x43, 0xd9, 0x1f, 0xa2, 0x74, 0x46, 0xa5, 0xf5, 0x2f, 0x84, 0x97, 0x10, 0x2f, 0x9d, 0x5, 0x1f, 0x93, 0x9, 0x26, 0x9c, 0x35, 0xb5, 0x3e, 0x4c, 0x30, 0xf0, 0x5b, 0xb6, 0x9e, 0xa5, 0x7b, 0xc, 0x23, 0x49, 0xe7, 0x2d, 0xef, 0x31, 0x41, 0x7f, 0x42, 0x1, 0xd5, 0xa0, 0x89, 0xab, 0xcc, 0x49, 0x29, 0xe, 0x79, 0xb, 0x95, 0x1f, 0x2, 0x13, 0x6d, 0x65, 0x14, 0x5, 0x2a, 0x4e, 0x98, 0x82, 0x18, 0x89, 0x4c, 0xf4, 0x73, 0x47, 0xa4, 0xa2, 0x2e, 0x80, 0x9d, 0x1d, 0x2d, 0x9a, 0x57, 0x4d, 0xc6, 0x9, 0x71, 0xc7, 0x67, 0xe9, 0x63, 0x43, 0x62, 0xab, 0x5c, 0xe5, 0xce, 0xf6, 0x29, 0x3, 0x24
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "04252dd78ecb094390c5d088aacff5ec2f3630e04281e64e75bf9d9db2c5e16a8f042d8a7e5f9ec503568cc2d75a82a8b5e121210853bdf07b94e966950e6c9f")
    }

    func test_decodeRandomBase64Key_shouldDecode() {
        let encoded: [UInt8] = [
            0x4, 0xcc, 0x4f, 0xbf, 0x77, 0x13, 0x2d, 0x6f, 0, 0xe3, 0xd9, 0xd7, 0xa3, 0x86, 0x68, 0x45, 0x5d, 0x1e, 0x6e, 0xcc, 0x8, 0x27, 0x33, 0xc, 0x4a, 0x64, 0x60, 0x6, 0x26, 0x9d, 0x9b, 0x77, 0xb8, 0x1d, 0xc4, 0x15, 0x7, 0xf6, 0xc2, 0x6e, 0xe9, 0xff, 0x64, 0x46, 0x8a, 0x41, 0x4c, 0xcf, 0x52, 0x5a, 0xb3, 0x1c, 0xdd, 0x20, 0x41, 0x64, 0xf5, 0x2e, 0x9d, 0xdc, 0x8e, 0x3a, 0x7f, 0x16, 0xb, 0xb5, 0x57, 0x8f, 0x3a, 0x4d, 0x2a, 0x6f, 0x44, 0xca, 0xf7, 0xc0, 0xf3, 0xdf, 0x60, 0x2e, 0x6b, 0x6, 0x77, 0x92, 0x55, 0x16, 0x4d, 0x62
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "uMRdt6jL6SL81/BYcTPo/FCSKGPMP7xWSdUWrcRqYZLXrrg9lIMOQz40gGHwNpETz4JT9hmLrzb/avJ2ULI1rw==")
    }

    func test_decodeUUIDKey_shouldDecode() {
        let encoded: [UInt8] = [
            0x45, 0xe5, 0x79, 0xe9, 0x62, 0x13, 0x70, 0x40, 0x1b, 0x81, 0xf1, 0x89, 0xa3, 0x84, 0x1e, 0x79, 0x5d, 0x73, 0x13, 0xc2, 0x44, 0x50, 0x43, 0x72, 0x37, 0x16, 0x54, 0x28, 0x4f, 0x9b, 0xd1, 0x18, 0xd3, 0x1b, 0xa6, 0x70
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "4dd2a67c-1df1-4ec9-ac13-65dc91288b72")
    }

    func test_decodeTrueBoolValue_shouldDecode() {
        let encoded: [UInt8] = [
            0x5, 0xf3, 0x68, 0xbe
        ]
        XCTAssertTrue(ArkanaKeys.decode(encoded: encoded, cipher: salt))
    }

    func test_decodeFalseBoolValue_shouldDecode() {
        let encoded: [UInt8] = [
            0x17, 0xe0, 0x71, 0xa8, 0x66
        ]
        XCTAssertFalse(ArkanaKeys.decode(encoded: encoded, cipher: salt))
    }

    func test_decodeIntValue_shouldDecode() {
        let encoded: [UInt8] = [
            0x45, 0xb3
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), 42)
    }

    func test_decodeIntValueWithLeadingZeroes_shouldDecodeAsString() {
        let encoded: [UInt8] = [
            0x41, 0xb1, 0x2d, 0xea
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "0001")
    }

    func test_decodeMassiveIntValue_shouldDecodeAsString() {
        let encoded: [UInt8] = [
            0x48, 0xb3, 0x2f, 0xe8, 0x30, 0x12, 0x75, 0x13, 0x5, 0x86, 0xad, 0xda, 0xa6, 0x9e, 0x1d, 0x29, 0x6, 0x7a, 0x9, 0x9a, 0x15, 0x53, 0x43, 0x6c, 0x36, 0x11, 0, 0x78, 0x40, 0x92, 0xd6, 0x14, 0xdc, 0x4e, 0xa4, 0x7a, 0x45, 0xa2
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "92233720368547758079223372036854775807")
    }

    func test_decodeNegativeIntValue_shouldDecodeAsString() {
        let encoded: [UInt8] = [
            0x5c, 0xb5, 0x2f
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "-42")
    }

    func test_decodeFloatingPointValue_shouldDecodeAsString() {
        let encoded: [UInt8] = [
            0x42, 0xaf, 0x2c, 0xef
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "3.14")
    }

    func test_encodeAndDecodeValueWithDollarSign_shouldDecode() {
        let encoded: [UInt8] = [
            0x3, 0xe4, 0x7c, 0xb7, 0x5c, 0x1, 0x2b, 0x4a, 0x5b, 0xef, 0xe6, 0x87, 0xf3, 0xcd, 0x53
        ]
        XCTAssertEqual(ArkanaKeys.decode(encoded: encoded, cipher: salt), "real_$lim_shady")
    }
}
