//
//  MainViewModel.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation

protocol IMainViewModel {
    var movies: [Movie]? { get set }
    var isPaginating: Bool { get set }
    
    var didFetchMoviesSucceed: (()->Void)? { get set }
    var didFetchMoviesFail: ((Error?)->Void)? { get set }
    
    var didFetchMovieDetailsSucceed: ((MovieDetails)->Void)? { get set }
    var didFetchMovieDetailsFail: ((Error?)->Void)? { get set }
    
    var omdbService: IOMDBService { get }
    
    func fetchMovies(for searchText: String?, pageNumber: Int)
    func getMovie(at index: Int) -> Movie
    func fetchMovieDetails(for index: Int)
}

final class MainViewModel: IMainViewModel {
    var movies: [Movie]?
    var isPaginating: Bool
    var didFetchMoviesSucceed: (() -> Void)?
    var didFetchMoviesFail: ((Error?) -> Void)?
    var didFetchMovieDetailsSucceed: ((MovieDetails) -> Void)?
    var didFetchMovieDetailsFail: ((Error?) -> Void)?
    var omdbService: IOMDBService
    
    init() {
        omdbService = OMDBService()
        isPaginating = false
    }
    
    func fetchMovies(for searchText: String?, pageNumber: Int) {
        self.omdbService.downloadMovies(for: searchText, pageNumber: pageNumber) { result in
            guard !(result.Search?.isEmpty ?? true) else { return }
            if self.isPaginating {
                self.movies?.append(contentsOf: result.Search ?? [])
            } else {
                self.movies = result.Search ?? []
            }
            self.didFetchMoviesSucceed?()
        } failure: { error in
            self.didFetchMoviesFail?(error)
        }
    }
    
    func fetchMovieDetails(for index: Int) {
        guard let imdbId = getMovie(at: index).imdbID else {
            print(invalidImdbID)
            return
        }
        omdbService.downloadMovieDetails(imdbId: imdbId) { movie in
            self.didFetchMovieDetailsSucceed?(movie)
        } failure: { error in
            self.didFetchMovieDetailsFail?(error)
        }
    }
    
    func getMovie(at index: Int) -> Movie {
        guard let movieCount = self.movies?.count, index < movieCount, let movie = self.movies?[index] else {
            fatalError(movieIndexOutOfRange)
        }
        return movie
    }
    
}
