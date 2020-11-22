//
//  NewConverterSettingsView.swift
//  RomanDates
//
//  Created by Robert Clarke on 18/11/2020.
//

import SwiftUI

class PreviewViewModel: ObservableObject {
    private var symbolOptions = ["·", "–", "/", " "]

    func previewConversion(userSettings: UserSettings) -> [(String, String)] {
        guard let convertedDateParts = RomanDateConverter().convert(Date()) else {
            return []
        }

        let result = convertedDateParts.descriptiveDateComponentsFor(dateFormatter: userSettings.dateFormatter, separatorSymbol: symbolOptions[userSettings.symbolSeparator])

        print("Converting Date")
        return result
    }
}

struct PartView: View {
    var parts: [(String, String)]

    var body: some View {
        HStack {
            Spacer()

            ForEach(0 ..< parts.count, id: \.self) {value in
                VStack {
                    Text(self.parts[value].1)
                        .font(.largeTitle)
                    Text(self.parts[value].0)
                        .font(.caption)
                }
            }

            Spacer()

        }
    }
}

struct NewConverterSettingsView: View {
    @State var useDeviceDateOrder = true
    @ObservedObject var settings: UserSettings = UserSettings()
    @ObservedObject private var previewViewModel = PreviewViewModel()

    private var symbolOptions = ["·", "–", "/", " "]

    var body: some View {
        Form {
            Section(header: Text("PREVIEW")) {
                // This appears to be called twice everytime something changes
                PartView(parts: self.previewViewModel.previewConversion(userSettings: self.settings))
            }
            
            // TODO: either hide the picker or show the current device settings instead
            Section(header: Text("DATE ORDER")) {

                Toggle("Use device settings", isOn: $settings.useDeviceDateOrder)

                Picker(
                    selection: $settings.dateOrder,
                    label: Text("date order"),
                    content: {
                        if (settings.showYear) {
                            Text("Day-M-Y").tag(0)
                            Text("Month-D-Y").tag(1)
                            Text("Year-M-D").tag(2)
                        } else {
                            Text("Day–Month").tag(0)
                            Text("Month–Day").tag(1)
                        }
                })
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(settings.useDeviceDateOrder)
            }
            
            Section(header: Text("YEAR"), footer: Text("Should the year be shown and should it appear in full (e.g. 2020 or 20)")) {

                Toggle("Show year", isOn: $settings.showYear)
                
                Toggle("Show year in full", isOn: $settings.showFullYear)
                    .disabled(settings.showYear == false)
            }

            Section(header: Text("SEPARATOR SYMBOL")) {
                Picker(
                    selection: $settings.symbolSeparator,
                    label: Text("symbol separator"),
                    content: {
                        ForEach(0..<symbolOptions.count) {
                            Text(self.symbolOptions[$0])
                        }
                })
                    .pickerStyle(SegmentedPickerStyle())

            }
            
            Section(header: Text("CLIPBOARD"), footer: Text("If this is enabled you can copy a date from another app and then have it converted automatically into Roman Numerals.")) {

                Toggle("Automatically convert clipboard", isOn: $settings.usePasteboard)
            }
        }
    }
}

struct NewConverterSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NewConverterSettingsView()
    }
}
