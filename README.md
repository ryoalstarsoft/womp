# Womp Platform

## Getting Started

Womp is running on Rails 5.1.2.

```
$ git clone git@github.com:wompxyz/womp-platform.git
$ cd womp-platform/
$ bundle install
$ yarn install
```

The database that's being used is Postgresql. The configuration must be manually implemented by you but an example file is provided for you.

```
$ cp config/example-database.yml config/database.yml
```

The configuration in the `example_database.yml` may work for you out of the box, though you may need to tweak it for your local Postgresql configuration.

Womp uses [Figaro](https://github.com/laserlemon/figaro) to handle environment variables that are sensitive and don't belong in the repository.

```
$ cp config/example-application.yml config/application.yml
```

You'll need to configure this file on your own as well. To get the values that you'll need for it please email [gaby@womp.xyz](mailto:gaby@womp.xyz).

If you configured your `database.yml` file correctly in the previous steps you may now create your database and tables.

```
$ rake db:create
$ rake db:migrate
```

At this point you should be ready to boot up your Rails Server and test things out in the browser at [localhost:3000](http://localhost:3000).

```
$ rails s
```

In production we utilize background jobs with Resque/Redis. This is due to the communication with the NXS Conversion Microservice mentioned in the next section. Communication with this microservice historically was long running, but now can likely be moved to the main process instead of a background job as it just entails an HTTP request.

The way things are configured in production won't work in development, as you'll read in the Microservice section. If you still want to run the queue in development anyways, you'll need to do the following.

In a new Terminal tab run:

```
$ QUEUE=* bundle exec rake resque:work
```

We're also currently in limbo between using Webpacker and the AssetPipeline. In order for the Webpacker javascript to be compiled and used in development you'll need to run the following in another Terminal tab:

```
./bin/webpack-dev-server
```

If you don't run the above, the changes you make to Webpacker compiled javascript will still be made, it will just take much longer as compilation happens when a request is made on the Rails server instead of when the code is changed.

### Microservice
There is a microservice that is used to process 3D Models that is located at [https://github.com/wompxyz/nxs-converter/](https://github.com/wompxyz/nxs-converter/). Since it puts jobs into a background process and executes a POST request back to this application, it isn't feasible using it in development. Because of this there is a rake task that fakes the result of a successful microservice interaction.

```
$ rake make:last_upload_viewer_ready
```

This will assign all of the attributes necessary to push projects forward when a 3D Model is processing such as volume, machine space, and surface area.

### Admin Users
There is an admin panel that you'll need to access to push project flows forward within the app. Admin accounts are created manually through the rails console.

```
$ rails c
$ AdminUser.create!(email: "test@test.com", password: "password", password_confirmation: "password")
```

You can now log in to the admin panel at the `/admin` path.

### Materials
To populate the materials list that you need in development, you'll need to upload a materials Excel sheet to the admin dashboard at `/admin/materials/new`. This sheet may be obtained [here](https://s3.amazonaws.com/womp-platform-live/00_0000+womp+materials+offered.xlsx). **Note:** This spreadsheet may be out of date but it is formatted correctly. Email [gaby@womp.xyz](mailto:gaby@womp.xyz) for the most up to date version of this sheet.

## Workflow
When you're about to start a new project the workflow is as follows.

1. Pull from master
2. Checkout a new branch for your project
3. Push to that branch
4. When the project/feature is complete open a pull request

## Front End
### Javascript
There are two different ways that Javascript are currently being used in this project. One is the typical Rails AssetPipeline. The other is through Webpacker.

#### AssetPipeline
This utilizes the default Rails templates. We're using jQuery for everything here. Turbolinks is enabled which means that the typical `$(document).ready()` does not work if you're writing JS in the `app/assets/javascripts/` folder. You'll need to use `$(document).on('turbolinks:load')` instead. If you're working with any of the React components on the project, you won't need to worry about this at all.


#### Webpacker
With Rails 5 came Webpacker which abstracts all the work needed to configure Webpack for the project. It conveniently provides packs which are accessible in the `app/javascript/packs` folder. These packs get added by adding a line such as the following to your `application.html.erb` file.

```
<%= javascript_pack_tag 'application' %>
```

With this configuration, we're able to add React components into our Rails templates by doing something like the following:

```
<%= react_component("Annotator", { imageUrl: @upload.file.variant(resize: "2550x3300").service_url, imageAltText: 'Womp Image', projectId: @upload.project.id, uploadId: @upload.id, existingAnnotations: @upload.formatted_annotations }) %>
```

#### Moving Forward
Having two ways that Javascript interacts with the platform isn't sustainable long term and we'll eventually need to introduce a more traditional React/Redux setup in the `app/javascript/` folder that reimplements everything in the default Rails Templates in a SPA. At the time we're holding off on doing this and will maintain our design pattern of using React Components when/where we need them within our Rails Templates while implementing other Javascript features with jQuery in the AssetPipeline.

### CSS
This project utilizes [Tachyons](http://tachyons.io/) which encourages as little custom CSS as possible. If you're unfamiliar with Tachyons, browse through some of the code and look up each class that's being used in their documentation (which is excellent).

We're using the Rails default of SASS which you'll see in the `app/assets/stylesheets/` folder.

### Error Monitoring in Production
Exceptions that are thrown in production get posted to Womp's Slack channel: `#womp-errors`.


### Production Performance Tracking
We use [Skylight](https://www.skylight.io/) for performance tracking in production. For an invite, email [gaby@womp.xyz](mailto:gaby@womp.xyz).
