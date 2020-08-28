require 'telegram/bot'
require 'dotenv/load'

Dotenv.load

TOKEN = ENV['TELEGRAM_BOT_TOKEN']

puts "Bot is running..."

BOT = Telegram::Bot::Client.new(TOKEN)
BOT.api.send_message(chat_id: 45873619, text: "pssst")

pingActive = false

def pinging
    puts "Start pinging. pingActive = #{pingActive}"
    loop do
        BOT.api.send_message(chat_id: 45873619, text: "ping")
        sleep 1
        puts "pingActive = #{pingActive}"
        if !pingActive
            break
        end
    end
end

loop do
    begin
        Telegram::Bot::Client.run(TOKEN) do |bot|
            puts "Bot activated"
            bot.listen do |request|
                Thread.start(request) do |request|
                    begin
                        case request.text
                        when '/start'
                            puts "Client (#{request.chat.id}): /start"
                            bot.api.send_message(chat_id: request.chat.id, text: "Hekko, #{request.from.first_name}")
                        when '/ping'
                            puts "Client (#{request.chat.id}): /ping"
                            pingActive = true
                            pinging()
                        when '/stopping'
                            puts "Client (#{request.chat.id}): /stopping"
                            pingActive = false
                            pinging()
                        when '/stop'
                            puts "Client (#{request.chat.id}): /stop"
                            bot.api.send_message(chat_id: request.chat.id, text: "Bye, #{request.from.first_name}")
                        end
                    rescue
                        puts "The shit down cause a message parsing"
                    end
                end
            end
        end
    rescue
        puts "The shit down cause a api error"
    end
end
