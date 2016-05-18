defmodule ExChain.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> process
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
    case ExChain.create_filtered_sentence do
      {:ok, sentence, _prob, _tries} ->
        IO.puts(sentence)
        System.halt(0)
      _ ->
        IO.puts("Couldn't generate sentence")
        System.halt(1)
    end
  end
end

