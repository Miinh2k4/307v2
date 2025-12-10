import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LampControlUI(),
  ));
}

class LampControlUI extends StatefulWidget {
  const LampControlUI({super.key});

  @override
  State<LampControlUI> createState() => _LampControlUIState();
}

class _LampControlUIState extends State<LampControlUI> {
  bool isOn = false;
  double intensity = 50;

  Future<void> toggleLamp(bool value) async {
    setState(() => isOn = value);

    await http.post(
      Uri.parse("http://172.20.10.3:8080/test/led"),
      headers: {"Content-Type": "text/plain"},
      body: value ? "1" : "0",
    );
  }

  Future<void> changeIntensity(double value) async {
    setState(() => intensity = value);

    await http.post(
      Uri.parse("http://172.20.10.3:8080/test/intensity"),
      headers: {"Content-Type": "text/plain"},
      body: value.toInt().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f3a34),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌕 Glow lớn phía sau
            Positioned(
              top: 100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isOn ? 1 : 0,
                child: Container(
                  width: 460,
                  height: 460,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromRGBO(
                            255, 255, 205, intensity / 120), // tâm sáng
                        Color.fromRGBO(
                            255, 240, 185, intensity / 300), // ngoài mờ
                        const Color.fromRGBO(0, 0, 0, 0),
                      ],
                      stops: const [0.0, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // 💡 Ảnh bóng đèn
            Positioned(
              top: -20,
              right: 20,
              child: Image.asset(
                "assets/lamp.png",
                width: 180,
              ),
            ),

            // ✨ Glow đui đèn
            Positioned(
              top: 235,
              right: 56,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isOn ? (intensity / 60) : 0,
                child: Image.asset(
                  "assets/bong.png",
                  width: 85,
                ),
              ),
            ),

            // 📌 UI panel
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Island Kitchen Bar",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "LED Pendant Ceiling Light",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 25),

                  // 🔘 Switch
                  Row(
                    children: [
                      Switch(
                        value: isOn,
                        onChanged: toggleLamp,
                        activeColor: Colors.greenAccent,
                      ),
                      Text(
                        isOn ? "ON" : "OFF",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text("Light Intensity", style: TextStyle(color: Colors.white)),

                  Row(
                    children: [
                      const Text("💡", style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Slider(
                          value: intensity,
                          min: 0,
                          max: 100,
                          activeColor: Colors.greenAccent,
                          onChanged: changeIntensity,
                        ),
                      ),
                      const Text("💡", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
