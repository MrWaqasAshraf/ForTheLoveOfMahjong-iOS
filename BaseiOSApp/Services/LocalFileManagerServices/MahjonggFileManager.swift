//
//  MahjonggFileManager.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 01/09/2025.
//

import Foundation
import UIKit

enum MahjongFileDirectories: String{
    
    case tournamentPhotosFileDirectory = "MahjongTournamentPhotos"
    
}

enum AppFileType{
    case photo
}

struct TempFileURLs {
    
    static private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static private let userPhotosURL = documentsURL.appendingPathComponent(MahjongFileDirectories.tournamentPhotosFileDirectory.rawValue)
    
    static let tournamentImage = userPhotosURL.appendingPathComponent("m_image.png")
//    static let adVideo = userPhotosURL.appendingPathComponent("adImage")
    static let profileImage = userPhotosURL.appendingPathComponent("profileImage.png")
    
    var tournamanetVideoUrl: URL?
    
    init(tournamanetVideoUrl: String? = nil) {
        if let tournamanetVideoUrl {
            self.tournamanetVideoUrl = TempFileURLs.userPhotosURL.appendingPathComponent(tournamanetVideoUrl)
        }
    }
    
    static func getTempDirectoryUrl() -> URL{
        return userPhotosURL
    }
    
}

class MahjongFileManager{
    
    static let shared: MahjongFileManager = MahjongFileManager()
    
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private func createTempAdsPhotosFileDirectory(){
        
        let fileManager = FileManager.default
        let userPhotosURL = TempFileURLs.getTempDirectoryUrl()
        let isDirectoryAvailable: Bool = checkIfFileOrDirectoryExists(path: userPhotosURL.relativePath, isDirectory: true)
        
        if !isDirectoryAvailable{
            do {
                try fileManager.createDirectory(at: userPhotosURL, withIntermediateDirectories: true, attributes: nil)
                print("Directory created successfully")
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        
    }
    
    func accessPlistValues<T>(plistName: PlistFileName, keyname: String, returnValuetype: T.Type) -> T? {
        if let dict = Bundle.parsePlist(ofName: .internalName), let value = dict[keyname] as? T {
            return value
        }
        else {
            return nil
        }
    }
    
    func addfileToLocalFiles(fileData: Data, isTemp: Bool = true, fileName: String? = nil, fileLocationUrl: URL) -> Bool{
        let fileManager = FileManager.default
        if let fileName, !isTemp{
            //Save permament file here
            print("Do nothing for permanent")
            return false
        }
        else if isTemp{
            //save temp file here
            
            //Create ads photos directory
            createTempAdsPhotosFileDirectory()
            
            //Check if file already Exists
            let tempImageURL = fileLocationUrl
            let exists: Bool = checkIfFileOrDirectoryExists(path: tempImageURL.relativePath)
            if exists{
                do {
                    
                    try fileManager.removeItem(at: tempImageURL)
                    print("File removed successfully")
                    
                    //Perform write operation and return success or failure
                    let isWriteSuccessfull = writeFile(data: fileData, pathUrl: tempImageURL)
                    return isWriteSuccessfull
                    
                } catch {
                    print("Error deleting file")
                    return false
                }
            }
            else{
                //Perform write operation and return success or failure
                let isWriteSuccessfull = writeFile(data: fileData, pathUrl: tempImageURL)
                return isWriteSuccessfull
            }
        }
        
        return false
    }
    
    private func writeFile(data: Data?, pathUrl: URL) -> Bool{
        if let data{
            do {
                try data.write(to: pathUrl)
                print("Successfully wrote to file!")
                return true
            } catch {
                print("Error writing to file: \(error)")
                return false
            }
        }
        else{
            print("File data doesn't exist")
            return false
        }
    }
    
    private func checkIfFileOrDirectoryExists(path: String, isDirectory: ObjCBool = false) -> Bool{
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = isDirectory
        print("Path: \(path)")
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                print("The directory exists.")
                return true
            } else {
                print("A file exists at the specified path.")
                return true
            }
        } else {
            print("The \(isDirectory.boolValue ? "directory" : "file") does not exist.")
            return false
        }
    }
    
    func readFile(path: URL) -> URL?{
        let isAvailable = checkIfFileOrDirectoryExists(path: path.relativePath)
        return isAvailable ? path : nil
    }
    
    func removeFile(path: URL){
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: path)
            print("File removed successfully")
            
        } catch {
            print("Error deleting file")
        }
    }
    
}

enum PlistFileName: String {
    case internalName = "Mahjong-Internal"
}

extension Bundle {
    
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
           return nil
        }
        return value
    }
    
    static func parsePlist(ofName name: PlistFileName) -> [String: AnyObject]? {

            // check if plist data available
        guard let plistURL = Bundle.main.url(forResource: name.rawValue, withExtension: "plist"),
                let data = try? Data(contentsOf: plistURL)
                else {
                    return nil
            }

            // parse plist into [String: Anyobject]
            guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] else {
                return nil
            }

            return plistDictionary
        }
    
}

//MARK: How to USE
/*
 //Camera image capture
 if let capturedImage = info[.editedImage] as? UIImage{
     adImage.image = capturedImage
     if let imageData = capturedImage.pngData(){
         let isSaved: Bool = MahjongFileDirectories.shared.addfileToLocalFiles(fileData: imageData, fileLocationUrl: TempFileURLs.tournamentImage)
         if !isSaved{
             GenericToast.showToast(message: "Some issue occurred")
         }
         if let imageUrl = MahjongFileDirectories.shared.readFile(path: TempFileURLs.tournamentImage){
             viewModel.imageUrls = [imageUrl]
             print("Ad added: \(String(describing: viewModel.imageUrls))")
         }
     }
 }
 else if let assetUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
     let type = assetUrl.pathExtension           //e.g: MOV
     generateThumbnailRepresentations(fileUrl: assetUrl)
     print("video url: \(assetUrl): location url \(assetUrl.absoluteString), type: \(type)")
     viewModel.imageUrls = [assetUrl]
 }
 */
