//
//  ViewController.swift
//  FileDownloaderSwift
//
//  Created by Usue on 12/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

struct Links {
    static let arrayOfLinks: [String] = ["https://scontent-mad1-1.cdninstagram.com/hphotos-xpt1/t51.2885-15/e35/12093320_175788646097650_1777493373_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xfa1/t51.2885-15/e15/11374708_899719610075462_2079944361_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-prn/t51.2885-15/e15/10453926_1525032927724797_562310669_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xpa1/t51.2885-15/e15/1172839_567556833321932_1527333660_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xtf1/t51.2885-15/e15/10513792_495014900600282_1769370509_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xpt1/t51.2885-15/e15/11267034_1587652828164926_739789033_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xat1/t51.2885-15/e15/10919668_1403608136601456_1011441104_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xpt1/t51.2885-15/e35/12070633_1679386142347942_1275333499_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xap1/l/t51.2885-15/e15/11372383_937098472979017_670472374_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xpa1/t51.2885-15/e15/11372175_104769283194557_114794195_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-ash/t51.2885-15/e15/10723669_1572438389651503_1533272280_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xat1/t51.2885-15/e15/891457_764319533631305_2078191492_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xft1/t51.2885-15/e15/891425_1525578637671412_1116020074_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/1173072_677701488928350_961482092_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xtf1/t51.2885-15/e35/11351795_925257324218183_1231567850_n.jpg", "https://scontent-mad1-1.cdninstagram.com/hphotos-xft1/t51.2885-15/e35/11248985_1641164812807481_1190120378_n.jpg"]
}

class ViewController: CustomAlertDelegate, DownloadManagerProtocol
{
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var btns: [UIButton]!
    var downloadingBtn: UIButton!
    var completedDownloads: Int = 0
    var progressController: ProgressController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        progressController = ProgressController()
        progressController.progressBar = self.progressBar
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func downloadFile(but: UIButton)
    {
        let alert = CustomAlertViewController(title: "Please confirm", message: "Are you sure you want to download the file?", delegate: self)
        downloadingBtn = but
        alert.showConfirmationAlert()
    }
    
    @IBAction func resetView()
    {
        completedDownloads = 0
        progressController.reset()
        
        for but: UIButton in btns {
            but.enabled = true
            but.setBackgroundImage(nil, forState: .Normal)
            but.setTitle("Press to download\nrandom image", forState: .Normal)
        }
    }
    
    @IBAction func downloadAll()
    {
        self.resetView()
        
        for _ in 1...btns.count {
            self.downloadRandomFile()
        }
    }
        
    
    //MARK CustomAlertDelegate
    
    override func pressedAlertButton(buttonIndex: Int)
    {
        if buttonIndex == AlertButtons.kAccept {
            progressController.reset()
            self.downloadRandomFile()
        }
    }
    
    func downloadRandomFile()
    {
        let randIndex = Int(arc4random_uniform(UInt32(Links.arrayOfLinks.count)))
        let url = Links.arrayOfLinks[randIndex]
        
        DownloadManager(delegate: self).downloadFileForUrl(url)
    }
    
    
    //MARK DownloadManagerProtocol
    
    func downloadedFileAtPath(path: NSURL)
    {
        if downloadingBtn == nil {
            downloadingBtn = btns[completedDownloads]
            completedDownloads++
        }
        
        downloadingBtn.setBackgroundImage(UIImage(data: NSData(contentsOfURL: path)!), forState: .Normal)
        downloadingBtn.enabled = false
        downloadingBtn.setTitle("", forState: .Normal)
        downloadingBtn = nil
    }
    
    func downloadedMbytesFromTotal(downloaded: Int64, total: Int64)
    {
        progressController.setProgressDownload(downloaded, total: total)
    }
    
    
    //MARK UIViewController
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}

