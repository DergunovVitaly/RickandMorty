//
//  ImageLoaderService.swift
//  RickAndMorty
//
//  Created by Vitaliy on 07.02.2025.
//
import UIKit

/// A simple image-loading service that caches images in memory (NSCache).
final class ImageLoaderService {
    
    // Singleton for convenience, or inject it via dependency if you prefer.
    static let shared = ImageLoaderService()
    
    /// NSCache to store images by URL string.
    private let cache = NSCache<NSString, UIImage>()
    
    // Private init for singleton.
    private init() {}
    
    /// Loads an image from cache or downloads it.  
    /// - Parameter url: The image URL
    /// - Returns: The downloaded (or cached) UIImage
    func loadImage(from url: URL) async throws -> UIImage {
        
        let cacheKey = url.absoluteString as NSString
        
        // 1. Check cache
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // 2. Download image
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Optional: check status code if needed
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw NSError(domain: "ImageLoaderService",
                          code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Failed with status \(httpResponse.statusCode)"])
        }
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageLoaderService",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Corrupted image data"])
        }
        
        // 3. Cache and return
        cache.setObject(image, forKey: cacheKey)
        return image
    }
}
