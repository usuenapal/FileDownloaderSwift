//
//  CustomAlertViewController.swift
//  FileDownloaderSwift
//
//  Created by Usue on 12/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

struct AlertButtons {
    static let kAccept = 1
    static let kCancel = 0
}

class CustomAlertViewController: UIAlertController
{
    let delegate: CustomAlertDelegate
    
    init(title: String, message: String, delegate: CustomAlertDelegate)
    {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        self.title = title
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func showConfirmationAlert()
    {
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action:UIAlertAction!) in self.delegate.pressedAlertButton(AlertButtons.kCancel)
        })
        
        let acceptAction = UIAlertAction(title: "Download", style: .default, handler: {
            (action:UIAlertAction!) in self.delegate.pressedAlertButton(AlertButtons.kAccept)
        })
        
        addAction(acceptAction)
        addAction(cancelAction)
        delegate.present(self, animated: true, completion: nil)
    }
}
