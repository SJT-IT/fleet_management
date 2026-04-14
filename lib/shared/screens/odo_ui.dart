import 'package:flutter/material.dart';

class OdoUIScreen extends StatelessWidget {
  final double speed;
  final String alarm;
  final String soc;
  final String voltage;
  final String temp;
  final String current;
  final String odometer;
  final String latitude;
  final String longitude;
  final String timestamp;

  final double sliderValue;
  final double maxSlider;
  final ValueChanged<double> onSliderChanged;

  const OdoUIScreen({
    super.key,
    required this.speed,
    required this.alarm,
    required this.soc,
    required this.voltage,
    required this.temp,
    required this.current,
    required this.odometer,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.sliderValue,
    required this.maxSlider,
    required this.onSliderChanged, required String vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "BMS Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _mainCard(context),
          const SizedBox(height: 40),
          _sliderSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _mainCard(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: Column(
              children: [
                _topRow(),
                const Divider(height: 30),
                _statsRow(),
                const SizedBox(height: 15),
                Expanded(child: _detailsSection()),
                _timestampBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              speed.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const Text(
              "km/h",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        _alarmChip(alarm),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCircle(Icons.battery_charging_full, soc, "SOC", Colors.green),
        _statCircle(Icons.bolt, voltage, "Voltage", Colors.orange),
        _statCircle(Icons.thermostat, temp, "Temp", Colors.redAccent),
      ],
    );
  }

  Widget _detailsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _detailRow(Icons.electric_moped, "Current", current),
        _detailRow(Icons.history, "Odometer", odometer),
        _detailRow(Icons.location_on, "Latitude", latitude),
        _detailRow(Icons.location_on_outlined, "Longitude", longitude),
      ],
    );
  }

  Widget _timestampBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            timestamp,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _sliderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Slider(
            value: sliderValue,
            min: 0,
            max: maxSlider,
            onChanged: onSliderChanged,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "HISTORY",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  "LIVE DATA",
                  style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCircle(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withAlpha(25),
          radius: 20,
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _alarmChip(String alarm) {
    bool isWarning = alarm.toLowerCase() != "no alarm";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red : Colors.green.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        alarm.toUpperCase(),
        style: TextStyle(
          color: isWarning ? Colors.white : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
