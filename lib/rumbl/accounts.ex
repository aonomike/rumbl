defmodule Rumbl.Accounts do
    @moduledoc """
    The Accounts context
    """

    alias Rumbl.Accounts.User

    def list_users do
      [
        %User{id: "1", name: "Jose", username: "jose"},
        %User{id: "2", name: "Chris", username: "chris"},
        %User{id: "3", name: "Nairobi", username: "nairobi"}
      ]
    end

    def get_user(id) do
      Enum.find(list_users(), fn map -> map.id == id end)
    end

    def get_user_by(params) do
      Enum.find(list_users(), fn map -> Enum.all?(params, fn {key, value} -> Map.get(map, key) == value end) end)
    end
end