defmodule Rumbl.TestHelpers do
  @moduledoc """
  Test hepler functions that are accessible to all the tests
  """
  alias Rumbl.{Accounts, Multimedia}

  @doc """
  Creates and returns user

  ## Examples

      iex> user_fixture()
      %User{username: "user1", ...}
  """
  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: username,
        name: "Some User",
        credential: %{
          email: attrs.email || "#{username}.example.com",
          password: attrs[:password] || "super-secret"
        }
      })
      |> Accounts.register_user()

    user
  end

  @doc """
  Creates a video and returns the created video

  ## Examples
      iex> video_fixture()
      %Video{name: "video", ...}
  """
  def video_fixture(%User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{title: "A title", url: "http://some.url", description: "a description"})

    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end
end
