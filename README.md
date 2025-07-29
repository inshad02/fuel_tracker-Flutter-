# Fuel Economy & Mileage Tracker

A comprehensive Flutter mobile application for tracking fuel efficiency and mileage for cars, bikes, and buses.

## Features

### Core Functionality
- **Vehicle Type Support**: Track fuel efficiency for Car, Bike, and Bus
- **Mileage Calculation**: Calculate distance traveled and fuel efficiency in km/l
- **Fuel Economy Tracking**: Monitor cost per kilometer in ₹/km
- **Real-time Calculations**: Automatic computation of all metrics

### Input Fields
- Start Odometer Reading (km)
- End Odometer Reading (km)
- Fuel Filled (liters)
- Fuel Price per Liter (₹)

### Calculations
- **Distance Traveled** = End Odometer - Start Odometer
- **Mileage** = Distance Traveled / Fuel Filled (km/l)
- **Total Fuel Cost** = Fuel Filled × Fuel Price
- **Fuel Economy** = Total Fuel Cost / Distance Traveled (₹/km)

### Data Management
- **Trip History**: Complete record of all trips with details
- **Data Persistence**: Local storage using Hive database
- **Filtering**: Filter trips by vehicle type
- **Statistics**: Comprehensive analytics and insights

### User Interface
- **Clean Design**: Modern, intuitive Material Design 3 interface
- **Form Validation**: Comprehensive input validation
- **Responsive Layout**: Optimized for mobile devices
- **Dark/Light Theme**: Adaptive theming support

## Screens

### 1. Home Screen
- Overview of all trips
- Quick statistics summary
- Filter by vehicle type
- Navigation drawer for additional features

### 2. Add Trip Screen
- Vehicle type selection (Car/Bike/Bus)
- Input forms for odometer readings and fuel details
- Real-time calculation preview
- Form validation with error messages

### 3. Trip Detail Screen
- Comprehensive trip information
- Efficiency analysis with ratings
- Input details review
- Performance metrics

### 4. Statistics Screen
- Overall performance metrics
- Vehicle-wise statistics
- Recent trips overview
- Filtered analytics

## Technical Details

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.20.2
  build_runner: ^2.4.15
  hive_generator: ^2.0.1
```

### Data Model
The app uses a `Trip` model with the following fields:
- Vehicle type (Car/Bike/Bus)
- Start and end odometer readings
- Fuel filled and fuel price
- Calculated metrics (distance, mileage, cost, economy)
- Timestamp

### Database
- **Hive**: NoSQL database for local storage
- **Automatic persistence**: All data is automatically saved
- **Type-safe**: Full type safety with generated adapters

## Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Generate Hive adapters:
   ```bash
   flutter packages pub run build_runner build
   ```
5. Run the app:
   ```bash
   flutter run
   ```

### Building for Production
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

## Usage

### Adding a Trip
1. Tap the "Add Trip" floating action button
2. Select vehicle type (Car/Bike/Bus)
3. Enter start odometer reading
4. Enter end odometer reading
5. Enter fuel filled (in liters)
6. Enter fuel price per liter
7. Tap "Calculate" to see results
8. Tap "Save Trip" to store the data

### Viewing Trip History
- All trips are displayed on the home screen
- Tap any trip to view detailed information
- Use the filter menu to view trips by vehicle type
- Access statistics through the navigation drawer

### Analyzing Performance
- View overall statistics on the home screen
- Access detailed analytics in the Statistics screen
- Monitor efficiency ratings for each trip
- Track trends over time

## Validation Rules

### Input Validation
- End odometer must be greater than start odometer
- Fuel filled must be greater than 0
- Fuel price must be greater than 0
- All numeric inputs must be valid numbers

### Efficiency Ratings
- **Mileage Efficiency**:
  - Excellent: ≥ 25 km/l
  - Good: 20-25 km/l
  - Average: 15-20 km/l
  - Poor: < 15 km/l

- **Cost Efficiency**:
  - Excellent: ≤ ₹2/km
  - Good: ₹2-4/km
  - Average: ₹4-6/km
  - Poor: > ₹6/km

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue on the GitHub repository.

---

**Fuel Tracker** - Your comprehensive fuel efficiency companion
