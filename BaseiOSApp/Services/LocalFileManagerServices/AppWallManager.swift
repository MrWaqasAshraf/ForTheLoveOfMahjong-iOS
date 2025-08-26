//
//  AppWallManager.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import Foundation
import Security

enum CustomKeys{
    
    static var userInfoKey: String?{
        guard let bID = Bundle.main.bundleIdentifier else{
            return nil
        }
        return bID + ".userInfo"
    }
    
    static var userCredsKey: String?{
        guard let bID = Bundle.main.bundleIdentifier else{
            return nil
        }
        return bID + ".userCreds"
    }
    
    static var appToken: String?{
        guard let bID = Bundle.main.bundleIdentifier else{
            return nil
        }
        return bID + ".appToken"
    }
    
    static var rsaKey: String?{
        guard let bID = Bundle.main.bundleIdentifier else{
            return nil
        }
        return bID + ".rsaKey"
    }
    
}

class KeychainManager{
    
    static let shared = KeychainManager()
    
    private init(){}
    
    //MARK: UpdateKeychainItem
    func saveInKeyChain<T: Codable>(key: String?, inputData: T){
        
        guard let key = key else{
            return
        }
        AppLogger.info(key)
        
        let encodedItem = ParsingHandler.shared.encodeItem(item: inputData)
        guard let encodedItem = encodedItem else{
            return
        }

        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        // Set attributes for the new data
        let attributes: [String: Any] = [kSecValueData as String: encodedItem]

        // Find data and update
        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
            AppLogger.info("data has been updated/changed")
        } else {
            // Add data
            let newAttributes = query.reduce(into: attributes) { partialResult, query in
                partialResult.updateValue(query.value, forKey: query.key)
            }
            if SecItemAdd(newAttributes as CFDictionary, nil) == noErr {
                AppLogger.info("Data saved successfully in the keychain")
            } else {
                AppLogger.error("Something went wrong trying to save the user in the keychain")
            }
            
        }
    }
    
    //MARK: RetrieveFromKeychain
    func retrieveKeyChainItem<T: Codable>(key: String?, expectedItem: T.Type) -> T?{
        
        // Set Key
        guard let key = key else{
            return nil
        }
        AppLogger.info(key)
        
//        // Set username of the user you want to find
//        let username = "john"

        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        // Check if data exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
//               let username = existingItem[kSecAttrAccount as String] as? String,
               let encodedData = existingItem[kSecValueData as String] as? Data
//               let creds = try ParsingHandler.shared.parser(data: encodedData, expected: Credentials.self) /* String(data: passwordData, encoding: .utf8) */
            {
                do {
                    let creds = try ParsingHandler.shared.parser(data: encodedData, expected: expectedItem)
                    AppLogger.info("Data retrieved successfully")
                    return creds
                } catch {
                    AppLogger.error("Decoding error: \(error.localizedDescription)")
                    return nil
                }
            }
            else{
                return nil
            }
        } else {
            AppLogger.error("Something went wrong trying to find the user in the keychain")
            return nil
        }
    }
    
    //MARK: DeleteFromKeychaing
    func deleteFromKeychain(key: String?){
        
        guard let key = key else{
            return
        }
        
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("Data removed successfully from the keychain")
        } else {
            print("Something went wrong trying to remove the data from the keychain")
        }
    }
    
}

class AppEncryptionManager {
    
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        
        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "").replacingOccurrences(of: "\n", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            print(error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }
    
    private static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
    
}

