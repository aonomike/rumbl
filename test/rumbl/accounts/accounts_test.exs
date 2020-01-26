defmodule Rumbl.Accounts.AccountsTest do
  @moduledoc """
  Tests functions in the accounts context
  """

  use Rumbl.DataCase

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      username: "eva",
      credential: %{email: "eva@email.com", password: "secret"}
    }
    @invalid_attrs %{}

    test "with valid attributes inserts data" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.username == "eva"
      assert user.name == "User"
      assert user.credential.email == "eva@email.com"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user to database" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert [] == Accounts.list_users()
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept usernames of more than 20 characters" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 21))
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
    end

    test "requires password to be atleats 20 charachters" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      assert {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 6 character(s)"]} =
               errors_on(changeset)[:credential]
    end
  end

  describe "authenticate_by_email_and_pass/2" do
    @email "user@example.com"
    @password "123456"

    setup do
      {:ok, user: user_fixture(%{email: @email, password: @password})}
    end

    test "returns user with correct email and password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_pass(@email, @password)
    end

    test "returns unauthorized with invalid password" do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_pass(@email, "bad-password")
    end

    test "returns not found with invalid email" do
      assert {:error, :not_found} =
               Accounts.authenticate_by_email_and_pass("bad@email.com", @password)
    end
  end
end
