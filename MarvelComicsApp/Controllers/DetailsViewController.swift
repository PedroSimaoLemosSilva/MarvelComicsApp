//
//  DetailsViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 31/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    private let tableView = UITableView()

    private let webservice = Webservice()

    private var characterThumbnail: CharacterThumbnail = CharacterThumbnail()

    lazy var characterComics: [Comic] = []

    lazy var characterEvents: [Event] = []

    lazy var characterStories: [Story] = []

    lazy var characterSeries: [Series] = []

    init(characterThumbnail: CharacterThumbnail) {

        super.init(nibName: nil, bundle: nil)
    
        self.characterThumbnail = characterThumbnail
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = characterThumbnail.name

        Task {

            //await dataFormatting()
            addSubviews()
            defineSubviewConstraints()
            configureSubviews()
        }
    }

    
}

private extension DetailsViewController {

    func addSubviews() {

        self.view.addSubview(self.tableView)
    }

    func defineSubviewConstraints() {

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    func configureSubviews() {

        self.view.backgroundColor = .white

        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
    }

    /*
    func dataFormatting() async {

        do {

            guard let characterDataWrapper = try await webservice.fetchCharactersInfo(url: Constants.Urls.characters),
                  let charactersData = characterDataWrapper.data?.results else { return }

            charactersData.forEach { character in

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext

                let characterThumbnail = CharacterThumbnail(id: id, name: name, imageUrl: imageUrl)

                characterThumbnails.append(characterThumbnail)

            }
        } catch { print(error) }
    } */
}

extension DetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 5
    }

    func configureCell(for cell: CharacterThumbnailCell, with item: CharacterThumbnail) {

        cell.transferThumbnailData(id: item.id, name: item.name, imageUrl: item.imageUrl)

    }
}
