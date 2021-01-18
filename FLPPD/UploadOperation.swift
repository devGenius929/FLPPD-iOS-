//
//  UploadOperation.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/20/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import Filestack
import FilestackSDK

class UploadImageOperation: Operation {
    internal static var fileStackClient:Filestack.Client? = {
        // Initialize a `Policy` with the expiry time and permissions you need.
        let oneDayInSeconds: TimeInterval = 60 * 60 * 24 * 30 // expires next month
        
        let policy = Policy(expiry: .distantFuture,
                            call: [.pick, .read, .stat, .write, .writeURL, .store, .convert, .remove, .exif])
        
        guard let security = try? Security(policy: policy, appSecret: "AVFWCCTZKJFITKGXSKOTAENN4Y") else {
            fatalError("Unable to instantiate Security object.")
        }
        
        // Create `Config` object.
        let config = Filestack.Config()
        
        // Make sure to assign an app scheme URL that matches the one configured in your info.plist.
        config.appURLScheme = "flppd"
        
        config.availableLocalSources = LocalSource.all()
        config.availableCloudSources = CloudSource.all()
        
        let client = Filestack.Client(apiKey: "Ah3czlUD8RhzVHXoMTxNIz", security: security, config: config)
        
        return client
    }()
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    override var isConcurrent: Bool { return true }
    internal let fileUrl:URL
    internal var _uploadedURL:URL?
    internal var request:CancellableRequest?
    var uploadedURL:URL? {
        get {
            return _uploadedURL
        }
    }
    init(image:UIImage) {
        fileUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        let data = UIImageJPEGRepresentation(image, 0)
        try! data!.write(to: fileUrl)
    }
    
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
        self.request = UploadImageOperation.fileStackClient!.upload(from: fileUrl, completionHandler: {[weak self] (response) in
            if let json = response?.json, let url = json["url"] as? String {
                // Use Filestack handle
                if let sself = self {
                    sself._uploadedURL = URL(string: url)
                }
                if let sself = self {
                    try? FileManager.default.removeItem(at: sself.fileUrl)
                    sself.state = .finished
                }
            }
        })
    }
    override func cancel() {
        self.request?.cancel()
        self.state = .finished
    }
}

class UploadMultiImages {
    private let images:[UIImage]
    private let queue = OperationQueue()
    init(images:[UIImage]) {
        self.images = images
    }
    func start(completion: @escaping ([URL?]) -> Void)  {
        if self.images.count == 0 {
            completion([URL?]())
            return
        }
        DispatchQueue.global(qos: .background).async {
            var operations = [UploadImageOperation]()
            for image in self.images {
                operations.append(UploadImageOperation(image: image))
                
            }
            self.queue.addOperations(operations, waitUntilFinished: true)
            let resultUrls = operations.map{ $0.uploadedURL}
            DispatchQueue.main.async {
                completion(resultUrls)
            }
            
        }

        
    }
    
}



