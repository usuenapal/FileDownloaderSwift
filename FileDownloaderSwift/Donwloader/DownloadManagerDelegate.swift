//
//  DownloadManagerDelegate.swift
//  FileDownloaderSwift
//
//  Created by Usue on 14/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

protocol DownloadManagerProtocol {
    //Called when the file has been download and saved on Documents directory
    func downloadedFileAtPath(path: NSURL)
    //Called during the downlod to manage UI information
    func downloadedMbytesFromTotal(downloaded: Int64, total: Int64)
}