//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit

class HeroListViewController: UIViewController {

    let scrollView = UIScrollView()

    let safeView = UIView()

    let gridView = GridView()

    var dict: [String: String] = [:]

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {
            
            view.addSubview(self.scrollView)
            view.addSubview(self.safeView)
            
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: safeView.bottomAnchor).isActive = true
            
            scrollView.backgroundColor = .white
            
            safeView.translatesAutoresizingMaskIntoConstraints = false
            safeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            safeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            safeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            safeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            
            safeView.backgroundColor = .white
            
            do {
                
                self.dict = try await Webservice().fetchCharactersNameThumbnailPath(url: Constants.Urls.characters)
                
                //let i = try await Webservice().fetchCharacterDataWrapper(url: Constants.Urls.characters)
                //print(dict)
            } catch {
                
                print(error)
            }
            
            gridView.populateGrid(parentView: scrollView, characterDictionary: self.dict)
        }
    }
}


