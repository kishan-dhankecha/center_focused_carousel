import 'package:flutter/material.dart';

import 'carousel/carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Center Focused Carousel',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final itemCount = 5;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     for (var i = 0; i < itemCount; i++) {
  //       precacheImage(
  //         NetworkImage(
  //           "https://picsum.photos/200/300?random=$i",
  //         ),
  //         context,
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: Stack(
        children: [
          Center(
            child: SizedBox.square(
              dimension: MediaQuery.of(context).size.width,
              child: CenterFocusedCarousel(
                children: List<Widget>.generate(itemCount, (index) {
                  return SizedBox.expand(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        border: Border.all(
                          width: 5,
                          color: Colors.purple,
                        ),
                      ),
                      // child: Image.network(
                      //   "https://picsum.photos/200/300?random=$index",
                      //   fit: BoxFit.cover,
                      // ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Color(0xFF232323),
                            fontWeight: FontWeight.bold,
                            fontSize: 42,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
