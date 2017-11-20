defmodule Weather.CLI do
  def main(args) do
    args
    |> process_args
    |> IO.inspect
  end

  def process_args([zip | _]) do
    create_url(zip)
  end

  def process_args([]) do
    "Weather balloon error: please enter a zip code."
  end

  def create_url(zip) do
    # TODO: hide key
    key = "f05db94200ce821e129cc86d109f222c"
    url = "api.openweathermap.org/data/2.5/weather?zip=#{zip},us&units=imperial&appid=#{key}"
    request_weather(url)
  end

  def request_weather(url) do
    parse_weather(HTTPoison.get(url))
  end

  def parse_weather({:ok, %{body: response}}) do
    case Poison.Parser.parse(response) do
      {:ok, %{"cod" => "404", "message" => message}} -> "Weather balloon error: #{message}."
      {:ok, body} -> format_weather(body)
    end
  end

  def format_weather(%{
    "main" => %{"temp" => temp},
    "name" => name,
    "weather" => [%{"description" => description}]
  }) do
    "It is currently #{temp} is #{name} with #{description}."
  end
end
