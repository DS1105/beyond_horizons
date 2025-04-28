// lib/widgets/flughafen_card.dart
import 'package:flutter/material.dart';
import '../models/flughafen.dart';

class FlughafenCard extends StatelessWidget {
  final Flughafen flughafen;

  FlughafenCard({required this.flughafen});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(flughafen.name),
        subtitle: Text('${flughafen.city}, ${flughafen.land}'),
      ),
    );
  }
}
