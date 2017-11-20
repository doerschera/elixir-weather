defmodule Weather.CLI do
  def main([args | _]) do
    args
    |> create_url
    |> request_weather
    |> parse_weather
    |> IO.inspect
  end

  def create_url(args) do
    # TODO: hide key
    key = "f05db94200ce821e129cc86d109f222c"
    "api.openweathermap.org/data/2.5/weather?zip=#{args},us&units=imperial&appid=#{key}"
  end

  def request_weather(url) do
    HTTPoison.get(url)
  end

  def parse_weather({:ok, %{body: response}}) do
    case Poison.Parser.parse(response) do
      {:ok, %{"cod" => "404", "message" => message}} -> message
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
