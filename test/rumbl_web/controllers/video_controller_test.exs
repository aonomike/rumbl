defmodule RumblWeb.VideoControllerTest do
  @moduledoc """
  Tests the functionality of the VideoController
  """

  use RumblWeb.ConnCase
  alias Rumbl.Multimedia

  @create_attrs %{url: "http://title.url", title: "vid", description: "a vid"}
  @invalid_attrs %{title: "vid"}

  defp video_count, do: Enum.count(Multimedia.list_videos)

  describe "with a logged in user" do
    setup %{conn: conn, login_as: username } do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)
  
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "max"
    test "lists all user's videos on index", %{conn: conn, user: user} do
      user_video = video_fixture(user, title: "funny cats")
      other_user = user_fixture(username: "other")
      other_video =  video_fixture(other_user, title: "another video")
      require IEx; IEx.pry
      conn = get(conn, Routes.video_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Listing Videos/
      assert String.contains?(conn.resp_body, user_video.title)
      refute String.contains?(conn.resp_body, other_video.title)
    end
  end

  # test "requires user to be logged in for all actions", %{conn: conn} do
  #   video_requests = [
  #     get(conn, Routes.video_path(conn, :new)),
  #     get(conn, Routes.video_path(conn, :index)),
  #     get(conn, Routes.video_path(conn, :show, 123)),
  #     get(conn, Routes.video_path(conn, :edit, 123)),
  #     get(conn, Routes.video_path(conn, :update, 123, %{})),
  #     get(conn, Routes.video_path(conn, :create, %{})),
  #     get(conn, Routes.video_path(conn, :delete, 123))
  #   ]

  #   Enum.each(video_requests, fn conn ->
  #     assert html_response(conn, 302)
  #     assert conn.halted
  #   end)
  # end

  

  #   test "authorizes actions against access by other users", %{conn: conn} do
  #     owner  = user_fixture(username: "owner")
  #     video = video_fixture(owner, @create_attrs)
  #     non_owner = user_fixture(username: "sneaky")
  #     conn = assign(conn, :current_user, non_owner)
  #     require IEx; IEx.pry
  #     assert_error_sent :not_found, fn -> 
  #       get(conn, Routes.video_path(conn, :show, :video))
  #     end
  
  #     assert_error_sent :not_found, fn -> 
  #       get(conn, Routes.video_path(conn, :edit, video))
  #     end
  
  #     assert_error_sent :not_found, fn ->
  #       put(conn, Routes.video_path(conn, :update, video: @create_attrs))
  #     end
  
  #     assert_error_sent :not_found, fn ->
  #       delete(conn, Routes.video_path(conn, :delete, video))
  #     end
  #   end

end
