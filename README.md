# ExUtils

## Installation

  1. Add ex_utils to your list of dependencies in `mix.exs`:

        def deps do
          [
            {:ex_utils, "~> 2.0.0", git: "https://github.com/faber-lotto/ex_utils.git"},
          ]
        end

  2. Ensure ex_utils is started before your application:

        def application do
          [applications: [:ex_utils]]
        end

