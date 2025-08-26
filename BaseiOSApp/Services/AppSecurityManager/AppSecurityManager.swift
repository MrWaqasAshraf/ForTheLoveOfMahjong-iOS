//
//  AppSecurityManager.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation
import CommonCrypto

struct EncryptionResponse: Codable {
    var result: String?
}

struct EncryptedObject {
    var encryptedText: String
}

extension String {
    
    func convertToCleanEncrptedString() -> String? {
        let encrptedString = self.replacingOccurrences(of: "+", with: "%2B")
        return encrptedString
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}

class AppSecurityManager {
    
    let algorithm = "AES"
    let transformation = "AES/CBC/PKCS5Padding" // for clarity, actual API uses options instead

    let base64Key = "j6d7KKC+66unhDowhE6JJogaTpKrKBhnXTBO4YPBSnQ="
    
    //MARK: EncryptPlainText
    //From hmd
//    func encrypt(plainText: String) -> String? {
//
//        //How to use in query params
//
//        /*
//
//         ?enc=\(encrytedQueryParams)
//
//         e.g: id=129&formName-contract to ANkjq12casnckasd //Don't add "?" while encrypting query params
//
//         */
//
//        let base64Key = "j6d7KKC+66unhDowhE6JJogaTpKrKBhnXTBO4YPBSnQ="
//        // Decode base64 key
//        guard let keyData = Data(base64Encoded: base64Key), keyData.count == 16 || keyData.count == 24 || keyData.count == 32 else {
//            print(":x: Invalid key length")
//            return nil
//        }
//        let keyBytes = keyData.bytes
//        // Generate random IV (16 bytes)
//        let ivBytes = AES.randomIV(AES.blockSize)
//        do {
//            let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7)
//            let encrypted = try aes.encrypt(Array(plainText.utf8))
//            // Combine IV + ciphertext
//            let combined = ivBytes + encrypted
//            let combinedData = Data(combined)
//            let base64String = combinedData.base64EncodedString()
//            let cleaned = base64String
//                .removingPercentEncoding?
//                .replacingOccurrences(of: "\\/", with: "/")
//                .replacingOccurrences(of: " ", with: "+") ?? base64String
//            return cleaned
//
////            let base64String = Data(encrypted).base64EncodedString()
////            return base64String
//        } catch {
//            print(":x: Encryption error:", error)
//            return nil
//        }
//    }

    //From android
//    func encryptWithoutIV(plainText: String/*, base64Key: String*/, requestType: RequestType) -> String? {
//        guard let keyData = Data(base64Encoded: base64Key),
//              keyData.count == kCCKeySizeAES256 else {
//            print("Invalid key length")
//            return nil
//        }
//
//        // Generate random IV
//        var iv = Data(count: kCCBlockSizeAES128)
//        let ivResult = iv.withUnsafeMutableBytes {
//            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, $0.baseAddress!)
//        }
//        guard ivResult == errSecSuccess else {
//            print("Failed to generate IV")
//            return nil
//        }
//
//        guard let dataToEncrypt = plainText.data(using: .utf8) else { return nil }
//
//        // Allocate buffer for encrypted data
//        var encryptedData = Data(count: dataToEncrypt.count + kCCBlockSizeAES128)
//        var numBytesEncrypted = 0
//
//        var mutableEncryptedData = encryptedData
//        let cryptStatus = mutableEncryptedData.withUnsafeMutableBytes { encryptedBytes in
//            dataToEncrypt.withUnsafeBytes { dataBytes in
//                iv.withUnsafeBytes { ivBytes in
//                    keyData.withUnsafeBytes { keyBytes in
//                        CCCrypt(CCOperation(kCCEncrypt),
//                                CCAlgorithm(kCCAlgorithmAES),
//                                CCOptions(kCCOptionPKCS7Padding), // PKCS7 is equivalent
//                                keyBytes.baseAddress, keyData.count,
//                                ivBytes.baseAddress,
//                                dataBytes.baseAddress, dataToEncrypt.count,
//                                encryptedBytes.baseAddress, encryptedData.count,
//                                &numBytesEncrypted)
//                    }
//                }
//            }
//        }
//
//        if cryptStatus == kCCSuccess {
//            mutableEncryptedData.removeSubrange(numBytesEncrypted..<mutableEncryptedData.count)
//
//            // Combine IV + encrypted
//            let combined = iv + mutableEncryptedData
//
//            // Base64 encode
//            let base64Encoded = combined.base64EncodedString()
//
//            if requestType == /*"GET" */ .get {
//                return base64Encoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            } else {
//                return base64Encoded
//            }
//        } else {
//            print("Encryption failed")
//            return nil
//        }
//    }
    
//    //MARK: UsingLiberary
//    public func encrypt(plainText: String) -> String? {
//        let base64Key = "j6d7KKC+66unhDowhE6JJogaTpKrKBhnXTBO4YPBSnQ="
//
//        // Decode base64 key
//        guard let keyData = Data(base64Encoded: base64Key),
//              keyData.count == 16 || keyData.count == 24 || keyData.count == 32 else {
//            print("❌ Invalid key length")
//            return nil
//        }
//
//        let keyBytes = keyData.bytes
//
//        // Generate random IV (16 bytes)
//        let ivBytes = AES.randomIV(AES.blockSize)
//
//        do {
//            let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs5)
//            let encryptedBytes = try aes.encrypt(Array(plainText.utf8))
//
//            // Combine IV + encrypted
//            let combinedBytes = ivBytes + encryptedBytes
//            let combinedData = Data(combinedBytes)
//
//            // Encode to Base64 string
//            var base64String = combinedData.base64EncodedString()
//
//            // Sanitize Base64 for URL safety
//            base64String = base64String
//                .replacingOccurrences(of: "\n", with: "")
//                .replacingOccurrences(of: "\r", with: "")
//                .replacingOccurrences(of: " ", with: "+") // ensure `+` isn't lost
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            // Ensure valid Base64 length (multiple of 4)
//            let paddingNeeded = 4 - (base64String.count % 4)
//            if paddingNeeded < 4 {
//                base64String += String(repeating: "=", count: paddingNeeded)
//            }
//
//            print("🔐 Encrypted Base64 Output:\n\(base64String)")
//            return base64String
//
//        } catch {
//            print("❌ Encryption error:", error)
//            return nil
//        }
//    }
//
//
//
    
    //MARK: EncryptPlainJSON
    func encryptRequestBody(requestBody: [String: Any]?) -> /*[String: Any]?*/  EncryptedObject? {
        // Step 1: Convert dictionary to JSON string
        //%2F
        var mutableRequest = requestBody
        if let requestBody {
            if var value = requestBody.filter { $0.key == "timeZone" }.first?.value as? String {
                value = value.replacingOccurrences(of: "\\/", with: "/")
//                value = value.replacingOccurrences(of: "/", with: "%2F")
                mutableRequest?.updateValue(value, forKey: "timeZone")
            }
        }
        guard let mutableRequest, let jsonData = try? JSONSerialization.data(withJSONObject: mutableRequest, options: []),
              var jsonString = String(data: jsonData, encoding: .utf8) else {
            print(":x: Failed to serialize JSON")
            return nil
        }
        // Step 2: Encrypt the JSON string using AES
        guard let encrypted = aesEncrypt(text: jsonString) else {
            print(":x: Encryption failed")
            return nil
        }
        // Step 3: Return dictionary with encrypted string
//        return ["encrypted": encrypted]
        return EncryptedObject(encryptedText: encrypted)
    }
    
    func aesEncrypt(text: String/*, base64Key: String*/) -> String? {
        guard let keyData = Data(base64Encoded: base64Key),
              keyData.count == kCCKeySizeAES256 else {
            print("Invalid key")
            return nil
        }
        
        // Generate random IV
        var iv = Data(count: kCCBlockSizeAES128)
        let result = iv.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, $0.baseAddress!)
        }
        guard result == errSecSuccess else {
            print("Failed to generate IV")
            return nil
        }
        
        guard let dataToEncrypt = text.data(using: .utf8) else { return nil }
        
        // Prepare buffer for encrypted data
        var encryptedData = Data(count: dataToEncrypt.count + kCCBlockSizeAES128)
        var numBytesEncrypted: size_t = 0
        
        var mutableEncryptedData = encryptedData
        let status = mutableEncryptedData.withUnsafeMutableBytes { encryptedBytes in
            dataToEncrypt.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    keyData.withUnsafeBytes { keyBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, keyData.count,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress, dataToEncrypt.count,
                                encryptedBytes.baseAddress, encryptedData.count,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        guard status == kCCSuccess else {
            print("Encryption failed")
            return nil
        }
        
//        // Resize buffer to actual data
//        encryptedData.removeSubrange(numBytesEncrypted..<encryptedData.count)
//
//        // Combine IV + encrypted data
//        let combined = iv + encryptedData
        
        // Resize buffer to actual data
        mutableEncryptedData.removeSubrange(numBytesEncrypted..<mutableEncryptedData.count)
        
        // Combine IV + encrypted data
        let combined = iv + mutableEncryptedData
        
        // Return Base64-encoded string
        return combined.base64EncodedString()
    }

    func decryptWithoutIV(encryptedBase64: String/*, base64Key: String*/) -> String? {
        guard let combinedData = Data(base64Encoded: encryptedBase64),
              let keyData = Data(base64Encoded: base64Key),
              keyData.count == kCCKeySizeAES256 else {
            print("Invalid input")
            return nil
        }

        let iv = combinedData.prefix(kCCBlockSizeAES128)
        let encryptedData = combinedData.dropFirst(kCCBlockSizeAES128)

        var decryptedData = Data(count: encryptedData.count + kCCBlockSizeAES128)
        var numBytesDecrypted = 0

        var mutableDecryptedData = decryptedData
        let cryptStatus = mutableDecryptedData.withUnsafeMutableBytes { decryptedBytes in
            encryptedData.withUnsafeBytes { encryptedBytes in
                iv.withUnsafeBytes { ivBytes in
                    keyData.withUnsafeBytes { keyBytes in
                        CCCrypt(CCOperation(kCCDecrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, keyData.count,
                                ivBytes.baseAddress,
                                encryptedBytes.baseAddress, encryptedData.count,
                                decryptedBytes.baseAddress, decryptedData.count,
                                &numBytesDecrypted)
                    }
                }
            }
        }

        if cryptStatus == kCCSuccess {
            mutableDecryptedData.removeSubrange(numBytesDecrypted..<mutableDecryptedData.count)
            return String(data: mutableDecryptedData, encoding: .utf8)
        } else {
            print("Decryption failed")
            return nil
        }
    }
    
}
