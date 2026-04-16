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

  // MONTHLY DATA
  final double? prevMonthDistance;
  final double? currentMonthDistance;
  final double? runningMonthDistance;

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
    required this.prevMonthDistance,
    required this.currentMonthDistance,
    required this.runningMonthDistance,
  });

  @override
  State<OdoUIScreen> createState() => _OdoUIScreenState();
}

class _OdoUIScreenState extends State<OdoUIScreen> {
  final PageController _controller = PageController(initialPage: 1);
  int currentPage = 1;

  final List<String> labels = ["HISTORY", "LIVE", "MONTHLY", "ALARMS"];

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
                setState(() => currentPage = index);
              },
              children: [
                _buildPage(showSlider: true),
                _buildPage(showSlider: false),
                _monthlyPage(),
                _alarmPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- NAV ----------------
  Widget _topPillNav() {
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
            final w = constraints.maxWidth / labels.length;

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: currentPage * w,
                  child: Container(
                    width: w,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                Row(
                  children: List.generate(labels.length, (i) {
                    final selected = i == currentPage;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _controller.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              labels[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.blue : Colors.grey,
                              ),
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
  Widget _buildPage({required bool showSlider}) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mainCard(),
              const SizedBox(height: 20),
              if (showSlider) _sliderSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- MONTHLY PAGE ----------------
  Widget _monthlyPage() {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(children: [_monthlyCard()]),
        ),
      ),
    );
  }

  Widget _monthlyCard() {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.vehicleId,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "MONTHLY ANALYSIS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 20),

            _monthlyTile(
              "Previous Month",
              widget.currentMonthDistance,
              Colors.green,
            ),
            _monthlyTile(
              "Current Month Running",
              widget.runningMonthDistance,
              Colors.blue,
            ),
            _monthlyTile(
              "Month Before Last",
              widget.prevMonthDistance,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthlyTile(String label, double? value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.show_chart, color: color),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(
            value == null ? "-- km" : "${value.toStringAsFixed(2)} km",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------- ALARM PAGE ----------------
  Widget _alarmPage() {
    return const Center(child: Text("ALARM LIST PAGE"));
  }

  // ---------------- MAIN CARD ----------------
  Widget _mainCard() {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.vehicleId,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _topRow(),
            const Divider(height: 25),
            _statsRow(),
            const SizedBox(height: 15),
            _detailsSection(),
            const SizedBox(height: 15),
            _timestampBox(),
          ],
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
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
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
        _stat("SOC", widget.soc, Colors.green),
        _stat("Volt", widget.voltage, Colors.orange),
        _stat("Temp", widget.temp, Colors.red),
      ],
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withAlpha(50),
          child: Icon(Icons.circle, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _detailsSection() {
    return Column(
      children: [
        _detailRow(Icons.electric_moped, "Current", widget.current),
        _detailRow(Icons.history, "Odometer", widget.odometer),
        _detailRow(Icons.location_on, "Lat", widget.latitude),
        _detailRow(Icons.location_on_outlined, "Long", widget.longitude),
      ],
    );
  }

  Widget _timestampBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(20),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slider(
        value: widget.sliderValue,
        min: 0,
        max: widget.maxSlider == 0 ? 1 : widget.maxSlider,
        onChanged: widget.onSliderChanged,
      ),
    );
  }

  Widget _alarmChip(String alarm) {
    final warn = alarm.toLowerCase() != "no alarm";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: warn ? Colors.red : Colors.green.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        alarm.toUpperCase(),
        style: TextStyle(
          color: warn ? Colors.white : Colors.green,
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
