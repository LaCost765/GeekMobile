//
//  FriendTableViewCell.swift
//  ClientVK
//
//  Created by Egor on 06.03.2021.
//

import UIKit
import RxSwift
import RxCocoa

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImage: CustomImageView!
    
    var viewModel: FriendViewModel?
    
    private let bag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func prepareForReuse() {
        
        self.viewModel = nil
        self.fullNameLabel.text = ""
        self.profileImage.image = nil
    }
    
    func configureViewModel(viewModel vm: FriendViewModel) {
        
        vm.fullName.bind(to: fullNameLabel.rx.text).disposed(by: bag)
        vm.profilePhoto.bind { [weak self] data in
            
            DispatchQueue.main.async { /// execute on main thread
                guard let data = data else { return }
                self?.profileImage.image = UIImage(data: data)
                self?.profileImage.setNeedsDisplay()
            }
        }.disposed(by: bag)
        
        viewModel = vm
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
