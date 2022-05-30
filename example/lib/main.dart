import 'package:flutter/material.dart';
import 'package:macos_tree_view/macos_tree_view.dart';
import 'package:uuid/uuid.dart';

class Test {
  String name;
  List<Test> children;

  Test({required this.name, required this.children});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TabController();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const TabPage(),
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late TreeViewController<String> _treeViewController;
  late TabController _controller;
  late TextEditingController _textEditingController;

  List<Node<String>> nodes = [
    Node.fromLabel('Label A', key: const Key('a')),
    Node.fromLabel('Label B', key: const Key('b'), children: [
      Node.fromLabel('B1', key: const Key('b1'), children: [
        Node.fromLabel('B1.1', key: const Key('b1.1')),
        Node.fromLabel('B1.2', key: const Key('b1.2')),
        Node.fromLabel('B1.3', key: const Key('b1.3')),
      ]),
      Node.fromLabel('B2', key: const Key('b2')),
      Node.fromLabel('B3', key: const Key('b3')),
    ]),
    Node(
      key: const Key('c'),
      label: 'Label C (expandable)',
      expanded: false,
      data: '1',
      children: [
        Node.fromLabel('Label C.A', key: const Key('ca')),
        Node.fromLabel('Label C.B', key: const Key('cb')),
        Node(
          key: const Key('c.c'),
          label: 'Label C.C (expandable)',
          expanded: false,
          data: '1',
          children: [
            Node.fromLabel('Label C.C.A', key: const Key('c.c.a')),
            Node.fromLabel('Label C.C.B', key: const Key('c.c.b')),
            Node.fromLabel('Label C.C.C', key: const Key('c.c.c')),
            Node.fromLabel('Label C.C.D', key: const Key('c.c.d')),
            Node.fromLabel('Label C.C.E', key: const Key('c.c.e')),
          ],
        ),
      ],
    ),
    Node.fromLabel('Label D', key: const Key('d')),
    Node.fromLabel('Label E', key: const Key('e')),
    Node(
      label: 'Label Z',
      key: const Key('z'),
      children: [
        Node.fromLabel('Label Z.A', key: const Key('za')),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    final List<Node<String>> iRow = [];
    for (var i = 0; i < 100; i++) {
      var uuid1 = const Uuid();
      final List<Node<String>> jRow = [];
      for (var j = 0; j < 100; j++) {
        var uuid2 = const Uuid();
        jRow.add(Node.fromLabel('$uuid2'));
      }
      iRow.add(Node.fromLabel('$uuid1', children: jRow));
    }

    nodes.addAll(iRow);

    _textEditingController = TextEditingController(text: 'hello');
    _treeViewController = TreeViewController(
      selectedValues: {const Key('z')},
      children: nodes,
    );
    // _treeViewController.addListener(() {
    //   print('TreeView changed');
    //   // print(jsonEncode(_treeViewController.toJson()));
    // });
    _controller = TabController(vsync: this, length: 2);

    _delay();
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  Future<void> _delay() async {
    const duration = Duration(seconds: 2);

    await Future.delayed(duration);
    print('============= addNode `jk`! =================');
    _treeViewController.addNode(Node.fromLabel('Batman & Joker'));
    _treeViewController.addNode(
        Node.fromLabel('This is a very very long labelllllllllllllllllll!'));

    await Future.delayed(duration);
    print('============= addNode "z"! =================');
    _treeViewController.addNode(Node.fromLabel('Junkai'));
    // _treeViewController.addNode(Node.fromLabel('junkai clone'),
    // // //     mode: InsertMode.prepend);
    // // // print('append z node!');
    _treeViewController.addNode(
        Node.fromLabel('z clone', key: const Key('z.clone')),
        parent: const Key('z'));
    print('============= addNode "nested deep c"! =================');
    _treeViewController.addNode(
        Node.fromLabel('Nested Deep C', key: const Key('nested.deepc')),
        parent: const Key('c.c.c'));
    _treeViewController.addNode(
        Node.fromLabel('z clone (prepend)', key: const Key('z.clone.p')),
        parent: const Key('z'),
        mode: InsertMode.prepend);
    await Future.delayed(duration);
    print('============= remove node "b"! =================');
    _treeViewController.removeNode(const Key('b'));

    // await Future.delayed(duration);
    // print('============= remove node "d"! =================');
    // _treeViewController.removeNode(const Key('d'));

    // // await Future.delayed(duration);
    // // print('select z clone!!!');
    // // _treeViewController.selectNode(const Key('z.clone'),
    // //     ancestorExpanded: true);

    // // await Future.delayed(duration);
    // // print('select z clone!!!');
    // // _treeViewController.selectNode(const Key('c'), ancestorExpanded: true);

    // await Future.delayed(duration);
    // print('============= toggleNode "c"! =================');
    // // _treeViewController.selectNode(const Key('c.c.d'), ancestorExpanded: true);
    // _treeViewController.toggleNode(const Key('c'));
    // // // _treeViewController.removeNode(const Key('b'));
    // // await Future.delayed(duration);
    // // print('Expanded all!');
    // // _treeViewController.expandAll();

    // // await Future.delayed(duration);
    // // print('Collapse all!');
    // // _treeViewController.collapseAll();

    // // print('Collapse all!');
    // // await Future.delayed(duration);
    // // _treeViewController.collapseAll();

    // await Future.delayed(duration);
    // print('============ Reset selection! ===============');
    // _treeViewController.resetSelection();

    // await Future.delayed(duration);
    // _treeViewController.expandAll(key: Key('d'));
  }

  @override
  void dispose() {
    _treeViewController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleRightClick(_, details) {
    print('onNodeSecondaryTapUp!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Tab'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(icon: Icon(Icons.laptop_mac)),
            Tab(icon: Icon(Icons.desktop_mac)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: TreeView<String>(
                  controller: _treeViewController,
                  // nodeBuilder: (context, node) {
                  //   return Text(
                  //       '${node.label} ${node.parent != null ? '${node.parent!.key}' : ''}');
                  // },
                  onNodeTap: (key) {
                    // print('onTap 1 => $key');
                    // print(jsonEncode(_treeViewController.children));
                    // _treeViewController.findNode(key);
                  },
                  onNodeSecondaryTapUp: _handleRightClick,
                ),
              )),
              // Expanded(
              //     child: Container(
              //   decoration: BoxDecoration(color: Colors.red),
              //   child: TreeView<String>(
              //     controller: _treeViewController,
              //     onNodeTap: (key) {
              //       print('onTap => $key');
              //       print(jsonEncode(_treeViewController.children));
              //       // _treeViewController.findNode(key);
              //     },
              //     onNodeSecondaryTapUp: _handleRightClick,
              //   ),
              // )),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(color: Colors.green),
                child: TreeView<String>(
                  controller: _treeViewController,
                  onNodeSecondaryTapUp: _handleRightClick,
                ),
              )),
            ],
          ),
          Center(
            child: Column(children: [
              TextField(controller: _textEditingController),
              const Text('desktop'),
              // GoogleMap(
              //     mapType: MapType.hybrid,
              //     initialCameraPosition: _kGooglePlex,
              //     onMapCreated: (GoogleMapController controller) {
              //       // _controller.complete(controller);
              //     }),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_treeViewController.selectionMode == SelectionMode.single) {
            _treeViewController.selectionMode = SelectionMode.multiple;
          } else {
            _treeViewController.selectionMode = SelectionMode.single;
          }
        },
        child: Text('Toggle mode (${_treeViewController.selectionMode})'),
      ),
    );
  }
}
