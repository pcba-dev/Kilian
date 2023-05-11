import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kilian/states/app_state.dart';

import '../models/trail.dart';
import '../models/user.dart';
import '../states/trail_action.dart';
import '../states/user_parameters_action.dart';
import '../view-models/trail.dart';
import '../widgets/form_fields.dart';
import '../widgets/painting.dart';
import '../widgets/theme.dart';
import '../widgets/trail.dart';
import '../widgets/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        body: new Center(
          child: new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMinWidthTablet),
            child: new StoreBuilder<AppState>(builder: (_, store) {
              return new _UserTrailView(
                trail: store.state.trail,
                params: store.state.parameters,
                onFitnessChanged: _onChangeFitness,
                onEditSegment: (s, i) => _onEditSegmentPressed(context, s, i),
                onReorder: _onReorderSegment,
              );
            }),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton(
          onPressed: () => _onFloatingButtonPressed(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onChangeFitness(final FitnessLevel? fitness) {
    if (fitness != null) {
      AppStore.instance.dispatch(new ChangeFitnessAction(fitness));
    }
  }

  Future<void> _onFloatingButtonPressed(final BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return new TrailSegmentDialog(
          onSavedPressed: (newSegment) {
            AppStore.instance.dispatch(new AddSegmentAction(newSegment));
          },
        );
      },
    );
  }

  Future<void> _onEditSegmentPressed(final BuildContext context, final TrailSegment segment, final int index) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return new TrailSegmentDialog(
          initial: segment,
          onSavedPressed: (newSegment) {
            AppStore.instance.dispatch(new ReplaceSegmentAction(index, newSegment));
          },
          onDeletePressed: () {
            AppStore.instance.dispatch(new RemoveSegmentAction(index));
          },
        );
      },
    );
  }

  void _onReorderSegment(final int oldPos, final int newPos) {
    if (newPos != oldPos && newPos != oldPos + 1) {
      AppStore.instance.dispatch(new ReorderSegmentAction(oldPos, newPos));
    }
  }
}

class _UserTrailView extends StatelessWidget {
  const _UserTrailView({
    required this.trail,
    required this.params,
    required this.onFitnessChanged,
    required this.onEditSegment,
    required this.onReorder,
    super.key,
  });

  final UserParameters params;

  final TrailViewModel trail;

  final ValueChanged<FitnessLevel?> onFitnessChanged;

  final void Function(TrailSegment, int) onEditSegment;

  /// Called to move a trail segment from one position to another position in the list.
  final void Function(int oldPos, int newPos) onReorder;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (_, constraints) {
      return new SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new TrailSummary(trail),
              kSpacingVerticalDouble,
              new Align(
                alignment: Alignment.centerRight,
                child: new FitnessSelector(
                  value: params.fitness,
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
                  padding: const EdgeInsets.fromLTRB(kMarginSize, 0, kMarginSize, 70),
                  children: _buildListItems(width: constraints.maxWidth - 2 * kMarginSize),
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

  List<Widget> _buildListItems({required final double width}) {
    final List<Widget> items = [];

    // Add a draggable target box at the end.
    if (trail.segments.length > 1) {
      items.add(_buildDragTarget(0));
    } else {
      items.add(const SizedBox(height: 20)); // Spacing.
    }

    for (int i = 0; i < trail.segments.length * 2 - 1; ++i) {
      final int index = (i / 2).floor();
      if (i.isOdd) {
        // Add the draggable target box.
        items.add(_buildDragTarget(index + 1));
      } else {
        // Add the draggable segment tile.
        items.add(_buildDraggable(trail.segments[index], index, width: width));
      }
    }
    // Add a draggable target box at the end.
    if (trail.segments.length > 1) {
      items.add(_buildDragTarget(trail.segments.length));
    }

    return items;
  }

  Widget _buildDraggable(final TrailSegmentViewModel segment, final int index, {required final double width}) {
    final Widget child = new TrailSegmentTile(
      segment,
      onPressed: () => onEditSegment(segment, index),
    );

    return new Draggable(
      // Link the underlying element and the widget with a unique ID.
      key: new ValueKey(child.hashCode),
      childWhenDragging: new Opacity(opacity: 0.50, child: child),
      maxSimultaneousDrags: 1,
      feedback: new SizedBox(width: width, child: child),
      data: index,
      child: child,
    );
  }

  Widget _buildDragTarget(final int idx) {
    return new DragTarget<int>(
      builder: (_, data, ___) {
        return new SizedBox(
          height: 20,
          width: double.infinity,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ColoredBox(color: data.isNotEmpty ? AppColors.secondary : Colors.transparent),
          ),
        );
      },
      onAccept: (oldPos) {
        onReorder(oldPos, idx);
      },
    );
  }
}

class TrailSegmentDialog extends StatefulWidget {
  const TrailSegmentDialog({required this.onSavedPressed, this.onDeletePressed, this.initial, super.key})
      : assert(initial == null || (initial != null && onDeletePressed != null));

  final TrailSegment? initial;

  final ValueSetter<TrailSegment> onSavedPressed;
  final VoidCallback? onDeletePressed;

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
    mid = widget.initial?.mid ?? MIDLevel.moderate;
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
                      precision: 4,
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
                      precision: 3,
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
            if (widget.onDeletePressed != null)
              new IconButton(
                onPressed: () {
                  widget.onDeletePressed!();
                  Navigator.of(context).pop();
                },
                color: Colors.red.shade300,
                icon: const Icon(Icons.delete_forever, size: 30),
              )
            else
              const SizedBox(),
            new IconButton(
              onPressed: () {
                final bool valid = formKey.currentState!.validate();
                if (valid) {
                  if (hdist != null && dalt != null && mid != null) {
                    // Pop the dialog providing a new [TrailSegment].
                    widget.onSavedPressed(new TrailSegment(hdist!, dalt!, mid!));
                    Navigator.of(context).pop();
                  }
                }
              },
              color: Colors.blueAccent.shade100,
              icon: const Icon(Icons.save, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
