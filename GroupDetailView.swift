// GroupDetailView.swift
import SwiftUI

struct GroupDetailView: View {
    @Binding var group: Group
    @State private var isAddingExpense = false
    @State private var showingSettlement = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 시계와 콘텐츠 사이 간격을 위한 여백
                Color.clear
                    .frame(height: 60)
                
                // 그룹 헤더 영역
                ZStack {
                    Rectangle()
                        .fill(Color.walicaPrimary)
                        .frame(height: 140)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text(group.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                // Edit group name
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(group.members) { member in
                                        Text(member.name)
                                            .font(.system(size: 14))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(20)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                // 빠른 액션 버튼
                Button(action: {
                    isAddingExpense = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                        Text("立替え記録を追加")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.walicaPrimary, Color.walicaPrimary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // 지출 기록 목록
                VStack(alignment: .leading, spacing: 12) {
                    if group.expenses.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 50))
                                .foregroundColor(Color.walicaLabelSecondary)
                            
                            Text("立替え記録がありません")
                                .font(.system(size: 16))
                                .foregroundColor(Color.walicaLabelPrimary)
                            
                            Text("記録を追加してみましょう")
                                .font(.system(size: 14))
                                .foregroundColor(Color.walicaLabelSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                    } else {
                        Text("立替え記録")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        ForEach(group.expenses) { expense in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(expense.title)
                                            .font(.system(size: 18, weight: .bold))
                                        
                                        Text("\(expense.paidBy.name)が立替え")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("¥\(Int(expense.amount))")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.walicaPrimary)
                                }
                                
                                Text(formatDate(expense.date))
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray.opacity(0.7))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 6) {
                                        ForEach(expense.participants, id: \.self) { participant in
                                            Text(participant.name)
                                                .font(.system(size: 12))
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color.walicaPrimary.opacity(0.1))
                                                .cornerRadius(12)
                                                .foregroundColor(Color.walicaPrimary)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.walicaCardBackground)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                    }
                }
                
                // 정산 정보 표시
                                if !group.expenses.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text("清算方法")
                                                .font(.system(size: 18, weight: .bold))
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        let settlements = group.calculateSettlement()
                                        if settlements.isEmpty {
                                            Text("精算すべき金額はありません")
                                                .padding()
                                                .foregroundColor(.gray)
                                        } else {
                                            VStack(spacing: 10) {
                                                ForEach(settlements) { settlement in
                                                    HStack {
                                                        Text("\(settlement.from.name) → \(settlement.to.name)")
                                                            .font(.system(size: 16))
                                                        
                                                        Spacer()
                                                        
                                                        Text("¥\(Int(settlement.amount))")
                                                            .font(.system(size: 16, weight: .semibold))
                                                    }
                                                    .padding(.horizontal, 20)
                                                    .padding(.vertical, 8)
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        }
                                        

                                    }
                                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .statusBar(hidden: false)
        .sheet(isPresented: $isAddingExpense) {
            AddExpenseView(group: $group, isPresented: $isAddingExpense)
        }
        .sheet(isPresented: $showingSettlement) {
            SettlementView(group: group)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E)"
        return formatter.string(from: date)
    }
}
