import 'package:equatable/equatable.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FamilyMember extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllFamilyMembers extends FamilyMember {}

class FamilyMembersState extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateRole extends FamilyMember {
  final int id;
  final String role;

  UpdateRole({required this.id, required this.role});

  @override
  List<Object> get props => [id, role];
}

class FamilyMembersInitial extends FamilyMembersState {}

class FamilyMembersLoading extends FamilyMembersState {}

class FamilyMembersLoaded extends FamilyMembersState {
  final List<dynamic> familyMembers;

  FamilyMembersLoaded({required this.familyMembers});

  @override
  List<Object> get props => [familyMembers];
}

class FamilyMembersError extends FamilyMembersState {
  final String error;

  FamilyMembersError({required this.error});

  @override
  List<Object> get props => [error];
}

// bloc

class FamilyMembersBloc extends Bloc<FamilyMember, FamilyMembersState> {
  final String baseUrl = 'http://localhost:3000/auth';
  FamilyMembersBloc() : super(FamilyMembersInitial()) {
    on<GetAllFamilyMembers>((event, emit) async {
      emit(FamilyMembersLoading());
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/getallUsers'),
          headers: {'Content-Type': 'application/json'},
        );

        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          List<User> users = [];
          for (var user in data) {
            users.add(User(
              userId: user['id'],
              email: user['email'],
              role: user['role'],
            ));
          }
          emit(FamilyMembersLoaded(familyMembers: users));
        } else {
          emit(FamilyMembersError(error: 'Failed to get users'));
        }
      } catch (e) {
        emit(FamilyMembersError(error: e.toString()));
      }
    });

    on<UpdateRole>((event, emit) async {
      try {
        final response = await http.patch(
          Uri.parse('$baseUrl/updateRole'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id': event.id,
            'role': event.role,
          }),
        );
        add(GetAllFamilyMembers());

      } catch (e) {
        emit(FamilyMembersError(error: e.toString()));
      }
    });
  }
}
