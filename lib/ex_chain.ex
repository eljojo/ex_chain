defmodule ExChain do
  use Application
  alias ExChain.MarkovModel

  def create_filtered_sentence(threshold \\ 0.5, maxtries \\ 50, tries \\ 0) do
    {sentence, probability} = create_sentence()
    if probability > threshold && tries < maxtries do
      create_filtered_sentence(threshold, maxtries, tries + 1)
    else
      if tries == maxtries do
        [:error, :maxtries_reached]
      else
        {:ok, sentence, probability, tries}
      end
    end
  end

  def create_sentence do
    complete_sentence("")
  end

  def tokenize(str) do
    str
    |> String.split
    |> Enum.reject(fn s -> String.length(s) == 0 end)
  end

  def complete_sentence(sentence) when is_binary(sentence) do
    complete_sentence(tokenize(sentence), 0.0, 0.0)
  end

  def complete_sentence(tokens, prob_acc, tokens_added) when is_list(tokens) do
    {new_token, prob} = tokens
                        |> MarkovModel.get_markov_state()
                        |> MarkovModel.get_random_token()

    if sentence_complete?(tokens, 5, 20) || new_token == '' do
      score = if tokens_added == 0 do
                1.0
              else
                prob_acc / tokens_added
              end
      {Enum.join(tokens, " "), score}
    else
      complete_sentence(tokens ++ [new_token], prob_acc + prob, tokens_added + 1)
    end
  end

  defp sentence_complete?(tokens, min_length, max_length) do
    last_token = List.last(tokens)
    length(tokens) > max_length ||
    (length(tokens) >= min_length && Regex.match?(~r/[\!\?\.]\z/, last_token))
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # this probably goes somewhere else
    :random.seed(:os.timestamp)

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ExChain.Worker, [arg1, arg2, arg3]),
      worker(ExChain.MarkovModel, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExChain.Supervisor]
    res = Supervisor.start_link(children, opts)

    ExChain.MarkovModel.populate_model()

    res
  end
end
