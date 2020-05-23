//
//  DocumentsTableViewController.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//
import CoreData
import UIKit

class DocumentsTableViewController: UITableViewController {
    private lazy var fetchedResultsController: NSFetchedResultsController<Experience> = {
        let fetchRequest: NSFetchRequest<Experience>
            = Experience.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        var frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    override func viewDidLoad() {
        setupTableView()
        configureView()
    }
    private func setupTableView() {
        tableView.rowHeight = 96
        tableView.register(DocumentCell.self, forCellReuseIdentifier: DocumentCell.reuseID)
    }
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentRecordingScreen))
        
    }
    @objc private func presentRecordingScreen() {
        let experienceRecordingVC = ExperienceRecordingViewController()
        navigationController?.pushViewController(experienceRecordingVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.reuseID, for: indexPath) as? DocumentCell else { return UITableViewCell() }
        let experience = fetchedResultsController.object(at: indexPath)
        cell.experience = experience
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let experienceDetailVC = ExperienceDetailViewController(nibName: nil, bundle: nil)
        let experience = fetchedResultsController.object(at: indexPath)
        experienceDetailVC.experience = experience
        navigationController?.pushViewController(experienceDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension DocumentsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexpath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexpath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default: break
        }
    }
}
