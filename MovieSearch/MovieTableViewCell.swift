//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Vũ Linh on 04/05/2021.
//

import UIKit


class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var year: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with model: MovieDetail) {
        self.title.text = model.Title
        self.year.text = model.Year
        
        let url = model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.imageMovie.image = UIImage(data: data)
        }
    }
}
