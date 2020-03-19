//
//  RemotePluginManager.swift
//  ELMaestro
//
//  Created by Angelo Di Paolo on 3/19/20.
//  Copyright © 2020 WalmartLabs. All rights reserved.
//

import Foundation

class RemotePluginManager {
    private(set) var plugins = [Pluggable]()
    private var libraries = [Library]()
    
    func loadRemotePlugin(_ url: URL) {
        let loader = LibraryLoader()
        loader.loadLibrary(url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let library):
                print("library open success")
                self.libraries.append(library)
                
                if let plugin = self.initializeRemotePlugin(library: library) {
                    print("plugin initialization success")
                    self.plugins.append(plugin)
                }
            case .failure(let error):
                print("loadRemotePlugin failed: \(error)")
            }
        }
    }
    
    private func initializeRemotePlugin(library: Library) -> Pluggable? {
        print("initializing plugin \(library.localURL)")
        let entryPoint = dlsym(library.handle.rawValue, "initRemotePlugin")
        guard entryPoint != nil else {
            fatalError("missing plugin initializer: \(library.localURL.absoluteString)")
        }
        typealias PluginInitializationFunc = @convention(c) () -> AnyObject
        let f = unsafeBitCast(entryPoint, to: PluginInitializationFunc.self)
        return f() as? Pluggable
    }
}

struct Library {
    let handle: LibraryHandle
    let localURL: URL
    
    init(handle: LibraryHandle, localURL: URL) {
        self.handle = handle
        self.localURL = localURL
    }
}

class LibraryHandle {
    var rawValue: UnsafeMutableRawPointer? = nil

    init(rawValue: UnsafeMutableRawPointer) {
      self.rawValue = rawValue
    }
}

enum LibraryError: Error {
    case downloadFailed
    case openFailed
}

class LibraryLoader {
    func loadLibrary(_ url: URL, completion: @escaping (Result<Library, Error>) -> Void) {
        downloadLibrary(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let localURL):
                do {
                    let handle = try self.openLibrary(localURL)
                    let library = Library(handle: handle, localURL: localURL)
                    completion(.success(library))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func downloadLibrary(url downloadURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        print("downloading library... \(downloadURL)")
        URLSession.shared.downloadTask(with: downloadURL) { (url, response, error) in
            print("download complete")
            guard let fileURL = url else {
                completion(.failure(LibraryError.downloadFailed))
                return
            }
            
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                print("saving library \(savedURL)")
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                
                let unzippedFileName = fileURL.lastPathComponent.replacingOccurrences(of: ".zip", with: "")
                let unzippedURL = documentsURL.appendingPathComponent(unzippedFileName)

                let decompressedData = try self.unzip(url: savedURL)
                
                print("saving decompressed library to \(unzippedURL)")
                try decompressedData.write(to: unzippedURL)
                
                completion(.success(savedURL))
            } catch {
                completion(.failure(error))
            }
            
            completion(.failure(LibraryError.downloadFailed))
        }.resume()
    }
    
    private func unzip(url fileURL: URL) throws -> Data {
        print("decompressing \(fileURL) ")
        let data = try Data(contentsOf: fileURL)
        if #available(iOS 13.0, *) {
            let decompressed = try (data as NSData).decompressed(using: .zlib)
            return decompressed as Data
        } else {
            fatalError("decompression failed due to iOS 13 requirement")
        }
    }
    
    private func openLibrary(_ url: URL) throws -> LibraryHandle {
        print("opening library \(url)")
        guard let handle = Darwin.dlopen(url.absoluteString, RTLD_NOW) else {
            throw LibraryError.openFailed
        }
        return LibraryHandle(rawValue: handle)
    }
}
