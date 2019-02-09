//
//  DownloadManager.swift
//  FileDownloaderSwift
//
//  Created by Usue on 14/12/15.
//  Copyright © 2019 Usue. All rights reserved.
//

import UIKit

class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate
{
    var session: Foundation.URLSession
    var destinationUrl: URL?
    var delegate: DownloadManagerProtocol
    
    init(delegate: DownloadManagerProtocol)
    {
        session = Foundation.URLSession()
        self.delegate = delegate
        
        super.init()
    }
    
    fileprivate func getSessionConfiguration() -> URLSessionConfiguration
    {
        let conf = URLSessionConfiguration.ephemeral
        conf.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        conf.urlCache = nil
        conf.timeoutIntervalForResource = 3600
        
        return conf
    }
    
    fileprivate func openSession()
    {
        session = Foundation.URLSession(configuration: self.getSessionConfiguration(), delegate: self, delegateQueue: OperationQueue.main)
    }
    
    fileprivate func closeSession()
    {
        session.invalidateAndCancel()
    }
    
    fileprivate func moveToDestinationFromPath(_ path: URL)
    {
        do {
            try FileManager.default.moveItem(at: path, to: destinationUrl!)
        } catch {}
    }
    
    //MARK Public funcs
    
    func downloadFileForUrl(_ url: String)
    {
        self.openSession()
        
        let nameFile = url.components(separatedBy: "/").last!
        var docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        docsPath = "\(docsPath)/\(nameFile)"
        destinationUrl = URL(fileURLWithPath: docsPath)
        
        let download = session.downloadTask(with: URL(string: url)!)
        download.resume()
    }
    
    
    //MARK NSURLSessionDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        moveToDestinationFromPath(location)
        downloadTask.cancel()
        closeSession()
        
        delegate.downloadedFileAtPath(destinationUrl!)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        delegate.downloadedMbytesFromTotal(totalBytesWritten/1000, total: totalBytesExpectedToWrite/1000)
    }
}
