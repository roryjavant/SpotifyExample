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
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//
//    @IBAction func btnNav(_ sender: UIButton) {
//        let viewController = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }

}
