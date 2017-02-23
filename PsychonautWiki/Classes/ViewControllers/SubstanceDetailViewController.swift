//
//  DetailViewController.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit

class SubstanceDetailViewController: UITableViewController {

    enum Sections: Int {
        case links = 0
        case addicationPotential
        case crossTolerance
        case dangerousInteraction
        case substanceClass
        case tolerance
        case effects
    }
    
    var substance: Substance? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        guard let substance = substance else { return }
        self.navigationItem.title = substance.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MultiLineTableViewCell.self, forCellReuseIdentifier: "EffectCell")
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indexPath = indexPath.section == Sections.effects.rawValue ? IndexPath(row: 0, section: indexPath.section) : indexPath
        return super.tableView(tableView, heightForRowAt: indexPath) + 20
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let indexPath = indexPath.section == Sections.effects.rawValue ? IndexPath(row: 0, section: indexPath.section) : indexPath
		return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.effects.rawValue {
        	return substance?.effects?.count ?? 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            if indexPath.section == Sections.effects.rawValue {
                return tableView.dequeueReusableCell(withIdentifier: "EffectCell")!
            } else {
            	return super.tableView(tableView, cellForRowAt: indexPath)
            }
        }()
        guard let section = Sections(rawValue: indexPath.section) else { return cell }
        
        switch section {
            case .links:
                cell.textLabel?.text = substance?.url ?? "Unknown"
            case .addicationPotential:
                cell.textLabel?.text = substance?.addictionPotential ?? "Unknown"
            case .crossTolerance:
                if let crossTolerance = substance?.crossTolerance {
                    cell.textLabel?.text = crossTolerance.flatMap({ $0 }).joined(separator: "\n")
                } else {
                    cell.textLabel?.text = "Unknown"
                }
            case .dangerousInteraction:
                if let dangerousInteraction = substance?.dangerousInteraction {
                    cell.textLabel?.text = dangerousInteraction.flatMap({ $0?.name }).joined(separator: "\n")
                } else {
                    cell.textLabel?.text = "Unknown"
                }
            case .substanceClass:
                if indexPath.row == 0 {
                    if let psychoactive = substance?.class?.psychoactive {
                        cell.detailTextLabel?.text = psychoactive.flatMap({ $0 }).joined(separator: "\n")
                    } else {
                        cell.detailTextLabel?.text = "Unknown"
                    }
                } else if indexPath.row == 1 {
                    if let chemical = substance?.class?.chemical {
                        cell.detailTextLabel?.text = chemical.flatMap({ $0 }).joined(separator: "\n")
                    } else {
                        cell.detailTextLabel?.text = "Unknown"
                    }
            	}
            case .tolerance:
                if indexPath.row == 0 {
                    cell.detailTextLabel?.text = substance?.tolerance?.full ?? "Unknown"
                } else if indexPath.row == 1 {
                    cell.detailTextLabel?.text = substance?.tolerance?.half ?? "Unknown"
                } else if indexPath.row == 2 {
                    cell.detailTextLabel?.text = substance?.tolerance?.zero ?? "Unknown"
                }
            case .effects:
                if let effects = substance?.effects,
                    effects.count > indexPath.row,
                    let effect = effects[indexPath.row] {
                    cell.textLabel?.text = effect.name ?? "Unknown"
                } else {
                    cell.textLabel?.text = "Unknown"
            	}
            	cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
}

