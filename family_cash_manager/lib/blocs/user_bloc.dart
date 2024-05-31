// user_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class UserSignUp extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  UserSignUp(
      {required this.name,
      required this.email,
      required this.password,
      required this.role});

  @override
  List<Object> get props => [name, email, password, role];
}

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class User extends Equatable {
  final int userId;
  final String email;
  String role;

  User({required this.email, required this.userId, required this.role});

  @override
  List<Object> get props => [email, role];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAuthenticated extends UserState {
  final User user;

  UserAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String error;

  UserError({required this.error});

  @override
  List<Object> get props => [error];
}


// user_bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final String baseUrl = 'http://localhost:3000/auth';

  UserBloc() : super(UserInitial()) {
    on<UserLogin>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': event.email, 'password': event.password}),
        );

        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          emit(UserAuthenticated(
              user: User(
            userId: data['userId'],
            email: data['email'],
            role: data['role'],
          )));
        } else {
          emit(UserError(error: 'Login failed'));
        }
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });

    on<UserSignUp>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': event.email,
            'password': event.password,
            'role': event.role,
          }),
        );
        try {
          final response = await http.post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body:
                jsonEncode({'email': event.email, 'password': event.password}),
          );

          final data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            emit(UserAuthenticated(
                user: User(
              userId: data["userId"],
              email: data['email'],
              role: data['role'],
            )));
          } else {
            emit(UserError(error: 'Login failed'));
          }
        } catch (e) {
          emit(UserError(error: e.toString()));
        }
      } catch (e) {
        emit(UserError(error: e.toString()));
      }
    });


  }
}
