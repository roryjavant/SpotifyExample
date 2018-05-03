//
//  PlaylistTableViewController.swift
//  SpotifyExample
//
//  Created by Rory Avant on 4/6/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import UIKit

protocol PlayListTableViewControllerDelegate: class {
    func updateCollectionViewFooter()
}





class PlaylistTableViewController: UITableViewController {
    
  
    var playStatusButtonArr : [UIButton] = [UIButton]()
    var numOfCells : Int = 0
    var delegate: PlayListTableViewControllerDelegate?
    var api = API.sharedAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numOfCells
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "playlistCell"
        let index = indexPath.item
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaylistTableViewCell else {
            fatalError("The dequeued cell is not an instance of PlaylistTableViewCell")
        }
        let spotifyBlack: UIColor = UIColor(red: 24.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.tableView.backgroundColor = spotifyBlack
        cell.contentView.backgroundColor = spotifyBlack
        
        if api.userPlaylists.count > 0 {
        cell.trackName.text = api.userPlaylists[index].name
        cell.trackArtist.text = "Rory the King"
        cell.trackNumber.text = String(index)
        cell.playStatusButton.tag = index
            cell.playStatusButton.addTarget(self, action: #selector(PlaylistTableViewController.playStatusButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        playStatusButtonArr.append(cell.playStatusButton)
        }
        return cell
    }
    
    @objc func playStatusButtonPressed(sender: UIButton) {
        for button in playStatusButtonArr {
            if button.tag == sender.tag {
                api.selectedPlaylist = api.userPlaylists[button.tag].name
                api.selectedPlaylistId = api.userPlaylists[button.tag].playableUri
                api.selectedPlaylistCount = api.userPlaylists[button.tag].trackCount
                api.selectedPlaylistOwner = api.userPlaylists[button.tag].owner.canonicalUserName
                
                let playlistImage = api.userPlaylists[button.tag].images[0] as? SPTImage
                api.selectedPlaylistImage = playlistImage
                api.selectedPlaylistImageUrl = (playlistImage?.imageURL.absoluteString)!
                
                if button.isSelected {
                    button.isSelected = false
                    button.setTitle("X", for: UIControlState.normal)
                } else {
                    button.isSelected = true
                    button.setTitle("O", for: UIControlState.normal)
                }
            } else {
                button.isSelected = false
                button.setTitle("X", for: UIControlState.normal)
            }
        }
        
        api.selectedPlaylistUrlString = parsePlaylistUrl(urlString: api.selectedPlaylistId.absoluteString)
        delegate?.updateCollectionViewFooter()
        navigationController?.popViewController(animated: true)
    }
    
    func parsePlaylistUrl(urlString: String) -> String {
        let array = urlString.components(separatedBy: ":")
        return array[array.count - 1]
        
    }
    
    
}


