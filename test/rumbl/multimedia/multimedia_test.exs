defmodule Rumbl.Multimedia.MultimediaTest do
  @moduledoc """
  Tests for Multimedia context
  """
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category

  describe "categories" do
    test "lists categories alphabettically" do
      for name <- ~w(Drama Action Comedy), do: Multimedia.create_category(name)

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories(), do: name

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    alias Rumbl.Multimedia.Video
    @valid_attrs %{description: "desc", title: "Title", url: "http://title.url"}
    @invalid_attrs %{title: nil, url: nil, description: nil}

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 gets video with a given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      owner = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)
      assert video.title == "Title"
      assert video.url == "http://title.url"
      assert video.description == "desc"
    end

    test "create_video/2 with invalid data returns an error changeset" do
      owner = user_fixture()
      assert {:error, changeset} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert {:ok, %Video{id: id} = updated_video} =
               Multimedia.update_video(video, %{title: "updated title"})

      assert id == video.id
      assert updated_video.title == "updated title"
    end

    test "update_video/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %Video{id: id} = video = video_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "delete_video/1 deletes video" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert {:ok, %Video{id: id}} = Multimedia.delete_video(video)
      assert [] == Multimedia.list_videos()
    end

    test "change_video/2 returns video changeset" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert %Ecto.Changeset{} = Multimedia.change_video(owner, video)
    end
  end
end
