import 'package:flutter/material.dart';
import 'package:kilian/widgets/painting.dart';

import '../models/calculator.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../view-models/trail.dart';
import '../widgets/trail.dart';
import '../widgets/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Trail _trail;

  TrailCalculator calculator = const StandardTrailCalculator();

  @override
  void initState() {
    super.initState();
    _trail = const Trail([
      const TrailSegment(1250, 300, MIDLevel.moderate),
      const TrailSegment(550, -200, MIDLevel.moderate),
      const TrailSegment(800, -100, MIDLevel.moderate),
      const TrailSegment(1250, 200, MIDLevel.moderate),
      const TrailSegment(1300, -150, MIDLevel.moderate),
      const TrailSegment(670, 100, MIDLevel.moderate),
      const TrailSegment(2400, 0, MIDLevel.moderate),
    ]);
    calculator = const StandardTrailCalculator();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize total duration.
    Duration totalDuration = Duration.zero;
    Duration totalResting = Duration.zero;

    final List<TrailSegmentViewModel> segments = [];
    for (int i = 0; i < _trail.segments.length; ++i) {
      final Duration duration = calculator.computeDuration(_trail.segments[i]);
      final Duration resting = calculator.computeResting(_trail.segments[i]);
      totalDuration += duration;
      totalResting += resting;
      segments.add(new TrailSegmentViewModel(
        _trail.segments[i].hdist,
        _trail.segments[i].dalt,
        _trail.segments[i].mid,
        index: i,
        duration: duration,
        resting: resting,
      ));
    }

    // TODO
    final TrailViewModel trail = new TrailViewModel(
      segments,
      duration: totalDuration,
      resting: totalResting,
    );

    final UserTrail<TrailViewModel> userTrail = new UserTrail(trail: trail, params: new UserParameters());

    return new SafeArea(
      child: new Scaffold(
        appBar: AppBar(),
        body: new Center(
          child: new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: new _UserTrailView(
              userTrail,
              onFitnessChanged: (fitness) {
                if (fitness != null) {
                  setState(() {
                    calculator = new StandardTrailCalculator(fitness: fitness);
                  });
                }
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _UserTrailView extends StatelessWidget {
  const _UserTrailView(this.trail, {required this.onFitnessChanged, super.key});

  final UserTrail<TrailViewModel> trail;

  final ValueChanged<FitnessLevel?> onFitnessChanged;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (_, constraints) {
      return new SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new TrailSummary(trail.trail),
              kSpacingVerticalDouble,
              new Align(
                alignment: Alignment.centerRight,
                child: new FitnessSelector(
                  value: trail.params.fitness,
                  onChanged: onFitnessChanged,
                ),
              ),
              // Segments section title text.
              _buildSegmentsTitleText(),
              const TrailSegmentTilesHeader(),
              _buildDivider(),
              // Segments section.
              new Expanded(
                child: new ListView(
                  padding: const EdgeInsets.only(bottom: 70),
                  children: trail.trail.segments.map((s) => new TrailSegmentTile(s)).toList(),
                ),
              )
            ],
          ));
    });
  }

  static Widget _buildSegmentsTitleText() {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 2 * kMarginSize, vertical: kMarginSize),
      child: new Text(
        // TODO: Locale
        "Etapas",
        style: const TextStyle(fontSize: 22, color: Colors.blueGrey),
      ),
    );
  }

  static Widget _buildDivider() {
    return const Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.5 * kMarginSize),
      child: const DecoratedBox(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blueGrey, width: 0.5))),
        child: SizedBox(height: 2, width: double.infinity),
      ),
    );
  }
}
