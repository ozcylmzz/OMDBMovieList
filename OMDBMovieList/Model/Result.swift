//
//  Result.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation

struct Result: Codable {
    var Search: [Movie]?
}

struct Movie: Codable {
    var imdbID: String?
    var Title: String?
    var Year: String?
    var Poster: String?
}
