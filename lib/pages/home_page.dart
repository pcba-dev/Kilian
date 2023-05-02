import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/calculator.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../view-models/trail.dart';
import '../widgets/form_fields.dart';
import '../widgets/painting.dart';
import '../widgets/theme.dart';
import '../widgets/trail.dart';
import '../widgets/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Trail _trail = const Trail([]);

  TrailCalculator calculator = const StandardTrailCalculator();

  @override
  void initState() {
    super.initState();
    _trail = const Trail([]);
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
              onEditSegment: _onEditSegmentPressed,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton(
          onPressed: _onFloatingButtonPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _onFloatingButtonPressed() async {
    final TrailSegment? segment = await showDialog<TrailSegment?>(
      context: context,
      builder: (_) {
        return const TrailSegmentDialog();
      },
    );

    if (segment != null) {
      setState(() {
        final List<TrailSegment> segments = new List.from(_trail.segments)..add(segment);
        _trail = new Trail(segments);
      });
    }
  }

  Future<void> _onEditSegmentPressed(final TrailSegment segment, final int index) async {
    final TrailSegment? newSegment = await showDialog<TrailSegment?>(
      context: context,
      builder: (_) {
        return new TrailSegmentDialog(initial: segment);
      },
    );

    if (newSegment != null) {
      setState(() {
        final List<TrailSegment> segments = new List.from(_trail.segments)
          ..removeAt(index)
          ..insert(index, newSegment);
        _trail = new Trail(segments);
      });
    }
  }
}

class _UserTrailView extends StatelessWidget {
  const _UserTrailView(this.userTrail, {required this.onFitnessChanged, required this.onEditSegment, super.key});

  final UserTrail<TrailViewModel> userTrail;

  final ValueChanged<FitnessLevel?> onFitnessChanged;

  final void Function(TrailSegment, int) onEditSegment;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (_, constraints) {
      return new SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new TrailSummary(userTrail.trail),
              kSpacingVerticalDouble,
              new Align(
                alignment: Alignment.centerRight,
                child: new FitnessSelector(
                  value: userTrail.params.fitness,
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
                  children: userTrail.trail.segments
                      .map((s) => new TrailSegmentTile(
                            s,
                            onPressed: () => onEditSegment(s, userTrail.trail.segments.indexOf(s)),
                          ))
                      .toList(),
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

class TrailSegmentDialog extends StatefulWidget {
  const TrailSegmentDialog({super.key, this.initial});

  final TrailSegment? initial;

  @override
  State<TrailSegmentDialog> createState() => _TrailSegmentDialogState();
}

class _TrailSegmentDialogState extends State<TrailSegmentDialog> {
  late final bool _editMode = widget.initial != null;

  /// Elevation gain.
  double? dalt;

  /// Horizontal distance.
  double? hdist;

  /// M.I.D. level
  MIDLevel? mid = MIDLevel.moderate;

  /// Element key for the form state.
  final GlobalKey<FormState> formKey = new GlobalKey();

  static const OutlineInputBorder _kInputBorder = const OutlineInputBorder();

  @override
  void initState() {
    super.initState();
    hdist = widget.initial?.hdist;
    dalt = widget.initial?.dalt;
    mid = widget.initial?.mid;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: kMarginAllDouble,
      title: new Text(_editMode ? "Editar tramo" : "Crear tramo", textAlign: TextAlign.center),
      children: [
        new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              new Row(
                children: [
                  new Expanded(
                    child: new NumberFormField.int(
                      signed: false,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        // TODO: Locale
                        labelText: "Distancia horizontal",
                        hintText: "Distancia",
                        border: _kInputBorder,
                        suffixText: "m",
                      ),
                      initialValue: widget.initial?.hdist.toInt(),
                      precision: 5,
                      onChanged: (val) => hdist = double.tryParse(val) ?? 0,
                    ),
                  ),
                  kSpacingHorizontalDouble,
                  new Expanded(
                    child: new NumberFormField.int(
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        // TODO: Locale
                        labelText: "Desnivel",
                        hintText: "d+ / d-",
                        border: _kInputBorder,
                        suffixText: "m",
                      ),
                      initialValue: widget.initial?.dalt.toInt(),
                      precision: 5,
                      onChanged: (val) => dalt = double.tryParse(val) ?? 0,
                    ),
                  ),
                ],
              ),
              kSpacingVerticalDouble,
              new MIDSelector(
                value: mid,
                onChanged: (val) {
                  setState(() => mid = val);
                },
              ),
            ],
          ),
        ),
        kSpacingVertical,
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new IconButton(
              onPressed: () {
                // Pop the dialog.
                Navigator.of(context).pop(null);
              },
              color: Colors.grey,
              icon: const Icon(Icons.arrow_back, size: 30),
            ),
            new IconButton(
              onPressed: () {
                final bool valid = formKey.currentState!.validate();
                if (valid) {
                  if (hdist != null && dalt != null && mid != null) {
                    // Pop the dialog providing a new [TrailSegment].
                    Navigator.of(context).pop(new TrailSegment(hdist!, dalt!, mid!));
                  }
                }
              },
              color: Colors.blueAccent,
              icon: const Icon(Icons.save, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
