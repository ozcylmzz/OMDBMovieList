//
//  OMDBService.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import Alamofire

// http://www.omdbapi.com/?i=tt3896198&apikey=3005badf

enum OMDBServiceEndPoint: String {
    case BASE_URL = "https://www.omdbapi.com/?"
    case APP_ID = "&apikey=3005badf"
    case UNITS = "i="
    //    case WHEATHER_IMAGE_BASE = "https://openweathermap.org/img/wn/"
    //    case WHEATHER_IMAGE_PATH = "@2x.png"
    
    static func omdbAPIURL() -> String {
        return "\(BASE_URL.rawValue)\(APP_ID.rawValue)"
    }
    
    static func getUrl(for searchTerm: String?, pageNumber: Int?) -> URL {
        var string = BASE_URL.rawValue + APP_ID.rawValue
        if let text = searchTerm?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            string += "&s=\(text)"
        }
        if let page = pageNumber {
            string += "&page=\(page)"
        }
        guard let url = URL(string: string) else {
            fatalError("Cannot create url from string: \(string)")
        }
        return url
    }
    
    static func getUrl(forId imdbId: String) -> URL {
        let string = BASE_URL.rawValue + UNITS.rawValue + imdbId + "\(APP_ID.rawValue)"
        guard let url = URL(string: string) else {
            fatalError("Cannot create url from string: \(string)")
        }
        return url
    }
    
}

protocol IOMDBService {
    func downloadMovies(for searchTerm: String?, pageNumber: Int, success: @escaping (Result)->Void, failure: @escaping (Error?)->Void )
    func downloadMovieDetails(imdbId: String, success: @escaping (MovieDetails)->Void, failure: @escaping (Error?)->Void )
}

struct OMDBService: IOMDBService {
    
    func downloadMovies(for searchTerm: String?, pageNumber: Int, success: @escaping (Result)->Void, failure: @escaping (Error?)->Void ) {
        let url = OMDBServiceEndPoint.getUrl(for: searchTerm, pageNumber: pageNumber)
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let result = try JSONDecoder().decode(Result.self, from: jsonData)
                    success(result)
                } catch {
                    failure(error)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func downloadMovieDetails(imdbId: String, success: @escaping (MovieDetails)->Void, failure: @escaping (Error?)->Void ) {
        let url = OMDBServiceEndPoint.getUrl(forId: imdbId)
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let result = try JSONDecoder().decode(MovieDetails.self, from: jsonData)
                    success(result)
                } catch {
                    failure(error)
                }
                
            case .failure(let error):
                failure(error)
            }
        }
    }
}
