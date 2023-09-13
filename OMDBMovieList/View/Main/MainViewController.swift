//
//  MainViewController.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 13.09.2023.
//

import UIKit
import Network
import PopupDialog

class MainViewController: UIViewController {
    
    let lotttieAnimation = LottieAnimations.shared
    let animationView = LottieAnimations.shared.animationView
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var viewChangeBarButton: UIBarButtonItem!
    
    lazy var mainViewModel: IMainViewModel = MainViewModel()
    var popup: PopupDialog?
    
    var debounce_timer: Timer?
    var searchController: UISearchController!
    var paginationActivity = UIActivityIndicatorView(style: .large)
    var fetchingMore = false
    var currentPage = 1
    var numberOfRows = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        OMDBAnalytics.log(event: .mainView(.controller))
        ReachabilityManager.shared.addListener(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(self)
    }
}

extension MainViewController {
    private func configureController() {
        setupCollectionView()
        configureSearch()
        updateRighBarButton(isGrid: true)
        bindViewModel()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID)
    }
    
    private func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = typeMovieNameHereToSearch
        search.searchBar.delegate = self
        navigationItem.searchController = search
        self.searchController = search
    }
    
    private func bindViewModel() {
        mainViewModel.didFetchMoviesSucceed = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.paginationActivity.stopAnimating()
                self.refreshUI()
                self.fetchingMore = false
            }
        }
        
        mainViewModel.didFetchMoviesFail = { [weak self] error in
            guard let self = self else {
                return
            }
            self.fetchingMore = false
            self.paginationActivity.stopAnimating()
            DispatchQueue.main.async {
                let errorString = error?.localizedDescription ?? somethingWentWrong
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                let button = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        mainViewModel.didFetchMovieDetailsSucceed = { [weak self] movie in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
//                self.removeLoader()
                guard let VC = UIStoryboard(name: "MovieDetailsViewController", bundle: nil).instantiateInitialViewController() as? MovieDetailsViewController else {
                    fatalError("Could not instantiate ViewController of type \(MovieDetailsViewController.description())")
                }
                let VM = MovieDetailsViewModel(movie: movie)
                VC.viewModel = VM
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
    
    private func refreshUI() {
        emptyView.isHidden = !(mainViewModel.movies?.count == 0)
        collectionView.reloadSections(IndexSet.init(integer: 0))
    }
    
    @objc func didTapViewChangeButton(_ sender: UIBarButtonItem) {
        if numberOfRows == 1 {
            numberOfRows = 3
            updateRighBarButton(isGrid: true)
        } else {
            numberOfRows = 1
            updateRighBarButton(isGrid: false)
        }
        collectionView.reloadData()
    }
    
    func updateRighBarButton(isGrid : Bool){
        let navBarButton = UIButton(type: .custom)
        navBarButton.frame = CGRect(x: 0, y: 0, width: BAR_BUTTON_SIZE, height: BAR_BUTTON_SIZE)
        navBarButton.addTarget(self, action: #selector(didTapViewChangeButton(_:)), for: .touchUpInside)
        
        if isGrid {
            navBarButton.setImage(LIST_IMAGE, for: .normal)
        } else {
            navBarButton.setImage(GRID_IMAGE, for: .normal)
        }
        let rightButton = UIBarButtonItem(customView: navBarButton)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func addLoader() {
        view.addSubview(animationView)
        animationView.center = view.center
        animationView.loopMode = .loop
        animationView.play(){ _ in }
    }
    
    func removeLoader() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Cannot dequeue cell of type \(MovieCollectionViewCell.description())")
        }
        configure(cell, for: indexPath)
        return cell
    }
    
    private func configure(_ cell: MovieCollectionViewCell, for indexPath: IndexPath) {
        let movie = mainViewModel.getMovie(at: indexPath.row)
        cell.movieImageView.fetchImage(for: movie.Poster ?? "")
        cell.movieNameLabel.text = movie.Title
        cell.movieGenreLabel.text = movie.Year
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: INSET, left: INSET, bottom: INSET, right: INSET);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if numberOfRows == 1 {
            let cellWidth = (view.frame.size.width / CGFloat(numberOfRows)) - 100
            return CGSize(width: cellWidth, height: (223))
        }
        let cellWidth = (view.frame.size.width / CGFloat(numberOfRows)) - 15
        return CGSize(width: cellWidth, height: (223.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID, for: indexPath)
            let label = UILabel()
            label.text = "Search Results"
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID, for: indexPath)
            footerView.addSubview(paginationActivity)
            paginationActivity.translatesAutoresizingMaskIntoConstraints = false
            paginationActivity.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            paginationActivity.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            return footerView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: HEADER_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: FOOTER_SIZE, height: FOOTER_SIZE)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.addLoader()
        mainViewModel.fetchMovieDetails(for: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let moviesCount = mainViewModel.movies?.count else {
            return
        }
        if (indexPath.row == moviesCount - 1) && (moviesCount > 9) {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        self.paginationActivity.startAnimating()
        self.fetchingMore = true
        mainViewModel.isPaginating = true
        currentPage = currentPage + 1
        mainViewModel.fetchMovies(for: searchController.searchBar.searchTextField.text, pageNumber: currentPage)
    }
    
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        cache.removeAllObjects()
        self.currentPage = 1
        mainViewModel.isPaginating = false
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        debounce_timer?.invalidate()
        debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.mainViewModel.fetchMovies(for: text, pageNumber: self.currentPage)
        }
    }
    
}

extension MainViewController: NetworkStatusListener {
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
