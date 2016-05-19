# ExChain

Very simple Markov Chain written in Elixir. This is my toy-project, so I can learn Elixir.

If you have experience with Elixir and find improvements, please let me know, or simply write a comment in the appropiate line. All suggestions are more than welcome.

It's mostly based in the [Markov Models in Ruby](https://docs.omniref.com/github/omniref/hn_title_generator/0.1.0/symbols/HNTitleGenerator::MarkovModel#line=11) tutorial.

The Markov Model creates funny messages based on tweets downloaded from your Twitter Archive.

It generates messages [like this](https://twitter.com/eljojo/status/730268186369646592).

## How to run this?

The first thing you need is Elixir. If you have a Mac, you can install it using ``brew install elixir``.

This program needs your twitter archive, so go ahead and dowload it from your settings in twitter.com.

Download the repository with ``git clone git@github.com:eljojo/ex_chain.git``.
Extract your twitter archive, and put the contents of the ``data/js/tweets`` folder into ``ex_chain/data``.

```
$ cd ex_chain
$ mix deps.get # get the dependencies using mix, Elixir's rake. Analog to bundle install.
$ iex -S mix # analog to irb or rails console
```

Inside iex, you can generate new messages by typing:

```elixir
iex(1)> {:ok, model} = ExChain.MarkovModel.start_link
{:ok, #PID<0.126.0>}
iex(2)> ExChain.MarkovModel.populate_model(model, ExChain.FileDatasource.get_data)
{:ok}
iex(3)> ExChain.SentenceGenerator.create_filtered_sentence(model)
{:ok, "I'm not a Food Social Network?", 0.4668037713169559, 4}
iex(4)> ExChain.SentenceGenerator.create_filtered_sentence(model)
{:ok, "I am in churros.", 0.30839889769910056, 2}
iex(5)> ExChain.SentenceGenerator.create_filtered_sentence(model)
{:ok, "I'm never sleeping again.", 0.3546596799639396, 14}
iex(6)> ExChain.SentenceGenerator.create_sentence(model)
{"future: scumbag apple: makes you release the happiness hormone.",
 0.8334241103848947}
iex(7)> ExChain.SentenceGenerator.complete_sentence(model, "i love")
{"i love the smell of shipping technical debt", 0.6685185185185185}
```

## Where's the code?

The meat and potatos are located in just three files:

| File                               | what it does                                                       |
|------------------------------------|--------------------------------------------------------------------|
| lib/ex_chain/file_datasource.ex    | This file parses the tweets located in the data folder.            |
| lib/ex_chain/markov_model.ex       | This file is in charge of holding the state of the "Markov Model". |
| lib/ex_chain/sentence_generator.ex | This file generates the sentences using the Markov Model.          |

### CLI

ExChain also has a CLI interface.
To use it, you first need to compile the application into an escript (Erlang VM) binary.

```
$ mix escript.build
$ ./ex_chain generate_sentence
I think currywurst is the best time to wake up.
```

## Suggestions

Please send me all your suggestions to [@eljojo](https://twitter.com/eljojo) or directly to my email jojo at eljojo dot net.
