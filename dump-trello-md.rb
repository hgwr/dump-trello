require 'yaml'
require 'json'
require 'trello'

CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/config.yml'))

Trello.configure do |config|
  config.developer_public_key = CONFIG["trello_developer_api_key"]
  config.member_token = CONFIG["trello_token"]
end

board_id = ARGV[0]
if board_id.blank?
  STDERR.puts "Error: BOARD_ID is not specified."
  STDERR.puts "Usage: bundle exec ruby dump-trello-md.rb BOARD_ID"
  exit 
end

board = Trello::Board.find(board_id)

lists = board.lists
lists.each do |list|
  puts '# ' + "#{list.name}"
  puts ""
  cards = list.cards
  cards.each do |card|
    puts '## ' + "#{card.name}"
    puts ""
    puts card.desc
    puts ""
    comments_json = card.client.get("/cards/#{card.id}/actions", filter: "commentCard")
    comments = JSON.parse(comments_json)
    comments.each do |comment|
      puts comment["data"]["text"]
      puts ""
    end
  end
end
