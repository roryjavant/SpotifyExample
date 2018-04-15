//
//  HomeController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/26/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var viewController : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let viewController = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
        switch sender.tag {
        case 1: viewController.intGymPartner = 1
        case 2: viewController.intGymPartner = 2
        case 3: viewController.intGymPartner = 3
        default: print(sender.tag)
        }        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
