//
//  PersistenceService.swift
//  Netflix
//
//  Created by newbie on 30.05.2022.
//

import Foundation
import CoreData
import UIKit

class PersistenceService {
    
    static let shared = PersistenceService()
    
    func saveMovie(with model: Movie) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let movieItem = PersistentMovie(context: context)
        
        if let id = model.id {
            movieItem.id = Int64(id)
        } else {
            movieItem.id = Int64()
        }
        movieItem.overview = model.overview
        movieItem.original_name = model.original_name
        movieItem.original_title = model.original_title
        movieItem.poster_path = model.poster_path
        movieItem.title = model.title
        movieItem.media_type = model.media_type
        movieItem.release_date = model.release_date
        movieItem.vote_average = Double(model.vote_average ?? 0)
        movieItem.vote_count = Int64(model.vote_count ?? 0)
        
        do {
            try context.save()
            print("Successfully saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func movieList() -> [PersistentMovie]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}

        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<PersistentMovie>
        
        request = PersistentMovie.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            print(result[0])
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return [PersistentMovie]()
    }
    
    func deleteMovie(model: PersistentMovie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
