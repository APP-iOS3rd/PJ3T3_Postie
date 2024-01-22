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
    var chunk: String

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("To. \(letter.receiver)")
                    .font(.headline)

                Spacer()
            }

            Divider()

            HStack {
                Image(systemName: "quote.opening")
                    .font(.title)
                    .foregroundStyle(Color(hex: 0xC2AD7E))

                Spacer()
            }
            .padding(.bottom, 8)

            Text(chunk)
                .lineSpacing(10.0)

            Spacer()

            HStack {
                Spacer()

                Image(systemName: "quote.closing")
                    .font(.title)
                    .foregroundStyle(Color(hex: 0xC2AD7E))
            }

            HStack {
                Text(Date.now.formatted().description)

                Spacer()

                Text("From. \(letter.sender)")
                    .font(.headline)
            }
        }
        .padding()
    }
}

//#Preview {
//    Page(letter: Letter.preview, chunk: "안녕? 잘지내? 한동안 따뜻 했다가 다시 추워졌네. 항상 감기 조심해... 이런 추운 겨울만 되면 항상 너가 생각나. 추운 겨울이 생각나지 않을 정도로 우리, 따뜻했잖아. 그런 겨울이 다시 올줄 알았는데 안타깝게도 그렇게 되진 못헀네. 너랑 헤어진 이후 내 머리속엔 항상 너로 가득했어. 돌이킬 수 없는 나의 실수에 자책을 너무 했어. 잊어보려 노력했지만, 시릴 정도로 추운 겨울이 너와 같이 찾아왔어. 처음이였어. 너도 처음이였고 이렇게 무언가에 빠진 나도 처음이야. 우리 다시 만나면 그 전 보다 더 잘될 수 있지 않을까...?")
//}

#Preview {
    LetterDetailView(letter: Letter.preview)
}
