//
//  ItemDetailViewModel.swift
//  TestMVVM
//
//  Created by Le Ngoc HOAN on 6/9/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift
import RxDataSources

class ItemDetailViewModel {
   
    let itemObservable: Observable<Item>
    let item: Item
    var words: Observable<[WordSection]> {
        return itemObservable
            .map { item in
                return [WordSection(model: "", items: item.words.toArray())]
            }
    }
    
    init(id: Int) {
        let realm = try! Realm()
        item = realm.object(ofType: Item.self, forPrimaryKey: id)!
        itemObservable = Observable.from(object: item)
    }
    
    func like() -> Observable<Item> {
        let realm = try! Realm()
        try! realm.write {
            item.isLiked = !item.isLiked
        }
        return .just(item)
    }
    
    
//    func fetchItemById(id: Int) -> Observable<Item> {
//        let realm = try! Realm()
//        let item = realm.object(ofType: Item.self, forPrimaryKey: id)
//        return Observable.from(object: item!)
//    }
}
