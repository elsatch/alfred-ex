defmodule Alfred.Result.Test do
  use ExUnit.Case
  doctest Alfred.Result

  alias Alfred.Result

  test "creating a basic result works" do
    result = Result.new("title", "subtitle")

    assert result.title == "title"
    assert result.subtitle == "subtitle"
  end

  test "title is required" do
    assert_raise ArgumentError, fn ->
      Result.new(nil, "subtitle")
    end
  end

  test "title cannot be blank" do
    assert_raise ArgumentError, fn ->
      Result.new("   ", "subtitle")
    end
  end

  test "subtitle is required" do
    assert_raise ArgumentError, fn ->
      Result.new("title", nil)
    end
  end

  test "subtitle cannot be blank" do
    assert_raise ArgumentError, fn ->
      Result.new("title", "")
    end
  end

  test "uid can be set via options" do
    result = Result.new("title", "subtitle", uid: "uid")

    assert %Result{} = result
    assert result.uid == "uid"
  end

  test "arg can be set via options" do
    result = Result.new("title", "subtitle", arg: "arg")

    assert %Result{} = result
    assert result.arg == "arg"
  end

  test "valid can be set via options" do
    result = Result.new("title", "subtitle", valid: false)

    assert %Result{} = result
    assert result.valid == false
  end

  test "an error is raised when valid is not a Boolean value" do
    assert_raise ArgumentError, fn ->
      Result.new("title", "subtitle", valid: 5)
    end
  end

  test "an error is raised when uid is not a string value" do
    assert_raise ArgumentError, fn ->
      Result.new("title", "subtitle", uid: 5)
    end
  end

  test "creating a new URL result works" do
    result = Result.new_url("title", "http://www.example.com")

    assert %Result{} = result
    assert result.title == "title"
    assert result.subtitle == "http://www.example.com"
    assert result.arg == "http://www.example.com"
    assert result.uid == "http://www.example.com"
    assert result.autocomplete == "title"
    assert result.quicklookurl == "http://www.example.com"
  end

  test "converting a single result to JSON wraps it in the expected structure" do
    result = Result.new("title", "subtitle")
    {:ok, json} = Result.to_json(result)

    assert json == "{\"items\":[{\"title\":\"title\",\"subtitle\":\"subtitle\"}]}"
  end

  test "converting a list of results to JSON embeds them properly" do
    result = Result.new("title", "subtitle")
    {:ok, json} = Result.to_json([result, result, result])

    assert json == "{\"items\":[{\"title\":\"title\",\"subtitle\":\"subtitle\"},{\"title\":\"title\",\"subtitle\":\"subtitle\"},{\"title\":\"title\",\"subtitle\":\"subtitle\"}]}"
  end
end