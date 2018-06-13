//
//  HomeController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/26/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var DorianImg: UIImageView!
    @IBOutlet weak var LewinImg: UIImageView!
    @IBOutlet weak var LeroyImg: UIImageView!
    
    var viewController : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {
        DorianImg.isUserInteractionEnabled = true
        LewinImg.isUserInteractionEnabled = true
        LeroyImg.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        gesture.numberOfTapsRequired = 1
        
        DorianImg.addGestureRecognizer(gesture)
        LewinImg.addGestureRecognizer(gesture)
        LeroyImg.addGestureRecognizer(gesture)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
    }
    
   @objc func onTapGesture(_ gesture:UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let viewController = ViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let tappedImageView = gesture.view!
        switch tappedImageView.tag {
            case 0: viewController.intGymPartner = 1
            case 1: viewController.intGymPartner = 2
            case 2: viewController.intGymPartner = 3
            default: print("ayyy")
        }
    self.navigationController?.pushViewController(viewController, animated: true)
    
        
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
