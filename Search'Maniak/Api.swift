//
//  Api.swift
//  fenetre
//
//  Created by Winé Hugo on 07/07/2021.
//

import Foundation
import UIKit
#if canImport(FoundationNetworking)
  //linux
  import FoundationNetworking
#endif

public struct Api: Decodable {
  let resultCount: Int
  let results: [Song]
}

public struct Song: Decodable {
  var artistName: String? = nil
  var collectionName: String? = nil
  var trackName: String? = nil
  var trackViewUrl: String? = nil
  var previewUrl: String? = nil
  var artworkUrl60: String? = nil
}

public struct Song_result {
  let artistName: String
  let collectionName: String
  let trackName: String
  let trackViewUrl: String
  let previewUrl: String
  let artworkUrl60: String
  public init(song: Song) {
    artistName = song.artistName == nil ? "" : song.artistName!
    collectionName = song.collectionName == nil ? "" : song.collectionName!
    trackName = song.trackName == nil ? "" : song.trackName!
    trackViewUrl = song.trackViewUrl == nil ? "" : song.trackViewUrl!
    previewUrl = song.previewUrl == nil ? "" : song.previewUrl!
    artworkUrl60 = song.artworkUrl60 == nil ? "" : song.artworkUrl60!
  }
}

public struct Result {
  var songs: [Song_result]
}

public class ApiItunes{
  private let session = URLSession.shared
  private let decoder = JSONDecoder()

  public func orderingResult(api:Api) -> Result {
    var result = Result(songs: [])
    var song_result : Song_result
    for song in api.results {
      song_result = Song_result(song:song)
      result.songs.append(song_result)
    }
    return result
  }

  public func search(keywords:String,mediaType:String) -> Result {
    var api_value = Api(resultCount: 0, results: [])
    let medias = ["movie", "podcast", "music", "ebook", "software", "musicVideo", "audiobook", "shortFilm", "tvShow"]
    let keyword = keywords.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil).replacingOccurrences(of: "’", with: "'", options: .literal, range: nil)
    var url : URL
    if (medias.contains(mediaType)) {
        url = URL(string: "https://itunes.apple.com/search?term=\(keyword)&media=\(mediaType)&country=FR&lang=fr_fr")!
    }
    else {
        url = URL(string: "https://itunes.apple.com/search?term=\(keyword)&media=all&country=FR&lang=fr_fr")!
    }
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let sem = DispatchSemaphore.init(value: 0)
    let task = session.dataTask(with: request) {data, response, error in
      defer { sem.signal() }
      if let data = data {
        do{
          let decoded = try JSONDecoder().decode(Api.self,from:data)
              api_value = decoded
        }catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
      } else if let error = error{
          print("Request failed \(error)")
      }
    }
    task.resume()
    sem.wait()
    return self.orderingResult(api: api_value)
  }
}
