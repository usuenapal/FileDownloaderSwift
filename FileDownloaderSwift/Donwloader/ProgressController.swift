//
//  ProgressController.swift
//  FileDownloaderSwift
//
//  Created by Usue on 15/12/15.
//  Copyright © 2019 Usue. All rights reserved.
//

import UIKit

class ProgressController: NSObject
{
    @IBOutlet var progressBar: UIProgressView!
    var downloadedBytes: [Int64]? = []
    var totalBytes: [Int64]? = []
    
    func reset()
    {
        downloadedBytes = []
        totalBytes = []
        
        progressBar.isHidden = true
        progressBar.setProgress(0.0, animated: false)
    }
    
    func setProgressDownload(_ downloaded: Int64, total: Int64)
    {
        if !totalBytes!.contains(total) {
            totalBytes!.append(total)
            downloadedBytes!.append(downloaded)
        } else {
            let i = totalBytes?.index(of: total)
            downloadedBytes![i!] = downloaded
        }
        
        let totalSum = totalBytes!.reduce(0, +)
        let downSum = downloadedBytes!.reduce(0, +)
        let progress = Float(downSum)/Float(totalSum)
        
        if progressBar.progress < progress {
            progressBar.setProgress(progress, animated: true)
        }
        
        progressBar.isHidden = downSum == totalSum
    }
}
