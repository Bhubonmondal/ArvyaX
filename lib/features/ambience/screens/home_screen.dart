import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ambience_provider.dart';
import '../../player/providers/session_provider.dart';
import '../../../data/models/ambience.dart';
import '../../player/widgets/mini_player.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(searchProvider),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final imagesToPrecache = [
      'forest.webp',
      'ocean.webp',
      'evening.webp',
      'sleep.webp',
      'cafe.webp',
      'morning.webp',
    ];
    for (final img in imagesToPrecache) {
      precacheImage(AssetImage('assets/images/$img'), context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getImagePath(String title) {
    final t = title.toLowerCase();
    if (t.contains('forest')) return 'assets/images/forest.webp';
    if (t.contains('ocean')) return 'assets/images/ocean.webp';
    if (t.contains('evening')) return 'assets/images/evening.webp';
    if (t.contains('sleep')) return 'assets/images/sleep.webp';
    if (t.contains('cafe')) return 'assets/images/cafe.webp';
    if (t.contains('morning')) return 'assets/images/morning.webp';
    return 'assets/images/forest.webp';
  }

  @override
  Widget build(BuildContext context) {
    final ambiencesAsync = ref.watch(ambiencesProvider);
    final filteredAmbiences = ref.watch(filteredAmbiencesProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final session = ref.watch(sessionProvider);
    final tags = ['Focus', 'Calm', 'Sleep', 'Reset'];

    final String bgImagePath = session.ambience != null
        ? _getImagePath(session.ambience!.title)
        : 'assets/images/forest.webp';

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: const MiniPlayer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Image.asset(
                bgImagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    const Color(0xFF050505),
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: false,
                  expandedHeight: 80,
                  flexibleSpace: const FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, bottom: 12),
                    title: Text(
                      'ArvyaX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 8),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => context.push('/history'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.history_rounded, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                ref.read(searchProvider.notifier).updateQuery(val),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Search ambiences...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 22,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 40),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.none,
                          child: Row(
                            children: tags.map((tag) {
                              final isSelected = selectedTag == tag;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(selectedTagProvider.notifier).toggle(tag);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        color: isSelected ? Colors.black : Colors.white70,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                if (ambiencesAsync.isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => const _SkeletonCard(),
                        childCount: 4,
                      ),
                    ),
                  )
                else if (filteredAmbiences.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 12),
                          Text(
                            'No ambiences found',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final amb = filteredAmbiences[index];
                        return _AmbienceCard(ambience: amb);
                      }, childCount: filteredAmbiences.length),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 0.8).animate(_controller),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.02)),
        ),
      ),
    );
  }
}

class _AmbienceCard extends StatelessWidget {
  final Ambience ambience;

  const _AmbienceCard({required this.ambience});

  String _getImagePath(String title) {
    final t = title.toLowerCase();
    if (t.contains('forest')) return 'assets/images/forest.webp';
    if (t.contains('ocean')) return 'assets/images/ocean.webp';
    if (t.contains('evening')) return 'assets/images/evening.webp';
    if (t.contains('sleep')) return 'assets/images/sleep.webp';
    if (t.contains('cafe')) return 'assets/images/cafe.webp';
    if (t.contains('morning')) return 'assets/images/morning.webp';
    return 'assets/images/forest.webp';
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          context.push('/details', extra: ambience);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF121215),
          ),
          child: Hero(
            tag: 'hero-image-${ambience.id}',
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _getImagePath(ambience.title),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF050505),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ambience.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ambience.tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(ambience.durationSeconds / 60).floor()} min',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
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
        ),
      ),
    );
  }
}