import SwiftUI

struct MountainCardView: View {

    let mountain: Mountain

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Image(mountain.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 190)
                .frame(maxWidth: .infinity)
                .clipped()

            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Text(mountain.name)
                        .font(.title3)
                        .fontWeight(.bold)

                    Spacer()

                    Text(mountain.difficulty)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                }

                HStack(spacing: 5) {
                    Image(systemName: "location.fill")

                    Text(mountain.region)

                    Text("·")

                    Text("\(mountain.height)m")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color.secondary.opacity(0.05))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    MountainCardView(
        mountain: MountainData.all[0]
    )
    .padding()
}
