//
//  TvShow.swift
//  fenetre
//
//  Created by Winé Hugo on 08/07/2021.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class TvShowViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var message: UILabel!
    
    
    let api : ApiItunes! = ApiItunes()
    var data : Result! = Result(songs:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate=self
        tableView.dataSource=self
        tableView.layer.backgroundColor=UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIView()
        if let image = UIImage(named: "play") {
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
        }
        message.textAlignment = .center
        message.text = ""
    }
    
    @IBAction func click(_ sender: Any) {
        self.message.text = ""
        if let index = tableView.indexPathsForSelectedRows {
            if (!data.songs[index[0][1]].previewUrl.isEmpty) {
                let music = URL(string: data.songs[index[0][1]].previewUrl)
                let player = AVPlayer(url: music!)
                let vc = AVPlayerViewController()
                vc.player = player
                self.present(vc, animated: true) { vc.player?.play() }
            }
            else {
                self.message.text = "Désolé! Pas d'extrait disponible."
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        var content_cell = ""
        if(!data.songs[indexPath.row].trackName.isEmpty){
            content_cell = "\(data.songs[indexPath.row].trackName)\n"
            if(!data.songs[indexPath.row].collectionName.isEmpty) {
                content_cell += " - \(data.songs[indexPath.row].collectionName)\n"
            }
        }else{
            content_cell = "\(data.songs[indexPath.row].collectionName)\n"
        }
        if (!data.songs[indexPath.row].artistName.isEmpty) {
            content_cell += data.songs[indexPath.row].artistName
        }
        cell.textLabel?.text = content_cell
        if (!data.songs[indexPath.row].artistName.isEmpty) {
            var data_image : Data
            let url = URL(string: data.songs[indexPath.row].artworkUrl60)
            data_image = try! Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data_image)
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor(displayP3Red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(0.3))
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data.songs.count == 0 && searchBar.text != "") {
            self.tableView.setEmptyMessage("Désolé! Aucune série n'a été trouvée.")
            self.message.text = ""
        } else {
            self.tableView.restore()
        }
        return data.songs.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        if !text.isEmpty{
            data=api.search(keywords: text, mediaType: "tvShow")
        }
        tableView.reloadData()
    }
}
