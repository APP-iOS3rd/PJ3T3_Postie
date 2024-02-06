//
//  PageViewController.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/18.
//

import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIPageViewController

    var controllers: [UIViewController] = []

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers(
            [controllers[0]],
            direction: .forward,
            animated: true
        )
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        let parent: PageViewController

        init(_ parent: PageViewController) {
            self.parent = parent
        }

        // 왼쪽 스와이프 하면 나올 뷰 설정
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
                guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                    return nil
                }

                if index == 0 {
                    return self.parent.controllers.last
                }

                return self.parent.controllers[index - 1]
            }

        // 오른쪽 스와이프 하면 나올 뷰 설정
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
                guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                    return nil
                }

                if index == self.parent.controllers.count - 1 {
                    return self.parent.controllers.first
                }

                return self.parent.controllers[index + 1 ]
            }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct Page: View {
    let letter: Letter

    var body: some View {
        ScrollView {
            HStack {
                Text("To. ")
                    .font(.view(.sourceSerifProBlack))
                + Text(letter.recipient)
                    .font(.letter(.nanumMyeongjoBold))
                Spacer()
            }

            Text(letter.text)
                .font(.letter(.nanumMyeongjo))
                .lineSpacing(10.0)
                .padding(.vertical, 8)

            Spacer()

            HStack {
                Text(letter.date.toString(format: "yyyy년 M월 d일"))
                    .font(.letter(.nanumMyeongjo))

                Spacer()

                Text("From. ")
                    .font(.view(.sourceSerifProBlack))
                + Text(letter.writer)
                    .font(.letter(.nanumMyeongjoBold))
            }
        }
        .scrollIndicators(.never)
        .padding()
        .background(Color(hex: 0xFFFBF2))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
