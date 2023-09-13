//
//  FirebaseEventTracker.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import FirebaseAnalytics

enum OMDBAnalytics {
    
    static func log(event: Event) {
        switch event {
        case .launchScreen(let state):
            Analytics.logEvent(event.name, parameters: [event.name: state.rawValue])
        case .mainView(let state):
            Analytics.logEvent(event.name, parameters: [event.name: state.rawValue])
        case .movieDetails(let data):
            Analytics.logEvent(event.name, parameters: [Event.MovieDetails.Details.imdbID.rawValue: data.imdbID,
                                                        Event.MovieDetails.Details.title.rawValue: data.title,
                                                        Event.MovieDetails.Details.year.rawValue: data.year
                                                       ])
        }
    }
}

extension OMDBAnalytics {
    enum Event {
        case launchScreen(LaunchScreen.State)
        case mainView(MainView.State)
        case movieDetails(MovieDetails)
        
        
        var name: String {
            switch self {
            case .launchScreen( _): return "LAUNCH_SCREEN"
            case .mainView( _): return "MAIN_VIEW"
            case .movieDetails( _): return "MOVIE_DETAILS"
            }
        }
    }
}

extension OMDBAnalytics.Event {
    enum LaunchScreen {
        enum State: String {
            case controller = "CONTROLLER"
        }
    }
    
    enum MainView {
        enum State: String {
            case controller = "CONTROLLER"
        }
    }
    
    struct MovieDetails {
        let imdbID: String
        let title: String
        let year: String
        //        let poster: String
        //        let released: String
        //        let runTime: String
        //        let genre: String
        //        let director: String
        //        let writer: String
        //        let actors: String
        //        let plot: String
        //        let language: String
        //        let country: String
        //        let imdbRating: String
        //        let imdbVotes: String
        
        enum Details: String {
            case imdbID = "IMDB_ID"
            case title = "Title"
            case year = "YEAR"
            //            case poster = "POSTER"
            //            case released = "RELEASED"
            //            case runTime = "RUN_TIME"
            //            case genre = "GENRE"
            //            case director = "DIRECTOR"
            //            case writer = "WRITER"
            //            case actors = "ACTORS"
            //            case plot = "PLOT"
            //            case language = "LANGUAGE"
            //            case country = "COUNTRY"
            //            case imdbRating = "IMDB_RATING"
            //            case imdbVotes = "IMDB_VOTES"
        }
    }
    
}
