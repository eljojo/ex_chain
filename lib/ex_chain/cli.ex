defmodule ExChain.CLI do
  alias ExChain.SentenceGenerator
  alias ExChain.MarkovModel
  alias ExChain.FileDatasource

  def main(argv) do
    argv
    |> parse_args
    |> process
    System.halt(0)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, ["generate_sentence"], _} -> :generate_sentence
      {_, _, _} -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Usage: ex_chain <command>

    Commands:
      generate_sentence: generates a new sentence
                  usage: $ ex_chain generate_sentence
    """
    System.halt(0)
  end

  def process(:generate_sentence) do
    {:ok, model} = MarkovModel.start_link
    MarkovModel.populate_model(model, FileDatasource.get_data)
    case SentenceGenerator.create_filtered_sentence(model) do
      {:ok, sentence, _prob, _tries} ->
        IO.puts(sentence)
      _ ->
        IO.puts("Couldn't generate sentence")
        System.halt(1)
    end
  end
end
