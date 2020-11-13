defmodule Sketch.Storage do
  @moduledoc """
  Wrapper around Erlang's DETS. Provides easy canvas persistance on disk and storage access
  functions.
  All CRUD functions are returning the data in the same way as Ecto repo all would.
  """

  @doc """
  Returns the list of canvases.

  ## Examples

      iex> list()
      [%{id: "17e2efc8...", content: %{0 => %{...}}, ...]

  """
  @spec list() :: list(map()) | {:error, term()}
  def list() do
    :dets.open_file(:sketch_storage, type: :set)

    result =
      case :dets.select(:sketch_storage, [{:"$1", [], [:"$1"]}]) do
        {:error, reason} -> {:error, reason}
        list -> Enum.into(list, [], fn {key, value} -> %{id: key, content: value} end)
      end

    :dets.close(:sketch_storage)
    result
  end

  @doc """
  Gets a single canvas.
  Returns nil if id not found.

  ## Examples

      iex> get("17e2efc8-24fa-11eb-b870-784f436f155b")
      %{id: "17e2efc8...", content: %{0 => %{...}}

  """
  @spec get(String.t()) :: map() | nil | {:error, term()}
  def get(id) do
    :dets.open_file(:sketch_storage, type: :set)

    result =
      case :dets.lookup(:sketch_storage, id) do
        [] -> nil
        {:error, reason} -> {:error, reason}
        [{id, content}] -> %{id: id, content: content}
      end

    :dets.close(:sketch_storage)
    result
  end

  @doc """
  Creates a canvas.

  ## Examples

      iex> create(%{...})
      {:ok, %{id: "17e2efc8...", content: %{0 => %{...}}}

  """
  @spec create(map()) :: {:ok, map()} | {:error, term()}
  def create(content) do
    id = UUID.uuid1()
    :dets.open_file(:sketch_storage, type: :set)

    {atom, result} =
      case :dets.insert_new(:sketch_storage, {id, content}) do
        true -> {:ok, %{id: id, content: content}}
        {:error, reason} -> {:error, reason}
      end

    :dets.close(:sketch_storage)
    {atom, result}
  end

  @doc """
  Updates a canvas.

  ## Examples

      iex> update("17e2efc8-24fa-11eb-b870-784f436f155b")
      {:ok, %{id: "17e2efc8...", content: %{0 => %{...}}}

      iex> update(canvas, %{field: bad_value})
      {:error, "..."}

  """
  @spec update(String.t(), map) :: {:ok, map()} | {:error, term()}
  def update(id, content) do
    :dets.open_file(:sketch_storage, type: :set)

    result =
      with [{id, _content}] <- :dets.lookup(:sketch_storage, id),
           :ok <- :dets.insert(:sketch_storage, {id, content}) do
        {:ok, %{id: id, content: content}}
      else
        [] -> {:error, "canvas does not exist"}
        {:error, reason} -> {:error, reason}
      end

    :dets.close(:sketch_storage)
    result
  end

  @doc """
  Deletes a canvas.

  ## Examples

      iex> delete(canvas)
      {:ok, %{id: "17e2efc8...", content: %{0 => %{...}}}

      iex> delete(canvas)
      {:error, "..."}

  """
  @spec delete(String.t()) :: {:ok, map()} | {:error, term()}
  def delete(id) do
    :dets.open_file(:sketch_storage, type: :set)

    result =
      with [{id, content}] <- :dets.lookup(:sketch_storage, id),
           :ok <- :dets.delete(:sketch_storage, id) do
        {:ok, %{id: id, content: content}}
      else
        [] -> {:error, "canvas does not exist"}
        {:error, reason} -> {:error, reason}
      end

    :dets.close(:sketch_storage)
    result
  end
end
