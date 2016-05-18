defmodule ExChain.SentenceGenerator do
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

  def complete_sentence(sentence) when is_binary(sentence) do
    complete_sentence(MarkovModel.tokenize(sentence), 0.0, 0.0)
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
end
