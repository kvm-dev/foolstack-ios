//
//  WebImageView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 30.12.2023.
//

import UIKit
import Combine
import SVGKit

@IBDesignable
class WebImageView: UIImageView {
    var onLoadFinished: (() -> Void)?
    var subscriptions = Set<AnyCancellable>()
    
    func load(urlString: String, folder: String, onComplete: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            printToConsole("Image URL init error. \(urlString)")
            return
        }
        load(url: url, folder: folder, onComplete: onComplete)
    }
    
    func load(url: URL, folder: String, onComplete: (() -> Void)? = nil) {
        //print("Load image URL: \(url.lastPathComponent)")
        onLoadFinished = onComplete
        if !loadFromCache(fileName: url.lastPathComponent, folder: folder) {
            loadFromWeb(url: url, localFolder: folder)
        }
    }
    
    private func loadFromCache(fileName: String, folder: String) -> Bool {
        guard let path = URL.cacheURL(subfolders: folder) else {
            printToConsole("Get cache folder 'covers' failed")
            return false
        }
        let filePath = path.appendingPathComponent(fileName)
        //print(filePath.relativePath)
        if filePath.pathExtension.lowercased() == "svg",
           let svgImage = SVGKImage(contentsOf: filePath) {
            let img = svgImage.uiImage
            self.image = img
            onLoadFinished?()
            return true
        } else if let img = UIImage(contentsOfFile: filePath.relativePath) {
            self.image = img
            onLoadFinished?()
            return true
        } else {
            printToConsole("UIImage from cache error")
        }
        
        return false
    }
    
    private func loadFromWeb(url: URL, localFolder: String) {
        let fileName = url.lastPathComponent
        URLSession.shared
            .dataTaskPublisher(for: url)
        //.delay(for: .seconds(3), scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
        //.print("YandexAPI")
            .sink { completion in
                if case .failure(let err) = completion {
                    printToConsole("Retrieving image data failed with error \(err)")
                }
            } receiveValue: { [weak self] (data: Data, response: URLResponse) in
                if let httpResponce = response as? HTTPURLResponse {
                    if httpResponce.statusCode == 200 {
                        //print("Image loaded successfully")
                        self?.dataLoaded(data, fileName: fileName, folder: localFolder)
                    } else {
                        printToConsole("Response error. code \(httpResponce.statusCode) - \(httpResponce)")
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func dataLoaded(_ data: Data, fileName: String, folder: String) {
        if let img = UIImage(data: data) {
            self.image = img
            onLoadFinished?()
            saveDataToCache(data: data, fileName: fileName, folder: folder)
        } else {
            printToConsole("UIImage from data error")
        }
    }
    
    private func saveDataToCache(data: Data, fileName: String, folder: String) {
        guard let path = URL.cacheURL(subfolders: folder) else {
            printToConsole("Get cache folder 'covers' failed")
            return
        }
        
        let filePath = path.appendingPathComponent(fileName)
        do {
            try data.write(to: filePath)
        } catch {
            printToConsole("Failed to save image to cache")
        }
    }
}
