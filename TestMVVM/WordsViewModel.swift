//
//  WordViewModel.swift
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

typealias WordSection = AnimatableSectionModel<String, Word>

class WordsViewModel {
    
    var words: Observable<[WordSection]> {
        return fetchWords()
            .map { results in
                return [WordSection(model: "", items: results.toArray())]
        }
    }
    
    func createWord() -> Observable<Word> {
        let realm = try! Realm()
        let word = Word()
        try! realm.write {
            word.id = (realm.objects(Word.self).max(ofProperty: "id") ?? 0) + 1
            word.title = "Word \(word.id)"
            realm.add(word)
        }
        return .just(word)
    }
    
    func likeWord(word: Word) -> Observable<Word> {
        let realm = try! Realm()
        try! realm.write {
            word.isLiked = !word.isLiked
        }
        return .just(word)
    }
    
    func fetchWords() -> Observable<Results<Word>> {
        let realm = try! Realm()
        let words = realm.objects(Word.self)
        return Observable.collection(from: words)
    }
    
    func getWordById(id: Int) -> Word? {
        let realm = try! Realm()
        return realm.object(ofType: Word.self, forPrimaryKey: id)
    }
}
