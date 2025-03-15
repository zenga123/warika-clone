// Models.swift
import Foundation

struct Member: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct Expense: Identifiable {
    var id = UUID()
    var title: String
    var amount: Double
    var paidBy: Member
    var participants: [Member]
    var date: Date
}

struct Group: Identifiable {
    var id = UUID()
    var name: String
    var members: [Member]
    var expenses: [Expense] = []
    
    func calculateSettlement() -> [Settlement] {
        var settlements: [Settlement] = []
        
        // Calculate total paid by each member
        var totalPaid: [Member: Double] = [:]
        var totalOwed: [Member: Double] = [:]
        
        for expense in expenses {
            // Add to total paid by the payer
            totalPaid[expense.paidBy, default: 0] += expense.amount
            
            // Calculate amount per participant
            let amountPerPerson = expense.amount / Double(expense.participants.count)
            
            // Add to total owed by each participant
            for participant in expense.participants {
                totalOwed[participant, default: 0] += amountPerPerson
            }
        }
        
        // Calculate net balance for each member
        for member in members {
            let paid = totalPaid[member, default: 0]
            let owed = totalOwed[member, default: 0]
            
            if paid > owed {
                // This member should receive money
                for otherMember in members where otherMember != member {
                    let otherPaid = totalPaid[otherMember, default: 0]
                    let otherOwed = totalOwed[otherMember, default: 0]
                    
                    if otherOwed > otherPaid {
                        // This other member needs to pay
                        let amount = min(paid - owed, otherOwed - otherPaid)
                        if amount > 0 {
                            settlements.append(Settlement(from: otherMember, to: member, amount: amount))
                        }
                    }
                }
            }
        }
        
        return settlements
    }
}

struct Settlement: Identifiable {
    var id = UUID()
    var from: Member
    var to: Member
    var amount: Double
}
