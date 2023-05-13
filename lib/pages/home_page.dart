import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kilian/pages/settings_page.dart';
import 'package:kilian/states/app_state.dart';

import '../l10n/l10n.dart';
import '../models/trail.dart';
import '../models/user.dart';
import '../states/trail_action.dart';
import '../view-models/trail.dart';
import '../widgets/form_fields.dart';
import '../widgets/painting.dart';
import '../widgets/theme.dart';
import '../widgets/trail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          leading: _buildSettingButton(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: new Center(
          child: new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMinWidthTablet),
            child: new StoreBuilder<AppState>(builder: (_, store) {
              return new _UserTrailView(
                trail: store.state.trail,
                params: store.state.parameters,
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

  Widget _buildSettingButton(final BuildContext context) {
    return new IconButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) => const SettingsDialog(),
        );
      },
      icon: const Icon(Icons.settings, color: Colors.blueGrey),
    );
  }

  void _onFloatingButtonPressed(final BuildContext context) {
    showDialog<void>(
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

  void _onEditSegmentPressed(final BuildContext context, final TrailSegment segment, final int index) {
    showDialog<void>(
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
    required this.onEditSegment,
    required this.onReorder,
    super.key,
  });

  final UserParameters params;

  final TrailViewModel trail;

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
              kSpacingVertical,
              // Segments section title text.
              _buildSegmentsTitleText(context),
              const TrailSegmentTilesHeader(),
              _buildDivider(),
              // Segments section.
              new Expanded(
                child: new ListView(
                  padding: const EdgeInsets.fromLTRB(
                      kMarginSize, 0, kMarginSize, 70),
                  children: _buildListItems(),
                ),
              )
            ],
          ));
    });
  }

  static Widget _buildSegmentsTitleText(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2 * kMarginSize, vertical: kMarginSize),
      child: new Text(
        context.l10n.stagesTitle,
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

  List<Widget> _buildListItems() {
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
        items.add(new DraggableTrailSegmentTile(
          segment: trail.segments[index],
          index: index,
          onPressed: () => onEditSegment(trail.segments[index], index),
        ));
      }
    }
    // Add a draggable target box at the end.
    if (trail.segments.length > 1) {
      items.add(_buildDragTarget(trail.segments.length));
    }

    return items;
  }

  Widget _buildDragTarget(final int idx) {
    return new DragTarget<int>(
      builder: (_, data, ___) {
        return new SizedBox(
          height: 12,
          width: double.infinity,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ColoredBox(
                color:
                    data.isNotEmpty ? AppColors.secondary : Colors.transparent),
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
  const TrailSegmentDialog({required this.onSavedPressed, this.onDeletePressed, this.initial, super.key});

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
      title: new Text(
        _editMode ? context.l10n.segmentEditDialogTitleEdit : context.l10n.segmentEditDialogTitleCreate,
        textAlign: TextAlign.center,
      ),
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
                        labelText: context.l10n.horizontalDistanceLabel,
                        hintText: context.l10n.horizontalDistanceHint,
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
                        labelText: context.l10n.daltitudeLabel,
                        hintText: context.l10n.daltitudeHint,
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
