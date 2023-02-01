import 'package:bukateria/models/ingredients.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:bukateria/models/recipe_method_model.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/models/user_model.dart';

List<MenusModel> menus = [
  /*MenusModel(
      title: "Pounded Yam & Ogbono Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Licking ",
        lastName: "Fingers",
        avatar: "assets/images/avatar-s-7.png",
        platFormName: "@lickingfingers",
      ),
      location: 'Ondo',
      deliveyStatus: true,
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      image: 'assets/images/fd7.jpg',
      stars: 5.0,
      amount: 7800,
      likes: false),
  MenusModel(
      title: "Pepper Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Kemi",
        lastName: "Kitchen",
        avatar: "assets/images/avatar3.png",
        platFormName: "@kemi123",
      ),
      location: 'Lagos',
      deliveyStatus: false,
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      image: 'assets/images/fd2.jpg',
      stars: 4.5,
      amount: 15000,
      likes: true),
  MenusModel(
      title: "Fresh Fish With Yam",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Musty",
        lastName: "Cutlery",
        avatar: "assets/images/avatar2.png",
        platFormName: "@musty345",
      ),
      location: 'Kaduna',
      deliveyStatus: true,
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      image: 'assets/images/fd7.jpg',
      stars: 4.7,
      amount: 10000,
      likes: true),
  MenusModel(
      title: "Vegetable Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Toyin",
        lastName: "Kitchen",
        avatar: "assets/images/avatar1.png",
        platFormName: "@toyin689",
      ),
      location: 'Abuja',
      deliveyStatus: true,
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      stars: 4.2,
      amount: 12000,
      image: 'assets/images/fd6.jpg',
      likes: true),*/
];

List<RecipeModel> recipes = [
  /*RecipeModel(
      title: "Pounded Yam & Ogbono Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Licking ",
        lastName: "Fingers",
        avatar: "assets/images/avatar-s-7.png",
        platFormName: "@lickingfingers",
      ),
      method: [
        RecipeMethod(
            description:
                "Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc,",
            image: "assets/images/fd1.jpg")
      ],
      location: 'Ondo',
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      category: 'Food',
      duration: '45m',
      image: 'assets/images/fd7.jpg',
      stars: 5.0,
      amount: 7800,
      likes: false),
  RecipeModel(
      title: "Pepper Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Kemi",
        lastName: "Kitchen",
        avatar: "assets/images/customer.jpg",
        platFormName: "@kemi123",
      ),
      location: 'Lagos',
      duration: '30m',
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      image: 'assets/images/fd2.jpg',
      category: 'Drink',
      stars: 4.5,
      amount: 15000,
      likes: true),
  RecipeModel(
      title: "Fresh Fish With Yam",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Musty",
        lastName: "Cutlery",
        avatar: "assets/images/avatar3.png",
        platFormName: "@musty345",
      ),
      location: 'Kaduna',
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      category: 'Food',
      duration: '1hr',
      image: 'assets/images/fd7.jpg',
      stars: 4.7,
      amount: 10000,
      likes: true),
  RecipeModel(
      title: "Vegetable Soup",
      description:
          'Cras dapibus. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Nam at tortor in tellus interdum sagittis. Phasellus accumsan cursus velit. Curabitur a felis in nunc fringilla tristique.',
      user: UserModel(
        firstName: "Toyin",
        lastName: "Kitchen",
        avatar: "assets/images/avatar2.png",
        platFormName: "@toyin689",
      ),
      location: 'Abuja',
      ingredients: [Ingredients(name: "pepper")],
      createdAt: '20th July',
      category: 'Food',
      duration: '55m',
      stars: 4.2,
      amount: 12000,
      image: 'assets/images/fd6.jpg',
      likes: true),*/
];
