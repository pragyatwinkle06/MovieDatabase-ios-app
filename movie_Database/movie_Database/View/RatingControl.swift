//
//  RatingControl.swift
//  movie_Database
//
//  Created by Tata on 30/06/24.
//

//import Foundation
//import UIKit
//
//@IBDesignable class RatingControl: UIView {
//    private var rating: Double = 0.0
//    
//    override func draw(_ rect: CGRect) {
//        // Draw the rating control (e.g., stars or a progress bar)
//        // Here, you can customize how you want to display the rating
//        let context = UIGraphicsGetCurrentContext()
//        context?.setFillColor(UIColor.yellow.cgColor)
//        let width = rect.width * CGFloat(rating) / 10.0
//        context?.fill(CGRect(x: 0, y: 0, width: width, height: rect.height))
//    }
//    
//    func setRating(_ rating: Double) {
//        self.rating = rating
//        setNeedsDisplay()
//    }
//}


import UIKit

@IBDesignable class RatingControl: UIView {
    private var rating: Double = 0.0
    private let starCount = 5
    private let starSize: CGFloat = 30.0
    private let starSpacing: CGFloat = 5.0
    private let labelHeight: CGFloat = 20.0

    private let ratingSourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(ratingSourceLabel)
        ratingSourceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingSourceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingSourceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ratingSourceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingSourceLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let starPath = UIBezierPath()
        let fullStar = UIImage(systemName: "star.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let emptyStar = UIImage(systemName: "star")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        for i in 0..<starCount {
            let x = CGFloat(i) * (starSize + starSpacing)
            let starRect = CGRect(x: x, y: 0, width: starSize, height: starSize)
            
            if Double(i) < rating {
                fullStar?.draw(in: starRect)
            } else {
                emptyStar?.draw(in: starRect)
            }
            
            
        }
    }
    
    func setRating(_ rating: Double, source: String) {
        self.rating = rating
        self.ratingSourceLabel.text = "\(source): \(rating)"
        setNeedsDisplay()
    }
}

