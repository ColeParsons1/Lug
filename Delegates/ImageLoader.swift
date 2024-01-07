//
//  ImageLoader.swift
//  MainRoot
//
//  Created by Cole Parsons on 11/28/22.
//

import Foundation


class ImageLoader: ObservableObject {
    //var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            //send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
