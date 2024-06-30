//
//  MovieInfoViewController.swift
//  movie_Database
//
//  Created by Tata on 30/06/24.
//

//import UIKit

//class MovieInfoViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//
//}


import UIKit

class MovieInfoViewController: UIViewController {
    var movie: Movie?
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var castCrewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var ratingSourceSegmentedControl: UISegmentedControl!
    
    private let ratingSources = ["IMDB", "Rotten Tomatoes", "Metacritic"] // Dynamic data for segments

       override func viewDidLoad() {
           super.viewDidLoad()
           configureView()
       }
       
       func configureView() {
           guard let movie = movie else { return }
           
           // Load the image from the URL
           if let url = URL(string: movie.poster) {
               URLSession.shared.dataTask(with: url) { (data, response, error) in
                   if let error = error {
                       print("Failed to load image with error: \(error)")
                       return
                   }
                   
                   guard let data = data, let image = UIImage(data: data) else {
                       print("Failed to load image from data")
                       return
                   }
                   
                   DispatchQueue.main.async {
                       self.posterImageView.image = image
                       self.posterImageView.layer.cornerRadius = 8
                       self.posterImageView.layer.masksToBounds = true
                   }
               }.resume()
           } else {
               print("Invalid URL: \(movie.poster)")
           }
           
           // Style titleLabel
           titleLabel.text = "Title: \(movie.title)"
           titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
           titleLabel.textColor = UIColor.black
           
           // Style plotLabel
           plotLabel.text = "Plot: \(movie.plot)"
           plotLabel.font = UIFont.systemFont(ofSize: 15)
           plotLabel.textColor = UIColor.darkGray
           plotLabel.numberOfLines = 0
           
           // Style castCrewLabel
           castCrewLabel.text = "Director: \(movie.director)\nActors: \(movie.actors.joined(separator: ", "))"
           castCrewLabel.font = UIFont.systemFont(ofSize: 15)
           castCrewLabel.textColor = UIColor.darkGray
           castCrewLabel.numberOfLines = 0
           
           // Style releaseDateLabel
           releaseDateLabel.text = "Released: \(movie.year)"
           releaseDateLabel.font = UIFont.systemFont(ofSize: 15)
           releaseDateLabel.textColor = UIColor.gray
           
           // Style genreLabel
           genreLabel.text = "Genre: \(movie.genre.joined(separator: ", "))"
           genreLabel.font = UIFont.systemFont(ofSize: 15)
           genreLabel.textColor = UIColor.gray
           
           // Configure dynamic segments
           configureSegmentedControl()
           
           // Set default rating source
           ratingSourceSegmentedControl.selectedSegmentIndex = 0
           updateRating()
       }
       
    private func configureSegmentedControl() {
        ratingSourceSegmentedControl.removeAllSegments() // Remove any existing segments
        
        for (index, source) in ratingSources.enumerated() {
            ratingSourceSegmentedControl.insertSegment(withTitle: source, at: index, animated: false)
        }
        
        // Set the tint color for the segmented control
        ratingSourceSegmentedControl.tintColor = UIColor.systemBlue // Tint color for segmented control
        
        // Set the text color of the segments to black
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        ratingSourceSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        // Style the segmented control's border and appearance
        ratingSourceSegmentedControl.layer.cornerRadius = 5
        ratingSourceSegmentedControl.layer.borderWidth = 1
        ratingSourceSegmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        
        ratingSourceSegmentedControl.addTarget(self, action: #selector(ratingSourceChanged(_:)), for: .valueChanged)
    }

       
       @objc func ratingSourceChanged(_ sender: UISegmentedControl) {
           updateRating()
       }
       
       func updateRating() {
           guard let movie = movie else { return }
           
           let selectedIndex = ratingSourceSegmentedControl.selectedSegmentIndex
           
           // Check if the selected index is within bounds
           guard selectedIndex >= 0 && selectedIndex < ratingSources.count else {
               print("Selected index out of bounds")
               return
           }
           
           let ratingSource = ratingSources[selectedIndex]
           var ratingValue: Double = 0.0
           
           switch ratingSource {
           case "IMDB":
               ratingValue = movie.imdbRating
           case "Rotten Tomatoes":
               ratingValue = movie.rottenTomatoesRating
           case "Metacritic":
               ratingValue = movie.metacriticRating
           default:
               break
           }
           
           ratingControl.setRating(ratingValue, source: ratingSource)
       }
   }
