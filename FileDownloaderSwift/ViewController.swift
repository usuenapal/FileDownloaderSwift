//
//  ViewController.swift
//  FileDownloaderSwift
//
//  Created by Usue on 12/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

struct Links {
    static let links: [String] = ["https://digitaldeleon.com/wp-content/uploads/2018/04/digitaldeleon-com-2018-04-20-10-0426-235824.jpg", "https://cdn1.royalcanin.es/wp-content/uploads/2017/01/gatos-de-interior.jpg", "https://www.notigatos.es/wp-content/uploads/2017/10/gato-encima-de-la-mesa-830x553.jpg", "http://fotografias.lasexta.com/clipping/cmsimages02/2016/03/13/9A1C357F-2FDD-4DD0-BFE5-5AAA2C81F6FB/58.jpg", "http://rumbos.viapais.com.ar/wp-content/uploads/2017/08/20170809183102_29384092_0_body-760x433-c-center.jpg", "https://www.hogarmania.com/archivos/201610/como-ven-los-gatos-XxXx80.jpg", "https://www.webconsultas.com/sites/default/files/styles/encabezado_articulo/public/articulos/intoxicacion-gatos.jpg?itok=ZEdt0aON", "http://3.bp.blogspot.com/-KZ0-FUd12Rw/U7Rs9WS2WzI/AAAAAAAAAA4/Eue_j6DV3uU/s1600/gato-siam%25C3%25A9s-muy-tierno.jpg", "https://static.vix.com/es/sites/default/files/styles/large/public/btg/curiosidades.batanga.com/files/8-sorprendentes-cosas-que-no-sabias-sobre-los-gatos-4.jpg?itok=SBwPbF17"]
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

    @IBAction func downloadFile(_ but: UIButton)
    {
        let alert = CustomAlertViewController(title: "Please confirm", message: "Are you sure you want to download the file?", delegate: self)
        downloadingBtn = but
        alert.showConfirmationAlert()
    }
    
    @IBAction func resetView()
    {
        completedDownloads = 0
        progressController?.reset()
        
        for but: UIButton in btns {
            but.isEnabled = true
            but.setBackgroundImage(nil, for: UIControlState())
            but.setTitle("Press to download\nrandom image", for: UIControlState())
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
    
    override func pressedAlertButton(_ buttonIndex: Int)
    {
        if buttonIndex == AlertButtons.kAccept {
            progressController.reset()
            self.downloadRandomFile()
        }
    }
    
    func downloadRandomFile()
    {
        let randIndex = Int(arc4random_uniform(UInt32(Links.links.count)))
        let url = Links.links[randIndex]
        
        DownloadManager(delegate: self).downloadFileForUrl(url)
    }
    
    
    //MARK DownloadManagerProtocol
    
    func downloadedFileAtPath(_ path: URL)
    {
        if downloadingBtn == nil && btns.count > completedDownloads {
            downloadingBtn = btns[completedDownloads]
            completedDownloads += 1
        }
        
        downloadingBtn?.setBackgroundImage(UIImage(data: try! Data(contentsOf: path)), for: .normal)
        downloadingBtn?.subviews.first?.contentMode = .scaleAspectFill
        downloadingBtn?.setTitle("", for: UIControlState())
        downloadingBtn?.isEnabled = false
        downloadingBtn = nil
    }
    
    func downloadedMbytesFromTotal(_ downloaded: Int64, total: Int64)
    {
        progressController.setProgressDownload(downloaded, total: total)
    }
    
    
    //MARK UIViewController
    
    override var prefersStatusBarHidden : Bool
    {
        return true
    }
}

