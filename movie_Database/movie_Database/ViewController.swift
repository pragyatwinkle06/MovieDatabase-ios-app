////
////  ViewController.swift
////  movie_Database
////
////  Created by Tata on 29/06/24.

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var viewModel: MovieViewModel = MovieViewModel()
    
    
    @IBOutlet weak var appTitle: UILabel!
    private let options = ["Year", "Genre", "Directors", "Actors", "All Movies"]
    private var expandedSection: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search movies by title/actor/genre/director"
        
        // Register the cells
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        
        // Fetch movies from the ViewModel
        viewModel.fetchMovies()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isFiltering {
            return viewModel.getMovies().count
        } else {
            if let expandedSection = expandedSection, expandedSection == section {
                switch options[section] {
                case "Year":
                    return viewModel.getDistinctYears().count + 1
                case "Genre":
                    return viewModel.getDistinctGenres().count + 1
                case "Directors":
                    return viewModel.getDistinctDirectors().count + 1
                case "Actors":
                    return viewModel.getDistinctActors().count + 1
                case "All Movies":
                    return viewModel.getMovies().count + 1
                default:
                    return 1
                }
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if viewModel.isFiltering {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            let movie = viewModel.getMovies()[indexPath.row]
            cell.configure(with: movie)
            return cell
        } else {
            if let expandedSection = expandedSection, expandedSection == section {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
                    cell.textLabel?.text = options[section]
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17) // Make the title bold
                    cell.accessoryType = .none
                    return cell
                } else {
                    if options[section] == "All Movies" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
                        let movie = viewModel.getMovies()[indexPath.row - 1]
                        cell.configure(with: movie)
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
                        switch options[section] {
                        case "Year":
                            cell.textLabel?.text = viewModel.getDistinctYears()[indexPath.row - 1]
                        case "Genre":
                            cell.textLabel?.text = viewModel.getDistinctGenres()[indexPath.row - 1]
                        case "Directors":
                            cell.textLabel?.text = viewModel.getDistinctDirectors()[indexPath.row - 1]
                        case "Actors":
                            cell.textLabel?.text = viewModel.getDistinctActors()[indexPath.row - 1]
                        default:
                            break
                        }
                        cell.accessoryType = .disclosureIndicator
                        return cell
                    }
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
                cell.textLabel?.text = options[section]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17) // Regular font for non-expanded cells
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isFiltering {
            let movie = viewModel.getMovies()[indexPath.row]
            navigateToMovieInfo(with: movie)
        } else {
            let section = indexPath.section
            if let expandedSection = expandedSection, expandedSection == section && indexPath.row > 0 {
                let selectedValue = getValueForExpandedSection(section: section, row: indexPath.row - 1)
                let filteredMovies = viewModel.filterMoviesForSelectedValue(section: section, value: selectedValue)
                showFilteredMovies(filteredMovies)
            } else {
                if expandedSection == section {
                    self.expandedSection = nil
                } else {
                    self.expandedSection = section
                }
                tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.clearFilter()
        } else {
            viewModel.searchMovies(by: searchText)
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.clearFilter()
        tableView.reloadData()
    }
    
    private func getValueForExpandedSection(section: Int, row: Int) -> String {
        switch options[section] {
        case "Year":
            return viewModel.getDistinctYears()[row]
        case "Genre":
            return viewModel.getDistinctGenres()[row]
        case "Directors":
            return viewModel.getDistinctDirectors()[row]
        case "Actors":
            return viewModel.getDistinctActors()[row]
        default:
            return ""
        }
    }
    
    private func showFilteredMovies(_ movies: [Movie]) {
        // Present or push a new view controller to display the filtered movies
        for movie in movies {
            print("\(movie.title) (\(movie.year))")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if let expandedSection = expandedSection, expandedSection == section && indexPath.row > 0 {
            if options[section] == "All Movies" {
                return 120 // Set the height for MovieTableViewCell
            }
        }
        return 44 // Default height for OptionCell
    }
    
    private func navigateToMovieInfo(with movie: Movie) {
        print("Navigating to MovieInfoViewController with movie: \(movie.title)")
        
        let movieInfoVC = MovieInfoViewController(nibName: "MovieInfoViewController", bundle: nil)
        print("Successfully instantiated MovieInfoViewController")
        movieInfoVC.movie = movie
        movieInfoVC.modalPresentationStyle = .fullScreen
        self.present(movieInfoVC, animated: true, completion: nil)
    }
}
