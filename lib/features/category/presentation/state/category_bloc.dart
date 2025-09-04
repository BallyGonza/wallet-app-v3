import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/usecases/usecase.dart';
import 'package:template_app/features/category/domain/entities/category_entity.dart';
import 'package:template_app/features/category/domain/usecases/get_all_categories.dart';
import 'package:template_app/features/category/domain/usecases/save_category.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final int? userId;
  final CategoryType? type;

  const LoadCategories({this.userId, this.type});

  @override
  List<Object?> get props => [userId, type];
}

class SaveCategoryEvent extends CategoryEvent {
  final CategoryEntity category;

  const SaveCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class LoadSubcategories extends CategoryEvent {
  final int categoryId;
  final int? userId;

  const LoadSubcategories({required this.categoryId, this.userId});

  @override
  List<Object?> get props => [categoryId, userId];
}

class SaveSubcategoryEvent extends CategoryEvent {
  final SubcategoryEntity subcategory;

  const SaveSubcategoryEvent(this.subcategory);

  @override
  List<Object> get props => [subcategory];
}

// States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategorySaved extends CategoryState {
  final CategoryEntity category;

  const CategorySaved(this.category);

  @override
  List<Object> get props => [category];
}

class SubcategoriesLoaded extends CategoryState {
  final List<SubcategoryEntity> subcategories;

  const SubcategoriesLoaded(this.subcategories);

  @override
  List<Object> get props => [subcategories];
}

class SubcategorySaved extends CategoryState {
  final SubcategoryEntity subcategory;

  const SubcategorySaved(this.subcategory);

  @override
  List<Object> get props => [subcategory];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;
  final SaveCategory saveCategory;

  CategoryBloc({
    required this.getAllCategories,
    required this.saveCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SaveCategoryEvent>(_onSaveCategory);
    on<LoadSubcategories>(_onLoadSubcategories);
    on<SaveSubcategoryEvent>(_onSaveSubcategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await getAllCategories(GetAllCategoriesParams(
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) {
        if (event.type != null) {
          final filteredCategories = categories
              .where((category) => category.type == event.type)
              .toList();
          emit(CategoriesLoaded(filteredCategories));
        } else {
          emit(CategoriesLoaded(categories));
        }
      },
    );
  }

  Future<void> _onSaveCategory(
    SaveCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await saveCategory(SaveCategoryParams(event.category));

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (category) => emit(CategorySaved(category)),
    );
  }

  Future<void> _onLoadSubcategories(
    LoadSubcategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    // Note: This would require a GetSubcategoriesByCategory use case
    // For now, we'll emit an empty list
    emit(const SubcategoriesLoaded([]));
  }

  Future<void> _onSaveSubcategory(
    SaveSubcategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());

    // Note: This would require a SaveSubcategory use case
    // For now, we'll emit the subcategory as saved
    emit(SubcategorySaved(event.subcategory));
  }
}
