//
//  Extensions.swift
//  SpotifyExample
//
//  Created by Rory Avant on 3/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

extension UIImageView{
    func downloadImageWithURL(_ url: String?) {
        if let urlString = url {
            DispatchQueue.global().async {
                if !urlString.isEmpty{
                    if let imageData = try? Data(contentsOf: URL.init(string: urlString)!) {
                        DispatchQueue.main.async(execute: {
                            self.image = UIImage(data:imageData)
                        })
                    }
                } 
            }
        }
    }
}
