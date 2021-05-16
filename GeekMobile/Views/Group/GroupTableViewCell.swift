//
//  GroupTableViewCell.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: GroupViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func configureViewModel(viewModel vm: GroupViewModel) {
        
        viewModel = vm
        
        vm.name.bind(to: titleLabel.rx.text).disposed(by: viewModel!.bag)
        
        vm.photo.bind { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async { /// execute on main thread
                self?.profileImageView.image = UIImage(data: data)
                self?.profileImageView.setNeedsDisplay()
            }
        }.disposed(by: viewModel!.bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
