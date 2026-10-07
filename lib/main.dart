import 'package:flutter/material.dart';

void main() => runApp(SadaApp());

class SadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SADA',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final contacts = ['أحمد', 'محمد', 'سارة', 'نور', 'علي'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SADA - صدى'), centerTitle: true),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(child: Text(contacts[i][0])),
            title: Text(contacts[i]),
            subtitle: Text('متاح الآن'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: Icon(Icons.call, color: Colors.green),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: contacts[i], isVideo: false))),
              ),
              IconButton(
                icon: Icon(Icons.videocam, color: Colors.blue),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: contacts[i], isVideo: true))),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String name;
  final bool isVideo;
  CallScreen({required this.name, required this.isVideo});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool muted = false;
  bool speaker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(children: [
        SizedBox(height: 80),
        if (widget.isVideo)
          Expanded(child: Center(child: Icon(Icons.person, size: 120, color: Colors.white30)))
        else
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(radius: 60, child: Text(widget.name[0], style: TextStyle(fontSize: 40))),
              SizedBox(height: 20),
              Text(widget.name, style: TextStyle(color: Colors.white, fontSize: 28)),
              Text('جاري الاتصال...', style: TextStyle(color: Colors.white54)),
            ]),
          ),
        Padding(
          padding: EdgeInsets.all(30),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatar(backgroundColor: muted? Colors.white : Colors.white24, radius: 28, child: IconButton(icon: Icon(Icons.mic_off, color: muted? Colors.black : Colors.white), onPressed: () => setState(() => muted =!muted))),
            CircleAvatar(backgroundColor: Colors.red, radius: 28, child: IconButton(icon: Icon(Icons.call_end, color: Colors.white), onPressed: () => Navigator.pop(context))),
            CircleAvatar(backgroundColor: speaker? Colors.white : Colors.white24, radius: 28, child: IconButton(icon: Icon(Icons.volume_up, color: speaker? Colors.black : Colors.white), onPressed: () => setState(() => speaker =!speaker))),
          ]),
        ),
      ]),
    );
  }
}
