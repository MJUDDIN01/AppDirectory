//
//  PeopleViewController.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import UIKit
import Combine


class PeopleViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: PeopleViewModel?
    private var bindings = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PeopleViewModel(directoryApi: DirectoryApi(apiTask: ApiTask()))
        
        viewModel?.submitAction(action: .loadPeoples(DirectoryRequest(path:Constants.people)))
        
        setupCollectionView()
        
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel?.$state.receive(on: RunLoop.main).sink(receiveValue: { [weak self] states in
            switch states {
            case .showActivityIndicator:
                self?.activityIndicator.startAnimating()
            case .showPeoples:
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            case .showError(_):
                print("")
            case .none:
                print("")
            }
        }).store(in: &bindings)
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
    }
}

extension PeopleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfPeople ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as? PeopleCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let people = viewModel?.getPeople(for: indexPath.row) {
            cell.configureData(people: people)
        }
        return cell
    }
}

extension PeopleViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:180)
    }
}

