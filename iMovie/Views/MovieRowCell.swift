import UIKit

class MovieRowCell: UITableViewCell {
    
    @IBOutlet weak var MovieName: UILabel!
    @IBOutlet weak var MovieImage: UIImageView!
    @IBOutlet weak var MovieGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
