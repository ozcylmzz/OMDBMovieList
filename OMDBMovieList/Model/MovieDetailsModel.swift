//
//  MovieDetailsModel.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation

struct MovieDetails: Codable {
    var imdbID: String?
    var Title: String?
    var Year: String?
    var Poster: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var imdbRating: String?
    var imdbVotes: String?
}
