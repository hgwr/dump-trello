require 'yaml'
require 'trello'

CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/config.yml'))

Trello.configure do |config|
  config.developer_public_key = CONFIG["trello_developer_api_key"]
  config.member_token = CONFIG["trello_token"]
end

hgwr = Trello::Member.find("hgwr")
puts hgwr.full_name
boards = hgwr.boards
# > boards[0]
# => #<Trello::Board:0x00000005172000 @attributes={:id=>"556e59821bbc3799cfcef054", :name=>"Tsubaiso Board",

boards.each do |b|
  puts "Name: #{b.name} ID: #{b.id}"
end
