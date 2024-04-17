import 'package:flutter/material.dart';
import 'package:shimmer_exampl/example/shimmer/shimmer_loader.dart';
import 'package:shimmer_exampl/example/state/shimmer_example_state.dart';

class ShimmerExampleScreen extends StatefulWidget {
  const ShimmerExampleScreen({super.key});

  @override
  State<ShimmerExampleScreen> createState() => _ShimmerExampleScreenState();
}

class _ShimmerExampleScreenState extends State<ShimmerExampleScreen> {
  late final StateController _state;

  @override
  void initState() {
    super.initState();

    _state = StateController();

    _state.initFakeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          children: [
            Shimmer(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 91, 91, 94),
                  Color.fromARGB(255, 145, 145, 145),
                  Color.fromARGB(255, 61, 61, 62),
                ],
                stops: [
                  0.1,
                  0.3,
                  0.4,
                ],
                begin: Alignment(-3.0, -0.5),
                end: Alignment(2.0, 0.3),
                tileMode: TileMode.clamp,
              ),
              child: StreamBuilder(
                stream: _state.currentState,
                builder: (context, state) {
                  if (state.data == null) {
                    return const SizedBox.shrink();
                  }

                  return state.data!.map<Widget>(
                    loading: (state) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return const ShimmerLoader(
                                  isLoading: true,
                                  child: CircleAvatar(
                                    backgroundColor: Color.fromRGBO(158, 158, 158, 1),
                                    radius: 35,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...List.generate(
                            4,
                            (index) {
                              return Column(
                                children: [
                                  ShimmerLoader(
                                    isLoading: true,
                                    child: Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: const ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                    success: (state) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 35,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  child: Image.asset(
                                    'assets/cats.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...List.generate(
                            4,
                            (index) {
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      child: Image.asset(
                                        'assets/image_$index.png',
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
