import 'package:flutter/material.dart';
import 'package:kilian/widgets/painting.dart';
import 'package:kilian/widgets/theme.dart';

import './model_extensions.dart';
import '../models/trail.dart';
import '../view-models/trail.dart';

const Widget _kSpacingHorizontalIcon = const SizedBox(width: 3);
const Widget _kSpacingBetweenRow = const SizedBox(width: 5);

const Widget _kVerticalSpacing = const SizedBox(height: 5);

class TrailSummary extends StatefulWidget {
  const TrailSummary(this.trail, {this.action, super.key});

  final Trail trail;

  final Widget? action;

  @override
  State<TrailSummary> createState() => new _TrailSummaryState();
}

class _TrailSummaryState extends State<TrailSummary> {
  bool expanded = true;

  @override
  void initState() {
    super.initState();
    expanded = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: const EdgeInsets.symmetric(horizontal: 1.5 * kMarginSize, vertical: kMarginSize),
      shape: kRoundedBorder,
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      child: new Column(
        children: [
          _buildTitleText(),
          if (expanded)
            new Padding(
              padding: const EdgeInsets.fromLTRB(2 * kMarginSize, kMarginSize, 2 * kMarginSize, 2 * kMarginSize),
              child: new Row(
                children: [
                  new Expanded(child: _buildHdistWidget()),
                  _kSpacingBetweenRow,
                  new Expanded(child: _buildDaltWidget()),
                  _kSpacingBetweenRow,
                  new Expanded(child: _buildDurationWidget()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return new Row(
      children: [
        new SizedBox(width: kMinInteractiveDimension),
        new Expanded(
          child: new Text(
            // TODO: Locale
            "Resumen",
            style: const TextStyle(fontSize: 22, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
        ),
        new IconButton(
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
            icon: Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
      ],
    );
  }

  Widget _buildHdistWidget() {
    final double distance = widget.trail.distance;
    final double hdist = widget.trail.hdist;
    final String strDist =
        distance > 1000 ? '${(distance / 1000).toStringAsFixed(2)} km' : '${distance.toStringAsFixed(0)} m';
    final String strHdist = hdist > 1000 ? '${(hdist / 1000).toStringAsFixed(2)} km' : '${hdist.toStringAsFixed(0)} m';

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.arrow_outward, color: Colors.brown, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              strDist,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const SizedBox(height: 8),
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.start, color: Colors.blueGrey, size: 20),
            _kSpacingHorizontalIcon,
            new Text(
              strHdist,
              style: const TextStyle(fontSize: 20, color: Colors.black38),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaltWidget() {
    final double dplus = widget.trail.dplus;
    final double dminus = widget.trail.dminus.abs();
    final String strDplus = '${dplus < 0.1 ? "0" : "+${dplus.toStringAsFixed(0)}"} m';
    final String strDminus = '${dminus < 0.1 ? "0" : "-${dminus.toStringAsFixed(0)}"} m';

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.arrow_upward, color: Colors.cyan, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              strDplus,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const SizedBox(height: 8),
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.arrow_downward, color: Colors.cyan, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              strDminus,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationWidget() {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.hiking, color: Colors.black, size: 26),
            _kSpacingHorizontalIcon,
            new Text(
              // TODO
              new Duration(hours: 2, minutes: 26).toHumanString(),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const SizedBox(height: 8),
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.pause_circle, color: Colors.blueGrey, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              // TODO
              new Duration(hours: 0, minutes: 10).toHumanString(),
              style: const TextStyle(fontSize: 20, color: Colors.black38),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ],
    );
  }
}

class TrailSegmentTile extends StatelessWidget {
  const TrailSegmentTile(this.segment, {super.key});

  final TrailSegmentViewModel segment;

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: kMarginAll,
      shape: kRoundedBorder,
      clipBehavior: Clip.hardEdge,
      child: new SizedBox(
        height: 70,
        child: new Row(
          children: [
            _buildIndexIcon(),
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.all(10),
                child: new Row(
                  children: [
                    new Expanded(child: _buildHdistWidget()),
                    _kSpacingBetweenRow,
                    new Expanded(child: _buildDaltWidget()),
                    _kSpacingBetweenRow,
                    _buildMIDLevelWidget(),
                    _kSpacingBetweenRow,
                    new Expanded(child: _buildDurationWidget()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexIcon() {
    return new ColoredBox(
      color: AppColors.secondary,
      child: new Center(
        child: new Padding(
          padding: const EdgeInsets.all(10),
          child: new Text(
            segment.index.toString(),
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildHdistWidget() {
    // TODO
    final String strDist = segment.distance > 1000
        ? '${(segment.distance / 1000).toStringAsFixed(2)} km'
        : '${segment.distance.toStringAsFixed(0)} m';
    final String strHdist = segment.hdist > 1000
        ? '${(segment.hdist / 1000).toStringAsFixed(2)} km'
        : '${segment.hdist.toStringAsFixed(0)} m';

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.arrow_outward, color: Colors.brown, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              strDist,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        _kVerticalSpacing,
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Icon(Icons.start, color: Colors.blueGrey, size: 22),
            _kSpacingHorizontalIcon,
            new Text(
              strHdist,
              style: const TextStyle(fontSize: 16, color: Colors.black38),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaltWidget() {
    final String str =
        '${segment.dalt.abs() < 0.1 ? "" : segment.dalt > 0 ? "+" : "-"}${segment.dalt.abs().toStringAsFixed(0)} m';
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (segment.dalt.abs() > 0.1)
          new Icon(segment.dalt > 0 ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.cyan, size: 24),
        _kSpacingHorizontalIcon,
        new Text(
          str,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildMIDLevelWidget() {
    return SizedBox(
      width: 30,
      child: new Center(
        child: new DecoratedBox(
          decoration: new BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.5)),
              border: Border.all(color: segment.mid.color)),
          child: new SizedBox.square(
            dimension: 25,
            child: new Center(
              child: new Text(
                segment.mid.toNumber().toString(),
                style: new TextStyle(fontSize: 16, color: segment.mid.color, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationWidget() {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Text(
          segment.duration.toHumanString(),
          style: const TextStyle(fontSize: 20),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
        _kVerticalSpacing,
        new Text(
          segment.cumulative.toHumanString(),
          style: const TextStyle(fontSize: 16, color: Colors.black38),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class TrailSegmentTilesHeader extends StatelessWidget {
  const TrailSegmentTilesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kMarginAll,
      child: new Row(
        children: [
          _buildIndexIcon(),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: new Row(
                children: [
                  new Expanded(child: _buildHdistWidget()),
                  _kSpacingBetweenRow,
                  new Expanded(child: _buildDaltWidget()),
                  _kSpacingBetweenRow,
                  _buildMIDLevelWidget(),
                  _kSpacingBetweenRow,
                  new Expanded(child: _buildDurationWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexIcon() {
    return new Center(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Text(
          "#",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildHdistWidget() {
    return new Text(
      // TODO: Locale
      "Distancia",
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  Widget _buildDaltWidget() {
    return new Text(
      // TODO: Locale
      "d+ / d-",
      style: const TextStyle(fontSize: 16, color: Colors.black54),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMIDLevelWidget() {
    return SizedBox(
      width: 30,
      child: new Center(
        child: new Text(
          "M.I.D.",
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDurationWidget() {
    return new Text(
      // TODO: Locale
      "Tiempo",
      style: const TextStyle(fontSize: 16, color: Colors.black54),
      textAlign: TextAlign.end,
    );
  }
}
