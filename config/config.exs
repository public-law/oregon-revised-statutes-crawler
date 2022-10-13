import Config

config :crawly,
  closespider_timeout: nil,
  concurrent_requests_per_domain: 8,
  # closespider_itemcount: 100,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    # {Crawly.Pipelines.Validate, fields: [:name]},
    # {Crawly.Pipelines.DuplicatesFilter, item_id: :title},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "jl", folder: "./tmp"}
  ]

config :mix_test_watch,
  clear: true

config :logger,
  level: :info
