//
//  ListenArticleViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 30/09/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit
import AVKit


class ListenArticleViewController : UIViewController {
    
    let wikiPage : WikiPage
    var wikiPageExtract : WikiPageExtract?
    let networkController : NetworkController
    let synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    let playPauseButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "playingIcon")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let loader : UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(style: .whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        ac.color = .white
        return ac
    }()
    
    init(wikiPage:WikiPage,networkController: NetworkController) {
        self.wikiPage = wikiPage
        self.networkController = networkController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = wikiPage.title
        self.view.backgroundColor = .black
        setUpLoader()
        setUpPlayButton()
        fectchExtractAndPlay()
    }
    
    private func setUpLoader() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.bringSubviewToFront(loader)
        loader.startAnimating()
    }
    
    private func fectchExtractAndPlay() {
        let title = Util.createUrlQueryParamFromTitle(title:wikiPage.title)
        networkController.request(payload: PayloadGenerator(requestType: .fetchArticleText(title: title)).generatePayload(), completion: { [weak self]
            (result: Result<WikiPageExtract, Error>) in
              DispatchQueue.main.async { [weak self]  in
                    do {
                        let response = try result.get()
                        self?.handleResponse(extract:response)
                    } catch  {
                        let alert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
            }
        })

    }
    
    func setUpPlayButton() {
        view.addSubview(playPauseButton)
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        playPauseButton.isHidden = true
        playPauseButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
    }
    
    @objc func togglePlay() {
        if synthesizer.isPaused {
            togglePlayPauseUI(isAlreadyPlaying: false)
            synthesizer.continueSpeaking()
        }
        else {
            togglePlayPauseUI(isAlreadyPlaying: true)
            synthesizer.pauseSpeaking(at: .word)
        }
    }
    
    private func togglePlayPauseUI(isAlreadyPlaying:Bool) {
        playPauseButton.isHidden = false
        if isAlreadyPlaying {
            playPauseButton.setImage(UIImage(named: "pausedIcon"), for: .normal)
        }
        else {
            playPauseButton.setImage(UIImage(named: "playingIcon"), for: .normal)
        }
    }
    
    private func handleResponse(extract:WikiPageExtract) {
        self.wikiPageExtract = extract
        self.startPlaying()
    }

    func startPlaying() {
        guard let str = wikiPageExtract?.extract else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion:{
                [weak self] in
                self?.navigationController?.popViewController(animated: true)
            } )
            return
        }
       // print(wikiPageExtract?.pageImage)
        loader.stopAnimating()
        
        let sanitisedExtract = Util.sanitiseExtract(input:str)
        
        let utternace : AVSpeechUtterance = AVSpeechUtterance.init(string: sanitisedExtract)
        
        synthesizer.speak(utternace)
        togglePlayPauseUI(isAlreadyPlaying: false)
    }
}
