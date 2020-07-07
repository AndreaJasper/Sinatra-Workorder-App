# Sinatra-Workorder-App

## Objectives

1. Build an MVC Sinatra application.
2. Use ActiveRecord with Sinatra.
3. Use multiple models.
4. Use at least one has_many relationship on a User model and one belongs_to relationship on another model.
5. Must have user accounts - users must be able to sign up, sign in, and sign out.
6. Validate uniqueness of user login attribute (username or email).
7. Once logged in, a user must have the ability to create, read, update and destroy the resource that belongs_to user.
8. Ensure that users can edit and delete only their own resources - not resources created by other users.
9. Validate user input so bad data cannot be persisted to the database.
10. BONUS: Display validation failures to user with error messages. (This is an optional feature, challenge yourself and give it a shot!)

## Overview

The goal of this project is to build Fwitter (aka Flatiron Twitter).

You'll be implementing Fwitter using multiple objects that interact, including
separate classes for User and Tweet.

Just like with Twitter, a user should not be able to take any actions (except
sign-up), unless they are logged in. Once a user is logged in, they should be
able to create, edit and delete their own tweets, as well as view all the
tweets.

There are controller tests to make sure that you build the appropriate
controller actions that map to the correct routes.

## License
You may view the license for this app here: <a href="/LICENSE.md"> View License </a>