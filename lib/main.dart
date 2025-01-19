import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(KararOyunu());
}

class KararOyunu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karar Oyunu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HikayeEkrani(),
    );
  }
}

class HikayeEkrani extends StatefulWidget {
  @override
  _HikayeEkraniState createState() => _HikayeEkraniState();
}

class _HikayeEkraniState extends State<HikayeEkrani> {
  List<Map<String, dynamic>> hikayeler = [
    {
      'metin': 'Ormanda kayboldun. Ne yapacaksın?',
      'secenekler': ['Dereyi takip et', 'Ağaçlara tırman'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [1, 2],
    },
    {
      'metin': 'Dereye ulaştın. Bir köprü var ama kırık. Ne yapacaksın?',
      'secenekler': ['Köprüyü geçmeyi dene', 'Geri dön'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [3, 4],
    },
    {
      'metin': 'Ağaçtan bir yırtıcıyı gördün. Ne yapacaksın?',
      'secenekler': ['Kaç', 'Yırtıcıyı izlemeye devam et'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [4, 5],
    },
    {
      'metin': 'Köprü çöktü. Akıntıya kapıldın!',
      'secenekler': ['Yeniden Başla', 'Yeniden Başla'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [0, 0],
    },
    {
      'metin': 'Başka bir yol buldun ve güvenle ormandan çıktın!',
      'secenekler': ['Yeniden Başla', 'Yeniden Başla'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [0, 0],
    },
    {
      'metin': 'Yırtıcı seni fark etti. Kaçmak için çok geç!',
      'secenekler': ['Yeniden Başla', 'Yeniden Başla'],
      'image': 'assets/images/gif1.gif',
      'sonraki': [0, 0],
    },
  ];

  int mevcutHikaye = 0;

  void secimYap(int index) {
    setState(() {
      mevcutHikaye = hikayeler[mevcutHikaye]['sonraki'][index];
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> aktifHikaye = hikayeler[mevcutHikaye];

    return Scaffold(
      appBar: AppBar(
        title: Text('Karar Oyunu'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: DraggableCard(
              hikaye: aktifHikaye,
              onSwipeLeft: () => secimYap(0),
              onSwipeRight: () => secimYap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Map<String, dynamic> hikaye;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const DraggableCard({
    required this.hikaye,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late Offset _offset;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _offset = Offset.zero;
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_offset.dx < -100) {
      widget.onSwipeLeft();
    } else if (_offset.dx > 100) {
      widget.onSwipeRight();
    }
    _resetPosition();
  }

  void _resetPosition() {
    _animation = Tween<Offset>(begin: _offset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        _offset = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                widget.hikaye['image'],
                height: 300,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.hikaye['metin'],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.hikaye['secenekler'].isNotEmpty
                              ? widget.hikaye['secenekler'][0]
                              : '',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.hikaye['secenekler'].isNotEmpty
                              ? widget.hikaye['secenekler'][1]
                              : '',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
