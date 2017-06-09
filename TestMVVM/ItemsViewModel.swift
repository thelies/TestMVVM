//
//  ItemsViewModel.swift
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

typealias ItemSection = AnimatableSectionModel<String, Item>

class ItemsViewModel {
    
    init() {
        let realm = try! Realm()
        let items = realm.objects(Item.self)
        
        if items.count == 0 {
            for _ in 1...20 {
                createItem()
            }
        }
    }
    
    var items: Observable<[ItemSection]> {
        return fetchItems()
            .map { results in
                return [ItemSection(model: "", items: results.toArray())]
        }
//        let realm = try! Realm()
//        let objects = realm.objects(Item.self)
//        return Observable.just([ItemSection(model: "", items: objects.toArray())])
    }
    
    func createItem() -> Observable<Item> {
        let realm = try! Realm()
        let item = Item()
        let wordVM = WordsViewModel()
        for _ in 1 ... 20 {
            let word = wordVM.createWord()
            word.subscribe(onNext: { newWord in
                item.words.append(newWord)
            })
            .dispose()
        }
        try! realm.write {
            item.id = (realm.objects(Item.self).max(ofProperty: "id") ?? 0) + 1
            item.title = "Item \(item.id)"
            realm.add(item)
        }
        return .just(item)
    }
    
    func likeItem(item: Item) -> Observable<Item> {
        let realm = try! Realm()
        try! realm.write {
            item.isLiked = !item.isLiked
        }
        return .just(item)
    }
    
    func fetchItems() -> Observable<Results<Item>> {
        let realm = try! Realm()
        let items = realm.objects(Item.self)
        return Observable.collection(from: items)
    }
}
