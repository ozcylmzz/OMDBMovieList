import UIKit
import Network
import PopupDialog

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: MovieImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var viewModel: MovieDetailsViewModel!
    
    var popup: PopupDialog?
    
    let lotttieAnimation = LottieAnimations.shared
    let animationView = LottieAnimations.shared.animationView
    
    let tableViewCellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        setupTableView()
        setupGenreCollectionView()
        view.addSubview(animationView)
        ReachabilityManager.shared.addListener(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = viewModel.movie?.Title
        animationView.stop()
        animationView.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        ReachabilityManager.shared.removeListener(self)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupGenreCollectionView() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.register(GenreCollectionViewCell.nib(), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        (genreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    private func populateUI() {
        guard let movie = viewModel.movie else { return }
        movieImageView.fetchImage(for: movie.Poster ?? "")
        descriptionLabel.text = movie.Plot
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("Cannot dequeue cell!")
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.textLabel?.tintColor = .systemGray6
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.text = viewModel.getText(for: indexPath.row)
        
        return cell
    }
    
}

extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGenreCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            fatalError("Cannot dequeue cell of type \(GenreCollectionViewCell.description())")
        }
        cell.genreLabel.text = viewModel.getGenre(at: indexPath.row)
        return cell
    }
}

extension MovieDetailsViewController: NetworkStatusListener {
    func networkStatusDidChange(status: NWPath.Status) {
        DispatchQueue.main.async {
            if status == .satisfied {
                self.dismissNoInternetConnectionAlert()
            } else {
                self.presentNoInternetConnectionAlert()
            }
        }
    }
    
    
    func presentNoInternetConnectionAlert() {
        let alertContent = AlertContentConfig(alertImage: WIFI ?? UIImage(),
                                              alertTitleText: noInternetTitle,
                                              alertDetailText: noInternetInfo)
        let customVC = getDefaultAlertController(with: alertContent)
        
        popup = PopupDialog(viewController: customVC,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            tapGestureDismissal: false,
                            panGestureDismissal: false)
        if let popup = popup {
            present(popup, animated: true, completion: nil)
        }
    }
    
    func dismissNoInternetConnectionAlert() {
        navigationController?.topViewController?.dismiss(animated: true)
    }
}
