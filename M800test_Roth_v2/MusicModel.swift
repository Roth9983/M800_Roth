//
//  MusicModel.swift
//  M800test_Roth_v2
//
//  Created by 朱若慈 on 2022/12/24.
//

import Foundation

struct ResponseFormat: Codable{
    let resultCount: Int
    let results: [Music]
}

struct Music: Codable {
    let artistName: String?
    let collectionCensoredName: String?
    let trackName: String
    let artistViewUrl: URL?
    let collectionViewUrl: URL
    let previewUrl: URL
    let artworkUrl100: URL
    let trackPrice: Double?
}

class MusicModel {
    
    func callITunesAPI (_ keyword : String, _ complete: @escaping ([Music]) -> Void) {
        let api = "https://itunes.apple.com/search?term=\(keyword)&media=music"
        if let query = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: query) {
            URLSession.shared.dataTask(with:url) {
                data, response, error in
                guard let data = data else { return }
                let decoder = JSONDecoder()
                do {
                    let searchResonse = try decoder.decode(ResponseFormat.self, from: data)
                    complete(searchResonse.results)
                }
                catch {
                    print("error",error)
                }
            }.resume()
        }
    }
}
