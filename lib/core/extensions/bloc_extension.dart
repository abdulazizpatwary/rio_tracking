import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocExtension on BuildContext{
  T bloc<T extends BlocBase>(){
    return read<T>();
  }
}