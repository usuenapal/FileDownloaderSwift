//
//  DownloadManager.swift
//  FileDownloaderSwift
//
//  Created by Usue on 14/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

class DownloadManager: NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate
{
    var session: NSURLSession
    var destinationUrl: NSURL
    var delegate: DownloadManagerProtocol
    
    init(delegate: DownloadManagerProtocol)
    {
        session = NSURLSession()
        destinationUrl = NSURL()
        self.delegate = delegate
        
        super.init()
    }
    
    private func getSessionConfiguration() -> NSURLSessionConfiguration
    {
        let conf = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        conf.requestCachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        conf.URLCache = nil
        conf.timeoutIntervalForResource = 3600
        
        return conf
    }
    
    private func openSession()
    {
        session = NSURLSession(configuration: self.getSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    private func closeSession()
    {
        session.invalidateAndCancel()
    }
    
    private func moveToDestinationFromPath(path: NSURL)
    {
        do {
            try NSFileManager.defaultManager().moveItemAtURL(path, toURL: destinationUrl)
        } catch {
            
        }
    }
    
    //MARK Public funcs
    
    func downloadFileForUrl(url: String)
    {
        self.openSession()
        
        let nameFile = url.componentsSeparatedByString("/").last!
        var docsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        docsPath = "\(docsPath)/\(nameFile)"
        destinationUrl = NSURL(fileURLWithPath: docsPath)
        
        let download = session.downloadTaskWithURL(NSURL(string: url)!)
        download.resume()
    }
    
    
    //MARK NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        self.moveToDestinationFromPath(location)
        downloadTask.cancel()
        self.closeSession()
        
        self.delegate.downloadedFileAtPath(destinationUrl)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        self.delegate.downloadedMbytesFromTotal(totalBytesWritten/1000, total: totalBytesExpectedToWrite/1000)
    }
}
