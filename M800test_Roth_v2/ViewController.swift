//
//  ViewController.swift
//  M800test_Roth_v2
//
//  Created by 朱若慈 on 2022/12/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var musicList: UITableView!
    
    var player: AVAudioPlayer?
    
    var datasource : [Music] = []
    
    var playingId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        musicList.delegate = self
        musicList.dataSource = self
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        searchBar.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        guard let keyword = textField.text else { return }
        MusicModel().callITunesAPI(keyword) {
            musics in
            DispatchQueue.main.async {
                self.datasource = musics
                self.musicList.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as? MusicListCell else {
            return UITableViewCell()
        }
        let music = datasource[indexPath.row]
        cell.cover.image = UIImage(data: try! Data(contentsOf: music.artworkUrl100))
        cell.name.text = music.trackName
        cell.play.tag = indexPath.row
        cell.play.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        
        return cell
    }
    
    @objc func playMusic(_ sender : UIButton){
        let manager = PaulPlayerManager.shared
        if let id = playingId, id == sender.tag {
            manager.player.pause()
            if #available(iOS 13.0, *) {
                sender.imageView?.image = UIImage(systemName: "play.circle")
            } else {
                // Fallback on earlier versions
            }
        } else {
            playingId = sender.tag
            manager.setupPlayer(with: datasource[playingId!].previewUrl)
            manager.player.play()
            if #available(iOS 13.0, *) {
                sender.imageView?.image = UIImage(systemName: "stop.circle")
            } else {
                // Fallback on earlier versions
            }
        }
    }
    

}



class MusicListCell : UITableViewCell {
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cover: UIImageView!
}
