//
//  MovieTableViewCell.swift
//  movie_Database
//
//  Created by Tata on 29/06/24.
//

//import UIKit
//
//class MovieTableViewCell: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//}


import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func awakeFromNib() {
           super.awakeFromNib()
           posterImageView.layer.cornerRadius = 8
           posterImageView.clipsToBounds = true
       }


    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        languageLabel.text = "Languages: " + movie.language.joined(separator: ", ")
        yearLabel.text = "Year: \(movie.year)"
        // Load image asynchronously (assuming movie.posterURL is a URL string)
        if let url = URL(string: movie.poster) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}


