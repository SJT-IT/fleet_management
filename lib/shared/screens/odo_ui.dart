import 'dart:ui';

import 'package:flutter/material.dart';

class OdoUIScreen extends StatefulWidget {
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

  final String vehicleId;

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
    required this.onSliderChanged,
    required this.vehicleId,
  });

  @override
  State<OdoUIScreen> createState() => _OdoUIScreenState();
}

class _OdoUIScreenState extends State<OdoUIScreen> {
  final PageController _controller = PageController(initialPage: 1);
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _topPillNav(),

          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: [_historyPage(), _livePage(), _alarmPage()],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PILL ----------------
  Widget _topPillNav() {
    final labels = ["HISTORY", "LIVE", "ALARMS"];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = constraints.maxWidth / labels.length;

            return Stack(
              children: [
                // MOVING BUBBLE (PIXEL CONTROLLED)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  // IMPORTANT: no duration → we follow finger smoothly
                  left: lerpDouble(
                    (currentPage.floor() * segmentWidth),
                    (currentPage.ceil() * segmentWidth),
                    (currentPage - currentPage.floor()) as double,
                  )!,
                  child: Container(
                    width: segmentWidth,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 220, 220, 220),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                // LABELS
                Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = (currentPage.round() == index);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color.fromARGB(255, 45, 182, 255)
                                  : const Color.fromARGB(255, 163, 163, 163),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- PAGES ----------------

  Widget _livePage() {
    return _buildBaseUI(showSlider: false);
  }

  Widget _historyPage() {
    return _buildBaseUI(showSlider: true);
  }

  Widget _alarmPage() {
    return const Center(
      child: Text(
        "ALARM LIST PAGE",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------- CORE UI ----------------

  Widget _buildBaseUI({required bool showSlider}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _mainCard(context),
        const SizedBox(height: 30),
        if (showSlider) _sliderSection(),
        const SizedBox(height: 30),
      ],
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
              widget.speed.toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Text("km/h", style: TextStyle(color: Colors.grey)),
          ],
        ),
        _alarmChip(widget.alarm),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCircle(
          Icons.battery_charging_full,
          widget.soc,
          "SOC",
          Colors.green,
        ),
        _statCircle(Icons.bolt, widget.voltage, "Voltage", Colors.orange),
        _statCircle(Icons.thermostat, widget.temp, "Temp", Colors.red),
      ],
    );
  }

  Widget _detailsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _detailRow(Icons.electric_moped, "Current", widget.current),
        _detailRow(Icons.history, "Odometer", widget.odometer),
        _detailRow(Icons.location_on, "Latitude", widget.latitude),
        _detailRow(Icons.location_on_outlined, "Longitude", widget.longitude),
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
      child: Center(
        child: Text(
          widget.timestamp,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _sliderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Slider(
            value: widget.sliderValue,
            min: 0,
            max: widget.maxSlider,
            onChanged: widget.onSliderChanged,
          ),
        ],
      ),
    );
  }

  Widget _statCircle(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _alarmChip(String alarm) {
    final isWarning = alarm.toLowerCase() != "no alarm";

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
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
