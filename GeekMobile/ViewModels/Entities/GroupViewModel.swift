//
//  GroupViewModel.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import Foundation
import RxSwift
import RxRelay

class GroupViewModel: DisposeBagHolder {
    
    let model: GroupModel
    var name: BehaviorRelay<String>
    var photo: BehaviorSubject<Data?>
        
    init(model: GroupModel) {
        self.model = model
        self.name = BehaviorRelay<String>(value: model.name)
        self.photo = BehaviorSubject<Data?>(value: nil)
        
        super.init()

        self.loadPhoto()
    }
    
    func loadPhoto() {
        
        model.loadPhoto()
            .subscribe(onNext: { [weak self] data in
                
                guard let `self` = self else { return }
                self.photo.onNext(data)
            })
            .disposed(by: bag)
    }
}
