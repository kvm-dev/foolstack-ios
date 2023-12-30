//
//  DataCacheTemp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 29.12.2023.
//

import Foundation

extension DataCacheImp {
    static func createMockResources() {
        copyFileToDocuments(sourcePath: "cache/images/professions", filename: "prof_1.svg")
        copyFileToDocuments(sourcePath: "cache/images/professions", filename: "prof_2.svg")
        copyFileToDocuments(sourcePath: "cache/images/professions", filename: "prof_3.svg")
    }
    
    func copyFolderToDocuments(path: String) {
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("Stickers")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("Stickers")
            
            do {
                if !FileManager.default.fileExists(atPath:(finalDatabaseURL.path))
                {
                    try FileManager.default.createDirectory(atPath: (finalDatabaseURL.path), withIntermediateDirectories: false, attributes: nil)
                }
                copyFiles(pathFromBundle: (documentsURL?.path)!, pathDestDocs: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
    }
    
    func copyFiles(pathFromBundle : String, pathDestDocs: String) {
        let fileManagerIs = FileManager.default
        do {
            let filelist = try fileManagerIs.contentsOfDirectory(atPath: pathFromBundle)
            try? fileManagerIs.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)
            
            for filename in filelist {
                try? fileManagerIs.copyItem(atPath: "\(pathFromBundle)/\(filename)", toPath: "\(pathDestDocs)/\(filename)")
            }
        } catch {
            print("\nError\n")
        }
    }
    static func copyFileToDocuments(sourcePath: String, filename: String) {
        do {
            let sourceFolderUrl = URL(fileURLWithPath: sourcePath)
            
            let folderParts = sourcePath.components(separatedBy: ["/", "\\"])

            guard var documentsURL = Bundle.main.resourceURL else {
                return
            }
            folderParts.forEach { documentsURL = documentsURL.appendingPathComponent($0) }

            let fm = FileManager.default
            let rootFolder = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            var folder = rootFolder
            folderParts.forEach { folder = folder.appendingPathComponent($0) }
            
            if !fm.fileExists(atPath: folder.path) {
                try fm.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            }
            
            let sourceFileUrl = documentsURL.appendingPathComponent(filename)
            let sourceFilePath = sourcePath + "/" + filename
            let fileUrl = folder.appendingPathComponent(filename)
            let fileExist = fm.fileExists(atPath: fileUrl.path)
            if !fileExist {
                try fm.copyItem(at: sourceFileUrl, to: fileUrl)
//                try fm.copyItem(atPath: sourceFilePath, toPath: fileUrl.path)
            }
        }
        catch {
            print("Saving file failed.", error)
        }
        
    }
}