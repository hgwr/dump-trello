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
  STDERR.puts "Usage: bundle exec ruby dump-trello.rb BOARD_ID"
  exit 
end

board = Trello::Board.find(board_id)

outputs = []
cards = board.cards
cards.each do |card|
  STDERR.print("#{card.short_url} ")
  sleep 1

  comment_data = []
  comments_json = card.client.get("/cards/#{card.id}/actions", filter: "commentCard")
  comments = JSON.parse(comments_json)
  comments.each do |comment|
    print(".")
    comment_data.push({
                        source: 'Trello',
                        original_id: comment["id"],
                        original_parent_id: (comment["data"]["list"]["id"] rescue nil),
                        content: comment["data"]["text"],
                        create_by: (comment["memberCreator"]["fullName"] rescue nil),
                        original_created: Time.parse(comment["date"])
                      })
  end

  card_data = {
    original_id: card.id,
    original_parent_id: card.list_id,
    original_key_string: card.short_url,
    subject: card.name,
    content: card.desc,
    create_by: card.members.map(&:full_name).join(', '),
    original_updated: card.last_activity_date,
    comments: comment_data
  }
  outputs.push(card_data)
  
  STDERR.puts("")
end

puts JSON.pretty_generate(outputs)
