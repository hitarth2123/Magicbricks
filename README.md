# Magicbricks Commercial

Magicbricks Commercial is a responsive Flutter application for commercial real-estate discovery and decision support. It brings property search, property evaluation, lease planning, floor-plan inspection, analytics, compliance information, service plans, and profile management into one workspace.

## Problem Statement

Commercial property decisions are often made using disconnected sources of information. Users may need to switch between property listings, floor plans, lease calculations, footfall reports, and compliance documents before they can evaluate a location.

The problem addressed by this project is:

> How can commercial property information and common evaluation tools be presented in one clear, responsive application so that users can compare properties and make faster, better-informed decisions?

Magicbricks Commercial addresses this problem through a unified navigation system and focused screens for the most common commercial-property workflows.

## Case Study: Commercial Office Selection

### Background

Rahul Mehta is evaluating office space for a growing business. He needs to compare locations, understand the usable area, estimate lease costs, inspect the floor layout, review visitor activity, and check compliance requirements before requesting a site visit.

### Existing Difficulties

- Property information is spread across different documents and websites.
- Floor plans may not clearly show room divisions or measurements.
- Lease costs and fit-out capacity can be difficult to compare.
- Footfall and compliance information may be reviewed too late.
- Switching between tools makes the decision process slower.

### Proposed Solution

The application gives Rahul one commercial-property workspace where he can:

1. Find and review commercial properties.
2. Open detailed property information.
3. Use the lease calculator for financial planning.
4. Inspect a measured floor plan and fit-out capacity.
5. Review footfall analytics.
6. Check GST and compliance information.
7. Compare plans and pricing.
8. Manage profile information and account access.

### Expected Outcome

The user can move from property discovery to an informed site-visit request using one consistent interface. This reduces information fragmentation and makes important property details easier to scan and compare.

## Objectives

- Build a practical commercial-property dashboard using Flutter.
- Present property information in a clear, structured format.
- Provide interactive floor-plan inspection with measurements.
- Support lease and financial planning workflows.
- Display footfall, compliance, and service-plan information.
- Provide responsive layouts for wide and compact screens.
- Organize the codebase using feature-based modules.

## Main Features

| Module | Purpose |
| --- | --- |
| Overview | Entry dashboard and navigation to key workflows |
| Find properties | Browse commercial property options |
| Property detail | Review information about a selected property |
| Lease calculator | Work with lease-related financial values |
| Floor plans | Inspect rooms, measurements, areas, and fit-out capacity |
| Footfall analytics | Review visitor activity and trends |
| GST and compliance | View regulatory and compliance information |
| Plans and pricing | Review available service plans |
| Profile | View account and user information |

## Demo Login Credentials

The prototype starts with a local role-based login screen. Use one of these accounts:

| Role | Email | Password |
| --- | --- | --- |
| Customer | `customer@magicbricks.com` | `customer123` |
| Admin | `admin@magicbricks.com` | `admin123` |

Customer accounts open the property workspace. Admin accounts also receive access to the Admin workspace for managing properties, price plans, users, customer requests, and the audit log.

## Floor Plan Viewer

The floor-plan viewer provides a measured layout for a commercial office. It includes:

- Fitted layout and bare-shell modes.
- Room labels for reception, open office, and meeting areas.
- Width and depth measurements.
- A visible `65 ft` depth measurement outside the right edge of the plan.
- Usable, common, and service-area information.
- Fit-out capacity including workstations, cabins, meeting rooms, and density.
- Zoom controls and a dimensions toggle.

## Technology Stack

- Flutter
- Dart
- Flutter Material widgets
- Custom `CustomPainter` floor-plan rendering
- Stateful Flutter widgets for local screen state
- Flutter test framework

The project contains platform targets for Android, iOS, Web, Linux, macOS, and Windows.

## Project Structure

```text
lib/
	main.dart
	core/
		app_theme.dart
	data/
		property_data.dart
	models/
		property.dart
	features/
		calculator/
		home/
		profile/
		property/
		reference/
		saved/
		tools/
	shared/
		widgets/
test/
	widget_test.dart
```

## Requirements

- Flutter SDK compatible with Dart `3.13.2` or later within the project constraint.
- An available Flutter device or browser target.
- Xcode for iOS and macOS builds on macOS.
- Android Studio or an Android SDK for Android builds.

## Setup and Run

From the project root:

```bash
flutter pub get
flutter run
```

To run in a browser:

```bash
flutter run -d chrome
```

## Production builds

The app uses `com.magicbricks.commercial` as its Android application ID and
`com.magicbricksCommercial` as its iOS bundle identifier. Update these IDs
before publishing under a different organization or brand.

Web release output:

```bash
flutter build web --release
```

For a signed Android release, create `android/key.properties` locally (it is
ignored by git) with the following values:

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=/absolute/path/to/upload-keystore.jks
```

Then build an app bundle for Google Play:

```bash
flutter build appbundle --release
```

Configure the iOS team, signing certificate, provisioning profile, and App
Store bundle identifier in Xcode before running:

```bash
flutter build ipa --release
```

Release checklist:

- Run `flutter analyze` and `flutter test`.
- Verify the app on a physical Android and iOS device.
- Replace the default launcher icons and review store metadata.
- Keep signing files and certificates outside source control.

## Testing and Validation

Run static analysis:

```bash
flutter analyze
```

Run the test suite:

```bash
flutter test
```

Build the web version:

```bash
flutter build web
```

## Screenshots

Add screenshots of the completed application to the project report and documentation. Recommended screenshots are:

1. Overview dashboard.
2. Find properties screen.
3. Property detail screen.
4. Lease calculator.
5. Floor-plan viewer showing the `65 ft` right-side measurement.
6. Footfall analytics.
7. GST and compliance screen.
8. Plans and pricing screen.
9. Profile screen.

The full report with dedicated image-pasting spaces is available in [PROJECT_REPORT.md](PROJECT_REPORT.md).

## Future Enhancements

- Connect property data to a backend service.
- Add authentication and persistent user accounts.
- Save and compare multiple properties.
- Add live market and footfall data.
- Export property comparisons and calculations as PDF.
- Add production analytics and error reporting.

## Conclusion

Magicbricks Commercial provides a single, responsive workspace for commercial property evaluation. By combining discovery, financial planning, floor-plan inspection, analytics, compliance, and account workflows, the application supports a more organized property decision process.
