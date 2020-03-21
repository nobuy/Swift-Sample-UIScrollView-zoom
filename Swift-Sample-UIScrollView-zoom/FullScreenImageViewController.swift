//
//  FullScreenImageViewController.swift
//  Swift-Sample-UIScrollView-zoom
//
//  Created by nobuy on 2020/03/21.
//  Copyright © 2020 A10 Lab Inc. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close.png"), for: UIControl.State())
        button.addTarget(self, action: #selector(FullScreenImageViewController.onCloseTapped(_:)), for: .touchUpInside)
        button.contentMode = .center
        return button
    }()

    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARk: - Lifc Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        let minZoomScale: CGFloat = 1.0
        let maxZoomScale = minZoomScale * 4.0
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.zoomScale = minZoomScale
        scrollView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let size = imageView.image?.size {
            let widthScale = scrollView.frame.width / size.width
            let heightScale = scrollView.frame.height / size.height
            let scale = min(widthScale, heightScale, 1.0)
            imageView.frame.size = CGSize(width: size.width * scale, height: size.height * scale)
            scrollView.contentSize = imageView.frame.size
            updateScrollViewContntInsets()
        }
    }

    // MARK: - Handle Event

    @objc private func onCloseTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private functions

    private func initView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func updateScrollViewContntInsets() {
        let topInset = max((scrollView.frame.height - imageView.frame.height) / 2, 0)
        let leftInset = max((scrollView.frame.width - imageView.frame.width) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
    }
}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollViewContntInsets()
    }
}
