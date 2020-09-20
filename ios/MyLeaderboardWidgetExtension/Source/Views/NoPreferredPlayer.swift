//
//  NoPreferredPlayer.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-09-20.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI

struct NoPreferredPlayer: View {
	var body: some View {
		VStack {
			Text("You must select a preferred player in Settings to see stats in the widget")
				.font(.caption)
			Spacer()
		}
		.padding()
	}
}
