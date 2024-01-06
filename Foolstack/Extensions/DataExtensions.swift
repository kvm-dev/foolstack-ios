//
//  DataExtensions.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

extension Data {
    static func fromJSON(fileName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        do {
            var fileUrl: URL!
            if #available(iOS 16.0, *) {
                fileUrl = URL(filePath: filePath)
            } else {
                fileUrl = URL(fileURLWithPath: filePath)
            }
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            print("Data from json '\(fileName)' error:", error)
        }
        
        return nil
    }
}
