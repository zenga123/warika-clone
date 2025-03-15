// DismissKeyboardHelper.swift
import SwiftUI

// 키보드 닫기 도우미 뷰
struct DismissKeyboardHelper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// 키보드 닫기 유틸리티 확장
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 키보드 관련 View 확장 기능 통합
extension View {
    // 배경에 제스처 추가하는 방식
    func dismissKeyboardOnTap() -> some View {
        return self.background(DismissKeyboardHelper())
    }
    
    // 코드에서 직접 호출하는 방식
    func hideKeyboard() {
        UIApplication.shared.endEditing()
    }
    
    // 투명 오버레이 방식 (가장 확실하게 동작)
    func tapToHideKeyboard() -> some View {
        modifier(TapToHideKeyboardModifier())
    }
}

// 화면 터치 시 키보드 숨기기 수정자
struct TapToHideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            
            // 키보드가 활성화되었을 때만 투명 레이어 추가
            Color.black.opacity(0.001)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .ignoresSafeArea()
        }
    }
}
