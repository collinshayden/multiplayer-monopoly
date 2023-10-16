import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
import 'util/json_utils.dart';

part 'board_config_state.dart';

class BoardConfigCubit extends Cubit<BoardConfigState> {
  BoardConfigCubit() : super(BoardConfigInitial());
}
