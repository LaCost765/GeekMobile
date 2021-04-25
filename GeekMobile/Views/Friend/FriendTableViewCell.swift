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
    
    func configureViewModel(viewModel vm: FriendViewModel) {
        viewModel = vm
        
        viewModel!.fullName.bind(to: fullNameLabel.rx.text).disposed(by: bag)
        
        viewModel!.profileImage.bind { [weak self] data in
            guard let data = data else { return }
            DispatchQueue.main.async { /// execute on main thread
                self?.profileImage.image = UIImage(data: data)
                self?.profileImage.setNeedsDisplay()
            }
        }.disposed(by: bag)
    }
    
    func setProfileImage(with url: String) {
        viewModel?.setProfileImage(with: url)
    }
    
    func getPhotos() -> [UIImage?] {
        let images: [UIImage?]? = viewModel?.photos.map {
            guard let data = $0 else { return nil }
            return UIImage(data: data)
        }
        
        guard let photos = images else {
            return []
        }
        
        return photos
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
