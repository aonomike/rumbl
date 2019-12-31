defmodule RumblWeb.VideoView do
  use RumblWeb, :view

  @doc """
  Returns a list of id and name tuples from a list of Category struct
  """
  def category_select_options(categories) do
    for category <- categories, do: {category.name, category.id}
  end
end
