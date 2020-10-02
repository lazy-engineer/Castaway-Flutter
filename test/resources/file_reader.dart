import 'dart:io';

String read(String name) => File('test/resources/$name').readAsStringSync();
