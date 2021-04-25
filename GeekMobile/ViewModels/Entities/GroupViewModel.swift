//
//  GroupViewModel.swift
//  ClientVK
//
//  Created by Egor on 07.03.2021.
//

import Foundation
import RxSwift

protocol GroupViewModelProtocol {
    var model: GroupModel { get }
    var title: BehaviorSubject<String> { get set }
    var subtitle: BehaviorSubject<String> { get set }
    var image: BehaviorSubject<Data?> { get set }
}

class GroupViewModel: GroupViewModelProtocol {
    
    var model: GroupModel
    var title: BehaviorSubject<String>
    var subtitle: BehaviorSubject<String>
    var image: BehaviorSubject<Data?>
    let bag: DisposeBag
        
    init(model: GroupModel) {
        self.model = model
        
        bag = DisposeBag()
        title = BehaviorSubject(value: model.title)
        subtitle = BehaviorSubject(value: model.subtitle)
        image = BehaviorSubject(value: model.image)
        
        // subscribe model on subjects changes
        title.subscribe(onNext: { model.title = $0 })
        subtitle.subscribe(onNext: { model.subtitle = $0 })
        image.subscribe(onNext: { model.image = $0 })
    }
}
