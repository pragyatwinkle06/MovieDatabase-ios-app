//
//  MovieResponseModel.swift
//  movie_Database
//
//  Created by Tata on 29/06/24.
//




//import Foundation
//
//struct Movie: Decodable {
//    let title: String
//    let year: String
//    let genre: [String]
//    let director: String
//    let actors: [String]
//    let plot: String
//    let language: [String]
//    let poster: String
//    let imdbRating: String
//    let rottenTomatoesRating: String
//    let metacriticRating: String
//
//    private enum CodingKeys: String, CodingKey {
//        case title = "Title"
//        case year = "Year"
//        case genre = "Genre"
//        case director = "Director"
//        case actors = "Actors"
//        case plot = "Plot"
//        case language = "Language"
//        case poster = "Poster"
//        case imdbRating = "imdbRating"
//        case ratings = "Ratings"
//    }
//    
//    private enum RatingsKeys: String, CodingKey {
//        case source = "Source"
//        case value = "Value"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: .title)
//        year = try container.decode(String.self, forKey: .year)
//        
//        let genreString = try container.decode(String.self, forKey: .genre)
//        genre = genreString.components(separatedBy: ", ")
//        
//        director = try container.decode(String.self, forKey: .director)
//        
//        let actorsString = try container.decode(String.self, forKey: .actors)
//        actors = actorsString.components(separatedBy: ", ")
//        
//        plot = try container.decode(String.self, forKey: .plot)
//        
//        
//        let languageString = try container.decode(String.self, forKey: .language)
//        language = languageString.components(separatedBy: ", ")
////        language = try container.decode(String.self, forKey: .language)
//        poster = try container.decode(String.self, forKey: .poster)
//        imdbRating = try container.decode(String.self, forKey: .imdbRating)
//        
//        var ratingsContainer = try container.nestedUnkeyedContainer(forKey: .ratings)
//        var rottenTomatoes = "N/A"
//        var metacritic = "N/A"
//        
//        while !ratingsContainer.isAtEnd {
//            let ratingContainer = try ratingsContainer.nestedContainer(keyedBy: RatingsKeys.self)
//            let source = try ratingContainer.decode(String.self, forKey: .source)
//            let value = try ratingContainer.decode(String.self, forKey: .value)
//            
//            switch source {
//            case "Rotten Tomatoes":
//                rottenTomatoes = value
//            case "Metacritic":
//                metacritic = value
//            default:
//                continue
//            }
//        }
//        
//        rottenTomatoesRating = rottenTomatoes
//        metacriticRating = metacritic
//    }
//}
//
//
//
////struct Movie: Decodable {
////    let title: String
////    let genre: [String] // genre as an array of strings
////    let year: String
////    let director: String
////    let actors: [String] // actors as an array of strings
////}

import Foundation

struct Movie: Decodable {
    let title: String
    let year: String
    let genre: [String]
    let director: String
    let actors: [String]
    let plot: String
    let language: [String]
    let poster: String
    let imdbRating: Double
    let rottenTomatoesRating: Double
    let metacriticRating: Double

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case poster = "Poster"
        case imdbRating = "imdbRating"
        case ratings = "Ratings"
    }
    
    private enum RatingsKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        
        let genreString = try container.decode(String.self, forKey: .genre)
        genre = genreString.components(separatedBy: ", ")
        
        director = try container.decode(String.self, forKey: .director)
        
        let actorsString = try container.decode(String.self, forKey: .actors)
        actors = actorsString.components(separatedBy: ", ")
        
        plot = try container.decode(String.self, forKey: .plot)
        
        let languageString = try container.decode(String.self, forKey: .language)
        language = languageString.components(separatedBy: ", ")
        
        poster = try container.decode(String.self, forKey: .poster)
        
        let imdbRatingString = try container.decode(String.self, forKey: .imdbRating)
        imdbRating = Double(imdbRatingString) ?? 0.0
        
        var ratingsContainer = try container.nestedUnkeyedContainer(forKey: .ratings)
        var rottenTomatoes = "0%"
        var metacritic = "0"
        
        while !ratingsContainer.isAtEnd {
            let ratingContainer = try ratingsContainer.nestedContainer(keyedBy: RatingsKeys.self)
            let source = try ratingContainer.decode(String.self, forKey: .source)
            let value = try ratingContainer.decode(String.self, forKey: .value)
            
            switch source {
            case "Rotten Tomatoes":
                rottenTomatoes = value
            case "Metacritic":
                metacritic = value
            default:
                continue
            }
        }
        
        rottenTomatoesRating = Double(rottenTomatoes.replacingOccurrences(of: "%", with: "")) ?? 0.0
        metacriticRating = Double(metacritic) ?? 0.0
    }
}
