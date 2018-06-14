//
//  CustomAlertDelegate.swift
//  FileDownloaderSwift
//
//  Created by Usue on 15/12/15.
//  Copyright © 2015 Usue. All rights reserved.
//

import UIKit

protocol CustomAlertProtocol {
    //Called when the user pressed a button in CustomAlertController
    func pressedAlertButton(_ buttonIndex: Int)
}

class CustomAlertDelegate: UIViewController, CustomAlertProtocol {
    func pressedAlertButton(_ buttonIndex: Int) {}
}
