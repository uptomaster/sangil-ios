import Foundation

enum MountainData {

    static let all: [Mountain] = [

        Mountain(
            name: "북한산",
            region: "서울 · 경기",
            height: 836,
            difficulty: "중급",
            imageName: "bukhansan",
            summary: "도심 가까이에서 암릉과 능선 풍경을 즐길 수 있는 서울의 대표적인 산입니다.",
            courseName: "백운대 코스",
            distance: 6.8,
            duration: "약 4시간"
        ),

        Mountain(
            name: "관악산",
            region: "서울 · 경기",
            height: 632,
            difficulty: "초급",
            imageName: "gwanaksan",
            summary: "서울에서 접근하기 쉽고 여러 코스를 선택할 수 있어 가볍게 산행을 시작하기 좋은 산입니다.",
            courseName: "관악산공원 코스",
            distance: 4.7,
            duration: "약 2시간 30분"
        ),

        Mountain(
            name: "설악산",
            region: "강원",
            height: 1708,
            difficulty: "상급",
            imageName: "seoraksan",
            summary: "웅장한 암봉과 깊은 계곡, 사계절마다 달라지는 풍경으로 유명한 대한민국 대표 명산입니다.",
            courseName: "오색 · 대청봉 코스",
            distance: 10.0,
            duration: "약 8시간"
        ),

        Mountain(
            name: "한라산",
            region: "제주",
            height: 1947,
            difficulty: "상급",
            imageName: "hallasan",
            summary: "제주도 중심에 자리한 대한민국 최고봉으로 정상 부근의 독특한 화산 지형이 특징입니다.",
            courseName: "성판악 코스",
            distance: 19.2,
            duration: "약 8~9시간"
        )
    ]
}
