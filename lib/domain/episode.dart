import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Episode extends Equatable {
  final String title;
  final String description;

  Episode({
    @required this.title,
    @required this.description,
  });

  @override
  List<Object> get props => [title, description];
}
