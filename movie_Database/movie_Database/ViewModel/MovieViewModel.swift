//
//  MovieViewModel.swift
//  movie_Database
//
//  Created by Tata on 29/06/24.
//

//import Foundation
//
//class MovieViewModel {
//    private var movies: [Movie] = []
//    private var filteredMovies: [Movie] = []
//    private var isFiltered: Bool = false
//
//    init() {
//        loadMovies()
//    }
//
//    private func loadMovies() {
//        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                self.movies = try JSONDecoder().decode([Movie].self, from: data)
//                print("Movies loaded successfully. Total movies: \(movies.count)")
//                for movie in movies {
//                    print("Title: \(movie.title), Year: \(movie.year), Genre: \(movie.genre)")
//                }
//            } catch {
//                print("Error loading movies: \(error)")
//            }
//        } else {
//            print("Error: movies.json file not found.")
//        }
//    }
//
//    func getMovies() -> [Movie] {
//        return isFiltered ? filteredMovies : movies
//    }
//
//    func filterMovies(by criteria: String, value: String) {
//        filteredMovies = movies.filter {
//            switch criteria {
//            case "title":
//                return $0.title.contains(value)
//            case "genre":
//                return $0.genre.contains(value)
//            case "actor":
//                return $0.actors.contains(value)
//            case "director":
//                return $0.director.contains(value)
//            default:
//                return false
//            }
//        }
//        isFiltered = true
//    }
//
//    func clearFilter() {
//        isFiltered = false
//    }
//}
import Foundation

class MovieViewModel {
    private var allMovies: [Movie] = []
    private var filteredMovies: [Movie] = []
    var isFiltering: Bool = false

    init() {
            fetchMovies()
        }

    func fetchMovies() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                print("Raw JSON Data: \(String(data: data, encoding: .utf8)!)")
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                self.allMovies = movies
                print("Parsed Movies: \(movies)")
            } catch {
                print("Error loading movies: \(error)")
            }
        }
    }

    func getMovies() -> [Movie] {
        return isFiltering ? filteredMovies : allMovies
    }

    func getDistinctYears() -> [String] {
        let years = Set(allMovies.map { $0.year })
        return Array(years).sorted()
    }

    func getDistinctGenres() -> [String] {
        let genres = Set(allMovies.flatMap { $0.genre })
        return Array(genres).sorted()
    }

    func getDistinctDirectors() -> [String] {
        let directors = Set(allMovies.map { $0.director })
        return Array(directors).sorted()
    }

    func getDistinctActors() -> [String] {
        let actors = Set(allMovies.flatMap { $0.actors })
        return Array(actors).sorted()
    }

    func clearFilter() {
        isFiltering = false
        filteredMovies = []
    }

    func filterMovies(by field: String, value: String) {
        isFiltering = true
        switch field {
        case "title":
            filteredMovies = allMovies.filter { $0.title.contains(value) }
        case "actor":
            filteredMovies = allMovies.filter { $0.actors.contains(where: { $0.contains(value) }) }
        case "genre":
            filteredMovies = allMovies.filter { $0.genre.contains(where: { $0.contains(value) }) }
        case "director":
            filteredMovies = allMovies.filter { $0.director.contains(value) }
        default:
            filteredMovies = allMovies
        }
    }

    func filterMoviesForSelectedValue(section: Int, value: String) -> [Movie] {
        switch section {
        case 0:
            return allMovies.filter { $0.year == value }
        case 1:
            return allMovies.filter { $0.genre.contains(value) }
        case 2:
            return allMovies.filter { $0.director == value }
        case 3:
            return allMovies.filter { $0.actors.contains(value) }
        default:
            return allMovies
        }
    }
    
    
    func searchMovies(by searchText: String) {
            isFiltering = true
            filteredMovies = allMovies.filter {
                $0.title.contains(searchText) ||
                $0.genre.contains(where: { $0.contains(searchText) }) ||
                $0.actors.contains(where: { $0.contains(searchText) }) ||
                $0.director.contains(searchText)
            }
        }
}
