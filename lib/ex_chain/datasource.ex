defmodule ExChain.Datasource do
  def get_data do
    files = Path.wildcard("./data/*.js")
    files
      |> Enum.map(&process_file_async(&1))
      |> Enum.map(&Task.await(&1))
      |> List.flatten
  end

  def process_file(file) do
    case File.read(file) do
      {:ok, contents} ->
        contents
        |> String.slice(33..-1)
        |> Poison.Parser.parse!()
        |> extract_texts()
        |> filter_unwanted_tweets()
      _ ->
        raise "error"
    end
  end

  def process_file_async(file) do
    Task.async(fn -> process_file(file) end)
  end

  def extract_texts(tweets) do
    Enum.map(tweets, fn (tweet) -> tweet["text"] end)
  end

  def filter_unwanted_tweets(tweets) do
    regex = ~r/((^(@|rt))|http|@)/i
    tweets |> Enum.filter(fn (tweet) -> !Regex.match?(regex, tweet) end)
  end
end
