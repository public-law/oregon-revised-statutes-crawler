import Config

config :crawly,
  closespider_timeout: 1,
  concurrent_requests_per_domain: 8,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    # {Crawly.Pipelines.Validate, fields: [:name]},
    # {Crawly.Pipelines.DuplicatesFilter, item_id: :title},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "jsonl", folder: "./tmp"}
  ],
  on_spider_closed_callback: fn _, _, _ -> System.halt(1) end

config :mix_test_watch,
  clear: true

config :logger,
  level: :info
