defmodule LiveViewNative.SwiftUI.MapKit.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :live_view_native_swiftui_map_kit,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:live_view_native_swiftui, "~> 0.3.0"},
    ]
  end
end
