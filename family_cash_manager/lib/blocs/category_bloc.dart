import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Category Event
class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCategories extends CategoryEvent {}

class AddCategories extends CategoryEvent {
  final String name;
  AddCategories({required this.name});

  @override
  List<Object> get props => [name];
}

class DeleteCategories extends CategoryEvent {
  final String id;
  DeleteCategories({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateCategories extends CategoryEvent {
  final String id;
  final String newName;
  UpdateCategories({required this.id, required this.newName});

  @override
  List<Object> get props => [id, newName];
}

// Category State
class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Map> categories;
  CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

// Category Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final String baseUrl = 'http://localhost:3000/category';

  CategoryBloc() : super(CategoryInitial()) {
    on<GetCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await http.get(Uri.parse(baseUrl));
        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          List<Map> categories = data.map<Map>((category) {
            return {'id': category['id'].toString(), category['id'].toString(): category['name']};
          }).toList();
          emit(CategoryLoaded(categories: categories));
        } else {
          emit(CategoryLoaded(categories: []));
        }
      } catch (e) {
        emit(CategoryError(message: e.toString()));
      }
    });

    on<AddCategories>((event, emit) async {
      try {
        final response = await http.post(
          Uri.parse(baseUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': event.name}),
        );
        if (response.statusCode == 201) {
          add(GetCategories());
        } else {
          emit(CategoryError(message: 'Failed to add category'));
        }
      } catch (e) {
        emit(CategoryError(message: 'Failed to add category'));
      }
    });

    on<DeleteCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await http.delete(Uri.parse('$baseUrl/${event.id}'));
        if (response.statusCode == 200) {
          add(GetCategories());
        } else {
          emit(CategoryError(message: 'Failed to delete category'));
        }
      } catch (e) {
        emit(CategoryError(message: 'Failed to delete category'));
      }
    });

    on<UpdateCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/${event.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'name': event.newName}),
        );
        if (response.statusCode == 200) {
          add(GetCategories());
        } else {
          emit(CategoryError(message: 'Failed to update category'));
        }
      } catch (e) {
        emit(CategoryError(message: 'Failed to update category'));
      }
    });
  }
}
