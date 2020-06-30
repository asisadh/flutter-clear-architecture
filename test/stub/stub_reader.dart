import 'dart:io';

String stub(String name) => File('test/stub/$name').readAsStringSync();
