import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Episode extends Equatable {
  final UniqueKey id = UniqueKey();
  final String title;
  final String description;
  final String audioUrl;

  Episode({
    @required this.title,
    @required this.description,
    @required this.audioUrl,
  });

  @override
  List<Object> get props => [title, description, audioUrl];

  @override
  bool get stringify => true;
}
