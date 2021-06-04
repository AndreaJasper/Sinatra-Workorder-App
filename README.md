# Work Order Management

## Installing

How to install and run this app.

1. Fork and clone this repository.
2. Load the repository in your favorite development software.
3. Run 'bundle install' in your terminal to install any dependencies.
4. Run 'shotgun' in your terminal to create a local environment to run and work within the app.

## Built With

* [Sinatra](https://rubygems.org/gems/sinatra) - Framework
* [ActiveRecord](https://rubygems.org/gems/activerecord) - Database management
* [sqlite3](https://rubygems.org/gems/sqlite3) - Database engine
* [bcrypt](https://rubygems.org/gems/bcrypt) - Password hasher
* [bootstrap](https://getbootstrap.com/) - HTML/CSS framework

### File Structure

```
├── CONTRIBUTING.md
├── Gemfile
├── Gemfile.lock
├── LICENSE.md
├── README.md
├── Rakefile
├── app
│   ├── controllers
│   │   ├── application_controller.rb
│   │   ├── workorders_controller.rb
│   │   └── users_controller.rb
│   ├── models
│   │   ├── workordereet.rb
│   │   └── user.rb
│   └── views
│       ├── index.erb
│       ├── layout.erb
│       ├── workorders
│       │   ├── create_workorders
│       │   ├── edit_workorder.erb
│       │   ├── new.erb
│       │   ├── show_workorder.erb
│       │   └── workorders.erb
│       └── users
│           ├── create_user.erb
│           └── login.erb
│           └── logout.erb
│           └── show.erb
├── config
│   └── environment.rb
├── config.ru
├── db
│   ├── development.sqlite
│   ├── migrate
│   │   ├── 20200703211243_create_users.rb
│   │   └── 20200815220641_create_workorders.rb
│   ├── schema.rb
│   └── test.sqlite
└── spec
    ├── controllers
    │   └── application_controller_spec.rb
    ├── models
    │   └── user_spec.rb
    └── spec_helper.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AndreaJasper/Sinatra-Work-Order-App. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details