defmodule ExChainTest do
  use ExUnit.Case
  doctest ExChain

  alias ExChain.MarkovModel

  test "get_markov_state" do
    list = ["a", "B", "c", "d", "E", "F"]
    assert MarkovModel.get_markov_state(list) == {"e", "f"}
    assert MarkovModel.get_markov_state(list, 0) == {nil, nil}
    assert MarkovModel.get_markov_state(list, 1) == {nil, "a"}
    assert MarkovModel.get_markov_state(list, 2) == {"a", "b"}
    assert MarkovModel.get_markov_state(list, 3) == {"b", "c"}
  end
end
