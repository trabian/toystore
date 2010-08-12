require 'helper'

describe Toy::List do
  uses_constants('User', 'Game', 'Move')

  before do
    @list = User.list(:games)
  end

  let(:list)  { @list }

  it "has model" do
    list.model.should == User
  end

  it "has name" do
    list.name.should == :games
  end

  it "has type" do
    list.type.should == Game
  end

  it "has key" do
    list.key.should == :game_ids
  end

  it "has instance_variable" do
    list.instance_variable.should == :@_games
  end

  it "adds list to model" do
    User.lists.keys.should include(:games)
  end

  it "adds attribute to model" do
    User.attributes.keys.should include(:game_ids)
  end

  it "adds reader method" do
    User.new.should respond_to(:games)
  end

  it "adds writer method" do
    User.new.should respond_to(:games=)
  end

  describe "#eql?" do
    it "returns true if same class, model, and name" do
      list.should eql(list)
    end

    it "returns false if not same class" do
      list.should_not eql({})
    end

    it "returns false if not same model" do
      list.should_not eql(Toy::List.new(Game, :users))
    end

    it "returns false if not the same name" do
      list.should_not eql(Toy::List.new(User, :moves))
    end
  end

  describe "list reader" do
    it "loads objects from ids when reading" do
      game = Game.create
      user = User.create(:game_ids => [game.id])
      user.games.should == [game]
    end
  end

  describe "list writer" do
    before do
      @game1 = Game.create
      @game2 = Game.create
      @user  = User.create(:game_ids => [@game1.id])
      @user.games = [@game2]
    end

    it "set ids attribute" do
      @user.game_ids.should == [@game2.id]
    end

    it "unmemoizes reader method" do
      @user.games.should == [@game2]
      @user.games         = [@game1]
      @user.games.should == [@game1]
    end
  end
end