defmodule RendaFixa.TaxasTest do
  use ExUnit.Case, async: true
  doctest RendaFixa.Taxas

  setup do
    {:ok, taxas} = RendaFixa.Taxas.start_link([])
    %{taxas: taxas}
  end

  test "armazena taxas por chave", %{taxas: taxas} do
    assert RendaFixa.Taxas.get(taxas, "ipca") == nil

    RendaFixa.Taxas.put(taxas, "selic", 6.75)
    assert RendaFixa.Taxas.get(taxas, "selic") == 6.75
  end

  test "deleta taxa pela chava", %{taxas: taxas} do
    RendaFixa.Taxas.put(taxas,"selic", 6.75)
    assert RendaFixa.Taxas.delete(taxas, "selic") == 6.75

    assert RendaFixa.Taxas.get(taxas, "selic") == nil
  end

  test "deleta taxas ao encerrar", %{taxas: taxas} do
    RendaFixa.Registry.create(taxas, "selic")
    {:ok, taxas} = RendaFixa.Registry.lookup(taxas, "selic")
    Agent.stop(taxas)
    assert RendaFixa.Registry.lookup(taxas, "selic") == :error
  end
end
