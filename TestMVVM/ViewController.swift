//
//  ViewController.swift
//  TestMVVM
//
//  Created by Le Ngoc HOAN on 6/9/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ItemsViewModel!
    let dataSource = RxTableViewSectionedAnimatedDataSource<ItemSection>()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ItemsViewModel()
        configureDataSource()
        bindViewModel()
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                let row = indexPath.row
                if let strongSelf = self {
                    let count = strongSelf.tableView.numberOfRows(inSection: 0)
//                    print("===count = \(count)===")
//                    print("===row = \(row)===")
                    if count > 0 && row == count - 1 {
                        for _ in 1...20 {
                            strongSelf.viewModel.createItem()
                        }
                    }
                }
            })
            .disposed(by: bag)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bindViewModel() {
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    func configureDataSource() {
        dataSource.configureCell = { (ds, tv, ip, item) in
//            print("Create cell row: \(ip.row)")
            let cell = tv.dequeueReusableCell(withIdentifier: ItemCell.identifier) as! ItemCell
            cell.titleLabel.text = item.title
            cell.likeButton.rx.tap.asObservable()
                .subscribe(onNext: { [weak self] _ in
                    let wordViewModel = WordsViewModel()
                    let word = wordViewModel.getWordById(id: (item.id * 20 - 10))
                    wordViewModel.likeWord(word: word!)
//                    self?.viewModel.likeItem(item: item)
                })
                .disposed(by: cell.bag)
            item.rx.observe(Bool.self, "isLiked")
                .subscribe(onNext: { value in
                    if let value = value, value {
                        cell.likeButton.setImage(UIImage(named: "Liked"), for: .normal)
                    } else {
                        cell.likeButton.setImage(UIImage(named: "UnLike"), for: .normal)
                    }
                })
                .disposed(by: cell.bag)
            return cell
        }
    }
}
