import Config

config :logger,
  backends: [{LoggerFileBackend, :debug_log}]

config :logger, :debug_log,
  path: "./tmp/logs/spider.log",
  level: :debug


config :crawly,
  log_dir: "./tmp/logs",
  log_to_file: true,

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
