//
//  SunriseSunsetView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/28/26.
//

//
//  SunriseSunsetView.swift
//
//  A reusable sunrise/sunset arc view, in the style of Google Weather
//  and Samsung Weather's daylight widgets.
//
//  How it works:
//  - The sun's path is modeled as a sine arch: height(t) = sin(t * π),
//    where t = 0 at sunrise and t = 1 at sunset. This naturally crosses
//    zero (the horizon) at both ends and peaks at solar noon (t = 0.5).
//  - Outside [0, 1], the same function dips *below* the horizon, which
//    is what gives you the "underground" curve before dawn / after dusk
//    that you see in the Google screenshot.
//  - sunrise/sunset are the only two values the arc strictly needs, so
//    those are guard-unwrapped once in SunriseSunsetView.body. civilDawn/
//    civilDusk are treated as optional extras, same as before.
//

import SwiftUI

// MARK: - Public entry point

struct SunriseSunsetView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    let times: SunModel
    var now: Date = Date() // Inject for previews/testing; defaults to now

    // Visual tuning
    var arcColor: Color = .gray.opacity(0.35)
    var elapsedGradient: [Color] = [Color.blue.opacity(0.25), Color.blue.opacity(0.55)]
    var nightColor: Color = Color(red: 0.20, green: 0.20, blue: 0.45)
    let sunColor: Color = .yellow
    let moonColor: Color = .white
    let backgroundColor: Color

    var body: some View {
        let color = appStateViewModel.blendColorWith20PercentWhite(themeColor: backgroundColor)
        // sunrise/sunset are Date? on SunModel (WeatherKit can omit them
        // during polar day/night), so this is the single unwrap point.
        // Everything downstream works with guaranteed non-optional dates.
        if let sunrise = times.sunrise, let sunset = times.sunset {
            SunArcView(
                sunrise: sunrise,
                sunset: sunset,
                civilDawn: times.civilDawn,
                civilDusk: times.civilDusk,
                now: now,
                labels: times,
                arcColor: arcColor,
                elapsedGradient: [backgroundColor],
                nightColor: nightColor,
                sunColor: times.isDaylight ?? true ? sunColor : moonColor
            )
            .bigCardTileModifier(backgroundColor: color)

        } else {
            SunDataUnavailableView(isDaylight: times.isDaylight)
                .bigCardTileModifier(backgroundColor: color)

        }
    }
}

// MARK: - Fallback when sunrise/sunset are nil

/// Shown when WeatherKit doesn't return sunrise/sunset for the day —
/// which happens at high latitudes during polar day (sun never sets)
/// or polar night (sun never rises). `isDaylight` disambiguates the two;
/// pass nil if that signal isn't available and a neutral message is shown.
struct SunDataUnavailableView: View {
    let isDaylight: Bool?

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(iconColor)
            Text(message)
                .font(.subheadline.weight(.medium))
        }
        .frame(height: 170)
        .frame(maxWidth: .infinity)
    }

    private var message: String {
        switch isDaylight {
        case true: return "Sun is up all day"
        case false: return "Sun doesn't rise today"
        case nil: return "Sunrise & sunset unavailable"
        }
    }

    private var iconName: String {
        switch isDaylight {
        case true: return "sun.max.fill"
        case false: return "moon.stars.fill"
        case nil: return "sun.horizon"
        }
    }

    private var iconColor: Color {
        switch isDaylight {
        case true: return .yellow
        case false: return .white
        case nil: return .white
        }
    }
}

// MARK: - Drawing (only runs once sunrise/sunset are non-optional)

private struct SunArcView: View {
    let sunrise: Date
    let sunset: Date
    let civilDawn: Date?
    let civilDusk: Date?
    let now: Date
    /// Kept only to read the pre-formatted display strings (sunriseTime,
    /// sunsetTime, dawn, dusk, solarNoonTime) off SunModel.
    let labels: SunModel

    let arcColor: Color
    let elapsedGradient: [Color]
    let nightColor: Color
    let sunColor: Color

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let horizonY = geo.size.height * 0.62
            let arcHeight = geo.size.height * 0.5

            ZStack {
                horizonLine(width: width, horizonY: horizonY)

                // Faint full arc (the "future" / un-elapsed track)
                arcPath(from: domainStart, to: domainEnd, width: width, horizonY: horizonY, arcHeight: arcHeight)
                    .stroke(arcColor, lineWidth: 2)

                // Dark fill for dawn -> sunrise (only relevant if civilDawn is provided)
                if domainStart < 0 {
                    fillPath(from: domainStart, to: 0, width: width, horizonY: horizonY, arcHeight: arcHeight)
                        .fill(nightColor)
                }

                // Elapsed daylight portion, sunrise -> now, gradient filled
                let elapsedEnd = min(max(nowFraction, 0), 1)
                if elapsedEnd > 0 {
                    fillPath(from: 0, to: elapsedEnd, width: width, horizonY: horizonY, arcHeight: arcHeight)
                        .fill(LinearGradient(colors: elapsedGradient, startPoint: .leading, endPoint: .trailing))
                }

                // Sun position dot
                let sunT = min(max(nowFraction, domainStart), domainEnd)
                let sunPoint = point(at: sunT, width: width, horizonY: horizonY, arcHeight: arcHeight)
                Circle()
                    .fill(sunColor)
                    .frame(width: 16, height: 16)
                    .shadow(color: sunColor.opacity(0.7), radius: 6)
                    .position(sunPoint)

                labelsView
            }
        }
        .frame(height: 170)
    }

    // MARK: Labels

    @ViewBuilder
    private var labelsView: some View {
        VStack {
            HStack {
                timeLabel("Sunrise", labels.sunriseTime)
                Spacer()
                timeLabel("Sunset", labels.sunsetTime)
            }
            Spacer()
            if civilDawn != nil, civilDusk != nil {
                HStack {
                    timeLabel("Dawn", labels.dawn)
                    Spacer()
                    timeLabel("Solar noon", labels.solarNoonTime)
                    Spacer()
                    timeLabel("Dusk", labels.dusk)
                }
            }
        }
    }

    private func timeLabel(_ title: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
    }

    // MARK: - Time math

    private var sunriseSunsetSpan: TimeInterval {
        sunset.timeIntervalSince(sunrise)
    }

    private func fraction(for date: Date) -> CGFloat {
        guard sunriseSunsetSpan > 0 else { return 0 }
        return CGFloat(date.timeIntervalSince(sunrise) / sunriseSunsetSpan)
    }

    private var nowFraction: CGFloat { fraction(for: now) }

    private var domainStart: CGFloat {
        if let dawn = civilDawn { return fraction(for: dawn) }
        return -0.18 // small default margin so the curve visibly meets the horizon
    }

    private var domainEnd: CGFloat {
        if let dusk = civilDusk { return fraction(for: dusk) }
        return 1.18
    }

    /// The arch itself: 0 at t=0 and t=1, peaks at t=0.5, negative outside [0,1].
    private func height(at t: CGFloat) -> CGFloat {
        sin(t * .pi)
    }

    // MARK: - Geometry

    private func point(at t: CGFloat, width: CGFloat, horizonY: CGFloat, arcHeight: CGFloat) -> CGPoint {
        let x = ((t - domainStart) / (domainEnd - domainStart)) * width
        let y = horizonY - height(at: t) * arcHeight
        return CGPoint(x: x, y: y)
    }

    private func horizonLine(width: CGFloat, horizonY: CGFloat) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: horizonY))
            path.addLine(to: CGPoint(x: width, y: horizonY))
        }
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    }

    private func arcPath(from start: CGFloat, to end: CGFloat, width: CGFloat, horizonY: CGFloat, arcHeight: CGFloat) -> Path {
        Path { path in
            let steps = 100
            for i in 0...steps {
                let t = start + (end - start) * CGFloat(i) / CGFloat(steps)
                let pt = point(at: t, width: width, horizonY: horizonY, arcHeight: arcHeight)
                i == 0 ? path.move(to: pt) : path.addLine(to: pt)
            }
        }
    }

    /// Closed shape: along the curve from `start` to `end`, then straight back
    /// along the horizon — this is what makes the gradient fill sit "under" the arc.
    private func fillPath(from start: CGFloat, to end: CGFloat, width: CGFloat, horizonY: CGFloat, arcHeight: CGFloat) -> Path {
        guard end > start else { return Path() }
        return Path { path in
            let steps = 80
            var points: [CGPoint] = []
            for i in 0...steps {
                let t = start + (end - start) * CGFloat(i) / CGFloat(steps)
                points.append(point(at: t, width: width, horizonY: horizonY, arcHeight: arcHeight))
            }
            guard let first = points.first, let last = points.last else { return }
            path.move(to: CGPoint(x: first.x, y: horizonY))
            path.addLine(to: first)
            points.dropFirst().forEach { path.addLine(to: $0) }
            path.addLine(to: CGPoint(x: last.x, y: horizonY))
            path.closeSubpath()
        }
    }
}

// MARK: - Preview

#Preview("Samsung-style (sunrise/sunset only)") {
    let cal = Calendar.current
    let today = Date()
    let sunrise = cal.date(bySettingHour: 5, minute: 32, second: 0, of: today)!
    let sunset = cal.date(bySettingHour: 19, minute: 44, second: 0, of: today)!
    let now = cal.date(bySettingHour: 13, minute: 0, second: 0, of: today)!

    return SunriseSunsetView(
        times: SunModel(
            sunrise: sunrise,
            sunset: sunset,
            civilDawn: nil,
            solarNoon: nil,
            civilDusk: nil,
            timezoneIdentifier: TimeZone.current.identifier,
            isDaylight: true,
        ),
        now: now,
        backgroundColor: Color.blue
    )
    .padding()
}

#Preview("Google-style (with dawn/dusk)") {
    let cal = Calendar.current
    let today = Date()
    let dawn = cal.date(bySettingHour: 5, minute: 55, second: 0, of: today)!
    let sunrise = cal.date(bySettingHour: 6, minute: 23, second: 0, of: today)!
    let solarNoon = cal.date(bySettingHour: 13, minute: 23, second: 0, of: today)!
    let sunset = cal.date(bySettingHour: 20, minute: 24, second: 0, of: today)!
    let dusk = cal.date(bySettingHour: 20, minute: 51, second: 0, of: today)!
    let now = cal.date(bySettingHour: 13, minute: 23, second: 0, of: today)!

    return SunriseSunsetView(
        times: SunModel(
            sunrise: sunrise,
            sunset: sunset,
            civilDawn: dawn,
            solarNoon: solarNoon,
            civilDusk: dusk,
            timezoneIdentifier: TimeZone.current.identifier,
            isDaylight: true
        ),
        now: now,
        backgroundColor: Color.blue

    )
    .padding()
}

#Preview("Polar day (sun never sets)") {
    SunriseSunsetView(
        times: SunModel(
            sunrise: nil,
            sunset: nil,
            civilDawn: nil,
            solarNoon: nil,
            civilDusk: nil,
            timezoneIdentifier: TimeZone.current.identifier,
            isDaylight: true
        ),
        backgroundColor: Color.blue
    )
    .padding()
}

#Preview("Polar night (sun never rises)") {
    SunriseSunsetView(
        times: SunModel(
            sunrise: nil,
            sunset: nil,
            civilDawn: nil,
            solarNoon: nil,
            civilDusk: nil,
            timezoneIdentifier: TimeZone.current.identifier,
            isDaylight: false
        ),
        backgroundColor: Color.blue
    )
    .padding()
}
