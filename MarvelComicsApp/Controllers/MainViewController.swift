//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit
class MainViewController: UIViewController {

    private let tableView = UITableView()

    private let webservice = MainWebservice()

    lazy var characterThumbnails: [CharacterThumbnail] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {

            tableView.reloadData()
            await dataLoad()
            addSubviews()
            defineSubviewConstraints()
            configureSubviews()
            configureFooterTableView()

            navigationItem.title = "Marvel Comics"

            tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "TableViewCell")
        }
    }
}

private extension MainViewController {

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
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }

    func configureFooterTableView() {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: 100))
        footerView.backgroundColor = .clear

        let loadButton = UIButton(frame: CGRect(x: 30, y: 30, width: self.view.frame.width - 60, height: 40))
        loadButton.backgroundColor = .systemGray
        loadButton.isUserInteractionEnabled = true
        loadButton.setTitle("Load More", for: .normal)
        loadButton.addTarget(self, action: #selector(self.dataLoadMore), for: .touchUpInside)

        footerView.addSubview(loadButton)
        self.tableView.tableFooterView = footerView

    }

    func dataLoad() async {

        do {

            guard let characterDataWrapper = try await webservice.fetchCharactersInfo(),
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
    }

    @objc
    func dataLoadMore() {

        Task {

            await dataLoad()
            tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.characterThumbnails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CharacterThumbnailCell else {

            return UITableViewCell()
        }

        cell.selectionStyle = .none
        
        let item = characterThumbnails[indexPath.row]
        configureCell(for: cell, with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 5
    }

    func configureCell(for cell: CharacterThumbnailCell, with item: CharacterThumbnail) {

        cell.transferThumbnailData(id: item.id, name: item.name, imageUrl: item.imageUrl)
        
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = characterThumbnails[indexPath.row]

        let detailsViewController = DetailsViewController(characterThumbnail: item)
        navigationController?.pushViewController(detailsViewController, animated: false)
    }
}



