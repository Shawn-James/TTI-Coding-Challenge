// 
// Created by Shawn James
// UIImageView+LoadImage.swift

import UIKit

// TODO: - Explore other options for async image and caching

extension UIImageView {
    private static var imageCache = NSCache<NSString, UIImage>()

    func loadImage(with urlString: String, placeholder: UIImage? = UIImage(systemName: "photo")) {
        image = placeholder
        guard urlString != "default" else { return }

        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
        } else {
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data, let downloadedImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    UIImageView.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                }
            }.resume()
        }
    }
}
