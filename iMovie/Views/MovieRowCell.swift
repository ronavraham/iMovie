import UIKit

class MovieRowCell: UITableViewCell {
    
    @IBOutlet weak var MovieName: UILabel!
    @IBOutlet weak var MovieGrade: UILabel!
    @IBOutlet weak var MovieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
