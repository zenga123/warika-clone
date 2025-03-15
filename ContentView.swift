// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var groups: [Group] = []
    @State private var isShowingCreateGroup = false
    @State private var selectedGroupIndex: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if groups.isEmpty {
                    VStack {
                        Text("まだグループがありません")
                            .font(.title2)
                            .padding()
                        
                        Button(action: {
                            isShowingCreateGroup = true
                        }) {
                            Text("グループを作成")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.walicaPrimary)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(groups) { group in
                            NavigationLink(destination: GroupDetailView(group: $groups[groups.firstIndex(where: { $0.id == group.id })!])) {
                                Text(group.name)
                                    .font(.headline)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Walica")
            .sheet(isPresented: $isShowingCreateGroup) {
                CreateGroupView(groups: $groups, isPresented: $isShowingCreateGroup, selectedGroupIndex: $selectedGroupIndex)
            }
            .background(
                NavigationLink(
                    destination: selectedGroupIndex != nil ?
                        GroupDetailView(group: $groups[selectedGroupIndex!]) : nil,
                    isActive: Binding(
                        get: { selectedGroupIndex != nil },
                        set: { if !$0 { selectedGroupIndex = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
        }
    }
}
