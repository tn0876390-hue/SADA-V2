import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(SadaApp());

class SadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SADA',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { super.initState(); checkLogin(); }
  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    if (prefs.getString('name')!= null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('SADA - صدى', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  save() async {
    if(nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameCtrl.text);
    await prefs.setString('phone', phoneCtrl.text);
    await prefs.setString('email', emailCtrl.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل في SADA')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
          SizedBox(height: 15),
          TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()), keyboardType: TextInputType.phone),
          SizedBox(height: 15),
          TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'الايميل', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
          SizedBox(height: 30),
          ElevatedButton(onPressed: save, child: Text('دخول SADA', style: TextStyle(fontSize: 18)), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50))),
        ]),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final contacts = ['أحمد', 'محمد', 'سارة', 'نور', 'علي', 'فاطمة'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SADA - صدى'), actions: [IconButton(icon: Icon(Icons.logout), onPressed: () async {
        final p = await SharedPreferences.getInstance(); await p.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      })]),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) => ListTile(
          leading: CircleAvatar(child: Text(contacts[i][0])),
          title: Text(contacts[i]),
          subtitle: Text('متاح للمكالمات'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: Icon(Icons.call, color: Colors.green), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: contacts[i], isVideo: false)))),
            IconButton(icon: Icon(Icons.videocam, color: Colors.blue), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: contacts[i], isVideo: true)))),
          ]),
        ),
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String name; final bool isVideo;
  CallScreen({required this.name, required this.isVideo});
  @override
  _CallScreenState createState() => _CallScreenState();
}
class _CallScreenState extends State<CallScreen> {
  bool muted = false; bool speaker = false; bool frontCamera = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(children: [
        Column(children: [
          SizedBox(height: 60),
          if (widget.isVideo)
            Expanded(child: Stack(children: [
              Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(frontCamera? Icons.face : Icons.landscape, size: 100, color: Colors.white24),
                SizedBox(height:10),
                Text(frontCamera? 'الكاميرا الأمامية' : 'الكاميرا الخلفية', style: TextStyle(color: Colors.white54)),
                Text('(هنا حتظهر الكاميرا الحقيقية بعد ربط Agora)', style: TextStyle(color: Colors.white24, fontSize: 12)),
              ])),
              Positioned(top: 20, right: 20, child: Container(width: 100, height: 150, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white24)), child: Icon(Icons.person, color: Colors.white30))),
            ]))
          else
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(radius: 60, child: Text(widget.name[0], style: TextStyle(fontSize: 40))),
              SizedBox(height: 20),
              Text(widget.name, style: TextStyle(color: Colors.white, fontSize: 28)),
              Text('جاري الاتصال...', style: TextStyle(color: Colors.white54)),
            ])),
          Padding(padding: EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _btn(Icons.mic_off, muted, () => setState(() => muted =!muted)),
            if (widget.isVideo) _btn(Icons.cameraswitch,!frontCamera, () => setState(() => frontCamera =!frontCamera)),
            CircleAvatar(backgroundColor: Colors.red, radius: 30, child: IconButton(icon: Icon(Icons.call_end, color: Colors.white), onPressed: () => Navigator.pop(context))),
            _btn(Icons.volume_up, speaker, () => setState(() => speaker =!speaker)),
          ])),
        ]),
        Positioned(top: 40, left: 20, child: SafeArea(child: Text(widget.name, style: TextStyle(color: Colors.white, fontSize: 18)))),
      ]),
    );
  }
  Widget _btn(IconData icon, bool active, VoidCallback onTap) {
    return CircleAvatar(backgroundColor: active? Colors.white : Colors.white24, radius: 28, child: IconButton(icon: Icon(icon, color: active? Colors.black : Colors.white), onPressed: onTap));
  }
}
