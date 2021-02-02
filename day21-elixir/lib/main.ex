defmodule Mix.Tasks.Main do
  use Mix.Task

  def read_file(filename) do

    regex = ~r/(?<ingredients>.*)\(contains (?<allergens>.*)\)/

    get_food = &(%Food { ingredients: &1["ingredients"] |> String.split(" ", trim: true) |> Enum.map(fn x -> x |> String.trim end) , \
                          allergens: &1["allergens"] |> String.split(",", trim: true) |> Enum.map(fn x -> x |> String.trim end)})

    File.read!(filename) \
      |> String.split("\n", trim: true) \
      |> Stream.map(&(Regex.named_captures(regex, &1)))  \
      |> Enum.map(&(get_food.(&1))) \
  end

  def get_allergens_and_ingredients_candidates(foods) do
    get_allergens = fn y -> Enum.map(y.allergens, fn x -> %{key: x, ingredients: y.ingredients} end) end

    foods |> Enum.map(&(get_allergens.(&1))) \
      |> List.flatten
      |> Enum.group_by(&(&1.key))
      |> Stream.map(&(%{name: elem(&1, 0), number: elem(&1, 1) |> length, candidates: elem(&1, 1) |> Enum.map(fn x -> x.ingredients end) |> List.flatten }))
      |> Enum.map(&(%{name: &1.name, number: &1.number, candidates: &1.candidates |> Enum.group_by(fn x -> x end) |> Enum.map(fn x -> %{name: elem(x, 0), number: elem(x, 1) |> length} end) }))
  end

  def get_ingredient(candidates, number_occurence) do
    result = candidates |> Enum.filter(&(&1.number == number_occurence))

    case result |> length do
      1 -> result |> Stream.map(&(&1.name)) |> Enum.at(0, 0)
      _ -> nil
    end

  end

  def get_first_ingredient_and_allergen(allergens) do
    allergens |> Stream.map(&(%{allergen: &1.name, ingredient: get_ingredient(&1.candidates, &1.number)})) \
      |> Stream.filter(&(&1.ingredient)) \
      |> Enum.at(0, nil) \
  end

  def filter_ingredient_and_allergen(ingredients, link) do
    ingredients |> Stream.filter(&(&1.name != link.allergen)) \
      |> Enum.map(&(%{name: &1.name, number: &1.number, candidates: &1.candidates |> Enum.filter(fn x -> x.name != link.ingredient end)})) \
  end

  def get_ingredients_and_allergens(allergens) do
    link = get_first_ingredient_and_allergen(allergens)

    if (is_nil(link)) do
      []
    else
      allergens = filter_ingredient_and_allergen(allergens, link)
      [link] ++ get_ingredients_and_allergens(allergens)
    end
  end

  def ingredients_inert_number(foods, ingredient_found) do
    foods |> Stream.map(&(&1.ingredients -- ingredient_found))
      |> Stream.map(&(&1 |> length))
      |> Enum.sum
  end

  def dangerous_ingredient(links) do
    links |>  Enum.sort_by(&(&1.allergen))
      |> Enum.map(&(&1.ingredient))

  end

  def run(_) do

    foods = read_file("data\\data")

    ingredients = get_allergens_and_ingredients_candidates(foods);

    found_link = get_ingredients_and_allergens(ingredients)

    ingredient_found = found_link |> Enum.map(&(&1.ingredient))

    ingredients_inert_number(foods, ingredient_found) |> IO.inspect

    dangerous_ingredient(found_link) |> Enum.join(",") |> IO.inspect

  end
end
