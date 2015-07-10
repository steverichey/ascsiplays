#!/usr/bin/env ruby

require 'twitter_ebooks'
require 'dotenv'
include Ebooks

Dotenv.load(".env")

CONSUMER_KEY = ENV['EBOOKS_CONSUMER_KEY']
CONSUMER_SECRET = ENV['EBOOKS_CONSUMER_SECRET']
OAUTH_TOKEN = ENV['EBOOKS_OAUTH_TOKEN']
OAUTH_TOKEN_SECRET = ENV['EBOOKS_OAUTH_TOKEN_SECRET']

ROBOT_ID = "ebooks" # Prefer not to talk to other robots
TWITTER_USERNAME = "ascsiplays" # Ebooks account username
TEXT_MODEL_NAME = "ascsiplays" # This should be the name of the text model

DELAY = 2..30 # Simulated human reply delay range, in seconds
BLACKLIST = [] # users to avoid interaction with
SPECIAL_WORDS = ['body', 'blood', 'spatter', 'damn', 'okay'] # Words we like
BANNED_WORDS = [] # Words we don't want to use

# Information about a particular Twitter user we know
class UserInfo
  attr_reader :username

  # @return [Integer] how many times we can pester this user unprompted
  attr_accessor :pesters_left

  # @param username [String]
  def initialize(username)
    @username = username
    @pesters_left = 1
  end
end

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = CONSUMER_KEY # Your app consumer key
    self.consumer_secret = CONSUMER_SECRET # Your app consumer secret

    # Users to block instead of interacting with
    self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    scheduler.every '24h' do
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
      tweet("hello there")
    end
  end

  def on_message(dm)
    # Reply to a DM
    # reply(dm, "secret secrets")
  end

  def on_follow(user)
    # Follow a user back
    # follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    # reply(tweet, meta(tweet).reply_prefix + "oh hullo")
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    # reply(tweet, meta(tweet).reply_prefix + "nice tweet")
  end
end

# Make a MyBot and attach it to an account
MyBot.new(TWITTER_USERNAME) do |bot|
  bot.access_token = OAUTH_TOKEN # Token connecting the app to this account
  bot.access_token_secret = OAUTH_TOKEN_SECRET # Secret connecting the app to this account
end
