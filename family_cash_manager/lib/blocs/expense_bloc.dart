import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddExpense extends ExpenseEvent {
  final String amount;
  final String date;
  final int userId;
  final String category;

  AddExpense(
      {required this.userId,
      required this.category,
      required this.amount,
      required this.date});

  @override
  List<Object> get props => [userId, category, amount, date];
}

class UpdateExpense extends ExpenseEvent {
  final int id;
  final String amount;
  final String date;
  final int userId;
  final String category;

  UpdateExpense(
      {required this.id,
      required this.userId,
      required this.category,
      required this.amount,
      required this.date});

  @override
  List<Object> get props => [id, userId, category, amount, date];
}

class GetExpenses extends ExpenseEvent {}

class DeleteExpense extends ExpenseEvent {
  final int id;

  DeleteExpense({required this.id});

  @override
  List<Object> get props => [id];
}


abstract class ExpenseState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseUpdate extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String error;

  ExpenseError({required this.error});

  @override
  List<Object> get props => [error];
}

class ExpenseLoaded extends ExpenseState {
  final List expenses;

  ExpenseLoaded({required this.expenses});

  @override
  List<Object> get props => [expenses];
}

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<AddExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/expense'),
          body: {
            'userId': event.userId.toString(),
            'category': event.category,
            'amount': event.amount.toString(),
            'date': event.date,
          },
        );
        add(GetExpenses());
      } catch (e) {
        emit(ExpenseError(error: 'Failed to add expenses'));
      }
    });

    on<GetExpenses>((event, emit) async {
      try {
        final response =
            await http.get(Uri.parse('http://localhost:3000/expense'));
        final data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          print(data);
          emit(ExpenseLoaded(expenses: data));
        } else {
          emit(ExpenseError(error: 'Failed to fetch expenses'));
        }
      } catch (e) {
        emit(ExpenseError(error: 'Failed to fetch expenses'));
      }
    });

    on<DeleteExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final response = await http
            .delete(Uri.parse('http://localhost:3000/expense/${event.id}'));
        add(GetExpenses());
      } catch (e) {
        emit(ExpenseError(error: 'Failed to delete expense'));
      }
    });

    on<UpdateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final response = await http.put(
          Uri.parse('http://localhost:3000/expense/${event.id}'),
          body: {
            'userId': event.userId.toString(),
            'category': event.category,
            'amount': event.amount.toString(),
            'date': event.date,
          },
        );
        
        add(GetExpenses());
      } catch (e) {
        emit(ExpenseError(error: 'Failed to update expense'));
      }
    });
  }
}
