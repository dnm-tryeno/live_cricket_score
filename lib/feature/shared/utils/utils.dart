/// Convert speed value from one unit to another
/// Supported units: 'bps', 'Kbps', 'Mbps', 'Gbps', 'Tbps'
/// All conversions are based on Mbps (megabits per second) as the base unit
double convertSpeedUnitUtil(double value, String fromUnit, String toUnit) {
  // Normalize unit names (case-insensitive)
  final from = fromUnit.toLowerCase();
  final to = toUnit.toLowerCase();

  // If same unit, return as is
  if (from == to) {
    return value;
  }

  // Convert to Mbps first (base unit)
  double valueInMbps = value;

  switch (from) {
    case 'bps':
      valueInMbps = value / 1000000; // 1 Mbps = 1,000,000 bps
      break;
    case 'kbps':
      valueInMbps = value / 1000; // 1 Mbps = 1,000 Kbps
      break;
    case 'mbps':
      valueInMbps = value; // Already in Mbps
      break;
    case 'gbps':
      valueInMbps = value * 1000; // 1 Gbps = 1,000 Mbps
      break;
    case 'tbps':
      valueInMbps = value * 1000000; // 1 Tbps = 1,000,000 Mbps
      break;
    default:
      // Default assume Mbps
      valueInMbps = value;
  }

  // Convert from Mbps to target unit
  switch (to) {
    case 'bps':
      return valueInMbps * 1000000;
    case 'kbps':
      return valueInMbps * 1000;
    case 'mbps':
      return valueInMbps;
    case 'gbps':
      return valueInMbps / 1000;
    case 'tbps':
      return valueInMbps / 1000000;
    default:
      // Default return in Mbps
      return valueInMbps;
  }
}

/// Format speed value with unit label
/// Returns formatted string like "100.5 Mbps"
/// Automatically adjusts decimal places based on unit to avoid showing 0.0 for small values
String formatSpeedWithUnitUtil(double value, String unit, {int? decimals}) {
  final convertedValue = convertSpeedUnitUtil(value, 'Mbps', unit);
  final unitLabel = unit.toUpperCase();

  // Determine appropriate decimal places based on unit
  int decimalPlaces;
  if (decimals != null) {
    decimalPlaces = decimals;
  } else {
    final unitLower = unit.toLowerCase();
    switch (unitLower) {
      case 'tbps':
        decimalPlaces = 3; // For very large units, show more precision
        break;
      case 'gbps':
        decimalPlaces =
            2; // For Gbps, show 2 decimals to avoid 0.0 for small values
        break;
      case 'mbps':
        decimalPlaces = 1; // Mbps is standard, 1 decimal is fine
        break;
      case 'kbps':
        decimalPlaces = 1; // Kbps, 1 decimal is fine
        break;
      case 'bps':
        decimalPlaces = 0; // bps, no decimals needed
        break;
      default:
        decimalPlaces = 1;
    }
  }

  // If value is very small, ensure we show at least 2 decimals for Gbps/Tbps
  final unitLower = unit.toLowerCase();
  if ((unitLower == 'gbps' || unitLower == 'tbps') &&
      convertedValue < 1.0 &&
      convertedValue > 0) {
    decimalPlaces = 2;
  }

  return '${convertedValue.toStringAsFixed(decimalPlaces)} $unitLabel';
}
