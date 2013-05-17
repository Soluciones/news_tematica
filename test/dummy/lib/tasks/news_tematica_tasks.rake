# coding: UTF-8

# desc "Explaining what the task does"
# task :news_tematica do
#   # Task goes here
# end

desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task routes: :environment do
  all_routes = Rails.application.routes.routes
  require 'action_dispatch/routing/inspector'
  inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
  puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, ENV['CONTROLLER'])
end
